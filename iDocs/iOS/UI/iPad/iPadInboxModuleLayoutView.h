//
//  iPadInboxModuleLayoutView.h
//  iDoc
//
//  Created by mark2 on 12/19/10.
//  Copyright 2010 KORUS Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iPadBaseLayoutView.h"
#import "iPadInboxModuleActionButtonsLayoutView.h"

@interface iPadInboxModuleLayoutView : iPadBaseLayoutView {
	UIView *leftTopToolbarButtonsPanel;
	HFSUILabel *inboxModuleHeaderTitle;
	HFSUIButton *showInboxListPopoverButton;
	HFSUILabel *showInboxListPopoverButtonTitle;	
	UIButton *navigateHomeButton;
    
	UIView *rightTopToolbarButtonsPanel;
    HFSUIButton *actionsPopoverButton;
    HFSUIButton *upButton;
    HFSUIButton *downButton;
    HFSUIButton *syncButton;
    HFSUIButton *toolsButton;
    
    HFSUILabel *syncButtonHint;
    HFSUILabel *syncButtonValue;

    HFSUILabel *toolsButtonHint;
    HFSUILabel *toolsButtonValue;
    
    iPadInboxModuleActionButtonsLayoutView *actionsPanel;
    
	UIView *leftSlidingPanel;
	UIView *leftSliderFilter;
	UIView *leftSliderBody;
    UIView *leftSliderFooter;
	UIView *leftSliderButton;
	UIImageView *leftSliderButtonImage;	

	BOOL inboxListPanelSlidedOff;
	BOOL slidingInProgress;
}

//left top toolbars
@property(nonatomic,retain) UIView *leftTopToolbarButtonsPanel;
@property(nonatomic,retain) HFSUILabel *inboxModuleHeaderTitle;
@property(nonatomic,retain) HFSUIButton *showInboxListPopoverButton;
@property(nonatomic,retain) HFSUILabel *showInboxListPopoverButtonTitle;
@property(nonatomic,retain) UIButton *navigateHomeButton;

//sliding panel
@property(nonatomic,retain) UIView *leftSlidingPanel;
@property(nonatomic,retain) UIView *leftSliderFilter;
@property(nonatomic,retain) UIView *leftSliderButton;
@property(nonatomic,retain) UIView *leftSliderBody;
@property(nonatomic,retain) UIView *leftSliderFooter;

//right top toolbar
@property(nonatomic,retain) UIView *rightTopToolbarButtonsPanel;
@property(nonatomic,retain) HFSUIButton *actionsPopoverButton;
@property(nonatomic,retain) HFSUIButton *upButton;
@property(nonatomic,retain) HFSUIButton *downButton;
@property(nonatomic,retain) HFSUIButton *syncButton;
@property(nonatomic,retain) HFSUIButton *toolsButton;

@property(nonatomic,retain) HFSUILabel *syncButtonHint;
@property(nonatomic,retain) HFSUILabel *syncButtonValue;

@property(nonatomic,retain) HFSUILabel *toolsButtonHint;
@property(nonatomic,retain) HFSUILabel *toolsButtonValue;


@property(nonatomic,retain) iPadInboxModuleActionButtonsLayoutView *actionsPanel;

- (void)slideLeftPanel;

@end