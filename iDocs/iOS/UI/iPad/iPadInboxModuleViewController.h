//
//  iPadInboxModuleViewController.h
//  iDoc
//
//  Created by rednekis on 10-12-15.
//  Copyright 2010 KORUS Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iPadBaseViewController.h"
#import "iPadInboxListPanelViewController.h"
#import "iPadInboxItemPanelViewController.h"
#import "iPadAttachmentViewController.h"
#import "iPadErrandPanelViewController.h"
#import "iPadResolutionViewController.h"
#import "iPadInboxModuleLayoutView.h"
#import "iPadTaskActionListViewController.h"
#import "iPadInboxModuleActionButtonsLayoutView.h"
#import "iPadListSortViewController.h"
#import "iPadResolutionReportsListViewController.h"
#import "iPadResolutionPanelViewController.h"
#import "Task.h"
#import "Doc.h"
#import "iDocAppDelegate.h"
#import "UserInfo.h"

@protocol iPadInboxModuleViewControllerDelegate <NSObject>
@optional
- (void)showAttachmentWithFileName:(NSString *)attachmentFileName andName:(NSString *)attachmentName;
- (void)errandViewCloseButtonPressed;
- (void)showResolution:(ActionToSync *)serverAction withTitle:(NSString *)resolutionTitle;
- (void)resolutionViewCloseButtonPressed;
- (void)selectReportButtonPressed;
@end

@interface iPadInboxModuleViewController : iPadBaseViewController 
<iPadInboxListPanelViewControllerDelegate, iPadAttachmentViewControllerDelegate, iPadInboxRequisitesTabViewControllerDelegate, 
 iPadInboxExecutionTabViewControllerDelegate, iPadErrandPanelViewControllerDelegate, 
 iPadResolutionViewControllerDelegate, iPadTaskActionListViewControllerDelegate, iPadInboxListSortViewControllerDelegate, 
 iPadSyncDelegate, NetworkReachabilityDelegate>  {																	   
	UIView *contentPanel;
	UIView *contentBodyPanel;
	UIView *buttonsPanel;
	UIView *leftSlidingBodyPanel;
	
	iPadInboxListPanelViewController *inboxListPanel;
	iPadInboxItemPanelViewController *inboxItemInfoPanel;

	UIButton *showInboxListPopoverButton;
	HFSUILabel *inboxModuleHeaderTitle;	
	
	iPadAttachmentViewController *attachmentPanel;
	iPadErrandPanelViewController *errandPanel;
	iPadResolutionPanelViewController *resolutionPanel;
		     
	iPadInboxModuleLayoutView *container;
    
    UIPopoverController *taskActionsPopover;
    UIButton *actionsPopoverButton;
    
    
    iPadListSortViewController *listSortViewController;
    UIPopoverController *listSortViewControllerPopover;
    
    NSArray *itemsListSortOptions;
    
    DashboardItem *currentDashboardItem;
}

@property (nonatomic, retain) UIPopoverController *inboxListPopover;
@property (nonatomic, retain) Task *loadedItem;
@property (nonatomic, retain) UserInfo *user;
@property (nonatomic, retain) NSString *currentActionToSyncId;
@property (nonatomic, retain) NSString *inboxModuleTitle;

- (id)init;
- (void)loadItemsInDashboardItem:(DashboardItem *)item;
- (NSArray *)getActionsList;
- (void)enableSyncOption;
- (void)disableSyncOption;
- (NSArray *)selectOnlyMyErrands;

@end
