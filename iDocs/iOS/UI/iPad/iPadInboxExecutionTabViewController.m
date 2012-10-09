//
//  iPadInboxExecutionTabViewController.m
//  iDoc
//
//  Created by rednekis on 10-12-19.
//  Copyright 2010 KORUS Consulting. All rights reserved.
//

#import "iPadInboxExecutionTabViewController.h"
#import "iPadInboxExecutionTabLayoutView.h"
#import "CoreDataProxy.h"
#import "Constants.h"
#import "DocErrand.h"
#import "SupportFunctions.h"
#import "iPadThemeBuildHelper.h"
#import "SystemDataEntity.h"
#import "ActionToSyncDataEntity.h"
#import "Doc.h"
#import "DocErrandExecutor.h"

@interface iPadInboxExecutionTabViewController(PrivateMethods)
- (NSArray *)getRecordsForDataGroupWithIndex:(int)groupIndex;
- (void)showErrandsUsingOwnedFilter:(Boolean)useOwnedFilter;
@end

@implementation iPadInboxExecutionTabViewController

#pragma mark custom methods - init
- (id)initWithPlaceholderPanel:(UIView *)placeholderPanel {
	NSLog(@"iPadInboxExecutionTab init");	
	if ((self = [super initWithNibName:nil bundle:nil])) {
        
        [self setErrandTableView:placeholderPanel];
         docEntity = [[DocDataEntity alloc] initWithContext:[[CoreDataProxy sharedProxy] workContext]];
	}
	return self;
}

- (void)setErrandTableView:(UIView *)placeholderPanel
{
    if (errandsTableView != nil)
        [errandsTableView release];
    
    iPadInboxExecutionTabLayoutView *container = [[iPadInboxExecutionTabLayoutView alloc] init];
    container.frame = placeholderPanel.bounds;
    self.view = container;
    
    [container.tableFilterButton addTarget:self action:@selector(setOnlyMyTasksFilter:) forControlEvents:UIControlEventTouchUpInside];
    
    errandsTableView = [[UITableView alloc] initWithFrame:container.tablePlaceholder.bounds style:UITableViewStylePlain];
    errandsTableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    
    errandsTableView.backgroundColor = [UIColor clearColor];
    
    errandsTableView.rowHeight = constInboxTabCellHeight;
    errandsTableView.scrollEnabled = YES;
    errandsTableView.dataSource = self;
    errandsTableView.delegate = self;
    executionTableSectionHeight = constTaskPanelTablesSectionHeight;
    [container.tablePlaceholder addSubview:errandsTableView];
    
    [placeholderPanel addSubview:container];
    
    [container release];
}

#pragma mark custom methods - load data
- (void)loadTabDataWithErrands:(NSArray *)newErrands andCurrentErrandId:(NSString *)newCurrentErrandId {
	NSLog(@"iPadInboxExecutionTab loadTabData");
    currentErrandId = newCurrentErrandId;
    if (errands != nil)
        [errands release];
    errands = [newErrands copy];
    ((iPadInboxExecutionTabLayoutView *)self.view).tableFilterButton.enabled = ([errands count] > 0) ? YES : NO;
    HFSUIButton *tableFilterButton = ((iPadInboxExecutionTabLayoutView *)self.view).tableFilterButton;
	[tableFilterButton setSelected:YES];
	[self showErrandsUsingOwnedFilter:[tableFilterButton isSelected]];
}

- (void) loadChildErrands:(NSDictionary *)childErrands
{
    NSLog(@"iPadInboxExecutionTab loadChildsForErrands:AT Consulting Dev");
    
    childErrandDictionary = childErrands;
    
    [childErrandDictionary retain];
}

#pragma mark custom methods - panel behavior
- (void)setDelegate:(id<iPadInboxExecutionTabViewControllerDelegate>)newDelegate {
	delegate = newDelegate;
}


#pragma mark custom methods - filter methods
- (void)setOnlyMyTasksFilter:(id)sender {
	NSLog(@"iPadTaskExecutionTab setOnlyMyTasksFilter button pressed");
	HFSUIButton *tableFilterButton = (HFSUIButton *)sender;
	[tableFilterButton setSelected:![tableFilterButton isSelected]];
	[self showErrandsUsingOwnedFilter:[tableFilterButton isSelected]];
}

