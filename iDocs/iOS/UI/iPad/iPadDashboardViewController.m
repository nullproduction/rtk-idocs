//
//  iPadDashboardViewController.m
//  iDoc
//
//  Created by mark2 on 12/17/10.
//  Copyright 2010 KORUS Consulting. All rights reserved.
//

#import "iPadDashboardViewController.h"
#import "iPadInboxModuleViewController.h"
#import "iPadDocModuleViewController.h"
#import "ClientSettingsDataEntity.h"
#import "iPadThemeBuildHelper.h"
#import "TaskDataEntity.h"
#import "SystemDataEntity.h"
#import "iPadInboxModuleViewController.h"
#import "iPadDocModuleViewController.h"
#import "UserDefaults.h"
#import "IASKSpecifier.h"
#import "IASKSettingsReader.h"
#import "IASKPSTitleValueSpecifierViewCell.h"
#import <QuartzCore/QuartzCore.h>

@interface iPadDashboardViewController(PrivateMethods)
- (void)initLayout;
- (void)folderNavigationLoad:(DashboardItem *)currentItem;
@end

@implementation iPadDashboardViewController

@synthesize appSettingsPanel;

- (UIColor *)backgroundColor {
    return [UIColor colorWithPatternImage:[UIImage imageNamed:[iPadThemeBuildHelper nameForImage:@"background_tile.png"]]];
}

