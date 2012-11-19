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
#import "AttachmentBase64Loader.h"
#import "WebServiceRequests.h"
#import "CoreDataProxy.h"
#import "SystemDataEntity.h"

#define defaultPopoverSize CGSizeMake(320.0f,44.0f)

@interface iPadInboxExecutionTabViewController(PrivateMethods)
- (NSArray *)getRecordsForDataGroupWithIndex:(int)groupIndex;
- (void)showErrandsUsingOwnedFilter:(Boolean)useOwnedFilter;
- (void)loadAttachmentWithReport:(ReportAttachment*)report andError:(NSString**)error;

@end

@implementation iPadInboxExecutionTabViewController

@synthesize attPicker;
@synthesize popController;

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
    
    if( nil != openOrCloseParentErrandDict )
        [openOrCloseParentErrandDict removeAllObjects];
    else {
        openOrCloseParentErrandDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    
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
    
    if( nil != childErrandDictionary ) {
        [childErrandDictionary release];
    }
    childErrandDictionary = childErrands;
    
    [childErrandDictionary retain];
}

- (void)loadErrandAttachmentsWithDocId:(NSString*)docId
{
    errandAttachments = [docEntity selectErrandAttachmentsWithDocId:docId];
    [errandAttachments retain];
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
        if (filteredErrands != nil)
            [filteredErrands release];
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
    return numberOfRowsInSection; //для обеспечения доступности нижних знАчимых ячеек
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
//    NSLog(@"cellForRowAtIndexPath indexPath %i", indexPath.row);
    if (indexPath.row < [filteredErrands count]) {
        NSString *cellIdentifier = @"DocExecutionCell";
        iPadDocExecutionCell *cell = (iPadDocExecutionCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[[iPadDocExecutionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        }
        [cell setBackgroundStyleForRow:indexPath.row];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        
        [cell setDelegate:self];
        
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
            
                OpenTreeButton *objectOTB = [cell getErrandOpenTreeButton];
            
            if( [openOrCloseParentErrandDict objectForKey:errand.number] ) {
                [objectOTB setSelected:YES];
            }
            else
            {
                [objectOTB setSelected:NO];
            }
            [cell setErrandOpenTreeButtonActionWithTarget:self andAction:@selector(insertChildsToTree:)];
        }
        else
        {
            [cell setErrandOpenTreeButtonActive:NO];
        }
        
        imageName = nil;
//        NSArray *executors = [docEntity selectExecutorsForErrandWithId:errand.id];  //errand.executors != [docEntity selectExecutorsForErrandWithId:errand.id] if have duplicate errand!!!
        NSArray *executors = [errand.executors allObjects];
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
        
        BOOL hiddenAttachment = ([[errandAttachments objectForKey:errand.id] count] > 0) ? NO : YES;
        
        [cell setErrandAttachmentFiles:hiddenAttachment];
        
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
        
//        iPadDocExecutionCell *cell = (iPadDocExecutionCell *)[tableView cellForRowAtIndexPath:indexPath];
//        [cell setSelection:nil];
        
		if (delegate != nil && [delegate respondsToSelector:@selector(showErrand:usingMode:)]) {
			DocErrand *errand = ((DocErrand *)[filteredErrands objectAtIndex:indexPath.row]);
            
            int viewMode = (errand.status != nil && [errand.status intValue] == constErrandStatusProject) ? constModeEdit : constModeView;
             [delegate showErrand:errand usingMode:viewMode];
		}
	}
	[tableView deselectRowAtIndexPath:indexPath animated:NO];	
}


#pragma mark other methods

- (void)showFileListWithCell:(iPadDocExecutionCell *)cell
{
    NSIndexPath *selectedIndexPath = [errandsTableView indexPathForCell:cell];
    DocErrand *errand = ((DocErrand *)[filteredErrands objectAtIndex:selectedIndexPath.row]);
    
    self.attPicker = [[AttachmentsPisker alloc] initWithStyle:UITableViewStylePlain];
    self.attPicker.delegate = self;
    self.attPicker.attachmentsArray = [errandAttachments objectForKey:errand.id];
    
    self.popController = [[UIPopoverController alloc] initWithContentViewController:self.attPicker];
    self.popController.popoverContentSize = defaultPopoverSize;
    self.popController.delegate = self;
    [self.popController presentPopoverFromRect:[cell getAttachmentButtonRect] inView:cell.contentView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    self.popController.popoverContentSize = self.attPicker.tableView.contentSize;
}

- (void)insertChildsToTree:(OpenTreeButton *)sender
{
    //get OpenTreeButton object indexPath of cell which it's subviewed
    
    NSIndexPath *OpenTreeButtonIndexPath = [sender getIndexPath];
    
    //get current erran whose button was pressed
    DocErrand *errand = [((DocErrand *)[filteredErrands objectAtIndex:OpenTreeButtonIndexPath.row]) retain];
    //loading child objects for selected errand
    NSArray *objectsToInsert = [childErrandDictionary objectForKey:errand.id];
    //array of index path's for uitableview animation
    NSMutableArray *arrayOfIndexPaths = [[NSMutableArray alloc] init];
    NSMutableArray *arrayOfObjectsToRemove = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < objectsToInsert.count; ++i)
    {
        //calculate index for inserting/deleting object.
        int newObjectIndex = i + OpenTreeButtonIndexPath.row + 1;
        NSIndexPath *currentIndexPath = [NSIndexPath indexPathForRow:newObjectIndex inSection:OpenTreeButtonIndexPath.section];
        
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
                [self insertChildsToTree:objectOTB];
            /*** End's of recursive section ***/
            
            [arrayOfObjectsToRemove addObject:[objectsToInsert objectAtIndex:i]];
            [arrayOfIndexPaths addObject:currentIndexPath];
        }
    }
    
    //remove objects from data model if exists then animate tableView
    [filteredErrands removeObjectsInArray:arrayOfObjectsToRemove];
    
    [errandsTableView beginUpdates];
        
    if(!sender.selected)  {
        [errandsTableView insertRowsAtIndexPaths:arrayOfIndexPaths withRowAnimation:UITableViewRowAnimationFade];
    }
    else {
        [errandsTableView deleteRowsAtIndexPaths:arrayOfIndexPaths withRowAnimation:UITableViewRowAnimationFade];
    }
    
    [errandsTableView endUpdates];
    
    [sender setSelected:!sender.selected];
    
    if( sender.selected ) {
        [openOrCloseParentErrandDict setObject:@"1" forKey:errand.number];
    }
    else if( [openOrCloseParentErrandDict objectForKey:errand.number] ) {
        [openOrCloseParentErrandDict removeObjectForKey:errand.number];
    }
    
//    for( int i = 0; i < [openOrCloseParentErrandDict count]; ++i ) {
//            NSLog(@" openOrCloseParentErrandDict %@ ", openOrCloseParentErrandDict);
//    }

    [arrayOfIndexPaths release];
    [arrayOfObjectsToRemove release];
    
    [errand release];
}

