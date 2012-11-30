//
//  SyncController.m
//  iDoc
//
//  Created by mark2 on 1/26/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import "SyncController.h"
#import "UserDefaults.h"
#import "SupportFunctions.h"
#import "ServerOperationQueueEntity.h"
#import "DataSyncEventHandler.h"
#import "CoreDataProxy.h"

@interface SyncController(PrivateMethods)
- (void)initializeSyncProcessMonitoringObjects;
@end

@implementation SyncController

- (id)initWithDelegate:(id<SyncDelegate>)newDelegate {
	if ((self = [super init])) {
        delegate = newDelegate;
        abortSyncRequested = NO;
        eventHandler = [[DataSyncEventHandler alloc] init];
	}
        
	return self;
}

#pragma mark sync mechanism
- (void)submitActions {
    NSAutoreleasePool *syncPool = [[NSAutoreleasePool alloc] init];
    
    ORDSyncManager *ordSyncManager = [[ORDSyncManager alloc] initWithSyncDelegate:self];
    ServerOperationQueueEntity *syncQueueEntity = [[ServerOperationQueueEntity alloc] initWithContext:[[CoreDataProxy sharedProxy] workContext]];  
    [syncQueueEntity deleteAll];

    if ([UserDefaults useORDServer] == YES  && [UserDefaults useTestData] == NO) {
        [ordSyncManager prepareLaunchActions];
        [ordSyncManager launchSyncActionsWithDelegate:self];
    }
    
    [ordSyncManager release];
    [syncQueueEntity release];
    
    [syncPool release];
}

- (void)submitTaskAsRead {
    NSLog(@"SyncController submitTaskAsRead");
    NSAutoreleasePool *syncPool = [[NSAutoreleasePool alloc] init];
    
    ORDSyncManager *ordSyncManager = [[ORDSyncManager alloc] initWithSyncDelegate:self];
    ServerOperationQueueEntity *syncQueueEntity = [[ServerOperationQueueEntity alloc] initWithContext:[[CoreDataProxy sharedProxy] workContext]];
    [syncQueueEntity deleteAll];
    
    if ([UserDefaults useORDServer] == YES  && [UserDefaults useTestData] == NO) {
        [ordSyncManager prepareLaunchTaskRead];
        [ordSyncManager launchSyncTaskAsReadWithDelegate:self];
    }
    
    [ordSyncManager release];
    [syncQueueEntity release];
    
    [syncPool release];
}

- (void)actionsSubmitFinished {
    ServerOperationQueueEntity *syncQueueEntity = [[ServerOperationQueueEntity alloc] initWithContext:[[CoreDataProxy sharedProxy] workContext]];  

    NSPredicate *predicate = nil;
    predicate = [NSPredicate predicateWithFormat:@"%K = %@", @"statusCode", [NSNumber numberWithInt:DSEventStatusError]];
    NSArray *syncErrors = [syncQueueEntity getListForPredicate:predicate];
    
    predicate = [NSPredicate predicateWithFormat:@"%K = %@", @"statusCode", [NSNumber numberWithInt:DSEventStatusWarning]];
    NSArray *syncWarnings = [syncQueueEntity getListForPredicate:predicate];
    
    [syncQueueEntity release];
    
    if (delegate != nil && [delegate respondsToSelector:@selector(syncFinishedWithErrors:andWarnings:)]) {
        [delegate syncFinishedWithErrors:syncErrors andWarnings:syncWarnings];
    }    
}

