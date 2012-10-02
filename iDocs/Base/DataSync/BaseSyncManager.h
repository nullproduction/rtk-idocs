//
//  BaseSyncManager.h
//  iDoc
//
//  Created by mark2 on 7/11/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerOperationQueueEntity.h"
#import "Constants.h"
#import "SupportFunctions.h"
#import "BaseLoaderDelegate.h"

@protocol BaseSyncManagerDelegate <NSObject>
+ (SyncStatus) status;
+ (void)setStatus:(SyncStatus) status;   
+ (int)lastCompletedStep;
+ (void)resetLastCompletedStep;
+ (void)saveSuspendDate;
+ (BOOL)isSuspendExpired;
- (void)incrementCurrentStep;
- (int)currentStep;
- (void)abortSync;
@end

@interface BaseSyncManager : NSObject <BaseLoaderDelegate> {
    NSManagedObjectContext *syncContext;
    ServerOperationQueueEntity *syncQueueEntity;
    id<BaseSyncManagerDelegate,BaseLoaderDelegate> syncDelegate;
}

- (id)initWithSyncDelegate:(id<BaseSyncManagerDelegate, BaseLoaderDelegate>)newDelegate;

- (void)prepareLaunch;
- (void)cleanupSync;
- (void)launchSync;

- (void)syncFinished;

- (void)mergeChangesWithWorkingContext:(NSNotification *)notification;

//методы делегата переопределены в саб-классах. возможно в интерфейсе их не обязательно декларировать
- (void)abortSync;

@end
