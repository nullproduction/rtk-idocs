//
//  TaskDataEntity.m
//  iDoc
//
//  Created by rednekis on 5/8/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import "TaskDataEntity.h"
#import "NSManagedObjectContext+CustomFetch.h"
#import "SupportFunctions.h"
#import "DashboardItem.h"
#import "Constants.h"
#import "ClientSettingsDataEntity.h"
#import "TaskActionTemplate.h"
#import "DocDataEntity.h"


#define constTaskGroupEntity @"TaskGroup"
#define constTaskEntity @"Task"
#define constTaskActionEntity @"TaskAction"
#define constTaskAsReadEntity @"TaskAsRead"

@implementation TaskDataEntity

- (id)initWithContext:(NSManagedObjectContext *)newContext {
	if ((self = [super init])) {
		context = newContext;
	}
	return self;
}

#pragma mark tasks
- (Task *)createTask {	
	return (Task *)[NSEntityDescription insertNewObjectForEntityForName:constTaskEntity inManagedObjectContext:context];
}

- (Task *)createTaskOnControlForDocWithId:(NSString *)docId {
    DocDataEntity *docEntity = [[DocDataEntity alloc] initWithContext:context];
    Doc *doc = [docEntity selectDocById:docId];
    
    Task *task = nil;
    if ([docEntity isOnControlTaskLinkedToDocWithId:docId] == NO) {
        Task *task = [self createTask];
        task.id = [NSString stringWithFormat:@"task_on_control_for_doc_%@", docId];
        task.name = NSLocalizedString(@"OnControlTaskTitle", nil);
        task.isViewed = [NSNumber numberWithBool:YES];
        task.type = [NSNumber numberWithInt:ORDTaskTypeOnControl];
        task.systemUpdateDate = doc.systemUpdateDate;
        task.systemSyncStatus = constSyncStatusWorking;
        task.doc = doc;
        
        ClientSettingsDataEntity *clientSettingsEntity = [[ClientSettingsDataEntity alloc] initWithContext:context];
        DashboardItem *dashboardItem = [clientSettingsEntity selectDashboardItemById:constOnControlFolderId];
        if (dashboardItem != nil)
            [task addDashboardItemsObject:dashboardItem];
        else
            task = nil;
        [clientSettingsEntity release];
        
        [self createActionsFromTemplatesForTaskWithId:task.id];
    }
    
    [docEntity release];
    
    return task;
}

- (Task *)selectTaskById:(NSString *)taskId {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id = %@", taskId];
    NSArray *items = [context executeFetchRequestWithPredicate:predicate andEntityName:constTaskEntity andSortDescriptors:nil];
	return ([items count] == 1) ? (Task *)[items objectAtIndex:0] : nil;	
}

- (Task *)selectTaskOnControlForDocWithId:(NSString *)docId {
    NSPredicate *predicate = 
        [NSPredicate predicateWithFormat:@"doc.id = %@ AND type = %@", docId, [NSNumber numberWithInt:ORDTaskTypeOnControl]];
    NSArray *items = [context executeFetchRequestWithPredicate:predicate andEntityName:constTaskEntity andSortDescriptors:nil];
    return ([items count] == 1) ? (Task *)[items objectAtIndex:0] : nil;
}

- (NSArray *)selectAllTasks {
    NSArray *items = [context executeFetchRequestWithPredicate:nil andEntityName:constTaskEntity andSortDescriptors:nil];
    return items;
}

- (NSArray *)selectRegularTasks {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type = %@", [NSNumber numberWithInt:ORDTaskTypeRegular]];
    NSArray *items = [context executeFetchRequestWithPredicate:predicate andEntityName:constTaskEntity andSortDescriptors:nil];
    return items;
}

- (NSArray *)selectOnControlTasks {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type = %@", [NSNumber numberWithInt:ORDTaskTypeOnControl]];
    NSArray *items = [context executeFetchRequestWithPredicate:predicate andEntityName:constTaskEntity andSortDescriptors:nil];
    return items;
}

- (NSArray *)selectTasksToLoad {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"systemSyncStatus = %@", constSyncStatusToLoad];
    NSArray *items = [context executeFetchRequestWithPredicate:predicate andEntityName:constTaskEntity andSortDescriptors:nil];
    return items;
}

