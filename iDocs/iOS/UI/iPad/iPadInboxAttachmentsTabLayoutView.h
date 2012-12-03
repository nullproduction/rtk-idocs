//
//  iPadInboxAttachmentsTabLayoutView.h
//  iDoc
//
//  Created by mark2 on 12/21/10.
//  Copyright 2010 KORUS Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuickLook/QuickLook.h>
#import <QuartzCore/QuartzCore.h>
#import "BaseLayoutView.h"
#import "HFSUIButton.h"
#import "UIWebView+Block.h"


@protocol iPadInboxAttachmentsTabLayoutViewDelegate <NSObject>

- (NSArray *)itemForPage:(int)page;

@end

@protocol QLookPreviewControllerDelegate <NSObject>

- (void)setStateForPage:(int)page;

@end

@interface QLookPreviewController : QLPreviewController {

    id<QLookPreviewControllerDelegate> delegateQL;
    
}

- (void)setDelegateQL:(id<QLookPreviewControllerDelegate>)_delegate;

@end


@interface iPadInboxAttachmentsTabLayoutView : BaseLayoutView <UIScrollViewDelegate, UIDocumentInteractionControllerDelegate,
    QLPreviewControllerDataSource, QLPreviewControllerDelegate, QLookPreviewControllerDelegate> {
        
	UIView *attachmentViewPlaceHolder;
    
    UINavigationController* navController;
	UIView *QLView;
    BOOL onlyQL;
    
    UIScrollView* attachmentScrollView;
    UIPageControl* pageControl;
    BOOL initialized;
    BOOL needsReset;

    UILabel *attachmentInfoLabel;
    UIButton *openInExtAppButton;
    UIDocumentInteractionController *docInteractionController;
    
    int totalNumberOfPages;
    
    id<iPadInboxAttachmentsTabLayoutViewDelegate> delegate;
    
    QLPreviewController *previewer;
    QLookPreviewController *viewer;
}

- (void)setDelegate:(id<iPadInboxAttachmentsTabLayoutViewDelegate>)newDelegate;

- (void)setupPages:(int)numberOfPages;
- (void)removeQLView;

@property(nonatomic, retain) UIView *attachmentViewPlaceHolder;
@property(nonatomic, retain) UIDocumentInteractionController *docInteractionController;
@property int totalNumberOfPages;

@property(nonatomic, retain) UIPageControl *pageControl;
@property(nonatomic, retain) UIScrollView *attachmentScrollView;

@property(nonatomic, retain) UINavigationController* navController;

@end
