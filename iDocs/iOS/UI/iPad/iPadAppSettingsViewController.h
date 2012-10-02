//
//  iPadIAppSettingsViewController.h
//  iDoc
//
//  Created by Алексей Алехин on 28.09.11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import "IASKAppSettingsViewController.h"

@protocol iPadAppSettingsViewControllerDelegate <NSObject>
@optional
- (void)showBackButton;
@end

@interface iPadAppSettingsViewController : IASKAppSettingsViewController 
< UINavigationControllerDelegate, IASKSettingsDelegate> {
	id<iPadAppSettingsViewControllerDelegate> appSettingsDelegate;	
}

- (id)initAppSettingsDelegate:(id<iPadAppSettingsViewControllerDelegate>)newAppSettingsDelegate;
- (BOOL)checkIfAllRequiredFieldsAreFilled;
- (void)synchronizeSettings;
@end
