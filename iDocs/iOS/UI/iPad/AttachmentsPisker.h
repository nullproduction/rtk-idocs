//
//  AttachmentsPisker.h
//  iDoc
//
//  Created by koulikovar on 19.10.12.
//  Copyright (c) 2012 KORUS Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ReportAttachment;

@protocol AttachmentPickerDelegate <NSObject>

- (void)reportAttachmentFileSelected:(ReportAttachment*)report;

@end

@interface AttachmentsPisker : UITableViewController

@property (nonatomic,retain) NSArray *attachmentsArray;
@property (nonatomic,assign) id<AttachmentPickerDelegate> delegate;

@end