#pragma mark custom methods - visual module init
- (id)init {
	NSLog(@"iPadDashboard init");	
	if ((self = [super initWithNibName:nil bundle:nil])) {
        [self initLayout];
        currentPath = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)initLayout {
    iPadDashboardLayoutView *layoutView = [[iPadDashboardLayoutView alloc] init];
    [layoutView.backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [layoutView.syncButton addTarget:self action:@selector(syncButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [layoutView.settingsButton addTarget:self action:@selector(settingsButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    self.view = layoutView;
    [layoutView release];
    		
    self.view.backgroundColor = [self backgroundColor];
}

#pragma mark UIViewController methods
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    NSLog(@"iPadDashboardViewController shouldAutorotateToInterfaceOrientation");
	return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {	
}

#pragma mark settings methods
- (void)settingsButtonPressed {
    NSLog(@"iPadDashboard settingsButtonPressed");
    iPadDashboardLayoutView *container = (iPadDashboardLayoutView *)self.view;
    container.modalPanelSize = CGSizeMake(700.0f, 600.0f);
    if (self.appSettingsPanel == nil) {
        iPadAppSettingsPanelViewController *panel = [[iPadAppSettingsPanelViewController alloc] initWithFrame:container.popupPanel.bounds];
        self.appSettingsPanel = panel;
        [panel release];
        [appSettingsPanel setDelegate:self];
    }
    [container.popupPanel putContent:appSettingsPanel.view];
    [container toggleModalPanelOnOFF:YES];
}

#pragma mark IASKAppSettingsViewControllerDelegate protocol
- (void)appSettingsPanelCloseButtonPressed {
    iPadDashboardLayoutView *container = (iPadDashboardLayoutView *)self.view;
    [container toggleModalPanelOnOFF:NO];
    [container.popupPanel cleanup];
    self.appSettingsPanel = nil;
    
	iDocAppDelegate *appDelegate = (iDocAppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([appDelegate isAppThemeChanged] == YES) {
        [self initLayout];
        [self loadData];
    }
    
    // update network status based on Use3GNetwork param
    [appDelegate checkNetworkStatus];    
    [appDelegate checkSyncRequired];
}

#pragma mark sync methods
- (void)syncButtonPressed {
    NSLog(@"iPadDashboard syncButtonPressed");
    //remove current user info
	iPadDashboardLayoutView *container = ((iPadDashboardLayoutView *)self.view);
    container.userNameLabel.text = constEmptyStringValue;
    //start sync
	iDocAppDelegate *appDelegate = (iDocAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate startFullSync];
}

- (void)syncFinished {
	NSLog(@"iPadDashboard syncFinished");
    [self initLayout];
    [self loadData];
}

- (void)loadData {
	NSLog(@"iPadDashboard reloadDataAfterSync");
	iPadDashboardLayoutView *container = ((iPadDashboardLayoutView *)self.view);
	
	iDocAppDelegate *appDelegate = (iDocAppDelegate *)[[UIApplication sharedApplication] delegate];	
    SystemDataEntity *systemEntity = [[SystemDataEntity alloc] initWithContext:[[CoreDataProxy sharedProxy] workContext]];
    UserInfo *user = [systemEntity userInfo];
    [systemEntity release];
    
    if (appDelegate.serverActive == YES && (user.ORDToken != nil || user.webDavToken != nil))
        container.userIcon.image = [UIImage imageNamed:[iPadThemeBuildHelper nameForImage:@"icon_user_online.png"]];	
    
    container.syncButton.hidden = NO;
    container.syncButton.enabled = 
        (([UserDefaults useORDServer] == YES || [UserDefaults useWebDavServer] == YES) && appDelegate.serverActive == YES);
    container.syncButtonHint.hidden = NO;
    container.syncButtonValue.hidden = NO;
    NSString *lastSyncDateString = [UserDefaults stringSettingByKey:constLastSuccessfullSyncDate];    
    container.syncButtonValue.text = 
        ([lastSyncDateString length] ? lastSyncDateString : NSLocalizedString(@"UnknownLastSyncDateText", nil));        
    
    container.settingsButton.hidden = NO;
    container.settingsButton.enabled = YES;
    
    [self folderNavigationLoad:nil];
}


#pragma mark
- (void)folderNavigationLoad:(DashboardItem *)currentItem {
    NSLog(@"iPadDashboard folderNavigationLoad: %@", currentItem.id);
    
    NSString *folderId = nil;
    DashboardItem *dashboardItem = nil;
    Dashboard *dashboard = nil;
    
    iPadDashboardLayoutView *container = ((iPadDashboardLayoutView *)self.view);
    
    if(widgetsPanelArray != nil) {
        [widgetsPanelArray release];
    }
    widgetsPanelArray = [[NSMutableArray alloc] init];
    [container clearContentPanel];
       
    if(currentItem != nil) {//Спуск вниз
        if(![currentPath count]) 
            currentPage = container.dashboardPager.currentPage;
        
        folderId = currentItem.id;
        dashboardItem = currentItem;
        dashboard = currentItem.dashboard;
        [currentPath addObject:dashboardItem];
    }
    else { // Подъем наверх
        if ([currentPath count]) {
            [currentPath removeLastObject];
        }
        dashboardItem = ((DashboardItem *)[currentPath lastObject]);        
        folderId = dashboardItem.id;
        dashboard = dashboardItem.dashboard;        
    }        
    
    if (folderId) { // Ненулевой уровень
        iPadDashboardWidgetsPanelViewController *widgetsPanelN = [[iPadDashboardWidgetsPanelViewController alloc] initWithPlaceholder:container dashboard:dashboard andCurrentPath:currentPath andDelegate:self];	
        [widgetsPanelArray addObject:widgetsPanelN];
        [widgetsPanelN release];
        container.backButton.hidden = NO;
    }
    else { // Первичная загрузка или нулевой уровень /*        
        ClientSettingsDataEntity *clientSettings = 
            [[ClientSettingsDataEntity alloc] initWithContext:[[CoreDataProxy sharedProxy] workContext]];
        NSArray *dashboards = [clientSettings selectAllDashboards];
        for (Dashboard *newDashboard in dashboards) {
            iPadDashboardWidgetsPanelViewController *widgetsPanelN = [[iPadDashboardWidgetsPanelViewController alloc] initWithPlaceholder:container dashboard:newDashboard andCurrentPath:nil andDelegate:self];	
            [widgetsPanelArray addObject:widgetsPanelN];
            [widgetsPanelN release];
        }
        [clientSettings release];
        container.backButton.hidden = YES;
    }
    
    [container setCurrentPage:(([currentPath count])? 0 : currentPage)];
    
    [self reloadWidgetData];
    [container layoutSubviews];
}

- (void)reloadWidgetData {
	NSLog(@"iPadDashboard reloadWidgetData");	
    //recalculate items count
    SystemDataEntity *systemEntity = [[SystemDataEntity alloc] initWithContext:[[CoreDataProxy sharedProxy] workContext]];
    UserInfo *user = [systemEntity userInfo];
    NSString *userName = (user.fio == nil) ? user.ORDLogin : [SupportFunctions createShortFIO:user.fio];

    iPadDashboardLayoutView *container = ((iPadDashboardLayoutView *)self.view);
    container.userNameLabel.text = userName;
    
    [systemEntity release];

    ClientSettingsDataEntity *clientSettings = [[ClientSettingsDataEntity alloc] initWithContext:[[CoreDataProxy sharedProxy] workContext]];
    [clientSettings updateItemsCountInAllTaskDashboardItems];
    [clientSettings release];
    for (iPadDashboardWidgetsPanelViewController *dashboardPanel in widgetsPanelArray) {
        [dashboardPanel loadValues];
    }
}


#pragma mark UI action methods
- (void)dashboardWidgetPressedForInboxModule:(DashboardItem *)group {
	NSLog(@"iPadDashboard dashboardWidgetPressedForInboxModule: %@", group.id);
	iDocAppDelegate *appDelegate = (iDocAppDelegate *)[[UIApplication sharedApplication] delegate];
    iPadDashboardLayoutView *container = ((iPadDashboardLayoutView *)self.view);
    
    if (![currentPath count]) {
        [container setCurrentPage:container.dashboardPager.currentPage];
    }
    
    iPadInboxModuleViewController *taskModule = [[iPadInboxModuleViewController alloc] init];	
    [taskModule loadItemsInDashboardItem:group]; 
    [appDelegate.navigationController pushViewController:taskModule animated:NO];
    [taskModule release];
}

- (void)dashboardWidgetPressedForFolder:(DashboardItem *)metaData {
    NSLog(@"iPadDashboard dashboardWidgetPressedForFolder: %@", metaData.id);
    [self folderNavigationLoad:metaData];
}

- (void)dashboardWidgetPressedForDocModule:(DashboardItem *)group {
    NSLog(@"iPadDashboard dashboardWidgetPressedForDocModule: %@", group.id);
    iDocAppDelegate *appDelegate = (iDocAppDelegate *)[[UIApplication sharedApplication] delegate];
    iPadDashboardLayoutView *container = ((iPadDashboardLayoutView *)self.view);
    
    if (![currentPath count]) {
        [container setCurrentPage:container.dashboardPager.currentPage];
    }
    
    iPadDocModuleViewController *docModule = [[iPadDocModuleViewController alloc] init];
    [docModule loadItemsInDashboardItem:group]; 
    [appDelegate.navigationController pushViewController:docModule animated:NO];
    [docModule release];
}

- (void)backButtonPressed {
    NSLog(@"iPadDashboard backButtonPressed");
    [self folderNavigationLoad:nil];
}

- (void)enableSyncOption {
    NSLog(@"iPadDashboard enableSyncOption");
    iPadDashboardLayoutView *container = (iPadDashboardLayoutView *)self.view;
    container.syncButton.enabled = YES;    
}

- (void)disableSyncOption {
    NSLog(@"iPadDashboard disableSyncOption");
    iPadDashboardLayoutView *container = (iPadDashboardLayoutView *)self.view;
    container.syncButton.enabled = NO;    
}


#pragma mark other methods
- (void)didReceiveMemoryWarning {
	NSLog(@"iPadDashboard didReceiveMemoryWarning");
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc. that aren't in use.
}

- (void)dealloc {
    [currentPath release];
    [widgetsPanelArray release];
    self.appSettingsPanel = nil;
    [super dealloc];
}


@end
