//
//  BaseFetchedTableDataViewController.h
//  Medi_Pad
//
//  Created by mark2 on 4/14/11.
//  Copyright 2011 HFS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class iDocAppDelegate;

@interface BaseFetchedTableDataViewController : UIViewController 
 <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate> {
    NSString *entityName;
    NSPredicate *predicate;
    NSArray *sortDescriptors;
    NSString *sectionNameKeyPath;
    NSFetchedResultsController *fetchedResultsController;
    UITableView *tableView;
    NSManagedObject *selectedItem;//используется при "заказе" выделения объекта по окончании добавления объекта в контекст
    
    UINavigationController *navController;
    BOOL isEditable;

}

@property (nonatomic, retain) UIView *tableViewPlaceholder;
@property (nonatomic, retain) UIColor *tableViewBackgroundColor;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSString *sectionNameKeyPath;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSString *entityName;
@property (nonatomic, retain) NSPredicate *predicate;
@property (nonatomic, retain) NSArray *sortDescriptors;

- (id)initWithFrame:(CGRect)newFrame;
- (id)initWithFrame:(CGRect)newFrame withNavigation:(BOOL)withNavigation;
- (void)performFetch;
- (void)addTableView;//используется только если не вызывается performFetch

- (BOOL)canEditRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)onObjectDeleted:(NSManagedObject *)deletedObj;
- (void)onEndUpdates;

//можно переопределить для размещения таблицы в специально отведенное место
- (UIView *)tableViewPlaceholder;

//можно переопределить для получения специальных ячеек
- (UITableViewCell *)prepareCellForIndexPath:(NSIndexPath *)indexPath;

//можно переопределить для специальной инициализации ячейки
- (void)processCell:(UITableViewCell *)cell fromIndexPath:(NSIndexPath *)indexPath;

//можно переопределить для задания специального значения ячейке 
- (NSString *)getTextForCellAtIndexPath:(NSIndexPath *)indexPath;

- (void)selectCellAtIndexPath:(NSIndexPath *)indexPath;
- (void)setSelectionTo:(NSManagedObject *)newSelectedItem;
- (void)applySelection;

@end