- (void)loadAttachmentWithReport:(ReportAttachment *)report andError:(NSString**)error
{
    AttachmentBase64Loader *loader = [[AttachmentBase64Loader alloc] init];
    SystemDataEntity *systemEntity = [[SystemDataEntity alloc] initWithContext:[[CoreDataProxy sharedProxy] workContext]];
    NSDictionary *requestData = [WebServiceRequests createRequestOfAttachmentContent:report.id forUser:[systemEntity userInfo]];
    *error = [loader downloadAndParseXMLWithRequest:requestData andSaveWithFileName:report.systemName];
    [systemEntity release];
    [loader release];
}

- (void)didReceiveMemoryWarning {
	NSLog(@"iPadInboxExecutionTab didReceiveMemoryWarning");		
    // Releases the iPadSearchFilter if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc. that aren't in use.
}

#pragma mark UIPopoverController Delegate methods

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{    
    [popoverController release];
    [self.attPicker release];
}

#pragma mark AttachmentPickerController Delegate methods

- (void)reportAttachmentFileSelected:(ReportAttachment *)report
{
    [self.popController dismissPopoverAnimated:YES];
    
//    NSLog(@"Selected File Name = %@",report.name);

    NSString *systemAttachmentName = [NSString stringWithFormat:@"%@_%@",report.id,report.name];
    NSString *attachmentPath = [SupportFunctions createPathForAttachment:systemAttachmentName];
    BOOL attachmentExist = [[NSFileManager defaultManager] fileExistsAtPath:attachmentPath];
    NSString *error = nil;
    
    if(!attachmentExist)
    {
        [self loadAttachmentWithReport:report andError:&error];
    }
    
    if(error != nil)
    {
        NSLog(@"iPadInboxExecutionTabViewController reportAttachmentFileSelected %@ failed with error: %@",report.name,error);
    }
    else
    {
        [delegate showAttachmentWithFileName:systemAttachmentName andName:report.name];
    }
}

#pragma mark custom methods - delegate implementation
- (void)showAttachmentWithFileName:(NSString *)attachmentFileName andName:(NSString *)attachmentName {
	NSLog(@"iPadInboxExecutionTab showAttachmentWithFileName:%@ andName:%@", attachmentFileName, attachmentName);
	if (delegate != nil && [delegate respondsToSelector:@selector(showAttachmentWithFileName:andName:)]) {
		[delegate showAttachmentWithFileName:attachmentFileName andName:attachmentName];
	}
}


- (void)dealloc {
	[errandsTableView release];

	[errands release];
	[filteredErrands release];

    [childErrandDictionary release];
    [errandAttachments release];

    [docEntity release];
    [openOrCloseParentErrandDict release];
    
    self.attPicker = nil;
    self.popController = nil;
	
    [super dealloc];
}
@end
