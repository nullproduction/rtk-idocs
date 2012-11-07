//
//  iPadInboxListTableViewControllerDelegate.m
//  iDoc
//
//  Created by mark2 on 6/17/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import "iPadInboxListTableViewController.h"
#import "iPadPanelBodyBackgroundView.h"
#import "iPadListItemCell.h"
#import "Task.h"
#import "CoreDataProxy.h"
#import "iPadTaskInfoCell.h"
#import "SupportFunctions.h"
#import "iPadThemeBuildHelper.h"
#import <QuartzCore/QuartzCore.h>

@implementation iPadInboxListTableViewController

@synthesize tableView;

- (id)initWithPanelDelegate:(id<iPadInboxListTableViewControllerDelegate>)newDelegate {
	NSLog(@"iPadInboxListTableViewController initWithTableViewController");		
	if ((self = [super initWithNibName:nil bundle:nil])) {    
        
        delegate = newDelegate;
        iPadPanelBodyBackgroundView *leftSliderBodyBack = [[iPadPanelBodyBackgroundView alloc] init];
        leftSliderBodyBack.frame = CGRectOffset(CGRectInset(self.view.bounds, -2, 0), 2, 0);

        UIView *colorMaskView  = [[UIView alloc] initWithFrame:leftSliderBodyBack.bounds];
        colorMaskView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        colorMaskView.backgroundColor = [iPadThemeBuildHelper itemListBackgroundOverlayColor];
        [leftSliderBodyBack addSubview:colorMaskView];
        [colorMaskView release];
        
        [self.view addSubview:leftSliderBodyBack];
        [leftSliderBodyBack release];
        
        UITableView *tmpTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        self.tableView = tmpTableView;
        [tmpTableView release];
        tableView.scrollEnabled = YES;
        tableView.showsVerticalScrollIndicator = YES;
        tableView.showsHorizontalScrollIndicator = NO;
        tableView.rowHeight = 111.0f;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        tableView.dataSource = self;
        tableView.delegate = self;
        
        [self.view addSubview:tableView];
        items = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSIndexPath *)indexPathForSelectedRow {
    return [tableView indexPathForSelectedRow];
}

#pragma mark UITableViewDataSource and UITableViewDelegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)atableView numberOfRowsInSection:(NSInteger)section {
	int numberOfRowsInSection = [items count];
    return numberOfRowsInSection;
}