- (void)syncWithModule:(DataSyncModule)syncModule { 
    restartSyncModule = syncModule;
    currentStep = 0;
    abortSyncRequested = NO;
    
    NSAutoreleasePool *syncPool = [[NSAutoreleasePool alloc] init];
    ClientSettingsSyncManager *clientSettingsSyncManager = [[ClientSettingsSyncManager alloc] initWithSyncDelegate:self];
    ORDSyncManager *ordSyncManager = [[ORDSyncManager alloc] initWithSyncDelegate:self];
    WebDavSyncManager *webDavSyncManager = [[WebDavSyncManager alloc] initWithSyncDelegate:self];    
    ServerOperationQueueEntity *syncQueueEntity = 
        [[ServerOperationQueueEntity alloc] initWithContext:[[CoreDataProxy sharedProxy] workContext]];  
    [syncQueueEntity deleteAll];
    if (syncModule == DSModuleClientSettings) {
        [clientSettingsSyncManager prepareLaunch];
        if (([UserDefaults useORDServer] == YES || [UserDefaults useTestData] == YES)) {
            [ordSyncManager prepareLaunch];
        }
        if ([UserDefaults useWebDavServer] == YES) {
            [webDavSyncManager prepareLaunch];
        }
        if (delegate != nil && [delegate respondsToSelector:@selector(syncStarted)]) {
            [delegate syncStarted];
        }
                
        [clientSettingsSyncManager launchSync];
        if ([UserDefaults useORDServer] == YES || [UserDefaults useTestData] == YES) {
            [ordSyncManager launchSync];
        }
        if ([UserDefaults useWebDavServer] == YES) {
            [webDavSyncManager launchSync];
        }
    }
    else if (syncModule == DSModuleORDServer) {
        if (([UserDefaults useORDServer] == YES || [UserDefaults useTestData] == YES)) {
            [ordSyncManager prepareLaunch];
        }
        if ([UserDefaults useWebDavServer] == YES) {
            [webDavSyncManager prepareLaunch];
        }
        if (delegate != nil && [delegate respondsToSelector:@selector(syncStarted)]) {
            [delegate syncStarted];
        }
        
        if ([UserDefaults useORDServer] == YES || [UserDefaults useTestData] == YES) {
            [ordSyncManager launchSync];
        }
        if ([UserDefaults useWebDavServer] == YES) {
            [webDavSyncManager launchSync];
        }
    }
    else if (syncModule == DSModuleWebDavServer) {
        if ([UserDefaults useWebDavServer] == YES) {
            [webDavSyncManager prepareLaunch];
        }
        if (delegate != nil && [delegate respondsToSelector:@selector(syncStarted)]) {
            [delegate syncStarted];
        }
        
        if ([UserDefaults useWebDavServer] == YES) {
            [webDavSyncManager launchSync];
        }
    }
    
    [clientSettingsSyncManager release];
    [ordSyncManager release];
    [webDavSyncManager release];
    [syncPool release];
    
    NSPredicate *predicate = nil;
    predicate = [NSPredicate predicateWithFormat:@"%K = %@", @"statusCode", [NSNumber numberWithInt:DSEventStatusError]];
    NSArray *syncErrors = [syncQueueEntity getListForPredicate:predicate];
    
    predicate = [NSPredicate predicateWithFormat:@"%K = %@", @"statusCode", [NSNumber numberWithInt:DSEventStatusWarning]];
    NSArray *syncWarnings = [syncQueueEntity getListForPredicate:predicate];
    
    [syncQueueEntity release];
    
    if ([UserDefaults intSettingByKey:constSyncStatus] == SyncStatusAbortedInBackground)
        [UserDefaults saveValue:[NSNumber numberWithInt:currentStep] forSetting:constLastSyncCompletedStep];
    else
        [SyncController resetLastCompletedStep];
    
    if (delegate != nil && [delegate respondsToSelector:@selector(syncFinishedWithErrors:andWarnings:)]) {
        [delegate syncFinishedWithErrors:syncErrors andWarnings:syncWarnings];
    }
}

#pragma mark BaseSyncManagerDelegate:
- (void)abortSync {
    abortSyncRequested = YES;
}

- (BOOL)isAbortSyncRequested {
    return abortSyncRequested;
}

+ (SyncStatus)status {
    return [UserDefaults intSettingByKey:constSyncStatus];
}

+ (void)setStatus:(SyncStatus) status {
    [UserDefaults saveValue:[NSNumber numberWithInt:status] forSetting:constSyncStatus];
}   

+ (int)lastCompletedStep {
    return [UserDefaults intSettingByKey:constLastSyncCompletedStep];

}

+ (void)resetLastCompletedStep {
    [UserDefaults saveValue:[NSNumber numberWithInt:0] forSetting:constLastSyncCompletedStep];
}

+ (void)saveSuspendDate {
    NSString *date = [SupportFunctions convertDateToString:[NSDate date] withFormat:constDateTimeSecondsFormat];
    [UserDefaults saveValue:date forSetting:constSyncSuspendDate];
}

+ (BOOL)isSuspendExpired {
    BOOL isSuspendExpired = NO;
    NSDate *date = [SupportFunctions convertStringToDate:[UserDefaults stringSettingByKey:constSyncSuspendDate] withFormat:constDateTimeSecondsFormat];
    int diffInSeconds = abs([[NSNumber numberWithDouble:[date timeIntervalSinceNow]] intValue]);
    isSuspendExpired = (diffInSeconds - constExpirationInterval > 0) ? YES : NO;
    return isSuspendExpired;
}

- (void)incrementCurrentStep {
    currentStep ++;
}

- (int)currentStep {
    return currentStep;
}

- (void)dealloc {
    [eventHandler release];
    
    [super dealloc];
}


@end