- (NSArray *)selectTasksWithDocsToLoad {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"doc.systemSyncStatus = %@", constSyncStatusToLoad];
    NSArray *items = [context executeFetchRequestWithPredicate:predicate andEntityName:constTaskEntity andSortDescriptors:nil];
    return items;
}

// sortArray - array of dictionaries: sortField + sortType
- (NSArray *)selectTasksInDashboardItemWithId:(NSString *)dashboardItemId sortByFields:(NSArray *)sortArray {
    NSMutableArray *sortDescriptors = [[NSMutableArray alloc] init];
    for (NSDictionary *sortFieldData in sortArray) {
        NSString *sortField = [sortFieldData valueForKey:constSortField];
        BOOL sortType = [[sortFieldData valueForKey:constSortType] boolValue];
        [sortDescriptors addObject:[NSSortDescriptor sortDescriptorWithKey:sortField ascending:sortType]];
    }
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY dashboardItems.id = %@", dashboardItemId];
    NSArray *items = [context executeFetchRequestWithPredicate:predicate andEntityName:constTaskEntity andSortDescriptors:(NSArray *)sortDescriptors];
    [sortDescriptors release];
	return items;	
}

- (void)deleteTasksInDashboardItemWithId:(NSString *)dashboardItemId {	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY dashboardItems.id = %@", dashboardItemId];
    NSArray *items = [context executeFetchRequestWithPredicate:predicate andEntityName:constTaskEntity andSortDescriptors:nil];
    for (NSManagedObject *item in items) {
        [context deleteObject:[context objectWithID:[item objectID]]];
    }	
}

- (BOOL)isTaskWithId:(NSString *)taskId inDashboardItem:(NSString *)dashboardItemId {	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id = %@ AND ANY dashboardItems.id = %@", taskId, dashboardItemId];
    NSArray *items = [context executeFetchRequestWithPredicate:predicate andEntityName:constTaskEntity andSortDescriptors:nil];
    return ([items count] > 0) ? YES : NO;	
}

- (BOOL)isTaskWithId:(NSString *)taskId linkedToDocWithId:(NSString *)docId {	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id = %@ AND doc.id = %@", taskId, docId];
    NSArray *items = [context executeFetchRequestWithPredicate:predicate andEntityName:constTaskEntity andSortDescriptors:nil];
    return ([items count] == 1) ? YES : NO;	
}

- (void)deleteTaskWithId:(NSString *)taskId {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id = %@", taskId];
    NSArray *items = [context executeFetchRequestWithPredicate:predicate andEntityName:constTaskEntity andSortDescriptors:nil];
    for (Task *item in items) {
        [context deleteObject:[context objectWithID:[item objectID]]];
    }
}

- (void)deleteAllTasks {
    NSArray *items = [context executeFetchRequestWithPredicate:nil andEntityName:constTaskEntity andSortDescriptors:nil];
    for (NSManagedObject *item in items) {
        [context deleteObject:[context objectWithID:[item objectID]]];
    }
}

- (void)deleteRegularTasks {
    NSArray *items = [self selectRegularTasks];
    for (NSManagedObject *item in items) {
        [context deleteObject:[context objectWithID:[item objectID]]];
    }
}

- (void)deleteOnControlTasks {
    NSArray *items = [self selectOnControlTasks];
    for (NSManagedObject *item in items) {
        [context deleteObject:[context objectWithID:[item objectID]]];
    }
}


- (void)deleteTasksForRemoval {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"systemSyncStatus = %@", constSyncStatusToDelete];
    NSArray *items = [context executeFetchRequestWithPredicate:predicate andEntityName:constTaskEntity andSortDescriptors:nil];
    for (Task *task in items) {
        [context deleteObject:[context objectWithID:[task objectID]]];
    }
}

- (void)depreciateWorkingRegularTasks {	
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"systemSyncStatus = %@ AND type = %@", 
                                                            constSyncStatusWorking,
                                                            [NSNumber numberWithInt:ORDTaskTypeRegular]];
    NSArray *items = [context executeFetchRequestWithPredicate:predicate andEntityName:constTaskEntity andSortDescriptors:nil];
	for (Task *item in items) {
		item.systemSyncStatus = constSyncStatusToDelete;
	}		
}