- (void)showErrandsUsingOwnedFilter:(Boolean)useOwnedFilter {
	NSLog(@"iPadTaskExecutionTab showErrandsUsingOwnedFilter:%i", useOwnedFilter);

	if (useOwnedFilter) {
		filteredErrands = [[NSMutableArray alloc] initWithCapacity:0];	
        SystemDataEntity *systemEntity = [[SystemDataEntity alloc] initWithContext:[[CoreDataProxy sharedProxy] workContext]];
        UserInfo *user = [systemEntity userInfo];
		NSString *userId = user.id;
        
        [systemEntity release];
		
		for(int i = 0; i < [errands count]; i++) {
			DocErrand *errand = ((DocErrand *)[errands objectAtIndex:i]);
			NSString *authorId = errand.authorId;
            
            if ([userId isEqualToString:authorId]) {
				[filteredErrands addObject:errand];		
			} 
            else {
                for (DocErrandExecutor *executor in errand.executors) {
                    if ([userId isEqualToString:executor.executorId]) {
                        [filteredErrands addObject:errand];	
                        break;
                    } 
                }
            }
		}
	}
	else {
		filteredErrands = [errands mutableCopy];	
	}
	[errandsTableView reloadData];
}


#pragma mark UITableViewDelegate and UITableViewDataSource methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	int numberOfRowsInSection = [filteredErrands count];
    return numberOfRowsInSection;//для обеспечения доступности нижних знАчимых ячеек
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    int rowHeight;
    if (indexPath.row < [filteredErrands count]) {
        DocErrand *errand = ((DocErrand *)[filteredErrands objectAtIndex:indexPath.row]);
        int executorsCount = [errand.executors count];
        rowHeight = constInboxTabCellHeight * ((executorsCount > 1) ? executorsCount/2 : 1);
    }
    else {
        rowHeight = constInboxTabCellHeight;
    }
	return rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    iPadDocExecutionCell *cell = nil;
    if (indexPath.row < [filteredErrands count]) {
        NSString *cellIdentifier = @"DocExecutionCell";
        iPadDocExecutionCell *cell = (iPadDocExecutionCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[[iPadDocExecutionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        }
        else
        {
            
        }
        [cell setBackgroundStyleForRow:indexPath.row];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
            
        DocErrand *errand = ((DocErrand *)[filteredErrands objectAtIndex:indexPath.row]);
        
        [cell setErrandId:errand.id];
                    
        NSString *imageName = nil;
        switch ([errand.status intValue]) {
            case constErrandStatusInProcess:
                imageName = [iPadThemeBuildHelper nameForImage:@"icon_mark_gear_1.png"];
                break;			
            case constErrandStatusApproved:
                imageName = [iPadThemeBuildHelper nameForImage:@"icon_mark_check_3.png"];
                break;
            case constErrandStatusRejected:
                imageName = [iPadThemeBuildHelper nameForImage:@"icon_mark_cross_1.png"];
                break;	
            case constErrandStatusProject:
                imageName = [iPadThemeBuildHelper nameForImage:@"icon_mark_edit_doc_1.png"];
              break;	
            default:
                imageName = nil;
                break;
        }
        [cell setErrandStatusImage:imageName];
        [cell setErrandNumber:errand.number];
        [cell setErrandAuthorName:errand.authorName];
        
        if([[childErrandDictionary objectForKey:errand.id] count] > 0)
        {
            [cell setErrandOpenTreeButtonActive:YES];
            [cell setErrandOpenTreeButtonActionWithTarget:self andAction:@selector(inserChildsToTree:)];
            [cell setErrandOpenTreeButtonIndexPath:indexPath];
        }
        else
        {
            [cell setErrandOpenTreeButtonActive:NO];
            [cell setErrandOpenTreeButtonIndexPath:nil];
        }
        
        imageName = nil;
        NSArray *executors = [docEntity selectExecutorsForErrandWithId:errand.id];
        if ([executors count] == 1 && [errand.status intValue] != constErrandStatusProject) {
            DocErrandExecutor *executor = [executors objectAtIndex:0];
            imageName = ([executor.isMajorExecutor boolValue] == YES) ? [iPadThemeBuildHelper nameForImage:@"executor_icon.png"] : nil;            
        }
        [cell setErrandMajorExecutorImage:imageName];
        
        //TODO simplify:
        NSString *executorNamesList = nil;
        for (DocErrandExecutor *executor in executors) {
            executorNamesList = ([executorNamesList length] == 0) ? 
                                executor.executorName : 
                                [NSString stringWithFormat:@"%@, %@", executorNamesList, executor.executorName];	
        }
        [cell setErrandExecutorName:executorNamesList];
        [cell setNumberOfLinesForErrandExecutorLabel:([executors count] > 0) ? [executors count] : 1];
        
        [cell setErrandText:errand.text];
        
        //set errand due date and due date status
        NSDate *dueDate = errand.dueDate;
        if (dueDate != nil) {
            NSString *dateFormatted = [SupportFunctions convertDateToString:dueDate withFormat:constDateTimeFormat]; 
            UIColor *statusColor = 
            ([SupportFunctions date:dueDate lessThanDate:[SupportFunctions currentDate]]) ? [iPadThemeBuildHelper commonTextFontColor3] : [iPadThemeBuildHelper commonTextFontColor1];
            [cell setErrandDueDate:dateFormatted withColor:statusColor];		
        }
        else {
            [cell setErrandDueDate:NSLocalizedString(@"ErrandNoControlTitle", nil) withColor:[iPadThemeBuildHelper commonTextFontColor1]];
        }

        [cell setCurrentErrandStyle:(currentErrandId != nil && [currentErrandId isEqualToString:errand.id]) ? YES : NO];    
        return cell;
    }
    else {         
        NSString *cellIdentifier = @"SupportCell";
        cell = (iPadDocExecutionCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[[iPadDocExecutionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        }
    return cell;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	if (scrollView.contentOffset.y <= executionTableSectionHeight && scrollView.contentOffset.y >= 0) {
		scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0.0f, 0.0f, 0.0f);
	} 
	else if(scrollView.contentOffset.y >= executionTableSectionHeight) {
		scrollView.contentInset = UIEdgeInsetsMake(-executionTableSectionHeight, 0.0f, 0.0f, 0.0f);
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSLog(@"iPadInboxExecutionTab didSelectRowAtIndexPath indexPath.row: %i", indexPath.row);
    if ([filteredErrands count] > indexPath.row) {
		if (delegate != nil && [delegate respondsToSelector:@selector(showErrand:usingMode:)]) {
			DocErrand *errand = ((DocErrand *)[filteredErrands objectAtIndex:indexPath.row]);
            
            int viewMode = (errand.status != nil && [errand.status intValue] == constErrandStatusProject) ? constModeEdit : constModeView;
             [delegate showErrand:errand usingMode:viewMode];
		}
	}
	[tableView deselectRowAtIndexPath:indexPath animated:NO];	
}


#pragma mark other methods

- (void)inserChildsToTree:(OpenTreeButton *)sender
{
    //get current erran whose button was pressed
    DocErrand *errand = ((DocErrand *)[filteredErrands objectAtIndex:sender.rowPath.row]);
    //loading child objects for selected errand
    NSArray *objectsToInsert = [childErrandDictionary objectForKey:errand.id];
    //array of index path's for uitableview animation
    NSMutableArray *arrayOfIndexPaths = [[NSMutableArray alloc] init];
    
    for (int i = 0;i<objectsToInsert.count;i++)
    {
        //calculate index for inserting/deleting object.
        int newObjectIndex = i+sender.rowPath.row+1;
        NSIndexPath *currentIndexPath = [NSIndexPath indexPathForRow:newObjectIndex inSection:sender.rowPath.section];
        
        if(!sender.selected)
        {
            //if inserts object -> add new objects to data model
            [filteredErrands insertObject:[objectsToInsert objectAtIndex:i] atIndex:newObjectIndex];
            [arrayOfIndexPaths addObject:currentIndexPath];
        }
        else
        {
            /*** This section needs for recursive deleting rows(objects) in uitableview.if we're closed the root errand and its child was opened -> close whole tree ***/
            iPadDocExecutionCell *cell = (iPadDocExecutionCell*)[errandsTableView cellForRowAtIndexPath:currentIndexPath];
            OpenTreeButton *objectOTB = [cell getErrandOpenTreeButton];
            
            if(objectOTB.selected)
                [self inserChildsToTree:objectOTB];
            /*** End's of recursive section ***/
            
            [filteredErrands removeObject:[objectsToInsert objectAtIndex:i]];
            [arrayOfIndexPaths addObject:currentIndexPath];
        }
    }
    
    [errandsTableView beginUpdates];
    
    (!sender.selected) ? [errandsTableView insertRowsAtIndexPaths:arrayOfIndexPaths withRowAnimation:UITableViewRowAnimationFade] : [errandsTableView deleteRowsAtIndexPaths:arrayOfIndexPaths withRowAnimation:UITableViewRowAnimationFade];
    
    [errandsTableView endUpdates];
    
    [sender setSelected:!sender.selected];
    
    [arrayOfIndexPaths release];
}

- (void)didReceiveMemoryWarning {
	NSLog(@"iPadInboxExecutionTab didReceiveMemoryWarning");		
    // Releases the iPadSearchFilter if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc. that aren't in use.
}

- (void)dealloc {
    [docEntity release];
	[errands release];
    [childErrandDictionary release];
	[filteredErrands release];
	[errandsTableView release];
	[super dealloc];
}
@end
