//
//  iPadDocModuleViewController.h
//  iDoc
//
//  Created by rednekis on 10-12-15.
//  Copyright 2010 KORUS Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iPadBaseViewController.h"
#import "iPadDocListPanelViewController.h"
#import "iPadDocItemPanelViewController.h"
#import "iPadDocModuleLayoutView.h"
#import "iPadListSortViewController.h"
#import "SyncController.h"
#import "iDocAppDelegate.h"
#import "iPadDocActionListViewController.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <EventKitUI/EKEventEditViewController.h>
#import <EventKit/EventKit.h>

@interface iPadDocModuleViewController : iPadBaseViewController 
<iPadDocListPanelViewControllerDelegate, iPadDocItemPanelViewControllerDelegate, iPadInboxListSortViewControllerDelegate, 
iPadSyncDelegate, iPadDocActionListViewControllerDelegate, MFMailComposeViewControllerDelegate, EKEventEditViewDelegate, 
NetworkReachabilityDelegate>  {		
	UIView *contentPanel;
	UIView *contentBodyPanel;
	UIView *leftSlidingPanel;
	UIView *leftSlidingBodyPanel;
	
	iPadDocListPanelViewController *docListPanel;
	UIPopoverController *docListPopover;																	
	iPadDocItemPanelViewController *docItemInfoPanel;

	UIButton *showDocListPopoverButton;
	HFSUILabel *docModuleHeaderTitle;	

    NSString *docModuleTitle;

	iPadDocModuleLayoutView *container;
            
    iPadListSortViewController *listSortViewController;
    UIPopoverController *listSortViewControllerPopover;
    
    NSMutableArray *actions;
    UIPopoverController *docActionsPopover;
    UIButton *actionsPopoverButton;
    
    NSDictionary *loadedItem; 
    NSString *currentActionId;
    
    NSArray *itemsListSortOptions;
    UserInfo *user;
    
    DashboardItem *currentDashboardItem;
}

@property (nonatomic, retain) UIPopoverController *docListPopover;
@property (nonatomic, retain) NSDictionary *loadedItem;
@property (nonatomic, retain) UserInfo *user;

- (id)init;
- (void)loadItemsInDashboardItem:(DashboardItem *)item;
- (NSArray *)getActionsList;
- (void)enableSyncOption;
- (void)disableSyncOption;
@end
