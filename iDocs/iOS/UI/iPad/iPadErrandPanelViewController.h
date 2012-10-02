//
//  iPadErrandPanelViewController.h
//  iDoc
//
//  Created by rednekis on 10-12-17.
//  Copyright 2010 KORUS Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iPadErrandViewController.h"
#import "iPadHeaderBodyFooterLayoutView.h"

@class iPadErrandPanelViewController;

@protocol iPadPopupLayoutViewDelegate;

@protocol iPadErrandPanelViewControllerDelegate <NSObject>
@optional
- (void)errandViewCloseButtonPressed;
- (void)deleteErrandActionButtonPressed;
- (void)submitErrandCreateActionsToServer:(NSArray *)actions;
- (void)submitErrandWorkflowActionToServer:(ActionToSync *)action;
@end

@interface iPadErrandPanelViewController : iPadBaseViewController <iPadErrandViewControllerDelegate> {
	iPadHeaderBodyFooterLayoutView *container;
	UINavigationController *errandNavigationController;
	iPadErrandViewController *errandViewController;
	id<iPadErrandPanelViewControllerDelegate> delegate;	
    
	int errandMode;
}

@property (nonatomic, retain) iPadHeaderBodyFooterLayoutView *container;
@property (nonatomic, retain) UINavigationController *errandNavigationController;
@property (nonatomic, retain) iPadErrandViewController *errandViewController;

- (id)initWithFrame:(CGRect)frame;
- (void)showErrand:(DocErrand *)errandData forTaskWithId:(NSString *)taskId usingMode:(int)mode;
- (void)createErrand:(DocErrand *)errandData forTaskAction:(ActionToSync *)actionData;
- (void)setTitleForPopupPanelHeader:(NSString *)newTitle;
- (void)setDelegate:(id<iPadErrandPanelViewControllerDelegate>)newDelegate;	
- (void)setPopupAuxPanel:(id<iPadPopupLayoutViewDelegate>)auxPanel;
@end
