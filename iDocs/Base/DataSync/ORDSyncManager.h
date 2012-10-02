//
//  ORDSyncManager.h
//  iDoc
//
//  Created by mark2 on 7/11/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseSyncManager.h"

@interface ORDSyncManager : BaseSyncManager {}

- (id)initForCleanupWithContext:(NSManagedObjectContext *)newContext;

- (void)prepareLaunchActions;
- (void)launchSyncActionsWithDelegate:(NSObject<BaseLoaderDelegate> *)newDelegate;

- (void)cleanupSync;
- (void)cleanupORDDictionariesData;
- (void)cleanupORDUserData;
- (void)cleanupORDUserDataForRegularTasks;
- (void)cleanupORDUserDataForOnControlTasks;
- (void)cleanupORDDataForTaskWithId:(NSString *)taskId;
- (void)cleanupORDDataForDocWithId:(NSString *)docId;
- (void)cleanupORDDataForDocsWithIds:(NSArray *)docIds;

@end
