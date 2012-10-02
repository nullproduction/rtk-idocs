//
//  iPadInboxModuleViewController.m
//  iDoc
//
//  Created by rednekis on 10-12-15.
//  Copyright 2010 KORUS Consulting. All rights reserved.
//

#import "iPadInboxModuleViewController.h"
#import "iPadDashboardViewController.h"
#import "iPadDashboardLayoutView.h"
#import "HFSUIActionSheet.h"
#import "ActionToSync.h"
#import "TaskAction.h"
#import "DocErrand.h"
#import "SystemDataEntity.h"
#import <QuartzCore/QuartzCore.h>
#import "UserDefaults.h"
#import "CoreDataProxy.h"
#import "TaskDataEntity.h"
#import "DocDataEntity.h"
#import "ActionToSyncDataEntity.h"


@interface iPadInboxModuleViewController(PrivateMethods)
//init
- (void)formatItemHeader:(int)numberOfRecords;
//behavior
- (void)removeSelectedItem;
- (void)removeAllItems;
- (void)navigateHome;
- (void)reloadDataAfterSync;
//actions:
- (NSArray *)getActionsList;
- (void)presentActionsList:(id)sender;
- (void)createWorkflowButtons;
- (void)showErrand:(DocErrand *)errand usingMode:(int)mode;
- (void)showErrand:(DocErrand *)errand forTaskAction:(ActionToSync *)action orTaskId:(NSString *)taskId usingMode:(int)mode;
- (void)showResolution:(ActionToSync *)action withTitle:(NSString *)resolutionTitle;
- (void)submitActionToServer:(ActionToSync *)action;
- (void)submitActionWithResolutionToServer:(ActionToSync *)action;
- (void)updateCurrentAction:(ActionToSync *)action;
- (void)submitActionsToServer;
@end

@implementation iPadInboxModuleViewController

@synthesize inboxListPopover, loadedItem, currentActionToSyncId, inboxModuleTitle, user;

- (UIColor *)backgroundColor {
    return [UIColor colorWithPatternImage:[UIImage imageNamed:[iPadThemeBuildHelper nameForImage:@"background_tile.png"]]];
}

#pragma mark visual module init
- (id)init {
	NSLog(@"iPadInboxModule init");
    if ((self = [super init])) {
		container = [[iPadInboxModuleLayoutView alloc] init];
		self.view = container;
		        
        [container.upButton addTarget:self action:@selector(selectingPreviousItem) forControlEvents:UIControlEventTouchUpInside];
        [container.downButton addTarget:self action:@selector(selectingNextItem) forControlEvents:UIControlEventTouchUpInside];
        
		//right toolbar actionsPopoverButton
        actionsPopoverButton = container.actionsPopoverButton;
		[actionsPopoverButton addTarget:self action:@selector(presentActionsList:) forControlEvents:UIControlEventTouchUpInside];
		
		//items list popover button
		showInboxListPopoverButton = container.showInboxListPopoverButton;
		[showInboxListPopoverButton addTarget:self action:@selector(showItemsListPopoverButtonPressed) forControlEvents:UIControlEventTouchUpInside];
		
		//inbox module header title
		inboxModuleHeaderTitle = container.inboxModuleHeaderTitle;
		
		//navigation home button
		[container.navigateHomeButton addTarget:self action:@selector(navigateHome) forControlEvents:UIControlEventTouchUpInside];
		
		//items list
		leftSlidingBodyPanel = container.leftSliderBody;
		inboxListPanel = [[iPadInboxListPanelViewController alloc] 
                          initWithBodyView:container.leftSliderBody 
                          filterView:container.leftSliderFilter 
                          buttonView:container.leftSliderButton 
                          andDelegate:self];
		
		//панель кнопок под списком документов
        [container.toolsButton addTarget:self action:@selector(showListSortOptions:) forControlEvents:UIControlEventTouchUpInside];
        [container.syncButton addTarget:self action:@selector(syncData:) forControlEvents:UIControlEventTouchUpInside];
        
		//task panel
		contentPanel = container.contentPanel;
		contentBodyPanel = container.contentBodyPanel;
		buttonsPanel = container.trayButtonsPanel;
		
		inboxItemInfoPanel = [[iPadInboxItemPanelViewController alloc] initWithContentPlaceholderView:contentBodyPanel 
                                                                                     buttonsPanelView:buttonsPanel
                                                                                          andDelegate:self];		        
        
        SystemDataEntity *systemEntity = [[SystemDataEntity alloc] initWithContext:[[CoreDataProxy sharedProxy] workContext]];
        self.user = [systemEntity userInfo]; 
        [systemEntity release];
        
        user.ORDListSortType = (user.ORDListSortType == nil) ? [NSNumber numberWithInt:0] : user.ORDListSortType;
        itemsListSortOptions = [[NSArray alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"InboxModuleItemsListSortOptions" withExtension:@"plist"]];
        inboxListPanel.sortFields = [[itemsListSortOptions objectAtIndex:[user.ORDListSortType intValue]] valueForKey:@"sortFields"];
        listSortViewController = [[iPadListSortViewController alloc] initWithSortOptionsDelegate:self];
        listSortViewControllerPopover = [[UIPopoverController alloc] initWithContentViewController:listSortViewController];
    }
    return self;	
}


