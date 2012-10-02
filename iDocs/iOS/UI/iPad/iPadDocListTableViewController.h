//
//  iPadDocListTableViewController.h
//  iDoc
//
//  Created by Michael Syasko on 6/16/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AttachmentTypeIconsDictionaryEntity.h"

@protocol iPadDocListTableViewControllerDelegate <NSObject>
- (void)didSelectItem:(NSDictionary *)item; //file data
@end

@interface iPadDocListTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    UITableView *docListTableView;
    NSMutableArray *items;
    AttachmentTypeIconsDictionaryEntity *iconsMap;
    id<iPadDocListTableViewControllerDelegate> delegate;
    NSString *currentPath;
    NSString *currentSearchString;
    int currentLevel;
    UITableView *tableView;

    NSString *sortField;
    BOOL ascending;
}

@property (nonatomic, retain) NSMutableArray *items;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSString *currentPath;
@property (nonatomic, retain) NSString *currentSearchString;
@property (nonatomic, retain) NSString *sortField;
@property () int currentLevel;

- (id)initWithDelegate:(id<iPadDocListTableViewControllerDelegate>)newDelegate;    
- (void)selectItemInRow:(int)row;
- (NSIndexPath *)indexPathForSelectedRow;
- (int)numberOfLoadedItems;
- (BOOL)hasFollowingRow:(int)index;
- (BOOL)isItemViewable:(int)row;
- (void)loadItemsFilteredBySearchText:(NSString *)searchString 
                            sortField:(NSString *)field
                            ascending:(BOOL)asc;
- (void)performInitialSelection;
- (void)removeItemList;

@end