- (UITableViewCell *)tableView:(UITableView *)atableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {	
    static NSString *cellIdentifier = @"TaskInfoCell";
    
    iPadTaskInfoCell *cell = (iPadTaskInfoCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil) {
		cell = [[[iPadTaskInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
	}
    
	Task *item = [items objectAtIndex:indexPath.row];
    currentTask = item;
	
	[cell setTaskId:item.id];
	[cell setDocTypeName:([item.type intValue] == ORDTaskTypeRegular) ? item.doc.typeName : item.name];
    [cell setTaskProcessed:[item.systemActionIsProcessed boolValue]];
    
	//is task viewed status
	BOOL isViewed = [item.isViewed boolValue];
    [cell setTaskViewed:isViewed];
	
    //set task due date and due date status
    NSDate *dueDate = item.dueDate;
    NSString *dateFormatted = nil;
    UIColor *statusColor = nil;
    if (dueDate != nil) {
        dateFormatted = [SupportFunctions convertDateToString:dueDate withFormat:constDateTimeFormatShort]; 
        statusColor = 
            ([SupportFunctions date:dueDate lessThanDate:[SupportFunctions currentDate]]) ? [iPadThemeBuildHelper commonTextFontColor3] : [iPadThemeBuildHelper commonTextFontColor1];
    }
    [cell setTaskStageDueDate:dateFormatted withColor:statusColor];		
    
	[cell setDocDesc:item.doc.desc];
	return cell;
}

- (void)tableView:(UITableView *)atableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSLog(@"iPadInboxList didSelectRowAtIndexPath rowIndex: %i", indexPath.row);
	[self selectItemInRow:indexPath.row];
}


#pragma mark 
- (void)removeItemList {
	NSLog(@"iPadInboxList removeItemList");
	[items removeAllObjects];
	[self.tableView reloadData];
}

- (void)selectItemInRow:(int)row {
	NSLog(@"iPadInboxList selectTaskInRow: %i", row);
	if ([items count] > row) {
		NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        
		if (delegate != nil && [delegate respondsToSelector:@selector(didSelectItem:)]) {
			Task *item = [items objectAtIndex:indexPath.row];	
			[delegate didSelectItem:item];
            
            //set record viewed
            iPadTaskInfoCell *cell;
            cell = (iPadTaskInfoCell *)[tableView cellForRowAtIndexPath:indexPath];
            [cell setTaskViewed:YES];
            
            //set item viewed
            item.isViewed = [NSNumber numberWithBool:YES];
		}	
	}
}

- (void)setSelectedItemProcessed {
    NSIndexPath *indexPath = [self indexPathForSelectedRow];
    iPadTaskInfoCell *cell = (iPadTaskInfoCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell setTaskProcessed:YES];
}

- (void)removeSelectedItem {
	NSLog(@"iPadInboxList removeSelectedTask");
	int selectedTaskIndex = [[tableView indexPathForSelectedRow] row];
	if ([items count] > selectedTaskIndex) {
		Task *item = [items objectAtIndex:selectedTaskIndex];
        TaskDataEntity *taskEntity = [[TaskDataEntity alloc] initWithContext:[[CoreDataProxy sharedProxy] workContext]];
		[taskEntity deleteTaskWithId:item.id];
        [taskEntity release];
		[items removeObjectAtIndex:selectedTaskIndex];
		[tableView reloadData];
	}
}


- (void)loadItemsFilteredBySearchText:(NSString *)searchString 
                         itemsGroupId:(NSString *)itemsGroupId  
                            sortFields:(NSString *)sortFields {
	NSLog(@"iPadInboxList loadItemsFilteredBySearchText: %@ itemsGroupId:%@ sortFields:%@", searchString, itemsGroupId, sortFields);
    [items removeAllObjects];
    
    searchString = (searchString.length > 0) ? [searchString lowercaseString] : nil;

    NSMutableArray *sortArray = [[NSMutableArray alloc] initWithCapacity:0];
    NSArray *sortData = [sortFields componentsSeparatedByString:@","];
    for (NSString *sortFieldData in sortData) {
        NSArray *sortFieldParams = [sortFieldData componentsSeparatedByString:@"|"];
        NSString *sortField = [sortFieldParams objectAtIndex:0];
        NSString *sortType = [sortFieldParams objectAtIndex:1];
        NSDictionary *sortFieldDict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:sortField, sortType, nil] 
                                                                  forKeys:[NSArray arrayWithObjects:constSortField, constSortType, nil]];
        [sortArray addObject:sortFieldDict];
    }
    
    TaskDataEntity *taskEntity = [[TaskDataEntity alloc] initWithContext:[[CoreDataProxy sharedProxy] workContext]];
	if (searchString.length == 0) {
//        if( nil != items )
//           [items release];
        items = [[taskEntity selectTasksInDashboardItemWithId:itemsGroupId sortByFields:sortArray] mutableCopy];
	}
	else if (searchString.length > 0) {
        NSArray *storedItems = [[taskEntity selectTasksInDashboardItemWithId:itemsGroupId sortByFields:sortArray] mutableCopy];
		for (int i = 0; i < [storedItems count]; i++) {
            Task *storedItem = [storedItems objectAtIndex:i];
			
            NSString *docTypeName = [storedItem.doc.typeName lowercaseString];
			NSRange searchTextRangeInDocTypeName = [docTypeName rangeOfString:searchString];
			
			NSString *taskDueDate = [[SupportFunctions convertDateToString:storedItem.dueDate withFormat:constDateTimeFormat] lowercaseString];
			NSRange searchTextRangeInTaskDueDate = [taskDueDate rangeOfString:searchString];
			
			NSString *docDesc = [storedItem.doc.desc lowercaseString];
			NSRange searchTextRangeInDocDesc = [docDesc rangeOfString:searchString];
			
			if (searchTextRangeInDocTypeName.location != NSNotFound ||
				searchTextRangeInTaskDueDate.location != NSNotFound ||
				searchTextRangeInDocDesc.location != NSNotFound) {
				[items addObject:storedItem];
			}
		}
        [storedItems release];
	}	
    [taskEntity release];
    [sortArray release];
	[tableView reloadData];
}

- (int)numberOfLoadedItems {
	NSLog(@"iPadInboxList numberOfLoadedTasks");
	return [items count];
}


- (void)dealloc {
    [items release];
    [tableView release];
    [super dealloc];
}

@end
