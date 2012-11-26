//
//  iPadDocItemPanelViewController.h
//  iDoc
//
//  Created by rednekis on 10-12-15.
//  Copyright 2010 KORUS Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iPadBaseViewController.h"
#import "HFSUILabel.h"

@protocol iPadDocItemPanelViewControllerDelegate <NSObject>
@end

@interface iPadDocItemPanelViewController : iPadBaseViewController <UIWebViewDelegate, UIDocumentInteractionControllerDelegate> {	
    NSDictionary *loadedItem; 	
    UIWebView *attachmentWebView;
    HFSUILabel *placeholderLabel;
    
    UIDocumentInteractionController *docInteractionController;
}

@property(nonatomic, retain) NSDictionary *loadedItem;
@property(nonatomic, retain) UIDocumentInteractionController *docInteractionController;

- (id)initWithContentPlaceholderView:(UIView *)contentPanel andDelegate:(id<iPadDocItemPanelViewControllerDelegate>)newDelegate;
- (void)loadItem:(NSDictionary *)item;

@end
