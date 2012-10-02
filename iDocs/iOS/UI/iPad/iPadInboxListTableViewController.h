//
//  iPadInboxListTableViewControllerDelegate.h
//  iDoc
//
//  Created by mark2 on 6/17/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TaskDataEntity.h"

@protocol iPadInboxListTableViewControllerDelegate <NSObject>
- (void)didSelectItem:(Task *)item;
@end

@interface iPadInboxListTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray *items;
    id<iPadInboxListTableViewControllerDelegate> delegate;
    UITableView *tableView;
    Task *currentTask;
}

@property (nonatomic, retain) UITableView *tableView;

- (id)initWithPanelDelegate:(id<iPadInboxListTableViewControllerDelegate>)newDelegate;    
- (NSIndexPath *)indexPathForSelectedRow;
- (int)numberOfLoadedItems;
- (void)loadItemsFilteredBySearchText:(NSString *)searchString 
                         itemsGroupId:(NSString *)itemsGroupId  
                            sortFields:(NSString *)sortFields;
- (void)selectItemInRow:(int)row;
- (void)setSelectedItemProcessed;
- (void)removeSelectedItem;
- (void)removeItemList;
- (int)numberOfLoadedItems;


@end
