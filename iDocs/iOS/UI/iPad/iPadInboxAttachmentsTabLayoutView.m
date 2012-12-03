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
#import "iPadBaseLayoutView.h"


@implementation QLookPreviewController

- (id <QLPreviewItem>)currentPreviewItem {
    if( delegateQL != nil && [delegateQL respondsToSelector:@selector(setStateForPage:)] ) {
        [delegateQL setStateForPage:[self currentPreviewItemIndex]];
    }
    return [super currentPreviewItem];
}

- (void)setDelegateQL:(id<QLookPreviewControllerDelegate>)_delegate {
    delegateQL = _delegate;
}

@end


@interface iPadInboxAttachmentsTabLayoutView (PrivateMethods)
- (void)setupDocumentControllerWithURL:(NSURL *)url andName:(NSString *)name;
- (void)changePageWithZeroOffset;
- (void)setViewForPage:(int)page;
@end

@implementation iPadInboxAttachmentsTabLayoutView

@synthesize docInteractionController, attachmentViewPlaceHolder, totalNumberOfPages;
@synthesize pageControl, attachmentScrollView;
@synthesize navController;

- (void)removeQLView {
    NSLog(@"removeQLView");
    if (previewer != nil) {
        [previewer setDataSource:nil];
        [previewer.view removeFromSuperview];
        [previewer release];
        previewer = nil;        
    }
    if (viewer != nil) {
        [viewer setDataSource:nil];
        [viewer setDelegateQL:nil];
        [viewer.view removeFromSuperview];
        [viewer release];
        viewer = nil;
    }
    if( navController != nil ) {
        [navController.view removeFromSuperview];
        [navController release];
        navController = nil;
    }
}

- (QLPreviewController *)emptyQLView {
    [self removeQLView];
    
    previewer = [[QLPreviewController alloc] init];
    previewer.view.contentScaleFactor = constViewScaleFactor;
    [previewer setDataSource:self];
    [previewer reloadData];
    [attachmentScrollView addSubview:previewer.view];
        
    return previewer;
}

- (id)init {
    if ((self = [super init])) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        attachmentViewPlaceHolder = [[UIView alloc] init];
        attachmentViewPlaceHolder.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        attachmentViewPlaceHolder.layer.cornerRadius = 5.0f;
        attachmentViewPlaceHolder.clipsToBounds = YES;
        [self addSubview:attachmentViewPlaceHolder];
		
        NSString *reqSysVer = @"6.0";
        NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
        if( [currSysVer compare:reqSysVer options:NSNumericSearch] == NSOrderedAscending ) {
//            NSLog(@" reqSysVer %@ > currSysVer %@", reqSysVer, currSysVer);

            attachmentScrollView = [[UIScrollView alloc] init];
            attachmentScrollView.showsHorizontalScrollIndicator = NO;
            attachmentScrollView.showsVerticalScrollIndicator = NO;
            attachmentScrollView.pagingEnabled = YES;
            attachmentScrollView.delegate = self;
            attachmentScrollView.backgroundColor = [UIColor whiteColor];
            [attachmentViewPlaceHolder addSubview:attachmentScrollView];
            
            pageControl = [[UIPageControl alloc] init];
            pageControl.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3f];
            pageControl.layer.cornerRadius = constCornerRadius;
            
            [pageControl addTarget:self action:@selector(changePage) forControlEvents:UIControlEventValueChanged];
            [attachmentViewPlaceHolder addSubview:pageControl];

            initialized = NO;
            
            onlyQL = NO;
        }
        else {
//            NSLog(@" reqSysVer %@ <= currSysVer %@", reqSysVer, currSysVer);
            QLView = [[UIView alloc] init];
            QLView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            QLView.clipsToBounds = YES;
            [attachmentViewPlaceHolder addSubview:QLView];
            
            onlyQL = YES;
        }
        
		attachmentInfoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		attachmentInfoLabel.hidden = YES;
		attachmentInfoLabel.opaque = YES;
		attachmentInfoLabel.enabled = YES;
		attachmentInfoLabel.textColor = [iPadThemeBuildHelper commonTextFontColor1];
		attachmentInfoLabel.font = [UIFont systemFontOfSize:constXLargeFontSize];
		attachmentInfoLabel.textAlignment = UITextAlignmentCenter;
		attachmentInfoLabel.backgroundColor = [UIColor clearColor];
		attachmentInfoLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        attachmentInfoLabel.text = nil;
        [attachmentViewPlaceHolder addSubview:attachmentInfoLabel];
        
        openInExtAppButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [openInExtAppButton setImage:[UIImage imageNamed:[iPadThemeBuildHelper nameForImage:@"open_in_external_app_button"]]
                            forState:UIControlStateNormal];
        [openInExtAppButton addTarget:self action:@selector(openInExtAppButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [attachmentViewPlaceHolder addSubview:openInExtAppButton];
        openInExtAppButton.hidden = YES;
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

- (void)openInExtAppButtonPressed {
    NSArray *attachmentInfo = nil;
    if( onlyQL ) {
        attachmentInfo = [delegate itemForPage:viewer.currentPreviewItemIndex];
    }
    else {
        attachmentInfo = [delegate itemForPage:pageControl.currentPage];
    }
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
  
    [self removeQLView];
    
    if( totalNumberOfPages ) {
        if( onlyQL ) {
            viewer = [[QLookPreviewController alloc] init];
            viewer.view.frame = QLView.bounds;
            viewer.view.contentScaleFactor = constViewScaleFactor;
            [viewer setDataSource:self];
            [viewer setDelegate:self];
            [viewer setDelegateQL:self];
            [viewer reloadData];
            
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewer];
            self.navController = navigationController;
            [navigationController release];
            navController.view.frame = QLView.bounds;
            navController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            navController.navigationBar.hidden = YES;
            
            [QLView addSubview:navController.view];
            
            openInExtAppButton.hidden = NO;
        }
        else {
            pageControl.numberOfPages = totalNumberOfPages;
            pageControl.currentPage = 0;
            pageControl.hidden = NO;
            needsReset = YES;
            
            if( initialized ) {
                attachmentScrollView.contentSize = CGSizeMake(attachmentScrollView.bounds.size.width * totalNumberOfPages, attachmentScrollView.bounds.size.height);
            }
            [self changePageWithZeroOffset];
        }
    }
    else {
        openInExtAppButton.hidden = YES;
        if( !onlyQL ) {
            pageControl.hidden = YES;
        }
    }

}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	CGRect attachmentViewPlaceHolderFrame = self.bounds;
	attachmentViewPlaceHolder.frame = attachmentViewPlaceHolderFrame;

    
    attachmentInfoLabel.frame = CGRectMake(attachmentViewPlaceHolder.bounds.origin.x + 100,
                                           attachmentViewPlaceHolder.bounds.origin.y + 50,
                                           attachmentViewPlaceHolder.bounds.size.width - 200, 40);

    openInExtAppButton.frame = CGRectMake(attachmentViewPlaceHolder.bounds.origin.x + 50,
                               attachmentViewPlaceHolder.bounds.origin.y + attachmentViewPlaceHolder.bounds.size.height - 38, 
                               26, 22);

    if( onlyQL ) {
        QLView.frame = attachmentViewPlaceHolder.bounds;       
    }
    else {
        attachmentScrollView.frame = attachmentViewPlaceHolder.bounds;
        attachmentScrollView.contentSize = CGSizeMake(attachmentViewPlaceHolder.bounds.size.width * totalNumberOfPages, attachmentViewPlaceHolder.bounds.size.height);
        
        pageControl.frame = CGRectInset(CGRectMake(attachmentViewPlaceHolder.bounds.origin.x,
                                                   attachmentViewPlaceHolder.bounds.origin.y + attachmentViewPlaceHolder.bounds.size.height - 50,
                                                   attachmentViewPlaceHolder.bounds.size.width,
                                                   50), 100, 17);
        if (!initialized) {
            initialized = YES;
            if( totalNumberOfPages )
                [self loadQLWithPage:0];
        }
    }
}


