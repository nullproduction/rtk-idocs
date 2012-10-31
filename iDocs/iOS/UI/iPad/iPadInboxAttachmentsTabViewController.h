//
//  iPadInboxAttachmentsTabViewController.h
//  iDoc
//
//  Created by rednekis on 10-12-19.
//  Copyright 2010 KORUS Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iPadBaseViewController.h"
#import "iPadAttachmentViewController.h"
#import "AttachmentTypeIconsDictionaryEntity.h"
#import "iPadInboxAttachmentsTabLayoutView.h"

@interface iPadInboxAttachmentsTabViewController : iPadBaseViewController <iPadInboxAttachmentsTabLayoutViewDelegate> {
	iPadInboxAttachmentsTabLayoutView *container;
	iPadAttachmentViewController *attachmentView;

	NSArray *attachments;
	AttachmentTypeIconsDictionaryEntity *attachmentTypeIcons;
    NSString *loadedAttachment;
	float contentItemWidth;
    
    NSArray *treatmentItems;
}


- (id)initWithPlaceholderPanel:(UIView *)placeholderPanel;
- (void)loadTabData:(NSArray *)newAttachments;

@property(nonatomic,retain) NSArray *treatmentItems;

@end
