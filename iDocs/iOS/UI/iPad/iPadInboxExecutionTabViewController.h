//
//  iPadInboxExecutionTabViewController.h
//  iDoc
//
//  Created by rednekis on 10-12-19.
//  Copyright 2010 KORUS Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iPadBaseViewController.h"
#import "iPadDocExecutionCell.h"
#import "DocErrand.h"
#import "ActionToSync.h"
#import "DocDataEntity.h"
#import "iPadAttachmentViewController.h"
#import "iPadDocAttachmentCell.h"

@class iPadInboxExecutionTabViewController;

@protocol iPadInboxExecutionTabViewControllerDelegate <NSObject>
@optional
- (void)showErrand:(DocErrand *)errand usingMode:(int)mode;
- (void)showAttachmentWithFileName:(NSString *)attachmentFileName andName:(NSString *)attachmentName;
@end

@interface iPadInboxExecutionTabViewController : iPadBaseViewController <UITableViewDelegate, UITableViewDataSource, iPadDocAttachmentCellDelegate> {
	UITableView *errandsTableView;
	float executionTableSectionHeight;
	
	NSArray *errands;
    NSString *currentErrandId;
	NSMutableArray *filteredErrands;
	
	id<iPadInboxExecutionTabViewControllerDelegate> delegate;

    DocDataEntity *docEntity;
    
}

- (id)initWithPlaceholderPanel:(UIView *)placeholderPanel;
- (void)setDelegate:(id<iPadInboxExecutionTabViewControllerDelegate>)newDelegate;
- (void)loadTabDataWithErrands:(NSArray *)newErrands andCurrentErrandId:(NSString *)newCurrentErrandId;
@end
