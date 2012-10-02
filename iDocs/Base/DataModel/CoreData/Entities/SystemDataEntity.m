//
//  SystemDataEntity.m
//  iDoc
//
//  Created by rednekis on 5/8/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import "SystemDataEntity.h"
#import "NSManagedObjectContext+CustomFetch.h"

#define constUserInfoEntity @"UserInfo"

@implementation SystemDataEntity

- (id)initWithContext:(NSManagedObjectContext *)newContext {
	if ((self = [super init])) {
		context = newContext;
	}
	return self;
}

#pragma mark task groups
- (UserInfo *)userInfo {
    UserInfo *userInfo = nil;
    NSArray *items = [context executeFetchRequestWithPredicate:nil andEntityName:constUserInfoEntity andSortDescriptors:nil];
    if ([items count] == 0) {
        userInfo = [NSEntityDescription insertNewObjectForEntityForName:constUserInfoEntity inManagedObjectContext:context];
    }
    else {
        userInfo = (UserInfo *)[items objectAtIndex:0];
    }
	return userInfo;	
}

- (void)deleteUserInfo {
    NSArray *items = [context executeFetchRequestWithPredicate:nil andEntityName:constUserInfoEntity andSortDescriptors:nil];
    for (NSManagedObject *item in items) {
        [context deleteObject:[context objectWithID:[item objectID]]];
    }
}

#pragma mark misc methods
- (void)dealloc {
	[super dealloc];
}
@end
