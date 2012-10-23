//
//  iPadInboxItemPanelViewController.m
//  iDoc
//
//  Created by rednekis on 10-12-15.
//  Copyright 2010 KORUS Consulting. All rights reserved.
//

#import "iPadInboxItemPanelViewController.h"
#import "CoreDataProxy.h"
#import "iPadInboxItemPanelPageLayoutView.h"
#import "iPadInboxItemPanelButtonsLayoutView.h"
#import "iPadInboxModuleLayoutView.h"
#import "EmployeeListDataEntity.h"
#import "Employee.h"
#import "iPadThemeBuildHelper.h"
#import "ActionToSync.h"
#import "TaskAction.h"
#import "DocDataEntity.h"
#import "DocErrand.h"
#import "Task.h"
#import "SystemDataEntity.h"

#import <QuartzCore/QuartzCore.h>

@interface iPadInboxItemPanelViewController(PrivateMethods)
//tabs:
- (void)setAccessForButtons;
- (void)attachmentsButtonPressed;
- (void)endorsementButtonPressed;
- (void)executionButtonPressed;
- (void)requisitesButtonPressed;
- (void)enableButtons;
- (void)disableButtons;
- (void)deselectButtons;
- (void)hideTabs;
@end

@implementation iPadInboxItemPanelViewController

@synthesize loadedItem;

