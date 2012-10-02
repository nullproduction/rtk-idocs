//
//  iPaddocListPanelViewController.h
//  iDoc
//
//  Created by rednekis on 10-12-15.
//  Copyright 2010 KORUS Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iPadBaseViewController.h"
#import "iPadTaskInfoCell.h"
#import "DashboardItem.h"
#import "AttachmentTypeIconsDictionaryEntity.h"
#import "iPadDocListTableViewController.h"
#import "SystemDataEntity.h"
#import "CoreDataProxy.h"

@class iPadDocListPanelViewController;
@protocol iPadDocListPanelViewControllerDelegate <NSObject>
@optional
- (void)slideDocListPanelButtonPressed;
- (void)didSelectItem:(NSDictionary *)item;//file data
- (void)formatItemHeader:(int)numberOfRecords;
@end

@interface iPadDocListPanelViewController : iPadBaseViewController 
<UITextFieldDelegate, 
 UINavigationControllerDelegate, 
 iPadDocListTableViewControllerDelegate> {
	id<iPadDocListPanelViewControllerDelegate> delegate;		
    NSString *fullDocumentsPath;
    NSString *searchString;
    NSString *sortField;
    BOOL ascending;
    UIViewController *containerController;
    UINavigationController *navController;
    iPadDocListTableViewController *docListTableViewController;
    CoreDataProxy *coreDataProxy;
    SystemDataEntity *systemEntity;
    UserInfo *user;
}

@property (nonatomic, retain) iPadDocListTableViewController *docListTableViewController;
@property (nonatomic, retain) UIViewController *containerController;
@property (nonatomic, retain) NSString *searchString;
@property (nonatomic, retain) NSString *sortField;
@property () BOOL ascending;

- (id)initWithBodyView:(UIView *)bodyView filterView:(UIView *)filterView buttonView:(UIView *)buttonView andDelegate:(id<iPadDocListPanelViewControllerDelegate>) newDelegate;
- (void)loadDataForDashboardItemId:(NSString *)itemId;
- (void)filterAndSortData;
- (void)selectNextItem;
- (void)selectPreviousItem;
- (BOOL)prevItemAvailable;
- (BOOL)nextItemAvailable;
- (BOOL)isSelectedItemViewable;

//passthrough methods
- (void)selectItemInRow:(int)row;
- (void)removeItemList;
- (int)numberOfLoadedItems;

@end
