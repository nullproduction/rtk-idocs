//
//  Doc.m
//  iDoc
//
//  Created by rednekis on 5/11/11.
//  Copyright (c) 2011 KORUS Consulting. All rights reserved.
//

#import "Doc.h"
#import "DocAttachment.h"
#import "DocEndorsement.h"
#import "DocEndorsementGroup.h"
#import "DocErrand.h"
#import "DocRequisite.h"
#import "DocNotice.h"
#import "Task.h"


@implementation Doc
@dynamic regDate;
@dynamic id;
@dynamic ownerId;
@dynamic ownerName;
@dynamic regNumber;
@dynamic desc;
@dynamic systemSyncStatus;
@dynamic systemUpdateDate;
@dynamic typeName;
@dynamic endorsementGroups;
@dynamic errands;
@dynamic tasks;
@dynamic requisites;
@dynamic attachments;
@dynamic endorsements;
@dynamic notices;

- (void)addEndorsementGroupsObject:(DocEndorsementGroup *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"endorsementGroups" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"endorsementGroups"] addObject:value];
    [self didChangeValueForKey:@"endorsementGroups" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeEndorsementGroupsObject:(DocEndorsementGroup *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"endorsementGroups" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"endorsementGroups"] removeObject:value];
    [self didChangeValueForKey:@"endorsementGroups" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addEndorsementGroups:(NSSet *)value {    
    [self willChangeValueForKey:@"endorsementGroups" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"endorsementGroups"] unionSet:value];
    [self didChangeValueForKey:@"endorsementGroups" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeEndorsementGroups:(NSSet *)value {
    [self willChangeValueForKey:@"endorsementGroups" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"endorsementGroups"] minusSet:value];
    [self didChangeValueForKey:@"endorsementGroups" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


- (void)addErrandsObject:(DocErrand *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"errands" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"errands"] addObject:value];
    [self didChangeValueForKey:@"errands" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeErrandsObject:(DocErrand *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"errands" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"errands"] removeObject:value];
    [self didChangeValueForKey:@"errands" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addErrands:(NSSet *)value {    
    [self willChangeValueForKey:@"errands" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"errands"] unionSet:value];
    [self didChangeValueForKey:@"errands" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeErrands:(NSSet *)value {
    [self willChangeValueForKey:@"errands" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"errands"] minusSet:value];
    [self didChangeValueForKey:@"errands" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


- (void)addTasksObject:(Task *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"tasks" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"tasks"] addObject:value];
    [self didChangeValueForKey:@"tasks" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeTasksObject:(Task *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"tasks" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"tasks"] removeObject:value];
    [self didChangeValueForKey:@"tasks" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addTasks:(NSSet *)value {    
    [self willChangeValueForKey:@"tasks" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"tasks"] unionSet:value];
    [self didChangeValueForKey:@"tasks" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeTasks:(NSSet *)value {
    [self willChangeValueForKey:@"tasks" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"tasks"] minusSet:value];
    [self didChangeValueForKey:@"tasks" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


- (void)addRequisitesObject:(DocRequisite *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"requisites" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"requisites"] addObject:value];
    [self didChangeValueForKey:@"requisites" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeRequisitesObject:(DocRequisite *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"requisites" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"requisites"] removeObject:value];
    [self didChangeValueForKey:@"requisites" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addRequisites:(NSSet *)value {    
    [self willChangeValueForKey:@"requisites" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"requisites"] unionSet:value];
    [self didChangeValueForKey:@"requisites" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeRequisites:(NSSet *)value {
    [self willChangeValueForKey:@"requisites" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"requisites"] minusSet:value];
    [self didChangeValueForKey:@"requisites" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


- (void)addAttachmentsObject:(DocAttachment *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"attachments" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"attachments"] addObject:value];
    [self didChangeValueForKey:@"attachments" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeAttachmentsObject:(DocAttachment *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"attachments" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"attachments"] removeObject:value];
    [self didChangeValueForKey:@"attachments" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addAttachments:(NSSet *)value {    
    [self willChangeValueForKey:@"attachments" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"attachments"] unionSet:value];
    [self didChangeValueForKey:@"attachments" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeAttachments:(NSSet *)value {
    [self willChangeValueForKey:@"attachments" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"attachments"] minusSet:value];
    [self didChangeValueForKey:@"attachments" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


- (void)addEndorsementsObject:(DocEndorsement *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"endorsements" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"endorsements"] addObject:value];
    [self didChangeValueForKey:@"endorsements" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeEndorsementsObject:(DocEndorsement *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"endorsements" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"endorsements"] removeObject:value];
    [self didChangeValueForKey:@"endorsements" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addEndorsements:(NSSet *)value {    
    [self willChangeValueForKey:@"endorsements" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"endorsements"] unionSet:value];
    [self didChangeValueForKey:@"endorsements" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeEndorsements:(NSSet *)value {
    [self willChangeValueForKey:@"endorsements" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"endorsements"] minusSet:value];
    [self didChangeValueForKey:@"endorsements" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}

- (void)addNoticesObject:(DocNotice *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"notices" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"notices"] addObject:value];
    [self didChangeValueForKey:@"notices" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeNoticesObject:(DocNotice *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"notices" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"notices"] removeObject:value];
    [self didChangeValueForKey:@"notices" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addNotices:(NSSet *)value {    
    [self willChangeValueForKey:@"notices" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"notices"] unionSet:value];
    [self didChangeValueForKey:@"notices" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeNotices:(NSSet *)value {
    [self willChangeValueForKey:@"notices" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"notices"] minusSet:value];
    [self didChangeValueForKey:@"notices" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}

@end
