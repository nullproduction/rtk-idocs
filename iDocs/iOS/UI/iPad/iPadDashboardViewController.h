//
//  iPadDashboardViewController.h
//  iDoc
//
//  Created by mark2 on 12/17/10.
//  Copyright 2010 KORUS Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iPadBaseViewController.h"
#import "iPadDashboardLayoutView.h"
#import "iPadDashboardWidgetView.h"
#import "iPadDashboardWidgetsPanelViewController.h"
#import "iPadDashboardWidgetView.h"
#import "HFSUILabel.h"
#import "HFSUIButton.h"
#import "UserInfo.h"
#import "SyncController.h"
#import "iDocAppDelegate.h"
#import "iPadAppSettingsPanelViewController.h"

@interface iPadDashboardViewController : iPadBaseViewController 
<iPadDashboardWidgetViewDelegate, iPadSyncDelegate, NetworkReachabilityDelegate, iPadAppSettingsPanelViewControllerDelegate> {	
    NSMutableArray  *widgetsPanelArray;    
    NSMutableArray *currentPath;
    NSInteger currentPage;
    iPadAppSettingsPanelViewController *appSettingsPanel;
}

@property (nonatomic, retain) iPadAppSettingsPanelViewController *appSettingsPanel;

- (id)init;
- (void)reloadWidgetData;
- (void)loadData;
- (void)enableSyncOption;
- (void)disableSyncOption;
- (void)settingsButtonPressed;

@end
