//
//  iPadSyncViewController.m
//  iDoc
//
//  Created by Arthur Semenyutin on 8/22/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import "iPadSyncViewController.h"
#import "UserDefaults.h"
#import <QuartzCore/QuartzCore.h>

#define HFS_SYNC_CONTROLLER_VIEW_TAG 112233 // вью syncController должна удаляться при перезапуске синхронизации

@interface iPadServerOperationMonitorViewController(PrivateMethods)
- (void)removeSyncProcessMonitor;
- (void)prepareSyncProcessMonitor;
@end

@implementation iPadSyncViewController

@synthesize syncProcessMonitor, internalSyncController;

#pragma mark UIViewController methods
- (id)initWithPlaceholder:(UIView *)newPlaceholderView andSyncDelegate:(id<iPadSyncDelegate>)newDelegate  {
	if ((self = [super init])) {
        delegate = newDelegate;
        SyncController *syncController = [[SyncController alloc] initWithDelegate:self];
        self.internalSyncController = syncController;
        [syncController release];
        [self setPlaceholder:newPlaceholderView];
	}
	return self;
}

- (void)removeSyncProcessMonitor {
    if (self.syncProcessMonitor != nil) {
        [syncProcessMonitor.view removeFromSuperview];
        self.syncProcessMonitor = nil;
    }   
}

- (void)prepareSyncProcessMonitor {
    [self removeSyncProcessMonitor];
    
    iPadServerOperationMonitorViewController *processMonitor = 
        [[iPadServerOperationMonitorViewController alloc] initWithServerOpMonitorDelegate:self];
    self.syncProcessMonitor = processMonitor;
    [processMonitor release];
    
    syncProcessMonitor.view.frame = self.view.bounds;
    [self.view addSubview:syncProcessMonitor.view];        
    [placeholderView addSubview:self.view];
}

- (void)setPlaceholder:(UIView *)newPlaceholderView {
    placeholderView = newPlaceholderView;
    
    self.view.frame = placeholderView.bounds;
    self.view.tag = HFS_SYNC_CONTROLLER_VIEW_TAG;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    UIView *monitoringView = [placeholderView viewWithTag:HFS_SYNC_CONTROLLER_VIEW_TAG];
    if (monitoringView) {
        [monitoringView removeFromSuperview];
    }     
}

#pragma mark sync mechanism
- (void)launchSyncWithModule:(DataSyncModule)syncModule {
	NSLog(@"iPadSyncViewController launchSyncWithModule:%i", syncModule);
    [UserDefaults saveValue:[NSNumber numberWithInt:SyncStatusIsRunningSync] forSetting:constSyncStatus];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
	restartSyncModule = syncModule;
    //окно добавляется только при стандарной синхронизации
    if (restartSyncModule == DSModuleActionsOnly) {
        [internalSyncController submitActions];
    }
    else if (restartSyncModule == DSModuleTaskAsRead) {
        [internalSyncController submitTaskAsRead];
    }
    else {
        [self prepareSyncProcessMonitor];
        [internalSyncController syncWithModule:syncModule];	
    }
}

- (void)onSyncFinished {
    [self dismissMonitorView];
    if ([UserDefaults intSettingByKey:constSyncStatus] == SyncStatusAbortedInBackground) {
        if (delegate != nil && [delegate respondsToSelector:@selector(syncAbortedInBackground)]) {
            [delegate syncAbortedInBackground];
        }
    }
    else {
        if (delegate != nil && [delegate respondsToSelector:@selector(syncFinishedForModule:)]) {
            [delegate syncFinishedForModule:restartSyncModule];
        }
    }
}

#pragma mark iPadServerOperationMonitorViewController delegate methods
- (void)repeatLastSync {
	[self launchSyncWithModule:DSModuleClientSettings];
}

- (void)dismissMonitorView { 
    [self.view removeFromSuperview];
    [self removeSyncProcessMonitor];        
}

- (void)showWaitForSyncResetFinishVeil {
    [syncProcessMonitor showWaitForSyncResetFinishVeil];
}

#pragma mark SyncResultProcessor protocol
- (void)syncStarted {
    [self.syncProcessMonitor startQueueOperations];    
}

- (void)syncFinishedWithErrors:(NSArray *)errors andWarnings:(NSArray *)warnings {
    NSLog(@"iPadSyncViewController syncFinishedWithErrorsAndWarnings %@ %@", [errors description], [warnings description]);
    NSString *syncedDate = constEmptyStringValue;
    if ([errors count] == 0 && [UserDefaults intSettingByKey:constSyncStatus] != SyncStatusAbortedInBackground) {
        syncedDate = [SupportFunctions convertDateToString:[NSDate date] withFormat:constDateTimeFormat];
    }
    [UserDefaults saveValue:syncedDate forSetting:constLastSuccessfullSyncDate];
    
    if (restartSyncModule == DSModuleActionsOnly) {
        if ([errors count] > 0 || [warnings count] > 0) {
            [self prepareSyncProcessMonitor];
            [syncProcessMonitor performFetch];
            [syncProcessMonitor showControls:MonitoringControlsSetDoneOnly];
        } 
        else {
            [self onSyncFinished];
        }
    }
    else if (restartSyncModule == DSModuleTaskAsRead) {
        [self onSyncFinished];        
    }
    else {
        if ([UserDefaults intSettingByKey:constSyncStatus] == SyncStatusAbortedInBackground) {
            [self onSyncFinished];
        }
        else if ([errors count] > 0 || [warnings count] > 0) {
            [syncProcessMonitor showControls:MonitoringControlsSetDoneRestart]; 
        }
        else {
            [self onSyncFinished];
        }
    }
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}

- (void)abortSync {
    NSLog(@"iPadSyncViewController abortSync");
    if (self.internalSyncController != nil) {
        [self.internalSyncController abortSync];
    }
}

- (void)dealloc {
    self.syncProcessMonitor = nil;
    self.internalSyncController = nil;
    [super dealloc];
}
@end
