//
//  ClientSettingsDataEntity.m
//  iDoc
//
//  Created by rednekis on 10-12-20.
//  Copyright 2010 KORUS Consulting. All rights reserved.
//

#import "ClientSettingsDataEntity.h"
#import "NSManagedObjectContext+CustomFetch.h"
#import "SupportFunctions.h"
#import "Constants.h"
#import "Task.h"

#define constGroupIdAllTasks @"all_tasks"
#define constGroupNameAllTasks NSLocalizedString(@"AllTasksTitle", nil)
#define constDashboardEntity @"Dashboard"
#define constDashboardItemEntity @"DashboardItem"
#define constGeneralSettingsEntity @"GeneralSetting"

@interface ClientSettingsDataEntity(PrivateMethods)
- (void)updateItemsCountInTaskDashboardItem:(DashboardItem *)item;
@end

@implementation ClientSettingsDataEntity

+ (NSString *)allTasksGroupId {
	return constGroupIdAllTasks;
}

+ (NSString *)allTasksGroupName {
	return constGroupNameAllTasks;
}


- (id)initWithContext:(NSManagedObjectContext *)newContext {
	if ((self = [super init])) {
		context = newContext;
	}
	return self;
}


#pragma mark dashboard
- (Dashboard *)createDashboard {	
	return (Dashboard *)[NSEntityDescription insertNewObjectForEntityForName:constDashboardEntity inManagedObjectContext:context];
}

- (NSArray *)selectAllDashboards {
    NSArray *items = [context executeFetchRequestWithPredicate:nil 
                                                 andEntityName:constDashboardEntity 
                                            andSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"id" ascending:YES]]];
    return items;
}

- (void)deleteAllDashboards {
    NSArray *items = [context executeFetchRequestWithPredicate:nil andEntityName:constDashboardEntity andSortDescriptors:nil];
    for (Dashboard *item in items) {
        [context deleteObject:[context objectWithID:[item objectID]]];
    }
}


#pragma mark dashboard item
- (DashboardItem *)createDashboardItem {	
	return (DashboardItem *)[NSEntityDescription insertNewObjectForEntityForName:constDashboardItemEntity inManagedObjectContext:context];    
}

- (NSArray *)selectDashboardItemsForBlock:(NSString *)block {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"block = %@", block];
    return [context executeFetchRequestWithPredicate:predicate andEntityName:constDashboardItemEntity andSortDescriptors:nil];
}

- (DashboardItem *)selectDashboardItemById:(NSString *)itemId {	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id = %@", itemId];
    NSArray *items = [context executeFetchRequestWithPredicate:predicate andEntityName:constDashboardItemEntity andSortDescriptors:nil];
	return ([items count] == 1) ? (DashboardItem *)[items objectAtIndex:0] : nil;	
}

- (NSArray *)parentDashboardItemsForDashboardWithId:(int)dashboardId {
    NSSortDescriptor *sortByIndex = [NSSortDescriptor sortDescriptorWithKey:@"systemSortIndex" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortByIndex, nil];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"parentId = nil AND dashboard.id = %i", dashboardId];
    NSArray *items = 
        [context executeFetchRequestWithPredicate:predicate andEntityName:constDashboardItemEntity andSortDescriptors:sortDescriptors];
    [sortDescriptors release];
    return items;
}

- (NSArray *)childsInDashboardItemWithId:(NSString *)itemId {    
    NSSortDescriptor *sortByIndex = [NSSortDescriptor sortDescriptorWithKey:@"systemSortIndex" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortByIndex, nil];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"parentId = %@", itemId];
    NSArray *items = 
        [context executeFetchRequestWithPredicate:predicate andEntityName:constDashboardItemEntity andSortDescriptors:sortDescriptors];
    [sortDescriptors release];
    return items;    
}

- (NSArray *)selectAllDashboardItems {
    NSArray *items = [context executeFetchRequestWithPredicate:nil andEntityName:constDashboardItemEntity andSortDescriptors:nil];
    return items;
}