#pragma mark Preview Controller

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller {
	return totalNumberOfPages;
}

- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index {
    NSArray *attachmentInfo = [delegate itemForPage:index];
    NSString *attachmentPath = [SupportFunctions createPathForAttachment:[attachmentInfo objectAtIndex:1]];
    
    return [NSURL fileURLWithPath:attachmentPath];
}


#pragma mark UIScrollView methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	int gotoNextPage = (int)(scrollView.contentOffset.x / scrollView.bounds.size.width);
	
	if (pageControl.currentPage != gotoNextPage) {
		pageControl.currentPage = gotoNextPage;
        [self loadQLWithPage:pageControl.currentPage];
	}
}

- (CGRect)frameForPage:(int)page {
    return CGRectMake(attachmentScrollView.bounds.size.width * page,
                      0.0f,
                      attachmentScrollView.bounds.size.width,
                      attachmentScrollView.bounds.size.height);
}

- (void)changePage {
    needsReset = YES;
    [self changePageWithZeroOffset];
}

- (void)changePageWithZeroOffset {
    if( !initialized ) {
        return;
    }
    
    if( needsReset ) {
        needsReset = NO;
        [attachmentScrollView scrollRectToVisible:[self frameForPage:pageControl.currentPage] animated:YES];
        [self loadQLWithPage:pageControl.currentPage];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    attachmentScrollView.scrollEnabled = YES;
}

- (BOOL)loadQLWithPage:(int)page {
    QLPreviewController *controller = [self emptyQLView];
    controller.view.frame = [self frameForPage:pageControl.currentPage];
    [controller setCurrentPreviewItemIndex:page];
    
    [self setViewForPage:page];
    
    return YES;
}


- (void)setViewForPage:(int)page {
    NSArray *attachmentInfo = [delegate itemForPage:page];
    NSString* isLoaded = [attachmentInfo objectAtIndex:2];
    if( [isLoaded isEqualToString:@"1"] ) {
        attachmentInfoLabel.hidden = YES;
        openInExtAppButton.hidden = NO;
    }
    else {
        attachmentInfoLabel.text = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"AttachmentsNotLoadedMessage", nil), [attachmentInfo objectAtIndex:0]];
        attachmentInfoLabel.hidden = NO;
        openInExtAppButton.hidden = YES;
    }
}


- (void)setStateForPage:(int)page {
    [self setViewForPage:page];
}

- (void)dealloc {
    [self removeQLView];
    if( onlyQL ) {
        [QLView removeFromSuperview];
        [QLView release];
        QLView = nil;
    }
    else {
        if( nil != attachmentScrollView ) {
            [attachmentScrollView removeFromSuperview];
            [attachmentScrollView release];
            attachmentScrollView = nil;
        }
        if( nil != pageControl ) {
            [pageControl removeFromSuperview];
            [pageControl release];
            pageControl = nil;
        }
    }
    [attachmentInfoLabel release];
    openInExtAppButton = nil;
    self.docInteractionController = nil;
    self.delegate = nil;
	self.attachmentViewPlaceHolder = nil;
    
    [super dealloc];
}

@end
