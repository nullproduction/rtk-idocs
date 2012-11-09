//
//  iPhoneTaskAttachmentCell.h
//  iDoc
//
//  Created by Dmitry Likhachev on 1/31/10.
//  Copyright 2009 KORUS Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFSUITableViewCell.h"

@class iPadDocAttachmentCell;
@protocol iPadDocAttachmentCellDelegate <NSObject>
- (void)showAttachmentWithFileName:(NSString *)attachmentFileName andName:(NSString *)attachmentName;
@end

@interface iPadDocAttachmentCell: HFSUITableViewCell {
	UILabel *attachmentIdLabel;
	UILabel *attachmentFileNameLabel;
	UILabel *attachmentNameLabel;
	UILabel *attachmentSizeLabel;
	id<iPadDocAttachmentCellDelegate> delegate;
}

- (void)setDelegate:(id<iPadDocAttachmentCellDelegate>)newDelegate;
- (void)setSelection:(id)sender;
- (void)setAttachmentId:(NSString *)attachmentId;
- (void)setAttachmentFileName:(NSString *)attachmentFileName;
- (void)setAttachmentName:(NSString *)attachmentName;
- (void)setAttachmentSize:(NSString *)attachmentSize;
- (void)setAvailable:(BOOL)access;
- (void)addCellIcon;

@end
