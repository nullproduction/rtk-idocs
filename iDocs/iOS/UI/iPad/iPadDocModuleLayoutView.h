//
//  iPadDocModuleLayoutView.h
//  iDoc
//
//  Created by mark2 on 12/19/10.
//  Copyright 2010 KORUS Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iPadBaseLayoutView.h"

@interface iPadDocModuleLayoutView : iPadBaseLayoutView {
	
    //left top toolbars
	UIView *leftTopToolbarButtonsPanel;
	HFSUILabel *docModuleHeaderTitle;
	HFSUIButton *showDocListPopoverButton;
	HFSUILabel *showDocListPopoverButtonTitle;	
	UIButton *navigateHomeButton;
    
    //right top toolbar
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
    
    //sliding panel
	UIView *leftSlidingPanel;
	UIView *leftSliderFilter;
	UIView *leftSliderBody;
    UIView *leftSliderFooter;
	UIView *leftSliderButton;
	UIImageView *leftSliderButtonImage;	
    
	BOOL docListPanelSlidedOff;
	BOOL slidingInProgress;
}

@property(nonatomic, retain) UIView *leftTopToolbarButtonsPanel;
@property(nonatomic, retain) HFSUILabel *docModuleHeaderTitle;
@property(nonatomic, retain) HFSUIButton *showDocListPopoverButton;
@property(nonatomic, retain) HFSUILabel *showDocListPopoverButtonTitle;
@property(nonatomic, retain) UIButton *navigateHomeButton;

@property(nonatomic, retain) UIView *leftSlidingPanel;
@property(nonatomic, retain) UIView *leftSliderFilter;
@property(nonatomic, retain) UIView *leftSliderButton;
@property(nonatomic, retain) UIView *leftSliderBody;
@property(nonatomic, retain) UIView *leftSliderFooter;
@property(nonatomic, retain) UIImageView *leftSliderButtonImage;

@property(nonatomic, retain) UIView *rightTopToolbarButtonsPanel;
@property(nonatomic, retain) HFSUIButton *actionsPopoverButton;
@property(nonatomic, retain) HFSUIButton *upButton;
@property(nonatomic, retain) HFSUIButton *downButton;
@property(nonatomic, retain) HFSUIButton *syncButton;
@property(nonatomic, retain) HFSUIButton *toolsButton;

@property(nonatomic, retain) HFSUILabel *syncButtonHint;
@property(nonatomic, retain) HFSUILabel *syncButtonValue;

@property(nonatomic, retain) HFSUILabel *toolsButtonHint;
@property(nonatomic, retain) HFSUILabel *toolsButtonValue;


- (void)slideLeftPanel;
@end