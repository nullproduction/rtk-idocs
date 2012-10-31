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


@interface iPadInboxAttachmentsTabLayoutView : BaseLayoutView <UIDocumentInteractionControllerDelegate,  QLPreviewControllerDataSource> {
	UIView *attachmentViewPlaceHolder;
	UIView *QLView;
    
    UIButton *openInExtAppButton;
    UIDocumentInteractionController *docInteractionController;
    
    int totalNumberOfPages;
    
    id<iPadInboxAttachmentsTabLayoutViewDelegate> delegate;
    
    QLPreviewController *previewer;
}

- (void)setDelegate:(id<iPadInboxAttachmentsTabLayoutViewDelegate>)newDelegate;
- (void)setupPages:(int)numberOfPages;

@property(nonatomic, retain) UIView *attachmentViewPlaceHolder;
@property(nonatomic, retain) UIDocumentInteractionController *docInteractionController;
@property int totalNumberOfPages;

@end
