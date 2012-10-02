//
//  iPadAppSettingsPanelViewController.h
//  iDoc
//
//  Created by rednekis on 10-12-17.
//  Copyright 2010 KORUS Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iPadAppSettingsViewController.h"
#import "iPadBaseViewController.h"
#import "iPadHeaderBodyFooterLayoutView.h"

@class iPadAppSettingsPanelViewController;

@protocol iPadPopupLayoutViewDelegate;
@protocol iPadAppSettingsPanelViewControllerDelegate <NSObject>
@optional
- (void)appSettingsPanelCloseButtonPressed;
@end


@interface iPadAppSettingsPanelViewController : iPadBaseViewController <iPadAppSettingsViewControllerDelegate> {
	iPadAppSettingsViewController *appSettingsViewController;
    //UINavigationController *navController;
    UIButton *backButton;
	id<iPadAppSettingsPanelViewControllerDelegate> delegate;	
}

@property (nonatomic, retain) iPadAppSettingsViewController *appSettingsViewController;
@property (nonatomic, retain) UINavigationController *navController;

- (id)initWithFrame:(CGRect)frame;
- (void)setDelegate:(id<iPadAppSettingsPanelViewControllerDelegate>)newDelegate;
@end