#pragma mark - sort options:
- (void)showListSortOptions:(HFSUIButton *)sender {
    [listSortViewControllerPopover presentPopoverFromRect:sender.bounds inView:sender permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    [listSortViewController setSelectedItem:[user.ORDListSortType intValue]];
}


#pragma mark - sort options - iPadInboxListSortViewControllerDelegate methods
- (void)didSelectSortOptionWithIndex:(int)index {
    user.ORDListSortType = [NSNumber numberWithInt:index];
    inboxListPanel.sortFields = [[itemsListSortOptions objectAtIndex:index] valueForKey:@"sortFields"];
    [listSortViewControllerPopover dismissPopoverAnimated:YES];

    [self loadItemsInDashboardItem:currentDashboardItem];
}

- (NSArray *)getSortOptions {
    return itemsListSortOptions;
}


#pragma mark - local sync:
- (void)syncData:(HFSUIButton *)sender {
    NSLog(@"iPadInboxModule syncData pressed");
	iDocAppDelegate *appDelegate = (iDocAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate startFullSync];
}


#pragma mark - syncDelegate:
- (void)syncFinished {    
    NSLog(@"iPadInboxModule syncFinished");
    [self reloadDataAfterSync];
}

- (void)reloadDataAfterSync {
    NSLog(@"iPadInboxModule reloadDataAfterSync");  
    iDocAppDelegate *appDelegate = (iDocAppDelegate *)[[UIApplication sharedApplication] delegate]; 

    //reload dashboard data
    NSArray *controllers = [appDelegate.navigationController viewControllers];
    UIViewController *rootController = [controllers objectAtIndex:0];
    if ([rootController isMemberOfClass:iPadDashboardViewController.class]) {
        [(iPadDashboardViewController *)rootController loadData];
    }
    
    //remove previous data
    currentDashboardItem = nil;
    self.loadedItem = nil;
    self.user = nil;
    
    //load new data
    ClientSettingsDataEntity *settingsDataEntity = 
        [[ClientSettingsDataEntity alloc] initWithContext:[[CoreDataProxy sharedProxy] workContext]];
    DashboardItem *item = [settingsDataEntity selectDashboardItemById:[UserDefaults stringSettingByKey:constSyncDashboardItemId]];
    if (item == nil) {	
        [self navigateHome];
    }
    else {
        [self loadItemsInDashboardItem:item];   
    }
    [settingsDataEntity release];
}

- (void)formatItemHeader:(int)numberOfRecords {
	NSString *popoverTitle = [NSString stringWithFormat:@"%@ (%i)", inboxModuleTitle, numberOfRecords];
	container.showInboxListPopoverButtonTitle.text = popoverTitle;
    
    NSString *moduleTitle = [NSString stringWithFormat:@"%@ (%i)", inboxModuleTitle, numberOfRecords];
    if (self.loadedItem != nil) {
        NSString *itemTitle = constEmptyStringValue; 
        NSString *docDesc = (self.loadedItem.doc.desc != nil) ? self.loadedItem.doc.desc : constEmptyStringValue;
        NSString *docRegNumber = (self.loadedItem.doc.regNumber != nil) ? self.loadedItem.doc.regNumber : nil;
        NSString *docRegDate = (self.loadedItem.doc.regDate != nil) ? [SupportFunctions convertDateToString:self.loadedItem.doc.regDate withFormat:constDateFormat] : nil;
        if (docRegNumber != nil && docRegDate != nil) {
            itemTitle = [NSString stringWithFormat:@"№ %@ %@ %@ (%@)", docRegNumber, NSLocalizedString(@"FromTitle", nil), docRegDate, docDesc];
        }
        else if (docRegNumber == nil && docRegDate != nil) {
            itemTitle = [NSString stringWithFormat:@"№ -- %@ %@ (%@)", NSLocalizedString(@"FromTitle", nil), docRegDate, docDesc];        
        }
        else if (docRegNumber != nil && docRegDate == nil) {
            itemTitle = [NSString stringWithFormat:@"№ %@ (%@)", docRegNumber, docDesc];
        }
        else if (docRegNumber == nil && docRegDate == nil) {
            itemTitle = docDesc;
        }
        moduleTitle = [moduleTitle stringByAppendingFormat:@": %@", itemTitle];   
    }
	inboxModuleHeaderTitle.text = moduleTitle;
}


#pragma mark module data
- (void)loadItemsInDashboardItem:(DashboardItem *)item {
	NSLog(@"iPadInboxModule loadItemsInDashboardItem: %@", item.id);
	[self removeAllItems];
		
    currentDashboardItem = item;
    //save id to keep it between background period
    [UserDefaults saveValue:currentDashboardItem.id forSetting:constSyncDashboardItemId];
    SystemDataEntity *systemEntity = [[SystemDataEntity alloc] initWithContext:[[CoreDataProxy sharedProxy] workContext]];
    self.user = [systemEntity userInfo];
    [systemEntity release];
    
    container.toolsButtonValue.text = [[itemsListSortOptions objectAtIndex:[user.ORDListSortType intValue]] valueForKey:@"name"];
    NSString *lastSyncDateString = [UserDefaults stringSettingByKey:constLastSuccessfullSyncDate];
    container.syncButtonValue.text = 
        ([lastSyncDateString length] ? lastSyncDateString : NSLocalizedString(@"UnknownLastSyncDateText", nil));        
    container.syncButton.hidden = NO;
	iDocAppDelegate *appDelegate = (iDocAppDelegate *)[[UIApplication sharedApplication] delegate];
    container.syncButton.enabled = 
        (([UserDefaults useORDServer] == YES || [UserDefaults useWebDavServer] == YES)  && appDelegate.serverActive == YES);

    
	self.inboxModuleTitle = item.name;
	inboxModuleHeaderTitle.text = inboxModuleTitle;

	container.showInboxListPopoverButtonTitle.text = inboxModuleTitle;    
	
	[inboxListPanel loadDataForDashboardItemId:item.id];
}

- (void)enableSyncOption {
    NSLog(@"iPadInboxModule enableSyncOption");
    container.syncButton.enabled = YES;    
}

- (void)disableSyncOption {
    NSLog(@"iPadInboxModule disableSyncOption");
    container.syncButton.enabled = NO;    
}

- (void)selectingPreviousItem {
	NSLog(@"iPadInboxModule selectingPreviousItem");
    if (![inboxListPanel selectPreviousItem]) {
        container.upButton.enabled = NO;
    }
    
    if (container.downButton.enabled == NO)
        container.downButton.enabled = YES;
}

- (void)selectingNextItem {
	NSLog(@"iPadInboxModule selectingNextItem");
    if (![inboxListPanel selectNextItem]) {
        container.downButton.enabled = NO;
    }
    
    if (container.upButton.enabled == NO)
        container.upButton.enabled = YES;
}

- (void)removeSelectedItem {
	NSLog(@"iPadInboxModule removeSelectedItem");	
	[inboxItemInfoPanel removeCurrentItem];
	[inboxListPanel removeSelectedItem];
	[inboxListPanel selectItemInRow:0];
	[self formatItemHeader:[inboxListPanel numberOfLoadedItems]];
}

- (void)removeAllItems {
	NSLog(@"iPadInboxModule removeAllItems");	
	[inboxItemInfoPanel removeCurrentItem];
	[inboxListPanel removeItemList];
}


#pragma mark module behavior
- (void)slideInboxListPanelButtonPressed {
	NSLog(@"iPadInboxModule slideTaskListPanelButtonPressed");	
	[container slideLeftPanel];
}

- (void)showItemsListPopoverButtonPressed {
	NSLog(@"iPadInboxModule showItemsListPopoverButtonPressed");	
	UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:inboxListPanel.inboxListTableViewController];
	popover.popoverContentSize = CGSizeMake(320.0f, 700.0f);	
	self.inboxListPopover = popover;
	[popover release];
	
	UIView *anchorView = showInboxListPopoverButton;
	CGRect anchorRect = CGRectMake(0.0f, 0.0f, anchorView.frame.size.width, anchorView.frame.size.height);
	[self.inboxListPopover presentPopoverFromRect:anchorRect inView:anchorView permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];	
}

