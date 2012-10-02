//
//  iPadSyncViewController.h
//  iDoc
//
//  Created by Arthur Semenyutin on 8/22/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+Blockable.h"
#import "UIViewController+Alert.h"
#import "iPadServerOperationMonitorViewController.h"
#import "SyncController.h"

@protocol iPadSyncDelegate <NSObject>
@optional
- (void)syncFinishedForModule:(DataSyncModule)syncModule;
- (void)syncFinished;
- (void)syncAbortedInBackground;
@end

@interface iPadSyncViewController : UIViewController  <iPadServerOperationMonitorViewControllerDelegate, SyncDelegate> { 
    iPadServerOperationMonitorViewController *syncProcessMonitor;
    UIView *placeholderView;
	SyncController *internalSyncController;
	DataSyncModule restartSyncModule;
    id<iPadSyncDelegate> delegate;
} 

@property (nonatomic, retain) SyncController *internalSyncController;
@property (nonatomic, retain) iPadServerOperationMonitorViewController *syncProcessMonitor;

- (id)initWithPlaceholder:(UIView *)newPlaceholderView andSyncDelegate:(id<iPadSyncDelegate>)newDelegate;
- (void)setPlaceholder:(UIView *)newPlaceholderView;
- (void)launchSyncWithModule:(DataSyncModule)syncModule;
- (void)onSyncFinished;
- (void)repeatLastSync;
- (void)abortSync;

@end
