//
//  iPadInboxItemPanelViewController.h
//  iDoc
//
//  Created by rednekis on 10-12-15.
//  Copyright 2010 KORUS Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iPadBaseViewController.h"
#import "HFSUILabel.h"
#import "iPadInboxAttachmentsTabViewController.h"
#import "iPadInboxEndorsementTabViewController.h"
#import "iPadInboxExecutionTabViewController.h"
#import "iPadInboxRequisitesTabViewController.h"
#import "iPadErrandPanelViewController.h"
#import "iPadResolutionViewController.h"

@interface iPadInboxItemPanelViewController : iPadBaseViewController {	
    Task *loadedItem; 	
    
	HFSUILabel *headerTitle;
	UIView *body;
    
	UIButton *attachmentsButton;
	iPadInboxAttachmentsTabViewController *attachmentsTab;
    
	UIButton *endorsementButton;
	iPadInboxEndorsementTabViewController *endorsementTab;
    
	UIButton *executionButton;
	iPadInboxExecutionTabViewController *executionTab;	

	UIButton *requisitesButton;
	iPadInboxRequisitesTabViewController *requisitesTab;
}

@property(nonatomic, retain) Task *loadedItem;

- (id)initWithContentPlaceholderView:(UIView *)contentPanel 
                    buttonsPanelView:(UIView *)buttonsPanel
                         andDelegate:(id<iPadInboxRequisitesTabViewControllerDelegate, 
                                      iPadInboxExecutionTabViewControllerDelegate>)newDelegate;
- (void)loadItem:(Task *)item;
- (void)removeCurrentItem;

- (void)reloadExecutionTab;

@end
