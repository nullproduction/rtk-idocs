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
#import <QuartzCore/QuartzCore.h>


@interface QLookPreviewController : QLPreviewController

- (void)setSubviewsBackgroundColor:(UIView*)view;

@end

@implementation QLookPreviewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //Find webview and set its subviews' background color to white
    [[self.view subviews] enumerateObjectsUsingBlock:^(UIView* view, NSUInteger idx, BOOL *stop) {
        
        [self setSubviewsBackgroundColor:view];
        
    }];
}

- (void)setSubviewsBackgroundColor:(UIView*)view{
    
    [[view subviews] enumerateObjectsUsingBlock:^(UIView* subview, NSUInteger idx, BOOL *stop) {
        
        if ([subview isKindOfClass:[UIWebView class]]) {
            
            [subview setBackgroundColor:[UIColor whiteColor]];
            [[subview subviews] enumerateObjectsUsingBlock:^(UIView* view, NSUInteger idx, BOOL *stop) {
                [view setBackgroundColor:[UIColor whiteColor]];
            }];
        }
        else [self setSubviewsBackgroundColor:subview];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];  // make the change for example
}

@end


@interface iPadInboxAttachmentsTabLayoutView(PrivateMethods)
- (BOOL)loadWebViewWithPage:(int)page;
- (void)changePage1:(int)offsetPage;//new implementation
- (void)gotoPageDelayer;
- (void)setupDocumentControllerWithURL:(NSURL *)url andName:(NSString *)name;
@end

@implementation iPadInboxAttachmentsTabLayoutView
@synthesize docInteractionController, attachmentViewPlaceHolder, totalNumberOfPages, pageControl, attachmentScrollView;

- (void)removeQLView {    
    if (previewer != nil) {
        [previewer setDataSource:nil];
        [previewer.view removeFromSuperview];
        [previewer release];
    }
}

- (QLookPreviewController *)emptyQLView {
    [self removeQLView];
    
//    currPage.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    currPage.mediaPlaybackRequiresUserAction = YES;
//    currPage.scalesPageToFit = YES;
//    currPage.alpha = 0;
    
    previewer = [[QLookPreviewController alloc] init];
    previewer.view.frame = attachmentScrollView.bounds;
//    previewer.view.backgroundColor = [UIColor darkGrayColor];
    previewer.view.contentScaleFactor = constViewScaleFactor;

    [previewer setDataSource:self];
    [previewer setDelegate:self];
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
        
        openInExtAppButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [openInExtAppButton setImage:[UIImage imageNamed:[iPadThemeBuildHelper nameForImage:@"open_in_external_app_button"]]
                            forState:UIControlStateNormal];
        [openInExtAppButton addTarget:self action:@selector(openInExtAppButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [attachmentViewPlaceHolder addSubview:openInExtAppButton];
                
        initialized = NO;
    }
    return self;
}

- (void)setDelegate:(id<iPadInboxAttachmentsTabLayoutViewDelegate, UIWebViewDelegate>)newDelegate {
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
    NSArray *attachmentInfo = [delegate itemForPage:pageControl.currentPage];
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


#pragma mark UIScrollView methods
- (void)setupPages:(int)numberOfPages {
    totalNumberOfPages = numberOfPages;
    pageControl.numberOfPages = totalNumberOfPages;
    pageControl.currentPage = 0;
    needsReset = YES;

    if (initialized) {
        attachmentScrollView.contentSize 
            = CGSizeMake(attachmentScrollView.bounds.size.width * totalNumberOfPages, attachmentScrollView.bounds.size.height);
    }
    [self changePage1:pageControl.currentPage];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    pageControlUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pageControlUsed = NO;
	int gotoPage = (int)(scrollView.contentOffset.x / scrollView.bounds.size.width);
	
	if (pageControl.currentPage != gotoPage) {
		pageControl.currentPage = gotoPage;
		[self gotoPageDelayer];
	}
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	CGRect attachmentViewPlaceHolderFrame = CGRectInset(self.bounds, 5, 5);
	attachmentViewPlaceHolder.frame = attachmentViewPlaceHolderFrame;	

    attachmentScrollView.frame = attachmentViewPlaceHolder.bounds;
    attachmentScrollView.contentSize 
        = CGSizeMake(attachmentViewPlaceHolder.bounds.size.width * totalNumberOfPages, attachmentViewPlaceHolder.bounds.size.height);
    
    pageControl.frame = CGRectInset(CGRectMake(attachmentViewPlaceHolder.bounds.origin.x, 
                                               attachmentViewPlaceHolder.bounds.origin.y + attachmentViewPlaceHolder.bounds.size.height - 50, 
                                               attachmentViewPlaceHolder.bounds.size.width, 
                                               50), 100, 17);
    
    if (!initialized) {
        initialized = YES;
        [self loadWebViewWithPage:0];
    }
    
    openInExtAppButton.frame = CGRectMake(attachmentViewPlaceHolder.bounds.origin.x + attachmentViewPlaceHolder.bounds.size.width - 77, 
                               attachmentViewPlaceHolder.bounds.origin.y + attachmentViewPlaceHolder.bounds.size.height - 38, 
                               26, 22);
}

- (void)gotoPageDelayer {	
	if (currentPageIsDelayingLoading)
		[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(gotoPage) object:nil];
	
	currentPageIsDelayingLoading = YES;
	[self performSelector:@selector(gotoPage) withObject:nil afterDelay:0.1];
}

- (CGRect)frameForPage:(int)page {
    return CGRectMake(attachmentScrollView.bounds.size.width * page, 
                      0.0f, 
                      attachmentScrollView.bounds.size.width, 
                      attachmentScrollView.bounds.size.height);
}

- (void)changePage { //вызывается из пейджера, нулевое приращение. будет отображена страница для номера, выбранного в пейджере
    pageControlUsed = YES;
    needsReset = YES;
    [self changePage1:0];
}

- (void)changePage1:(int)offsetPage { //вызывается программно, с приращением (+/-). будет отображена страница = текущая + приращение
    if (!initialized) {//нельзя вызывать loadScrollViewWithPage раньше layoutSubviews
        return;
    }
    int page = pageControl.currentPage + offsetPage;
    
    if (page < 0) {
		pageControl.currentPage = 0;
	} else if (page > totalNumberOfPages) {
		pageControl.currentPage = totalNumberOfPages-1;
	} else if (page != pageControl.currentPage || needsReset) {
        needsReset = NO;
        pageControl.currentPage = page;
    
        [attachmentScrollView scrollRectToVisible:[self frameForPage:pageControl.currentPage] animated:YES];
        [self gotoPageDelayer];
    }    
}

- (void)gotoPage {
    [self loadWebViewWithPage:pageControl.currentPage];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    attachmentScrollView.scrollEnabled = YES;
}

- (BOOL)loadWebViewWithPage:(int)page {
//    UIWebView *webView = [self emptyWebView];
//    webView.alpha = 0;
//    webView.frame = [self frameForPage:pageControl.currentPage];
//    NSArray *attachmentInfo = [delegate itemForPage:page];
//    NSString *attachmentPath = [SupportFunctions createPathForAttachment:[attachmentInfo objectAtIndex:1]];
//    NSURL *attachmentUrl = [NSURL fileURLWithPath:attachmentPath];
//    NSURLRequest *request = [NSURLRequest requestWithURL:attachmentUrl];
//    [webView loadRequest:request];
//    NSLog(@"request %@ ", [request description]);
//    return YES;


    QLookPreviewController *controller = [self emptyQLView];
    controller.view.frame = [self frameForPage:pageControl.currentPage];
    controller.view.backgroundColor = [UIColor darkGrayColor];
    controller.view.contentScaleFactor = constViewScaleFactor;

    [controller setCurrentPreviewItemIndex:page];
    return YES;
}


#pragma mark Preview Controller

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller {
	return totalNumberOfPages;
}

- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index {
    NSArray *attachmentInfo = [delegate itemForPage:index];
    NSString *attachmentPath = [SupportFunctions createPathForAttachment:[attachmentInfo objectAtIndex:1]];
    NSLog(@"attachmentPath %@ at index %i", attachmentPath, index);
    
	return [NSURL fileURLWithPath:attachmentPath];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
}

- (void)dealloc {
    [self removeQLView];
    
	self.attachmentViewPlaceHolder = nil;
    self.attachmentScrollView = nil;
    self.pageControl = nil;
    self.docInteractionController = nil;
    [super dealloc];
}


@end
