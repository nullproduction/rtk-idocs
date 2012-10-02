//
//  ActionToSyncDataEntity.m
//  iDoc
//
//  Created by rednekis on 5/8/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import "ActionToSyncDataEntity.h"
#import "Constants.h"
#import "NSManagedObjectContext+CustomFetch.h"
#import "NSManagedObject+Clone.h"

#define constActionToSyncEntity @"ActionToSync"

@implementation ActionToSyncDataEntity

- (id)initWithContext:(NSManagedObjectContext *)newContext {
	if ((self = [super init])) {
		context = newContext;
	}
	return self;
}

- (ActionToSync *)createActionToSync {	
	return (ActionToSync *)[NSEntityDescription insertNewObjectForEntityForName:constActionToSyncEntity inManagedObjectContext:context];
}

- (ActionToSync *)selectActionToSyncById:(NSString *)actionToSyncId {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id = %@", actionToSyncId];
    NSArray *items = [context executeFetchRequestWithPredicate:predicate andEntityName:constActionToSyncEntity andSortDescriptors:nil];
	return ([items count] == 1) ? (ActionToSync *)[items objectAtIndex:0] : nil;
}

- (ActionToSync *)selectActionToSyncById:(NSString *)actionToSyncId andRequestType:(int)requestType {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id = %@ AND requestType = %i", actionToSyncId, requestType];
    NSArray *items = [context executeFetchRequestWithPredicate:predicate andEntityName:constActionToSyncEntity andSortDescriptors:nil];
	return ([items count] == 1) ? (ActionToSync *)[items objectAtIndex:0] : nil;
}

- (NSArray *)selectActionsToSync {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"systemSyncStatus != %@ OR systemSyncStatus == nil", constSyncStatusInSync];
    NSSortDescriptor *sortByActionDate = [NSSortDescriptor sortDescriptorWithKey:@"actionDate" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortByActionDate, nil];
    NSArray *items = 
        [context executeFetchRequestWithPredicate:predicate andEntityName:constActionToSyncEntity andSortDescriptors:sortDescriptors];
    [sortDescriptors release];
	return items;
}

- (void)setSyncStatus:(NSString *)syncStatus forActionToSyncWithId:(NSString *)actionToSyncId {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id = %@", actionToSyncId];
    NSArray *items = [context executeFetchRequestWithPredicate:predicate andEntityName:constActionToSyncEntity andSortDescriptors:nil];
	if([items count] == 1) {
		ActionToSync *item = (ActionToSync *)[items objectAtIndex:0];
		item.systemSyncStatus = syncStatus;
	}    
}

- (NSString *)removeErrandExecutorId:(NSString *)executorId fromActionToSyncWithId:(NSString *)actionToSyncId {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id = %@", actionToSyncId];
    NSArray *items = [context executeFetchRequestWithPredicate:predicate andEntityName:constActionToSyncEntity andSortDescriptors:nil];
    ActionToSync *item = (ActionToSync *)[items objectAtIndex:0];

    BOOL needReplaceOfMajorExecutor = NO;
    NSString *majorExecutorId = item.systemErrandMajorExecutorId;

    NSString *newExecutorIdString = constEmptyStringValue;
    NSArray *itemExecutorIds = [item.errandExecutorId componentsSeparatedByString:constSeparatorSymbol];
    for (int i = 0; i < [itemExecutorIds count]; i++) {
        NSString *itemExecutorId = [itemExecutorIds objectAtIndex:i];
        
        if (i == 0 && [itemExecutorId isEqualToString:executorId]) {
            needReplaceOfMajorExecutor = YES;
        }
        else if (i == 1 && needReplaceOfMajorExecutor == YES) {
            item.systemErrandMajorExecutorId = itemExecutorId;
            majorExecutorId = itemExecutorId;
            needReplaceOfMajorExecutor = NO;
        }
        
        if (![itemExecutorId isEqualToString:executorId]) {
            if (i == 0)
                newExecutorIdString = itemExecutorId;
            else
                newExecutorIdString = [NSString stringWithFormat:@"%@%@%@", newExecutorIdString, constSeparatorSymbol, itemExecutorId];
        }
    }
    if ([newExecutorIdString length] > 0) {
        item.errandExecutorId = newExecutorIdString;
    }
    else {
        [context deleteObject:item];
        majorExecutorId = nil;
    }
    
    return majorExecutorId;
}

- (void)deleteActionToSyncWithId:(NSString *)actionToSyncId {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id = %@", actionToSyncId];
    NSArray *items = [context executeFetchRequestWithPredicate:predicate andEntityName:constActionToSyncEntity andSortDescriptors:nil];
	if ([items count] == 1) {
        ActionToSync *item = (ActionToSync *)[items objectAtIndex:0];
        [context deleteObject:item];
	}    
}

- (void)deleteActionToSync:(ActionToSync *)action {	
	[context deleteObject:[context objectWithID:[action objectID]]];	
}

- (void)deleteAllActionsToSync {
    NSArray *items = [context executeFetchRequestWithPredicate:nil andEntityName:constActionToSyncEntity andSortDescriptors:nil];
    for (NSManagedObject *item in items) {
        [context deleteObject:[context objectWithID:[item objectID]]];
    }
}

- (ActionToSync *)cloneActionToSync:(ActionToSync *)action excludingRelations:(NSArray *)excludedRelations {
    return (ActionToSync *)[action cloneInContext:context excludeEntities:excludedRelations];
}


#pragma mark misc methods
- (void)dealloc {
	[super dealloc];
}
@end
