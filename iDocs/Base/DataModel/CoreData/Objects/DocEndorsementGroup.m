//
//  DocEndorsementGroup.m
//  iDoc
//
//  Created by rednekis on 5/11/11.
//  Copyright (c) 2011 KORUS Consulting. All rights reserved.
//

#import "DocEndorsementGroup.h"
#import "Doc.h"
#import "DocEndorsement.h"


@implementation DocEndorsementGroup
@dynamic id;
@dynamic name;
@dynamic systemSortIndex;
@dynamic doc;
@dynamic endorsements;


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


@end
