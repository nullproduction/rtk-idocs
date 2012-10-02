//
//  iPadInboxItemPanelButtonsLayoutView.h
//  iDoc
//
//  Created by mark2 on 12/21/10.
//  Copyright 2010 KORUS Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseLayoutView.h"
#import "HFSUIButton.h"

@interface iPadInboxItemPanelButtonsLayoutView : BaseLayoutView {
	HFSUIButton *attachmentsButton;
	HFSUIButton *endorsementButton;
	HFSUIButton *executionButton;
	HFSUIButton *requisitesButton;
}

@property (nonatomic, retain) HFSUIButton *attachmentsButton;
@property (nonatomic, retain) HFSUIButton *endorsementButton;
@property (nonatomic, retain) HFSUIButton *executionButton;
@property (nonatomic, retain) HFSUIButton *requisitesButton;

@end
