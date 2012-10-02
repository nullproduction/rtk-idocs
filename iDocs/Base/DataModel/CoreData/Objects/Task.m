//
//  Task.m
//  iDoc
//
//  Created by rednekis on 5/28/11.
//  Copyright (c) 2011 KORUS Consulting. All rights reserved.
//

#import "Task.h"
#import "DashboardItem.h"
#import "Doc.h"
#import "TaskAction.h"


@implementation Task
@dynamic name;
@dynamic dueDate;
@dynamic id;
@dynamic type;
@dynamic isViewed;
@dynamic doc;
@dynamic dashboardItems;
@dynamic actions;
@dynamic systemCurrentErrandId;
@dynamic systemActionResultText;
@dynamic systemActionIsProcessed;
@dynamic systemSyncStatus;
@dynamic systemUpdateDate;
@dynamic systemHasDueDate;

- (void)addDashboardItemsObject:(DashboardItem *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"dashboardItems" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"dashboardItems"] addObject:value];
    [self didChangeValueForKey:@"dashboardItems" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeDashboardItemsObject:(DashboardItem *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"dashboardItems" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"dashboardItems"] removeObject:value];
    [self didChangeValueForKey:@"dashboardItems" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addDashboardItems:(NSSet *)value {    
    [self willChangeValueForKey:@"dashboardItems" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"dashboardItems"] unionSet:value];
    [self didChangeValueForKey:@"dashboardItems" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeDashboardItems:(NSSet *)value {
    [self willChangeValueForKey:@"dashboardItems" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"dashboardItems"] minusSet:value];
    [self didChangeValueForKey:@"dashboardItems" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


- (void)addActionsObject:(TaskAction *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"actions" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"actions"] addObject:value];
    [self didChangeValueForKey:@"actions" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeActionsObject:(TaskAction *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"actions" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"actions"] removeObject:value];
    [self didChangeValueForKey:@"actions" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addActions:(NSSet *)value {    
    [self willChangeValueForKey:@"actions" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"actions"] unionSet:value];
    [self didChangeValueForKey:@"actions" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeActions:(NSSet *)value {
    [self willChangeValueForKey:@"actions" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"actions"] minusSet:value];
    [self didChangeValueForKey:@"actions" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


@end