- (void)depreciateWorkingOnControlTasks {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"systemSyncStatus = %@ AND type = %@", 
                              constSyncStatusWorking,
                              [NSNumber numberWithInt:ORDTaskTypeOnControl]];
    NSArray *items = [context executeFetchRequestWithPredicate:predicate andEntityName:constTaskEntity andSortDescriptors:nil];
	for (Task *item in items) {
		item.systemSyncStatus = constSyncStatusToDelete;
	}		
}

- (void)setActionProcessedWithStatus:(NSString *)status forTaskWithId:(NSString *)taskId {	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id = %@", taskId];
    NSArray *items = [context executeFetchRequestWithPredicate:predicate andEntityName:constTaskEntity andSortDescriptors:nil];
	
	if ([items count] == 1) {
        Task *item = (Task *)[items objectAtIndex:0];
        item.systemUpdateDate = [NSDate date];
        item.systemActionResultText = status;
        item.systemActionIsProcessed = [NSNumber numberWithBool:YES];
        for(NSManagedObject *action in item.actions) {
            [context deleteObject:[context objectWithID:[action objectID]]];
        }
	}		
}


#pragma mark task actions
- (TaskAction *)createTaskAction {	
	return (TaskAction *)[NSEntityDescription insertNewObjectForEntityForName:constTaskActionEntity inManagedObjectContext:context];
}

- (void)createActionsFromTemplatesForTaskWithId:(NSString *)taskId {
    Task *task = [self selectTaskById:taskId];
    if (task != nil) {
        for (DashboardItem *dashboardItem in task.dashboardItems) {
            for (TaskActionTemplate *template in dashboardItem.actionTemplates) {
                TaskAction *action = [self createTaskAction];
                action.id = template.id;
                action.name = template.name;
                action.buttonColor = template.buttonColor;
                action.type = template.type;
                action.isFinal = template.isFinal;
                action.resultText = template.resultText;
                action.systemSortIndex = template.systemSortIndex;
                action.task = task;
            }
        }
    }
}

- (NSArray *)selectTaskActionsforTaskWithId:(NSString *)taskId {
    NSSortDescriptor *sortByIndexId = [NSSortDescriptor sortDescriptorWithKey:@"systemSortIndex" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortByIndexId, nil];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"task.id = %@", taskId];
    NSArray *items = 
        [context executeFetchRequestWithPredicate:predicate andEntityName:constTaskActionEntity andSortDescriptors:sortDescriptors];
    [sortDescriptors release];
    return items;	
}

- (void)deleteTaskActionsForTaskWithId:(NSString *)taskId {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"task.id = %@", taskId];    
    NSArray *items = [context executeFetchRequestWithPredicate:predicate andEntityName:constTaskActionEntity andSortDescriptors:nil];
    for (NSManagedObject *item in items) {
        [context deleteObject:[context objectWithID:[item objectID]]];
    }
}

- (BOOL)isTasksExistsWithType:(ORDTaskType)type {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type = %@", [NSNumber numberWithInt:type]]; 
    BOOL result = [context executeCountRequestWithPredicate:predicate andEntityName:constTaskEntity] > 0;
    return result;
}


#pragma task as read methods

- (TaskAsRead *)createTaskAsRead {
	return (TaskAsRead *)[NSEntityDescription insertNewObjectForEntityForName:constTaskAsReadEntity inManagedObjectContext:context];    
}

- (void)deleteTaskAsReadWithId:(NSString *)taskId {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"taskId = %@", taskId];
    NSArray *items = [context executeFetchRequestWithPredicate:predicate andEntityName:constTaskAsReadEntity andSortDescriptors:nil];
    for (TaskAsRead *item in items) {
        [context deleteObject:[context objectWithID:[item objectID]]];
    }
    
}

- (NSArray *)selectAllTasksAsRead {
    NSArray *items = [context executeFetchRequestWithPredicate:nil andEntityName:constTaskAsReadEntity andSortDescriptors:nil];
    return items;    
}

- (void)deleteAllTasksAsRead {
    NSArray *items = [context executeFetchRequestWithPredicate:nil andEntityName:constTaskAsReadEntity andSortDescriptors:nil];
    for (NSManagedObject *item in items) {
        [context deleteObject:[context objectWithID:[item objectID]]];
    }
}


#pragma mark misc methods
- (void)dealloc {
	[super dealloc];
}
@end
