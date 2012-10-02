//
//  iPadDocModuleViewController.m
//  iDoc
//
//  Created by rednekis on 10-12-15.
//  Copyright 2010 KORUS Consulting. All rights reserved.
//

#import "iPadDocModuleViewController.h"
#import "iPadDashboardViewController.h"
#import "iPadDashboardLayoutView.h"
#import "iPadDocListTableViewController.h"
#import "HFSUIActionSheet.h"
#import "SystemDataEntity.h"
#import <QuartzCore/QuartzCore.h>
#import "SupportFunctions.h"
#import "iPadDocActionListViewController.h"
#import "UserDefaults.h"

@interface iPadDocModuleViewController(PrivateMethods)
//init
- (void)formatItemHeader:(int)numberOfRecords;
//behavior
- (void)reloadDataAfterSync;
- (void)navigateHome;
//action methods
- (void)displayMailComposer;
- (void)showEventEditViewController;
@end

@implementation iPadDocModuleViewController

@synthesize docListPopover, loadedItem, user;

- (UIColor *)backgroundColor {
    return [UIColor colorWithPatternImage:[UIImage imageNamed:[iPadThemeBuildHelper nameForImage:@"background_tile.png"]]];
}

#pragma mark cvisual module init
- (id)init {
	NSLog(@"iPadDocModule init");
    if ((self = [super init])) {
		container = [[iPadDocModuleLayoutView alloc] init];
		self.view = container;		        
		
		//items list popover button
		showDocListPopoverButton = container.showDocListPopoverButton;
		[showDocListPopoverButton addTarget:self action:@selector(showItemsListPopoverButtonPressed) forControlEvents:UIControlEventTouchUpInside];
		
		//inbox module header title
		docModuleHeaderTitle = container.docModuleHeaderTitle;
		
		//navigation home button
		[container.navigateHomeButton addTarget:self action:@selector(navigateHome) forControlEvents:UIControlEventTouchUpInside];
		
		//items list
		leftSlidingBodyPanel = container.leftSliderBody;
		docListPanel = [[iPadDocListPanelViewController alloc] initWithBodyView:container.leftSliderBody filterView:container.leftSliderFilter buttonView:container.leftSliderButton andDelegate:self];
        
        [container.upButton addTarget:docListPanel action:@selector(selectPreviousItem) forControlEvents:UIControlEventTouchUpInside];
        [container.downButton addTarget:docListPanel action:@selector(selectNextItem) forControlEvents:UIControlEventTouchUpInside];
		
		//кнопка вызова действий по документу
        actionsPopoverButton = container.actionsPopoverButton;
		[actionsPopoverButton addTarget:self action:@selector(presentActionsList:) forControlEvents:UIControlEventTouchUpInside];
		
		//панель кнопок под списком документов
        [container.toolsButton addTarget:self action:@selector(showListSortOptions:) forControlEvents:UIControlEventTouchUpInside];
        [container.syncButton addTarget:self action:@selector(syncData:) forControlEvents:UIControlEventTouchUpInside];
        
		//item panel
		contentPanel = container.contentPanel;
		contentBodyPanel = container.contentBodyPanel;
		
		docItemInfoPanel = [[iPadDocItemPanelViewController alloc] initWithContentPlaceholderView:contentBodyPanel andDelegate:self];		                        
        
        SystemDataEntity *systemEntity = [[SystemDataEntity alloc] initWithContext:[[CoreDataProxy sharedProxy] workContext]];
        self.user = [systemEntity userInfo];
        [systemEntity release];

        user.webDavListSortType = (user.webDavListSortType == nil) ? [NSNumber numberWithInt:0] : user.webDavListSortType;
        itemsListSortOptions = [[NSArray alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"DocModuleItemsListSortOptions" withExtension:@"plist"]];
        docListPanel.sortField = [[itemsListSortOptions objectAtIndex:[user.webDavListSortType intValue]] valueForKey:@"sortField"];
        docListPanel.ascending = [[[itemsListSortOptions objectAtIndex:[user.webDavListSortType intValue]] valueForKey:@"ascending"] isEqualToString:@"yes"];
        
        listSortViewController = [[iPadListSortViewController alloc] initWithSortOptionsDelegate:self];
        listSortViewControllerPopover = [[UIPopoverController alloc] initWithContentViewController:listSortViewController];
    }
    return self;	
}


