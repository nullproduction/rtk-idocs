//
//  iPadTaskAttachmentCell.m
//  iDoc
//
//  Created by Dmitry Likhachev on 1/31/10.
//  Copyright 2009 KORUS Consulting. All rights reserved.
//

#import "iPadDocAttachmentCell.h"
#import "Constants.h"
#import "iPadThemeBuildHelper.h"

@implementation iPadDocAttachmentCell

- (id)initWithStyle:(UITableViewCellStyle)UITableViewCellStyle reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier])) {
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		self.accessoryType = UITableViewCellAccessoryNone;
		self.backgroundColor = [UIColor clearColor];
		
		attachmentIdLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 0.0f, 0.0f)];
		attachmentIdLabel.hidden = YES;
		[[self contentView] addSubview:attachmentIdLabel];

		attachmentFileNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 0.0f, 0.0f)];
		attachmentFileNameLabel.hidden = YES;
		[[self contentView] addSubview:attachmentFileNameLabel];
        
		attachmentNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50.0f, 2.0f, 200.0f, 36.0f)];
		attachmentNameLabel.hidden = YES;
		attachmentNameLabel.opaque = YES;
		attachmentNameLabel.enabled = YES;
		attachmentNameLabel.textColor = [iPadThemeBuildHelper commonTextFontColor1];		
		attachmentNameLabel.font = [UIFont systemFontOfSize:constMediumFontSize];
		attachmentNameLabel.textAlignment = UITextAlignmentLeft;
		attachmentNameLabel.backgroundColor = [UIColor clearColor];
		attachmentNameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;			
		[[self contentView] addSubview:attachmentNameLabel];

		attachmentSizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(255.0f, 2.0f, 100.0f, 36.0f)];
		attachmentSizeLabel.hidden = YES;
		attachmentSizeLabel.opaque = YES;
		attachmentSizeLabel.enabled = YES;
		attachmentSizeLabel.textColor = [iPadThemeBuildHelper commonTextFontColor1];		
		attachmentSizeLabel.font = [UIFont systemFontOfSize:constMediumFontSize];
		attachmentSizeLabel.textAlignment = UITextAlignmentLeft;
		attachmentSizeLabel.backgroundColor = [UIColor clearColor];
		attachmentSizeLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;			
		[[self contentView] addSubview:attachmentSizeLabel];
    }
    return self;
}

- (void)addCellIcon {
    UIImageView *attachmentImage = [[UIImageView alloc] initWithFrame:CGRectMake(5.0f, 2.0f, 33.0f, 36.0f)];
    UIImage *image = [UIImage imageNamed:[iPadThemeBuildHelper nameForImage:@"task_attachment_icon.png"]];
    [attachmentImage setImage:image];
    attachmentImage.hidden = NO;
    attachmentImage.autoresizingMask = UIViewAutoresizingNone;	
    [[self contentView] addSubview:attachmentImage];
    [attachmentImage release];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	self.backgroundView.frame = CGRectInset(self.backgroundView.frame, 20, 0);
}

- (void)setAttachmentId:(NSString *)attachmentId {
	attachmentIdLabel.hidden = YES;
	attachmentIdLabel.text = attachmentId;	
}

- (void)setAttachmentFileName:(NSString *)attachmentFileName {
	attachmentFileNameLabel.hidden = YES;
	attachmentFileNameLabel.text = attachmentFileName;	
}

- (void)setAttachmentName:(NSString *)attachmentName {
	attachmentNameLabel.hidden = NO;
	attachmentNameLabel.text = attachmentName;	
}

- (void)setAttachmentSize:(NSString *)attachmentSize {
	attachmentSizeLabel.hidden = NO;
	attachmentSizeLabel.text = attachmentSize;	
}

- (void)setDelegate:(id<iPadDocAttachmentCellDelegate>)newDelegate {
	delegate = newDelegate;
}

- (void)setSelection:(id)sender {
	if (delegate != nil && [delegate respondsToSelector:@selector(showAttachmentWithFileName:andName:)]) {
		[delegate showAttachmentWithFileName:attachmentFileNameLabel.text andName:attachmentNameLabel.text];
	}	
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
}

- (void)setAvailable:(BOOL)access {
    if( access ) {
        attachmentIdLabel.textColor = [iPadThemeBuildHelper commonTextFontColor1];
        attachmentFileNameLabel.textColor = [iPadThemeBuildHelper commonTextFontColor1];
        
		attachmentNameLabel.textColor = [iPadThemeBuildHelper commonTextFontColor1];
		attachmentSizeLabel.textColor = [iPadThemeBuildHelper commonTextFontColor1];
    }
    else {
        attachmentIdLabel.textColor = [iPadThemeBuildHelper commonSeparatorColor];
        attachmentFileNameLabel.textColor = [iPadThemeBuildHelper commonSeparatorColor];

		attachmentNameLabel.textColor = [iPadThemeBuildHelper commonSeparatorColor];
		attachmentSizeLabel.textColor = [iPadThemeBuildHelper commonSeparatorColor];        
    }
}

- (void)dealloc {
	[attachmentIdLabel release];	
    [attachmentFileNameLabel release];
	[attachmentNameLabel release];
	[attachmentSizeLabel release];
    
//    [self setDelegate:nil];
    
    [super dealloc];
}


@end
