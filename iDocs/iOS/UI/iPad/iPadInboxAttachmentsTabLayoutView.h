//
//  iPadInboxAttachmentsTabLayoutView.h
//  iDoc
//
//  Created by mark2 on 12/21/10.
//  Copyright 2010 KORUS Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseLayoutView.h"
#import "HFSUIButton.h"
#import "UIWebView+Block.h"

@protocol iPadInboxAttachmentsTabLayoutViewDelegate <NSObject>
- (NSArray *)itemForPage:(int)page;
@end

@interface iPadInboxAttachmentsTabLayoutView : BaseLayoutView 
<UIScrollViewDelegate, UIWebViewDelegate, UIDocumentInteractionControllerDelegate> {
	UIView *attachmentViewPlaceHolder;
    UIScrollView *attachmentScrollView;
    UIPageControl *pageControl;
    
    UIButton *openInExtAppButton;
    UIDocumentInteractionController *docInteractionController;
    
    int totalNumberOfPages;
    BOOL pageControlUsed;
    
    id<iPadInboxAttachmentsTabLayoutViewDelegate, UIWebViewDelegate> delegate;
    BOOL initialized; //layoutSubview уже был = YES, иначе - NO
    BOOL needsReset;  //при загрузке аттачментов нового документа - перезагружаем 0 страницу
    UIWebView *currPage;
    BOOL currentPageIsDelayingLoading;
}

- (void)setDelegate:(id<iPadInboxAttachmentsTabLayoutViewDelegate, UIWebViewDelegate>)newDelegate;
- (void)setupPages:(int)numberOfPages;

@property(nonatomic, retain) UIView *attachmentViewPlaceHolder;
@property(nonatomic, retain) UIPageControl *pageControl;
@property(nonatomic, retain) UIScrollView *attachmentScrollView;
@property(nonatomic, retain) UIDocumentInteractionController *docInteractionController;
@property int totalNumberOfPages;

@end