#pragma mark - sort options:
- (void)showListSortOptions:(HFSUIButton *)sender {
	NSLog(@"iPadDocModule showListSortOptions");
    [listSortViewControllerPopover presentPopoverFromRect:sender.bounds inView:sender permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    [listSortViewController setSelectedItem:[user.webDavListSortType intValue]];
}

- (void)didSelectSortOptionWithIndex:(int)index {
	NSLog(@"iPadDocModule didSelectSortOptionWithIndex");
    user.webDavListSortType = [NSNumber numberWithInt:index];
    docListPanel.sortField = [[itemsListSortOptions objectAtIndex:index] valueForKey:@"sortField"];
    docListPanel.ascending = [[[itemsListSortOptions objectAtIndex:index] valueForKey:@"ascending"] isEqualToString:@"yes"];
    container.toolsButtonValue.text = [[itemsListSortOptions objectAtIndex:index] valueForKey:@"name"];
    [listSortViewControllerPopover dismissPopoverAnimated:YES];

    [docListPanel filterAndSortData];
}

- (NSArray *)getSortOptions {
    return itemsListSortOptions;
}

#pragma mark - local sync:
- (void)syncData:(HFSUIButton *)sender {
    NSLog(@"iPadDocModule syncData pressed");
	iDocAppDelegate *appDelegate = (iDocAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate startFullSync];
}

- (void)syncFinished {
    NSLog(@"iPadDocModule syncFinished");
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

#pragma mark module data
- (void)loadItemsInDashboardItem:(DashboardItem *)item {
	NSLog(@"iPadDocModule loadItemsInDashboardItem: %@", item.id);
		
    //save id to keep it between background period
    [UserDefaults saveValue:item.id forSetting:constSyncDashboardItemId];
    SystemDataEntity *systemEntity = [[SystemDataEntity alloc] initWithContext:[[CoreDataProxy sharedProxy] workContext]];
    self.user = [systemEntity userInfo];
    [systemEntity release];
    
    container.toolsButtonValue.text = [[itemsListSortOptions objectAtIndex:[user.webDavListSortType intValue]] valueForKey:@"name"];
    NSString *lastSyncDateString = [UserDefaults stringSettingByKey:constLastSuccessfullSyncDate];
    container.syncButtonValue.text = ([lastSyncDateString length] ? lastSyncDateString : NSLocalizedString(@"UnknownLastSyncDateText", nil));        
    container.syncButton.hidden = NO;
	iDocAppDelegate *appDelegate = (iDocAppDelegate *)[[UIApplication sharedApplication] delegate];
    container.syncButton.enabled = 
        (([UserDefaults useORDServer] == YES || [UserDefaults useWebDavServer] == YES)  && appDelegate.serverActive == YES);

	docModuleTitle = item.name;
	docModuleHeaderTitle.text = docModuleTitle;
	container.showDocListPopoverButtonTitle.text = docModuleTitle;    
	
	[docListPanel loadDataForDashboardItemId:item.id];
}

- (void)enableSyncOption {
    NSLog(@"iPadDocModule enableSyncOption");
    container.syncButton.enabled = YES;    
}

- (void)disableSyncOption {
    NSLog(@"iPadDocModule disableSyncOption");
    container.syncButton.enabled = NO;    
}

#pragma mark module behavior
- (void)slideDocListPanelButtonPressed {
	NSLog(@"iPadDocModule slideDocListPanelButtonPressed");	
	[container slideLeftPanel];
}

- (void)showItemsListPopoverButtonPressed {
	NSLog(@"iPadDocModule showItemsListPopoverButtonPressed");	
	UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:docListPanel.containerController];
	popover.popoverContentSize = CGSizeMake(320.0f, 700.0f);
	self.docListPopover = popover;
	[popover release];
	
	UIView *anchorView = showDocListPopoverButton;
	CGRect anchorRect = CGRectMake(0.0f, 0.0f, anchorView.frame.size.width, anchorView.frame.size.height);
	[self.docListPopover presentPopoverFromRect:anchorRect inView:anchorView permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];	
}

- (void)navigateHome {
	NSLog(@"iPadDocModule navigateHome");	
	iDocAppDelegate *appDelegate = (iDocAppDelegate *)[[UIApplication sharedApplication] delegate];	
	NSArray *controllers = [appDelegate.navigationController viewControllers];
	UIViewController *rootController = [controllers objectAtIndex:0];
	if ([rootController isMemberOfClass:iPadDashboardViewController.class]) {
		[(iPadDashboardViewController *)rootController reloadWidgetData];
	}
	[appDelegate.navigationController popToRootViewControllerAnimated:YES];	
}

- (void)presentActionsList:(UIButton *)sender {
	NSLog(@"iPadDocModule presentActionsList");
    iPadDocActionListViewController *actionSheet = [[iPadDocActionListViewController alloc] init];
    [actionSheet setActionsDelegate:self];
    docActionsPopover = [[UIPopoverController alloc] initWithContentViewController:actionSheet];    
    [actionSheet release];
    docActionsPopover.popoverContentSize = CGSizeMake(250.0f, constListItemCellHeight*[[self getActionsList] count] + 40);
    [docActionsPopover presentPopoverFromRect:sender.bounds  
                                        inView:sender
                      permittedArrowDirections:UIPopoverArrowDirectionUp
                                      animated:YES];	
}

- (NSArray *)getActionsList {
	NSLog(@"iPadDocModule getActionsList");
    if (actions == nil) {
        actions = [[NSMutableArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CommonActionsList" ofType:@"plist"]];
        //remove send mail action if mail is not set up
        if ([MFMailComposeViewController canSendMail] == NO) {
            for (NSDictionary *action in actions) {
                int actionId = [[action valueForKey:@"id"] intValue];
                if (actionId == constActionIdSendMail) {
                    [actions removeObject:action];
                    break;
                }
            }
        }
    }
    return actions;
}

- (void)formatItemHeader:(int)numberOfRecords {
	NSLog(@"iPadDocModule formatItemHeader");
	NSString *popoverTitle = [NSString stringWithFormat:@"%@ (%i)", docModuleTitle, numberOfRecords];
	container.showDocListPopoverButtonTitle.text = popoverTitle;
    
    NSString *moduleTitle = [NSString stringWithFormat:@"%@ (%i)", docModuleTitle, numberOfRecords];
    if (self.loadedItem != nil) {
        NSString *itemTitle = [self.loadedItem valueForKey:HFS_FileName];
        moduleTitle = [moduleTitle stringByAppendingFormat:@": %@", itemTitle];   
    }
	docModuleHeaderTitle.text = moduleTitle;
}


#pragma mark custom methods - delegate implementation methods
- (void)didSelectItem:(NSDictionary *)item {
	NSLog(@"iPadDocModule didSelectItem:%@", item);		
	if (docListPopover.popoverVisible == YES && [docListPanel isSelectedItemViewable] == YES) {
		[self.docListPopover dismissPopoverAnimated:YES];
	}
    self.loadedItem = item;
    [self formatItemHeader:[docListPanel numberOfLoadedItems]];
	[docItemInfoPanel loadItem:item];
	container.actionsPopoverButton.enabled = (self.loadedItem != nil) ? YES : NO;
    container.upButton.enabled = [docListPanel prevItemAvailable];
    container.downButton.enabled = [docListPanel nextItemAvailable];
}

- (void)itemsListFilterIsUsed {
	NSLog(@"iPadDocModule itemsListFilterIsUsed");	
    [docListPanel selectItemInRow:0];
}

- (void)didSelectActionWithId:(int)actionId {
    NSLog(@"iPadDocActionListViewController didSelectActionWithId:%i", actionId); 
    [docActionsPopover dismissPopoverAnimated:NO];
    switch (actionId) {
        case constActionIdSendMail:
            [self displayMailComposer];
            break;
        case constActionIdCalendarEntry:
            [self showEventEditViewController];
            break;
        default:
            break;
    }
}

- (void)displayMailComposer {
    NSLog(@"iPadDocActionListViewController displayMailComposer");
	MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
    mailComposer.mailComposeDelegate = self;
    mailComposer.navigationBar.tintColor = [iPadThemeBuildHelper tabBarBackColor];
    
    if (loadedItem != nil) {
        NSString *fileName = [loadedItem valueForKey:HFS_FileAttributesDictionaryFileName];
        NSString *filePath = [loadedItem valueForKey:HFS_FileAttributesDictionaryFilePath];
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            NSData *fileData = [NSData dataWithContentsOfFile:filePath];
            [mailComposer addAttachmentData:fileData mimeType:@"application/octet-stream" fileName:fileName];
        }
        [mailComposer setSubject:fileName];
    }
    else {
        [mailComposer setSubject:NSLocalizedString(@"NewMessage", nil)];
    }
    
    mailComposer.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentModalViewController:mailComposer animated:YES];
    [mailComposer release];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {	
    NSLog(@"iPadDocActionListViewController mailComposeController didFinishWithResult");
	[self dismissModalViewControllerAnimated:YES];
}

- (void)showEventEditViewController {
    NSLog(@"iPadDocModule showEventEditViewController");
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    
    EKEventEditViewController *eventEditViewController = [[EKEventEditViewController alloc] init];
    eventEditViewController.eventStore = eventStore;
    eventEditViewController.editViewDelegate = self;
    eventEditViewController.navigationBar.tintColor = [iPadThemeBuildHelper tabBarBackColor];
    
    if (loadedItem != nil) {
        EKEvent *newEvent = [EKEvent eventWithEventStore:eventStore];
        NSString *fileName = [loadedItem valueForKey:HFS_FileAttributesDictionaryFileName];
        newEvent.title = fileName;
        eventEditViewController.event = newEvent;
    }
    
    eventEditViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentModalViewController:eventEditViewController animated:YES];
    [eventEditViewController release];
    
    [eventStore release];
}

- (void)eventEditViewController:(EKEventEditViewController *)controller didCompleteWithAction:(EKEventEditViewAction)action {
	NSLog(@"iPadDocModule eventEditViewController didCompleteWithAction"); 
    NSError *error = nil;
    EKEvent *thisEvent = controller.event;
    
    switch (action) {
        case EKEventEditViewActionCanceled:
            break;            
        case EKEventEditViewActionSaved:
            [controller.eventStore saveEvent:thisEvent span:EKSpanThisEvent error:&error];
            break;
        case EKEventEditViewActionDeleted:
            [controller.eventStore removeEvent:thisEvent span:EKSpanThisEvent error:&error];
            break;            
        default:
            break;
    }
    [self dismissModalViewControllerAnimated:YES];
}


#pragma mark UIViewController methods
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {		
	NSLog(@"iPadDocModule shouldAutorotateToInterfaceOrientation");
	BOOL isPortraitOrientation = (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
	showDocListPopoverButton.hidden = (isPortraitOrientation) ? NO : YES;
    [docActionsPopover dismissPopoverAnimated:NO];
	return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {	
	[self.docListPopover dismissPopoverAnimated:NO];
    if (fromInterfaceOrientation == UIDeviceOrientationPortrait ||
        fromInterfaceOrientation == UIDeviceOrientationPortraitUpsideDown) {
        docListPanel.containerController.view.frame = CGRectOffset( container.leftSliderBody.bounds, -2, -2);
        [container.leftSliderBody addSubview:docListPanel.containerController.view]; 
    }
}

#pragma mark other methods
- (void)didReceiveMemoryWarning {
	NSLog(@"iPadDocModule didReceiveMemoryWarning");
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc. that aren't in use.
}

- (void)dealloc {    
    self.user = nil;
    self.loadedItem = nil;
    
    [actions release];
    
    if (docActionsPopover != nil) {
        [docActionsPopover release];
    }
    [listSortViewController release];
    [listSortViewControllerPopover release];
    [itemsListSortOptions release];
	[docListPanel release];
	self.docListPopover = nil;	
	[docItemInfoPanel release];
	[container release];
    
    [super dealloc];
}

@end
