//
//  iPadInboxAttachmentsTabLayoutView.m
//  iDoc
//
//  Created by mark2 on 12/21/10.
//  Copyright 2010 KORUS Consulting. All rights reserved.
//


#import "iPadInboxAttachmentsTabLayoutView.h"
#import "iPadInboxAttachmentsTabViewController.h"
#import "Constants.h"
#import "iPadThemeBuildHelper.h"
#import "SupportFunctions.h"


@interface iPadInboxAttachmentsTabLayoutView(PrivateMethods)
- (void)setupDocumentControllerWithURL:(NSURL *)url andName:(NSString *)name;
@end

@implementation iPadInboxAttachmentsTabLayoutView
@synthesize docInteractionController, attachmentViewPlaceHolder, totalNumberOfPages;

- (void)removeQLView {    
    if (previewer != nil) {
        [previewer setDataSource:nil];
        [previewer.view removeFromSuperview];
        [previewer release];
        previewer = nil;
    }
    if(openInExtAppButton != nil) {
        [openInExtAppButton removeFromSuperview];
        [openInExtAppButton release];
        openInExtAppButton = nil;
    }
}

- (id)init {
    if ((self = [super init])) {
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
				
        attachmentViewPlaceHolder = [[UIView alloc] init];
        attachmentViewPlaceHolder.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        attachmentViewPlaceHolder.layer.cornerRadius = 5.0f;
        attachmentViewPlaceHolder.clipsToBounds = YES;
        [self addSubview:attachmentViewPlaceHolder];
        
    }
    return self;
}

- (void)setDelegate:(id<iPadInboxAttachmentsTabLayoutViewDelegate>)newDelegate {
    delegate = newDelegate;
}

- (void)setupDocumentControllerWithURL:(NSURL *)url andName:(NSString *)name {
    if (self.docInteractionController == nil) {
        self.docInteractionController = [UIDocumentInteractionController interactionControllerWithURL:url];
        docInteractionController.delegate = self;
        docInteractionController.name = name;
    }
    else {
        docInteractionController.URL = url;
        docInteractionController.name = name;
    }
}


#pragma mark single webview engine implementation

- (void)openInExtAppButtonPressed {
    NSArray *attachmentInfo = [delegate itemForPage:previewer.currentPreviewItemIndex];
    NSString *attachmentName = [attachmentInfo objectAtIndex:0];
    NSString *attachmentPath = [SupportFunctions createPathForAttachment:[attachmentInfo objectAtIndex:1]];
    NSURL *attachmentUrl = [NSURL fileURLWithPath:attachmentPath];
    [self setupDocumentControllerWithURL:attachmentUrl andName:attachmentName];
    
    BOOL isValid = [docInteractionController presentOpenInMenuFromRect:openInExtAppButton.frame 
                                                                inView:attachmentViewPlaceHolder 
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


- (void)setupPages:(int)numberOfPages {
    totalNumberOfPages = numberOfPages;
    if( totalNumberOfPages ) {
        if (nil != previewer || nil != openInExtAppButton) {
            [self removeQLView];
        }
        
        previewer = [[QLPreviewController alloc] init];
        previewer.view.frame = attachmentViewPlaceHolder.bounds;
        previewer.view.contentScaleFactor = constViewScaleFactor;
        [previewer setDataSource:self];
        [attachmentViewPlaceHolder addSubview:previewer.view];
        
        openInExtAppButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [openInExtAppButton setImage:[UIImage imageNamed:[iPadThemeBuildHelper nameForImage:@"open_in_external_app_button"]]
                            forState:UIControlStateNormal];
        [openInExtAppButton addTarget:self action:@selector(openInExtAppButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [attachmentViewPlaceHolder addSubview:openInExtAppButton];
        
        [previewer setCurrentPreviewItemIndex:0];
        [self layoutSubviews];
    }
    else {
        [self removeQLView];        
    }
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	CGRect attachmentViewPlaceHolderFrame = CGRectInset(self.bounds, 5, 5);
	attachmentViewPlaceHolder.frame = attachmentViewPlaceHolderFrame;	
    previewer.view.frame = attachmentViewPlaceHolder.bounds;
        
    openInExtAppButton.frame = CGRectMake(attachmentViewPlaceHolder.bounds.origin.x + attachmentViewPlaceHolder.bounds.size.width - 77, 
                               attachmentViewPlaceHolder.bounds.origin.y + attachmentViewPlaceHolder.bounds.size.height - 38, 
                               26, 22);
}


#pragma mark Preview Controller

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller {
	return totalNumberOfPages;
}

- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index {
    NSArray *attachmentInfo = [delegate itemForPage:index];
    NSString *attachmentPath = [SupportFunctions createPathForAttachment:[attachmentInfo objectAtIndex:1]];
//    NSLog(@"attachmentPath %@ at index %i", attachmentPath, index);
    
	return [NSURL fileURLWithPath:attachmentPath];
}


- (void)dealloc {
    [self removeQLView];
    
	self.attachmentViewPlaceHolder = nil;
    self.docInteractionController = nil;
    self.delegate = nil;
    
    [super dealloc];
}


@end
