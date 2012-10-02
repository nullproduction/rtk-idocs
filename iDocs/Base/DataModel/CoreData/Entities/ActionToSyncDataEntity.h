//
//  ActionToSyncDataEntity.h
//  iDoc
//
//  Created by rednekis on 5/8/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ActionToSync.h"

@interface ActionToSyncDataEntity : NSObject {
	NSManagedObjectContext *context;     
}

- (id)initWithContext:(NSManagedObjectContext *)newContext;

- (ActionToSync *)createActionToSync;
- (ActionToSync *)selectActionToSyncById:(NSString *)actionToSyncId;
- (ActionToSync *)selectActionToSyncById:(NSString *)actionToSyncId andRequestType:(int)requestType;
- (NSArray *)selectActionsToSync;
- (void)setSyncStatus:(NSString *)syncStatus forActionToSyncWithId:(NSString *)actionToSyncId;
- (void)deleteActionToSync:(ActionToSync *)action;
- (void)deleteActionToSyncWithId:(NSString *)actionToSyncId;
- (void)deleteAllActionsToSync;
- (NSString *)removeErrandExecutorId:(NSString *)executorId fromActionToSyncWithId:(NSString *)actionToSyncId;
- (ActionToSync *)cloneActionToSync:(ActionToSync *)action excludingRelations:(NSArray *)excludedRelations;
@end
