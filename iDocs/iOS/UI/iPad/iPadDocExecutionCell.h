//
//  iPadTaskExecutionCell.h
//  iDoc
//
//  Created by Dmitry Likhachev on 1/31/10.
//  Copyright 2009 KORUS Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFSUITableViewCell.h"
#import "iPadDocAttachmentCell.h"

@class iPadDocExecutionCell;

@protocol iPadDocExecutionCellDelegate <NSObject>
@optional
- (void)viewErrand:(NSString *)errandId;
@end

@protocol iPadDocAttachmentCellDelegate;

@interface iPadDocExecutionCell: HFSUITableViewCell {
	UILabel *errandIdLabel;
	UIImageView *errandStatusImage;
    UIImageView *errandMajorExecutorImage;
	UILabel *errandNumberLabel;	
	UILabel *errandAuthorLabel;
	UILabel *errandExecutorLabel;	
	UILabel *errandTextLabel;
	UILabel *errandDueDateLabel;
    
    UIButton* errandAttachmentFiles;
    id<iPadDocAttachmentCellDelegate> delegate;

}

- (void)setDelegate:(id<iPadDocAttachmentCellDelegate>)newDelegate;
- (void)setSelection:(id)sender;
+ (NSArray *)prepareCellFrames:(CGRect)rowFrame;
- (void)setErrandId:(NSString *)errandId;
- (void)setErrandStatusImage:(NSString *)imageName;
- (void)setErrandMajorExecutorImage:(NSString *)imageName;
- (void)setErrandNumber:(NSString *)errandNumber;
- (void)setErrandAuthorName:(NSString *)authorName;
- (void)setErrandExecutorName:(NSString *)executorName;
- (void)setNumberOfLinesForErrandExecutorLabel:(int)numberOfLines;
- (void)setErrandText:(NSString *)errandText;
- (void)setErrandDueDate:(NSString *)dueDate withColor:(UIColor *)color;
- (void)setCurrentErrandStyle:(Boolean)isCurrentErrand;

- (void)setErrandAttachmentFiles;

@end
