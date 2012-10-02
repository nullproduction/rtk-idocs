//
//  iPadServerOperationMonitorViewController.h
//  Medi_Pad
//
//  Created by mark2 on 4/23/11.
//  Copyright 2011 HFS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseFetchedTableDataViewController.h"
#import "ServerOperationQueueEntity.h"
#import "iPadServerOpMonDetailViewController.h"

typedef enum _MonitoringControlsSet {
    MonitoringControlsSetNone = 0,
    MonitoringControlsSetDoneRestart = 1,
    MonitoringControlsSetDoneOnly = 2,
    MonitoringControlsSetRestartOnly = 3
} MonitoringControlsSet;

@protocol iPadServerOperationMonitorViewControllerDelegate <NSObject>
- (void)dismissMonitorView;
- (void)showWaitForSyncResetFinishVeil;
@optional
- (void)repeatLastSync;
@end

@interface iPadServerOperationMonitorViewController : BaseFetchedTableDataViewController {
    id<iPadServerOperationMonitorViewControllerDelegate> delegate;
    UIView *tableViewPraceholderView;
    UIView *footerView;
    
    BOOL viewIsDisplayed;
    ServerOperationQueueEntity *queueEntity;
    
    iPadServerOpMonDetailViewController *detailController;
}

@property (nonatomic, retain) iPadServerOpMonDetailViewController *detailController;

- (id)initWithServerOpMonitorDelegate:(id<iPadServerOperationMonitorViewControllerDelegate>)newDelegate;
- (void)startQueueOperations;
- (void)showControls:(MonitoringControlsSet)controlsSet;
- (void)showWaitForSyncResetFinishVeil;

@end