#pragma mark custom methods - visual init
- (id)initWithContentPlaceholderView:(UIView *)contentPanel 
					buttonsPanelView:(UIView *)buttonsPanel 
                         andDelegate:(id<iPadInboxRequisitesTabViewControllerDelegate,
                                      iPadInboxExecutionTabViewControllerDelegate>)newDelegate {
	NSLog(@"iPadInboxItemPanel initWithContentPlaceholderView");	
	if ((self = [super initWithNibName:nil bundle:nil])) {
		//body
		iPadInboxItemPanelPageLayoutView *container = [[iPadInboxItemPanelPageLayoutView alloc] init];
		container.frame = contentPanel.bounds;
		body = container.bodyPanel;
		//footer				
		iPadInboxItemPanelButtonsLayoutView *buttons = [[iPadInboxItemPanelButtonsLayoutView alloc] init];
		buttons.frame = buttonsPanel.bounds;
        
		attachmentsTab = [[iPadInboxAttachmentsTabViewController alloc] initWithPlaceholderPanel:body];
		attachmentsButton = buttons.attachmentsButton;
		attachmentsButton.enabled = NO;
		[attachmentsButton addTarget:self action:@selector(attachmentsButtonPressed) forControlEvents:UIControlEventTouchUpInside];

		endorsementTab = [[iPadInboxEndorsementTabViewController alloc] initWithPlaceholderPanel:body];	
		endorsementButton = buttons.endorsementButton;
		endorsementButton.enabled = NO;
		[endorsementButton addTarget:self action:@selector(endorsementButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        
		executionTab = [[iPadInboxExecutionTabViewController alloc] initWithPlaceholderPanel:body];
		[executionTab setDelegate:newDelegate];
		executionButton = buttons.executionButton;
		executionButton.enabled = NO;
		[executionButton addTarget:self action:@selector(executionButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        
		requisitesTab = [[iPadInboxRequisitesTabViewController alloc] initWithPlaceholderPanel:body];
		[requisitesTab setDelegate:newDelegate];
		requisitesButton = buttons.requisitesButton;
		requisitesButton.enabled = NO;		
		[requisitesButton addTarget:self action:@selector(requisitesButtonPressed) forControlEvents:UIControlEventTouchUpInside];
		
		[self hideTabs];
				
		[contentPanel addSubview:container];				
		[container release];
		[buttonsPanel addSubview:buttons];
		[buttons release];
	}
	return self;
}


#pragma mark custom methods - tabs methods
- (void)loadItem:(Task *)item {
	NSLog(@"iPadInboxItemPanel loadItem");
    [self removeCurrentItem];
    self.loadedItem = item;
    
    NSLog(@" ------- loadItem ------ start");
        
    NSLog(@"item.name [%@] item.dueDate [%@] item.id [%@] item.type [%@] isViewed [%@]", item.name, [item.dueDate description], [item.id description], item.type, [item.isViewed description]);
    NSLog(@"item.systemCurrentErrandId [%@] item.systemActionResultText [%@] item.systemActionIsProcessed [%@] ", [item.systemCurrentErrandId description], [item.systemActionResultText description], [item.systemActionIsProcessed description]);
    NSLog(@"item.systemSyncStatus [%@] systemUpdateDate [%@] systemHasDueDate [%@]", [item.systemSyncStatus description], [item.systemUpdateDate description], [item.systemHasDueDate description]);
    
    for( DashboardItem* item_ in item.dashboardItems ) {
        NSLog(@"DashboardItem [%@]", [item_ description]);
    }
    
    for( TaskAction* item_ in item.actions ) {
        NSLog(@"TaskAction [%@]", [item_ description]);
        NSLog(@"TaskAction.name [%@]", item_.name);
        NSLog(@"TaskAction.resultText [%@]", item_.resultText);
    }
    
    NSLog(@"item.doc [%@]", [item.doc description]);
    NSLog(@"item.doc.desc [%@]", [item.doc.desc description]);
    NSLog(@"item.doc.typeName [%@]", [item.doc.typeName description]);
    NSLog(@"item.doc.ownerName [%@]", [item.doc.ownerName description]);
    
    for( DocErrand* item_ in item.doc.errands ) {
        NSLog(@"DocErrand [%@]", [item_ description]);
        NSLog(@"DocErrand report [%@]", [item_.report description]);
        NSLog(@"DocErrand authorName [%@]", [item_.authorName description]);
        NSLog(@"DocErrand text [%@]", [item_.text description]);
        NSLog(@"DocErrand executors [%@]", [item_.executors description]);
    }
    NSLog(@" ------- loadItem ------ finish");

    [self enableButtons];
    [self attachmentsButtonPressed];
}

- (void)removeCurrentItem {
	NSLog(@"iPadInboxItemPanel removeCurrentItem");
	headerTitle.text = constEmptyStringValue;
	[self hideTabs];
	[self disableButtons];
}

- (void)enableButtons {
	attachmentsButton.enabled = YES;
    endorsementButton.enabled = YES;
    executionButton.enabled = YES;
    requisitesButton.enabled = YES;
}

- (void)disableButtons {
	attachmentsButton.enabled = NO;
    endorsementButton.enabled = NO;
    executionButton.enabled = NO;
    requisitesButton.enabled = NO;
}

- (void)deselectButtons {
	attachmentsButton.selected = NO;
    endorsementButton.selected = NO;
    executionButton.selected = NO;
    requisitesButton.selected = NO;
}

- (void)hideTabs {
	attachmentsTab.view.hidden = YES;
    endorsementTab.view.hidden = YES;
    executionTab.view.hidden = YES;
    requisitesTab.view.hidden = YES;
}

- (void)attachmentsButtonPressed {
	NSLog(@"iPadInboxItemPanel attachmentsButtonPressed");
    DocDataEntity *docEntity = [[DocDataEntity alloc] initWithContext:[[CoreDataProxy sharedProxy] workContext]];
	[attachmentsTab loadTabData:[docEntity selectAttachmentsForDocWithId:self.loadedItem.doc.id]];
	[self hideTabs];
	[self deselectButtons];
	attachmentsTab.view.hidden = NO;
	attachmentsButton.selected = YES;
    [docEntity release];
}

- (void)endorsementButtonPressed {
	NSLog(@"iPadInboxItemPanel endorsementButtonPressed");
    DocDataEntity *docEntity = [[DocDataEntity alloc] initWithContext:[[CoreDataProxy sharedProxy] workContext]];
	[endorsementTab loadTabData:[docEntity selectEndorsementGroupsForDocWithId:self.loadedItem.doc.id]];
	[self hideTabs];
	[self deselectButtons];	
	endorsementTab.view.hidden = NO;
	endorsementButton.selected = YES;
    [docEntity release];
}

- (void)executionButtonPressed {
	NSLog(@"iPadInboxItemPanel executionButtonPressed");
    DocDataEntity *docEntity = [[DocDataEntity alloc] initWithContext:[[CoreDataProxy sharedProxy] workContext]];
    NSString *currentErrandId = self.loadedItem.systemCurrentErrandId;
	[executionTab loadTabDataWithErrands:[docEntity selectErrandsForDocWithId:self.loadedItem.doc.id] andCurrentErrandId:currentErrandId];
    [executionTab loadChildErrands:[docEntity selectChildErrandsForDocWithId:self.loadedItem.doc.id]];

    [executionTab loadErrandAttachmentsWithDocId:self.loadedItem.doc.id];
    
    [executionTab setErrandTableView:body];
    
	[self hideTabs];
	[self deselectButtons];	
	executionTab.view.hidden = NO;
	executionButton.selected = YES;
    [docEntity release];
}

- (void)reloadExecutionTab { 
    if (executionTab.view.hidden == NO){
        [self executionButtonPressed];
    }
}

- (void)requisitesButtonPressed {
	NSLog(@"iPadInboxItemPanel requisitesButtonPressed");
    DocDataEntity *docEntity = [[DocDataEntity alloc] initWithContext:[[CoreDataProxy sharedProxy] workContext]];
    [requisitesTab loadTabDataWithExecutorName:self.loadedItem.doc.ownerName 
                                docDescription:self.loadedItem.doc.desc 
                                    requisites:[docEntity selectRequisitesForDocWithId:self.loadedItem.doc.id]
                                andAttachments:[docEntity selectAttachmentsForDocWithId:self.loadedItem.doc.id]];
	[self hideTabs];
	[self deselectButtons];	
	requisitesTab.view.hidden = NO;
	requisitesButton.selected = YES;
    [docEntity release];
}

#pragma mark other methods
- (void)didReceiveMemoryWarning {
	NSLog(@"iPadInboxItemPanel didReceiveMemoryWarning");		
    // Releases the iPadSearchFilter if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc. that aren't in use.
}

- (void)dealloc {
	[attachmentsTab release];
	[endorsementTab release];
	[executionTab release];
	[requisitesTab release];    
	[super dealloc];
}
@end
