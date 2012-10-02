//
//  MedExamDictionaryItemListViewController.m
//  Medi_Pad
//
//  Created by mark2 on 4/14/11.
//  Copyright 2011 HFS. All rights reserved.
//

#import "BaseFetchedTableDataViewController.h"
#import <CoreData/CoreData.h>
#import "Constants.h"
#import "CoreDataProxy.h"

@interface BaseFetchedTableDataViewController(PrivateMethods)
- (void)fetchControllerUpdateRowAtIndexPath:(NSIndexPath *)indexPath;
@end

@implementation BaseFetchedTableDataViewController

@dynamic tableViewPlaceholder, tableViewBackgroundColor;

@synthesize tableView, fetchedResultsController, entityName, predicate, sortDescriptors,sectionNameKeyPath;

- (id)initWithFrame:(CGRect)newFrame {
    return [self initWithFrame:newFrame withNavigation:NO];
}

- (id)initWithFrame:(CGRect)newFrame withNavigation:(BOOL)withNavigation {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.view.frame = newFrame;
        self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        selectedItem = nil;
        isEditable = NO;
        if (withNavigation) 
        {   //контроллер сам себе создает навигейшн, и умеет в него пушиться.
            navController = [[UINavigationController alloc] initWithRootViewController:self];
            navController.view.frame = self.view.frame;
        }
    }
    return self;
}

- (UIView *)tableViewPlaceholder {
    return self.view;
}

- (UIColor *)tableViewBackgroundColor {
    return nil;
}

- (void)addTableView {
    //если фильтр изменился - необходимо полностью пересоздать таблицу. обновление не помогает, таблица рассинхронизируется с fc (бага fc)        
    if(self.tableView) {
        [self.tableView removeFromSuperview];
        self.tableView = nil;
    }
    UITableView *tmpTableView = [[UITableView alloc] initWithFrame:self.tableViewPlaceholder.bounds style:UITableViewStylePlain];
    self.tableView = tmpTableView;
    [tmpTableView release];
    
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.rowHeight = 30.0f;
    tableView.bounces = NO;
    if (self.tableViewBackgroundColor) {
        tableView.backgroundColor = self.tableViewBackgroundColor;
    }
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.tableViewPlaceholder addSubview:tableView];
}

- (void)performFetch {
    self.fetchedResultsController = nil;//сброс fc перед изменением предиката и сортировки, и пока не создана таблица. это важно. иначе - рассинхронизация
    [self addTableView];

    NSError *error = nil;
    [self.fetchedResultsController performFetch:&error];
    if (error) {
        [[[[UIAlertView alloc]initWithTitle:@"BaseFetchedTableDataViewController" 
                                  message:[error localizedDescription] 
                                 delegate:nil 
                          cancelButtonTitle:@"Ok" otherButtonTitles: nil] autorelease] show];
    }
}

#pragma mark - Override methods
- (UITableViewCell *)prepareCellForIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell1"];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell1"] autorelease];
        [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
    }
    return cell;
}

- (BOOL)canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return isEditable;
}

- (void)onObjectDeleted:(NSManagedObject *)deletedObj {
    
}

- (void)onEndUpdates {
}

- (NSString *)getTextForCellAtIndexPath:(NSIndexPath *)indexPath {
    return [NSString stringWithFormat:@"%i",indexPath.row];
}

- (void)processCell:(UITableViewCell *)cell fromIndexPath:(NSIndexPath *)indexPath {
    NSString *cellValue = [self getTextForCellAtIndexPath:indexPath];
    cell.textLabel.text = cellValue;
}

- (void)selectCellAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self selectCellAtIndexPath:indexPath];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    int sectionsCount = [[self.fetchedResultsController sections] count];
    return sectionsCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    int rowsCount = [sectionInfo numberOfObjects];
    return rowsCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self prepareCellForIndexPath:indexPath];
    [self processCell:cell fromIndexPath:indexPath];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    id<NSFetchedResultsSectionInfo>sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo indexTitle];
}

- (NSString *)controller:(NSFetchedResultsController *)controller sectionIndexTitleForSectionName:(NSString *)sectionName {
    return sectionName;
}

#pragma mark Editing
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self canEditRowAtIndexPath:indexPath];
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self canEditRowAtIndexPath:indexPath];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)atableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObject *toDelete = [self.fetchedResultsController objectAtIndexPath:indexPath];
        if (selectedItem && selectedItem == toDelete) {
            selectedItem = nil;
        };
        [[[CoreDataProxy sharedProxy] workContext] deleteObject:toDelete];
        [self onObjectDeleted:toDelete];
    }
}


#pragma mark Fetched results controller
- (NSFetchedResultsController *)fetchedResultsController {
    if (fetchedResultsController != nil) {
        return fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];

    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName 
                                              inManagedObjectContext:[[CoreDataProxy sharedProxy] workContext]];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    if (predicate) [fetchRequest setPredicate:predicate];
    if (sortDescriptors) [fetchRequest setSortDescriptors:sortDescriptors];
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] 
                                                             initWithFetchRequest:fetchRequest 
                                                             managedObjectContext:[[CoreDataProxy sharedProxy] workContext]
                                                             sectionNameKeyPath:self.sectionNameKeyPath
                                                             cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    [aFetchedResultsController release];
    [fetchRequest release];
    
    return fetchedResultsController;
}    

- (void)fetchControllerUpdateRowAtIndexPath:(NSIndexPath *)indexPath {
    [self processCell:[tableView cellForRowAtIndexPath:indexPath] fromIndexPath:indexPath];
}


#pragma mark Fetched results controller delegate
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
        {
            [self fetchControllerUpdateRowAtIndexPath:indexPath];
        }
            break;
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
    //[tableView reloadData];
    [self onEndUpdates];
    [self applySelection];
}

- (void)setSelectionTo:(NSManagedObject *)newSelectedItem {
    //запоминаем - какой объект должен быть визуально выбран (после добавления)
    selectedItem = newSelectedItem;
}

- (void)applySelection {
    if (selectedItem != nil) {
        NSIndexPath *indexPath = [self.fetchedResultsController indexPathForObject:selectedItem];
        //если был заказан выбор объекта - находим и выбираем строку, которая ему соответствует
        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];    
    }
    //сбрасываем заказанный под выделение объект - он уже выбран
    selectedItem = nil;
}


#pragma mark
- (void)dealloc {
    navController = nil;

    [sectionNameKeyPath release];
    [entityName release];
    self.predicate = nil;
    self.sortDescriptors = nil;
    self.fetchedResultsController = nil;
    self.tableView = nil;
    [super dealloc];
}

@end
