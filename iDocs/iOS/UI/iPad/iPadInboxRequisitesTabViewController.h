//
//  iPadInboxRequisitesTabViewController.h
//  iDoc
//
//  Created by rednekis on 10-12-19.
//  Copyright 2010 KORUS Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iPadBaseViewController.h"
#import "iPadDocAttachmentCell.h"
#import "iPadDocRequisiteCell.h"
#import "HFSUILabel.h"

@class iPadInboxRequisitesTabViewController;
@protocol iPadInboxRequisitesTabViewControllerDelegate<NSObject>
@optional
- (void)showAttachmentWithFileName:(NSString *)attachmentFileName andName:(NSString *)attachmentName;
@end

@interface iPadInboxRequisitesTabViewController : iPadBaseViewController 
 <UITableViewDelegate, UITableViewDataSource,iPadDocAttachmentCellDelegate> {
	UITableView *requisitesTableView;
	float requisitesTableSectionHeight;    
	HFSUILabel *executorName;
	HFSUILabel *taskDocDescription;

	NSArray *attachments;
    NSArray *requisites;
    BOOL hasRequisites;
	id<iPadInboxRequisitesTabViewControllerDelegate> delegate;
}

- (id)initWithPlaceholderPanel:(UIView *)placeholderPanel;
- (void)setDelegate:(id<iPadInboxRequisitesTabViewControllerDelegate>)newDelegate;
- (void)loadTabDataWithExecutorName:(NSString *)name 
                     docDescription:(NSString *)description 
                         requisites:(NSArray *)newRequisites 
                     andAttachments:(NSArray *)newAttachments;
@end