- (void)navigateHome {
	NSLog(@"iPadInboxModule navigateHome");		
	iDocAppDelegate *appDelegate = (iDocAppDelegate *)[[UIApplication sharedApplication] delegate];	
	NSArray *controllers = [appDelegate.navigationController viewControllers];
	UIViewController *rootController = [controllers objectAtIndex:0];
	if ([rootController isMemberOfClass:iPadDashboardViewController.class]) {
		[(iPadDashboardViewController *)rootController reloadWidgetData];
	}
	[appDelegate.navigationController popToRootViewControllerAnimated:YES];
	
}

#pragma mark custom methods - delegate implementation methods
- (void)didSelectItem:(Task *)item {
	NSLog(@"iPadInboxModule didSelectItem:%@ %@", item.id, item.doc.id);
	if (self.inboxListPopover.popoverVisible == YES) {
		[self.inboxListPopover dismissPopoverAnimated:YES];
	}
    self.loadedItem = item;
    [self formatItemHeader:[inboxListPanel numberOfLoadedItems]];
    [self createWorkflowButtons];
    
	[inboxItemInfoPanel loadItem:item];	
}

- (void)itemsListFilterIsUsed {
	NSLog(@"iPadInboxModule itemsListFilterIsUsed");	
	[inboxItemInfoPanel removeCurrentItem];
}


