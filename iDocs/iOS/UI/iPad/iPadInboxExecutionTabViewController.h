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
#import "AttachmentsPisker.h"

@class iPadInboxExecutionTabViewController;
@class OpenTreeButton;

@protocol iPadInboxExecutionTabViewControllerDelegate <NSObject>
@optional
- (void)showErrand:(DocErrand *)errand usingMode:(int)mode;
- (void)showAttachmentWithFileName:(NSString *)attachmentFileName andName:(NSString *)attachmentName;
@end

@interface iPadInboxExecutionTabViewController : iPadBaseViewController <UITableViewDelegate, UITableViewDataSource, iPadDocAttachmentCellDelegate, UIPopoverControllerDelegate, AttachmentPickerDelegate> {
	UITableView *errandsTableView;
	float executionTableSectionHeight;
	
	NSArray *errands;
    NSString *currentErrandId;
	NSMutableArray *filteredErrands;
    NSDictionary *childErrandDictionary;
    NSDictionary *errandAttachments;
	
	id<iPadInboxExecutionTabViewControllerDelegate> delegate;

    DocDataEntity *docEntity;
    
    NSMutableDictionary* openOrCloseParentErrandDict;
}

@property (nonatomic,retain) AttachmentsPisker *attPicker;
@property (nonatomic,retain) UIPopoverController *popController;

- (id)initWithPlaceholderPanel:(UIView *)placeholderPanel;
- (void)setDelegate:(id<iPadInboxExecutionTabViewControllerDelegate>)newDelegate;
- (void)loadTabDataWithErrands:(NSArray *)newErrands andCurrentErrandId:(NSString *)newCurrentErrandId;
- (void)loadChildErrands:(NSDictionary*)childErrands;
- (void)loadErrandAttachmentsWithDocId:(NSString*)docId;
- (void)insertChildsToTree:(OpenTreeButton*)sender;
- (void)setErrandTableView:(UIView *)placeholderPanel;
- (void)showFileListWithCell:(iPadDocExecutionCell*)cell;
@end
