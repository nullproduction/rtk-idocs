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
    NSArray* attachments = [docEntity selectAttachmentsForDocWithId:self.loadedItem.doc.id];
    NSArray* sortedAttachments = [docEntity sortDocAttachments:attachments];
	[attachmentsTab loadTabData:sortedAttachments];
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
    [executionTab setErrandTableView:body];
	[executionTab loadTabDataWithErrands:[docEntity selectErrandsForDocWithId:self.loadedItem.doc.id] andCurrentErrandId:currentErrandId];
    [executionTab loadChildErrands:[docEntity selectChildErrandsForDocWithId:self.loadedItem.doc.id]];

    [executionTab loadErrandAttachmentsWithDocId:self.loadedItem.doc.id];
    
    
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
    NSArray* attachments = [docEntity selectAttachmentsForDocWithId:self.loadedItem.doc.id];
    NSArray* sortedAttachments = [docEntity sortDocAttachments:attachments];
    
    [requisitesTab loadTabDataWithExecutorName:self.loadedItem.doc.ownerName 
                                docDescription:self.loadedItem.doc.desc 
                                    requisites:[docEntity selectRequisitesForDocWithId:self.loadedItem.doc.id]
                                andAttachments:sortedAttachments];
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