#pragma mark actions create methods
- (NSArray *)getActionsList {
    TaskDataEntity *taskEntity = [[TaskDataEntity alloc] initWithContext:[[CoreDataProxy sharedProxy] workContext]];
    NSArray *actionsList = [taskEntity selectTaskActionsforTaskWithId:self.loadedItem.id];
    [taskEntity release];
    return actionsList;
}

- (void)createWorkflowButtons {   
	NSLog(@"iPadInboxModule createWorkflowButtons");	
	NSArray *actions = [self getActionsList];
    
    //action panel
    [container.actionsPanel removeButtonsAndStatus];
    if ([actions count] > 0) {
        [container.actionsPanel addButtons:actions];
                 
        //bind actions to buttons
        for (int i = 0; i < [container.actionsPanel.buttons count]; i++) {
            HFSUIButton *button = [container.actionsPanel.buttons objectAtIndex:i];
            [button addTarget:self action:@selector(executeWorkflowAction:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = i;
        }
    } else if (self.loadedItem.systemActionResultText != nil) {
        [container.actionsPanel showActionStatus:self.loadedItem.systemActionResultText];
    }
    
    //popover button
    if ([actions count] == 0) {
        actionsPopoverButton.enabled = NO;
        actionsPopoverButton.hidden = YES;       
    }
    else if ([actions count] > 0 && [actions count] <=2) {
        actionsPopoverButton.enabled = NO;
        actionsPopoverButton.hidden = NO;
    }
    else {
        actionsPopoverButton.enabled = YES;
        actionsPopoverButton.hidden = NO;
    }
}

- (void)presentActionsList:(UIButton *)sender {
	NSLog(@"iPadInboxModule presentActionsList");
	NSArray *actions = [self getActionsList];
    if ([actions count] > 2) {
        iPadTaskActionListViewController *actionSheet = [[iPadTaskActionListViewController alloc] init];
        [actionSheet setActionsDelegate:self];
        taskActionsPopover = [[UIPopoverController alloc] initWithContentViewController:actionSheet];    
        [actionSheet release];
        taskActionsPopover.popoverContentSize = CGSizeMake(250.0f, constListItemCellHeight*[actions count] + 40);
        [taskActionsPopover presentPopoverFromRect:sender.bounds  
                                            inView:sender
                          permittedArrowDirections:UIPopoverArrowDirectionUp
                                          animated:YES];	
    }
}

- (void)executeWorkflowAction:(id)sender {
	NSLog(@"iPadInboxItemPanel workflowAction");
    [self didSelectActionAtIndexPath:[NSIndexPath indexPathForRow:[(HFSUIButton *)sender tag] inSection:0]];
}

- (void)didSelectActionAtIndexPath:(NSIndexPath *)indexPath {
    [taskActionsPopover dismissPopoverAnimated:NO];
    
	int selectedButtonIndex = indexPath.row;
	
	NSArray *actions = [self getActionsList];
	NSString *actionId = ((TaskAction *)[actions objectAtIndex:selectedButtonIndex]).id;
	NSString *actionType = ((TaskAction *)[actions objectAtIndex:selectedButtonIndex]).type;
    NSNumber *actionIsFinal = ((TaskAction *)[actions objectAtIndex:selectedButtonIndex]).isFinal;
    NSString *actionResultText = ((TaskAction *)[actions objectAtIndex:selectedButtonIndex]).resultText;
    
    ActionToSync *action = nil;
    //create new action
    if ([actionType isEqualToString:constTaskActionTypeSubmit] ||
        [actionType isEqualToString:constTaskActionTypeSubmitWithComment] ||
        [actionType isEqualToString:constTaskActionTypeAddErrandReport] ||
        //[actionType isEqualToString:constTaskActionTypeAddNotice] ||
        [actionType isEqualToString:constTaskActionTypeAddErrand] ||
        [actionType isEqualToString:constTaskActionTypeAddMultiErrand]) {
        
        self.currentActionToSyncId = [NSString stringWithFormat: @"%@_%.0f", @"action", [NSDate timeIntervalSinceReferenceDate] * 1000.0];
        ActionToSyncDataEntity *actionsEntity = 
            [[ActionToSyncDataEntity alloc] initWithContext:[[CoreDataProxy sharedProxy] workContext]];
        action = [actionsEntity createActionToSync];
        [actionsEntity release];
        action.id = currentActionToSyncId;
        action.docId = loadedItem.doc.id;
        action.taskId = loadedItem.id;
        action.actionId = actionId;
        action.actionType = actionType;
        action.actionIsFinal = actionIsFinal;
        action.actionResultText = actionResultText;
        action.actionDate = [SupportFunctions dateTime]; //iDocSync compatability;
        action.systemSyncStatus = constSyncStatusWorking;
    }
    
	if ([actionType isEqualToString:constTaskActionTypeSubmit]) {
        action.requestType = [NSNumber numberWithInt:constRequestTypeTaskAction];
        [self submitActionToServer:action];
    } 		
    else if ([actionType isEqualToString:constTaskActionTypeSubmitWithComment] ||
             [actionType isEqualToString:constTaskActionTypeAddErrandReport]) {
        action.requestType = [NSNumber numberWithInt:constRequestTypeTaskAction];
        NSString *resolutionTitle = 
            NSLocalizedString(([actionType isEqualToString:constTaskActionTypeSubmitWithComment]) ? @"ResolutionFormTitle" : @"ErrandReportFormTitle", nil);
        [self showResolution:action withTitle:resolutionTitle];
    } 	
	else if ([actionType isEqualToString:constTaskActionTypeAddErrand] ||
             [actionType isEqualToString:constTaskActionTypeAddMultiErrand]) {
        action.requestType = [NSNumber numberWithInt:constRequestTypeCreateOrUpdateErrandAction];
        
        DocDataEntity *docEntity = [[DocDataEntity alloc] initWithContext:[[CoreDataProxy sharedProxy] workContext]];
		DocErrand *errand = [docEntity createDocErrand];
        errand.id = [NSString stringWithFormat: @"%@_%.0f", @"errand", [NSDate timeIntervalSinceReferenceDate] * 1000.0];
		errand.authorId = user.id;
        errand.authorName = [SupportFunctions createShortFIO:user.fio]; 
        errand.doc = loadedItem.doc;
        errand.status = constErrandStatusInProcess;
        errand.systemActionToSyncId = currentActionToSyncId;
        errand.systemSortIndex = [NSNumber numberWithInt:[errand.doc.errands count]];
		[self showErrand:errand forTaskAction:action orTaskId:nil usingMode:constModeCreate];
        [docEntity release];
	}
	else if ([actionType isEqualToString:constTaskActionTypeAddNotice]) {
    }
}


#pragma mark actions support methods
- (void)showResolution:(ActionToSync *)action withTitle:(NSString *)resolutionTitle {
	NSLog(@"iPadInboxModule showResolution withTitle %@", resolutionTitle);
	container.modalPanelSize = CGSizeMake(600.0f, 600.0f);
	resolutionPanel = [[iPadResolutionViewController alloc] initWithFrame:container.popupPanel.bounds];
    [resolutionPanel setDelegate:self];
	[container.popupPanel putContent:resolutionPanel.view];
	[resolutionPanel setTitleForPopupPanelHeader:resolutionTitle];
	[resolutionPanel showResolutionForTaskServerAction:action];
	
	[container toggleModalPanelOnOFF:YES];
}

- (void)resolutionViewCloseButtonPressed {
	NSLog(@"iPadInboxModule resolutionViewCloseButtonPressed");	
    //rollback changes
    [[[CoreDataProxy sharedProxy] workContext] rollback];
	[container toggleModalPanelOnOFF:NO];
    [resolutionPanel release];
}

- (void)showErrand:(DocErrand *)errand usingMode:(int)mode {
    NSLog(@"iPadInboxModule showErrand usingMode %i", mode);
    [self showErrand:errand forTaskAction:nil orTaskId:loadedItem.id usingMode:mode];
}

- (void)showErrand:(DocErrand *)errand forTaskAction:(ActionToSync *)action orTaskId:(NSString *)taskId usingMode:(int)mode {
	NSLog(@"iPadInboxModule showErrand forTaskAction usingMode %i", mode);
	container.modalPanelSize = CGSizeMake(600.0f, 600.0f);

    errandPanel = [[iPadErrandPanelViewController alloc] initWithFrame:container.popupPanel.bounds];
    [errandPanel setDelegate:self];
	[container.popupPanel putContent:errandPanel.view];
    [errandPanel setPopupAuxPanel:container.popupPanel];
	
	NSString *errandViewTitle = constEmptyStringValue;
	switch (mode) {
		case constModeCreate:
            errandViewTitle = NSLocalizedString(@"CreateErrandFormTitle", nil);
			[errandPanel createErrand:errand forTaskAction:action];
			break;
		case constModeEdit:
            errandViewTitle = NSLocalizedString(@"EditErrandFormTitle", nil);
            [errandPanel showErrand:errand forTaskWithId:taskId usingMode:mode];
			break;
		case constModeView:
            errandViewTitle = NSLocalizedString(@"ViewErrandFormTitle", nil);
            [errandPanel showErrand:errand forTaskWithId:taskId usingMode:mode];
			break;	
		default:
			break;
	}
    [errandPanel setTitleForPopupPanelHeader:errandViewTitle];
	[container toggleModalPanelOnOFF:YES];
}

- (void)errandViewCloseButtonPressed {
	NSLog(@"iPadInboxModule errandViewCloseButtonPressed");
    //rollback changes
    [[[CoreDataProxy sharedProxy] workContext] rollback];
    self.currentActionToSyncId = nil;
	[container toggleModalPanelOnOFF:NO];	
    [errandPanel release];
}

- (void)deleteErrandActionButtonPressed {
	NSLog(@"iPadInboxModule deleteErrandActionButtonPressed");
    //save changes
    [[CoreDataProxy sharedProxy] saveWorkingContext];
	[container toggleModalPanelOnOFF:NO];
    [errandPanel release];
	
    [inboxItemInfoPanel reloadExecutionTab];
}

- (void)showAttachmentWithFileName:(NSString *)attachmentFileName andName:(NSString *)attachmentName {
	NSLog(@"iPadInboxModule showAttachmentWithFileName:%@ andName:%@", attachmentFileName, attachmentName);
	container.modalPanelSize = CGSizeMake(700.0f, 700.0f);
	attachmentPanel = [[iPadAttachmentViewController alloc] initWithPlaceholder:container.popupPanel];
    [attachmentPanel setDelegate:self];	
    [attachmentPanel setCloseButtonHidden:NO];
	[container.popupPanel putContent:attachmentPanel.view];
	[attachmentPanel loadAttachmentFile:attachmentFileName withPopupPanelHeader:attachmentName];
    
	[container toggleModalPanelOnOFF:YES];
}

- (void)attachmentViewCloseButtonPressed {
	NSLog(@"iPadInboxModule attachmentViewCloseButtonPressed");
	[container toggleModalPanelOnOFF:NO];
    [attachmentPanel release];
}

#pragma mark actions submit methods
- (void)submitErrandCreateActionsToServer:(NSArray *)actions {
 	NSLog(@"iPadInboxModule submitErrandCreateActionsToServer"); 
    [inboxItemInfoPanel reloadExecutionTab];
    [self updateCurrentAction:[actions objectAtIndex:0]];
    [[CoreDataProxy sharedProxy] saveWorkingContext];
    
    [container toggleModalPanelOnOFF:NO];
    [errandPanel release];
    
    [self submitActionsToServer];
}

- (void)submitErrandWorkflowActionToServer:(ActionToSync *)action {
 	NSLog(@"iPadInboxModule submitErrandWorkflowActionToServer"); 
    [[CoreDataProxy sharedProxy] saveWorkingContext];
    
    [container toggleModalPanelOnOFF:NO]; 
    [errandPanel release];
    
    [inboxItemInfoPanel reloadExecutionTab];
    [self submitActionsToServer];
}


- (void)submitActionWithResolutionToServer:(ActionToSync *)action {
	NSLog(@"submitActionWithResolutionToServer submitActionToServer");
    [self updateCurrentAction:action];
    [[CoreDataProxy sharedProxy] saveWorkingContext];
    
    [container toggleModalPanelOnOFF:NO];
    [resolutionPanel release];
    
    [self submitActionsToServer];    
}

- (void)submitActionToServer:(ActionToSync *)action {
	NSLog(@"submitActionToServer submitActionToServer");
    [self updateCurrentAction:action];
    [[CoreDataProxy sharedProxy] saveWorkingContext];
    
    [self submitActionsToServer];
}

- (void)updateCurrentAction:(ActionToSync *)action {
    //if action task is final - remove task action buttons and show next task
    if ([action.actionIsFinal boolValue] == YES) {
        TaskDataEntity *taskEntity = [[TaskDataEntity alloc] initWithContext:[[CoreDataProxy sharedProxy] workContext]];
        [taskEntity setActionProcessedWithStatus:action.actionResultText forTaskWithId:self.loadedItem.id];
        [self createWorkflowButtons];
        [taskEntity release];
        
        [inboxListPanel setSelectedItemProcessed];
        [inboxListPanel selectNextItem];  
    } 
    self.currentActionToSyncId = nil;
}

- (void)submitActionsToServer {
    //submit actions to server
    iDocAppDelegate *appDelegate = (iDocAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate submitActionsToServer];    
}


#pragma mark UIViewController methods
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {		
	NSLog(@"iPadInboxModule shouldAutorotateToInterfaceOrientation");
	BOOL isPortraitOrientation = (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
	showInboxListPopoverButton.hidden = (isPortraitOrientation) ? NO : YES;
    [taskActionsPopover dismissPopoverAnimated:NO];
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {	
	[self.inboxListPopover dismissPopoverAnimated:NO];
    if (fromInterfaceOrientation == UIDeviceOrientationPortrait ||
        fromInterfaceOrientation == UIDeviceOrientationPortraitUpsideDown) {
        inboxListPanel.inboxListTableViewController.view.frame = container.leftSliderBody.bounds;
        [container.leftSliderBody addSubview:inboxListPanel.inboxListTableViewController.view]; 
    }
}

#pragma mark other methods
- (void)didReceiveMemoryWarning {
	NSLog(@"iPadInboxModule didReceiveMemoryWarning");
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc. that aren't in use.
}

- (void)dealloc {
    self.loadedItem = nil;
    self.currentActionToSyncId = nil;
    self.inboxModuleTitle = nil;
    self.user = nil;
    
    if (currentDashboardItem != nil)
        [currentDashboardItem release];
    
    [listSortViewController release];
    [listSortViewControllerPopover release];
    [itemsListSortOptions release];
	[inboxListPanel release];
	[inboxListPopover release];	
	[inboxItemInfoPanel release];
	[container release];
            
    [super dealloc];
}

@end
