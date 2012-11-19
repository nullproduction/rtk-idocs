//
//  SyncController.h
//  iDoc
//
//  Created by mark2 on 1/26/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import "Constants.h"
#import "BaseLoaderDelegate.h"
#import "ClientSettingsSyncManager.h"
#import "ORDSyncManager.h"
#import "WebDavSyncManager.h"
#import "DataSyncEventHandler.h"

@protocol SyncDelegate <NSObject>
@optional
- (void)syncStarted;
- (void)syncFinishedWithErrors:(NSArray *)errors andWarnings:(NSArray *)warnings;
@end

@interface SyncController : NSObject <BaseLoaderDelegate, BaseSyncManagerDelegate> { 
	id<SyncDelegate> delegate;
    DataSyncModule restartSyncModule;
    DataSyncEventHandler *eventHandler;
    BOOL abortSyncRequested; // флаг поднимается, если дальнейшее выполнение не целесообразно (например, loginFailed)
    int currentStep;
} 

- (id)initWithDelegate:(id<SyncDelegate>)newDelegate;

- (void)syncWithModule:(DataSyncModule)syncModule;
- (void)abortSync;
- (BOOL)isAbortSyncRequested;

- (void)submitActions;
- (void)submitTaskAsRead;

+ (SyncStatus) status;
+ (void)setStatus:(SyncStatus) status;   
+ (int)lastCompletedStep;
+ (void)resetLastCompletedStep;
+ (void)saveSuspendDate;
+ (BOOL)isSuspendExpired;
- (void)incrementCurrentStep;
- (int)currentStep;

@end;
