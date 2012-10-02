//
//  iPadDocItemPanelViewController.m
//  iDoc
//
//  Created by rednekis on 10-12-15.
//  Copyright 2010 KORUS Consulting. All rights reserved.
//

#import "iPadDocItemPanelViewController.h"
#import "iPadDocItemPanelPageLayoutView.h"
#import "iPadDocModuleLayoutView.h"
#import "iPadThemeBuildHelper.h"
#import "SystemDataEntity.h"
#import "UIWebView+Block.h"
#import <QuartzCore/QuartzCore.h>
#import "SupportFunctions.h"

@implementation iPadDocItemPanelViewController

@synthesize loadedItem, docInteractionController;

- (id)initWithContentPlaceholderView:(UIView *)contentPanel andDelegate:(id<iPadDocItemPanelViewControllerDelegate>)newDelegate {
	NSLog(@"iPadDocItemPanel initWithContentPlaceholderView");	
	if ((self = [super initWithNibName:nil bundle:nil])) {		        		
		//body
		iPadDocItemPanelPageLayoutView *container = [[iPadDocItemPanelPageLayoutView alloc] init];
		container.frame = contentPanel.bounds;
		self.view = container;
        
        placeholderLabel = [HFSUILabel labelWithFrame:container.bodyPanel.bounds 
                                              forText:NSLocalizedString(@"AttachmentContentPlaceholderLabelText", nil) 
                                            withColor:nil 
                                            andShadow:nil];
        placeholderLabel.textAlignment = UITextAlignmentCenter;
        [container.bodyPanel addSubview:placeholderLabel];
        
		[contentPanel addSubview:container];				
		[container release];
	}
	return self;
}

#pragma mark custom methods - visual init
- (void)removeWebView {
    if (attachmentWebView != nil) {
        [attachmentWebView stopLoading];
        attachmentWebView.delegate = nil;
        [attachmentWebView removeFromSuperview];
        attachmentWebView = nil;
    }
}

- (UIWebView *)emptyWebView {
    [self removeWebView];
    
    iPadDocItemPanelPageLayoutView *container = (iPadDocItemPanelPageLayoutView *)self.view;
    
    attachmentWebView = [[UIWebView alloc] initWithFrame:container.bodyPanel.bounds];
    attachmentWebView.delegate = self;
    attachmentWebView.scalesPageToFit = YES;
    attachmentWebView.contentScaleFactor = constViewScaleFactor;
    attachmentWebView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    attachmentWebView.alpha = 0;
    
    [container.bodyPanel addSubview:attachmentWebView];
    
    [container.openInExtAppButton addTarget:self action:@selector(openInExtAppButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [attachmentWebView addSubview:container.openInExtAppButton];

    return attachmentWebView;
}

- (void)setupDocumentControllerWithURL:(NSURL *)url {
    if (self.docInteractionController == nil) {
        self.docInteractionController = [UIDocumentInteractionController interactionControllerWithURL:url];
        docInteractionController.delegate = self;
    }
    else {
        docInteractionController.URL = url;
    }
}

- (void)openInExtAppButtonPressed {
    NSString *attachmentPath = [loadedItem objectForKey:HFS_FileAttributesDictionaryFilePath];
    NSURL *attachmentUrl = [NSURL fileURLWithPath:attachmentPath];
    
    [self setupDocumentControllerWithURL:attachmentUrl];
    
    CGRect anchor = CGRectMake(attachmentWebView.bounds.origin.x + attachmentWebView.bounds.size.width - 77, 
                               attachmentWebView.bounds.origin.y + attachmentWebView.bounds.size.height - 38, 
                               26, 22);
    
    BOOL isValid = [self.docInteractionController presentOpenInMenuFromRect:anchor
                                                                     inView:attachmentWebView
                                                                   animated:YES];
    if (isValid == NO) {
        NSLog(@"There are no external apps that can open this file: %@", attachmentUrl);
        [[[[UIAlertView alloc]initWithTitle:nil
                                    message:NSLocalizedString(@"NoAppsToOpenFileMessage", nil)
                                   delegate:nil 
                          cancelButtonTitle:@"Ok" otherButtonTitles: nil] autorelease] show];
    }
}

#pragma mark UIDocumentInteractionControllerDelegate methods
- (void) documentInteractionController:(UIDocumentInteractionController *)controller 
            didEndSendingToApplication:(NSString *)application {
}

- (void) documentInteractionController:(UIDocumentInteractionController *)controller 
         willBeginSendingToApplication:(NSString *)application {
    NSLog(@"documentInteractionController willBeginSendingToApplication: %@", application);
}


#pragma mark custom methods - tabs methods
- (void)loadItem:(NSDictionary *)item {
	NSLog(@"iPadDocItemPanel loadItem");	
    self.loadedItem = item; 
    UIWebView *webView = [self emptyWebView];
    
    if (item != nil) {
        NSString *attachmentPath = [item objectForKey:HFS_FileAttributesDictionaryFilePath];
        NSURL *attachmentUrl = [NSURL fileURLWithPath:attachmentPath];
        NSURLRequest *request = [NSURLRequest requestWithURL:attachmentUrl];

        [webView loadRequest:request];
    }
}

#pragma mark UIWebView delegate methods
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType) navigationType {
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:.001]];
    webView.alpha = 0;
    placeholderLabel.hidden = YES;
	[webView block];
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self performSelector:@selector(revealWebView:) withObject:webView afterDelay:0.1]; 
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self performSelector:@selector(revealWebView:) withObject:webView afterDelay:0.1]; 
}

- (void)webView:(UIWebView *)webView hidden:(BOOL)status animating:(BOOL)animating {
	if (animating) {
		webView.alpha = 0.0;
		
		[UIView beginAnimations:@"webViewVisibility" context:nil]; {
			[UIView setAnimationDuration:0.5];
			webView.alpha = 1.0;	
		}
		[UIView commitAnimations];		
	} else {
		webView.alpha = 1.0;
	}
    [webView unlock];
}

- (void)revealWebView:(UIWebView *)webView {//wrapper-функция для вызова с задержкой из webViewDidFinishLoad
	[self webView:webView hidden:NO animating:YES]; 
}

#pragma mark other methods
- (void)didReceiveMemoryWarning {
	NSLog(@"iPadInboxItemPanel didReceiveMemoryWarning");		
    // Releases the iPadSearchFilter if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc. that aren't in use.
}

- (void)dealloc {
    [self removeWebView];
    
    self.loadedItem = nil;
    self.docInteractionController = nil;
    
	[super dealloc];
}
@end
