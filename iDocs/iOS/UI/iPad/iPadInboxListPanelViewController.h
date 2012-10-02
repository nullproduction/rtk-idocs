//
//  iPadInboxListPanelViewController.h
//  iDoc
//
//  Created by rednekis on 10-12-15.
//  Copyright 2010 KORUS Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iPadBaseViewController.h"
#import "iPadTaskInfoCell.h"
#import "DashboardItem.h"
#import "iPadInboxListTableViewController.h"

@class iPadInboxListPanelViewControllerDelegate;
@protocol iPadInboxListPanelViewControllerDelegate <NSObject>
@optional
- (void)slideInboxListPanelButtonPressed;
- (void)didSelectItem:(Task *)item;
- (void)setSelectedItemProcessed;
- (void)formatItemHeader:(int)numberOfRecords;
@end

@interface iPadInboxListPanelViewController : iPadBaseViewController <UITextFieldDelegate, iPadInboxListTableViewControllerDelegate> {
	id<iPadInboxListPanelViewControllerDelegate> delegate;
    iPadInboxListTableViewController *inboxListTableViewController;
	NSString *itemsGroupId;	
    NSString *sortFields;
}

@property (nonatomic, retain) iPadInboxListTableViewController *inboxListTableViewController;
@property (nonatomic, retain) NSString *sortFields;
@property (nonatomic, retain) NSString *itemsGroupId;

- (id)initWithBodyView:(UIView *)bodyView filterView:(UIView *)filterView buttonView:(UIView *)buttonView andDelegate:(id<iPadInboxListPanelViewControllerDelegate>)newDelegate;
- (void)loadDataForDashboardItemId:(NSString *)itemId;
- (BOOL)selectNextItem;
- (BOOL)selectPreviousItem;

//passthrough methods
- (void)selectItemInRow:(int)row;
- (void)setSelectedItemProcessed;
- (void)removeSelectedItem;
- (void)removeItemList;
- (int)numberOfLoadedItems;

@end
