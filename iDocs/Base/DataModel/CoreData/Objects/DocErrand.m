//
//  DocErrand.m
//  iDoc
//
//  Created by Likhachev Dmitry on 2/17/12.
//  Copyright (c) 2012 KORUS Consulting. All rights reserved.
//

#import "DocErrand.h"
#import "Doc.h"
#import "DocErrandAction.h"
#import "DocErrandExecutor.h"


@implementation DocErrand

@dynamic id;
@dynamic authorId;
@dynamic parentId;
@dynamic systemSortIndex;
@dynamic dueDate;
@dynamic authorName;
@dynamic systemActionToSyncId;
@dynamic number;
@dynamic report;
@dynamic text;
@dynamic status;
@dynamic executors;
@dynamic errandActions;
@dynamic doc;

- (void)addExecutorsObject:(DocErrandExecutor *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"executors" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"executors"] addObject:value];
    [self didChangeValueForKey:@"executors" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];    
}

- (void)removeExecutorsObject:(DocErrandExecutor *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"executors" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"executors"] removeObject:value];
    [self didChangeValueForKey:@"executors" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];    
}

- (void)addExecutors:(NSSet *)values {
    [self willChangeValueForKey:@"executors" withSetMutation:NSKeyValueUnionSetMutation usingObjects:values];
    [[self primitiveValueForKey:@"executors"] unionSet:values];
    [self didChangeValueForKey:@"executors" withSetMutation:NSKeyValueUnionSetMutation usingObjects:values];    
}

- (void)removeExecutors:(NSSet *)values {
    [self willChangeValueForKey:@"executors" withSetMutation:NSKeyValueMinusSetMutation usingObjects:values];
    [[self primitiveValueForKey:@"executors"] minusSet:values];
    [self didChangeValueForKey:@"executors" withSetMutation:NSKeyValueMinusSetMutation usingObjects:values];    
}


- (void)addActionsObject:(DocErrandAction *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"errandActions" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"errandActions"] addObject:value];
    [self didChangeValueForKey:@"errandActions" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];    
}

- (void)removeActionsObject:(DocErrandAction *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"errandActions" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"errandActions"] removeObject:value];
    [self didChangeValueForKey:@"errandActions" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];    
}

- (void)addActions:(NSSet *)values {
    [self willChangeValueForKey:@"errandActions" withSetMutation:NSKeyValueUnionSetMutation usingObjects:values];
    [[self primitiveValueForKey:@"errandActions"] unionSet:values];
    [self didChangeValueForKey:@"errandActions" withSetMutation:NSKeyValueUnionSetMutation usingObjects:values];    
}

- (void)removeActions:(NSSet *)values {
    [self willChangeValueForKey:@"errandActions" withSetMutation:NSKeyValueMinusSetMutation usingObjects:values];
    [[self primitiveValueForKey:@"errandActions"] minusSet:values];
    [self didChangeValueForKey:@"errandActions" withSetMutation:NSKeyValueMinusSetMutation usingObjects:values];    
}
@end