- (NSArray *)selectDistinctTaskBlocks {
    return [context distinctValuesForField:@"block" 
                            withEntityName:constDashboardItemEntity 
                             withPredicate:[NSPredicate predicateWithFormat:@"block != nil AND block != ''"]];
}

- (NSArray *)selectAllWebDavDashboardItems {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type = %@", constWidgetTypeWebDavFolder];
    NSArray *items = 
        [context executeFetchRequestWithPredicate:predicate andEntityName:constDashboardItemEntity andSortDescriptors:nil];
    return items;
}

- (void)deleteAllDashboardItems {
    NSArray *items = [context executeFetchRequestWithPredicate:nil andEntityName:constDashboardItemEntity andSortDescriptors:nil];
    for (NSManagedObject *item in items) {
        [context deleteObject:[context objectWithID:[item objectID]]];
    }
}

- (void)updateItemsCountInAllTaskDashboardItems {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type = %@", constWidgetTypeORDGroup];
    NSArray *items = 
        [context executeFetchRequestWithPredicate:predicate andEntityName:constDashboardItemEntity andSortDescriptors:nil];
    
    for (DashboardItem *item in items) {
        [self updateItemsCountInTaskDashboardItem:item];
    }
}

- (void)updateItemsCountInTaskDashboardItem:(DashboardItem *)item {
    if ([item.type isEqualToString:constWidgetTypeORDGroup] || [item.type isEqualToString:constWidgetTypeWebDavFolder]) {
        item.countTotal = [NSNumber numberWithInt:0];
        item.countNew = [NSNumber numberWithInt:0];
        item.countOverdue = [NSNumber numberWithInt:0];
        NSSet *tasks = item.tasks;
        for (Task *task in tasks) {  
            item.countTotal = [NSNumber numberWithInt:([item.countTotal intValue] + 1)];
            if (![task.isViewed boolValue]) 
                item.countNew = [NSNumber numberWithInt:([item.countNew intValue] + 1)];
            if(task.dueDate != nil && [SupportFunctions date:task.dueDate lessThanDate:[SupportFunctions currentDate]]) {
                item.countOverdue = [NSNumber numberWithInt:([item.countOverdue intValue] + 1)]; 
            }
        }
    }
}

#pragma mark general seetings
- (GeneralSetting *)createGeneralSetting {
    return (GeneralSetting *)[NSEntityDescription insertNewObjectForEntityForName:constGeneralSettingsEntity inManagedObjectContext:context];
}
- (void)deleteAllGeneralSettings {
    NSArray *items = [context executeFetchRequestWithPredicate:nil andEntityName:constGeneralSettingsEntity andSortDescriptors:nil];
    for (NSManagedObject *item in items) {
        [context deleteObject:[context objectWithID:[item objectID]]];
    }    
}

- (NSString *)logoIcon {
#ifdef HIDE_LOGO
    return nil;
#else
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@", @"logoIcon"];
    NSArray *items = [context executeFetchRequestWithPredicate:predicate andEntityName:constGeneralSettingsEntity andSortDescriptors:nil];  
    return ([items count] == 1) ? ((GeneralSetting *)[items objectAtIndex:0]).value : nil;
#endif
}

- (NSString *)logoIconWithName {
#ifdef HIDE_LOGO
    return nil;
#else
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@", @"logoIconWithName"];
    NSArray *items = [context executeFetchRequestWithPredicate:predicate andEntityName:constGeneralSettingsEntity andSortDescriptors:nil];  
    return ([items count] == 1) ? ((GeneralSetting *)[items objectAtIndex:0]).value : nil;  
#endif
}

- (BOOL)showMajorExecutorErrandSign {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@", @"showMajorExecutorErrandSign"];
    NSArray *items = [context executeFetchRequestWithPredicate:predicate andEntityName:constGeneralSettingsEntity andSortDescriptors:nil];  
    return ([items count] == 1) ? [((GeneralSetting *)[items objectAtIndex:0]).value boolValue] : NO;     
}

- (void)dealloc {
	[super dealloc];
}

@end
