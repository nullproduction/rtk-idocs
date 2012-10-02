//
//  iPadInboxItemPanelContentButtonsLayoutView.h
//  iDoc
//
//  Created by mark2 on 1/14/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseLayoutView.h"
#import "HFSUIButton.h"

@interface iPadInboxModuleActionButtonsLayoutView : BaseLayoutView {
	NSMutableArray *buttons;
    UIView *buttonsContainer;
    HFSUILabel *statusLabel;
    BOOL pageControlUsed;
}

@property(nonatomic,retain) NSMutableArray *buttons;

- (void)addButtons:(NSArray *)actions;
- (void)showActionStatus:(NSString *)status;
- (void)removeButtonsAndStatus;
@end
