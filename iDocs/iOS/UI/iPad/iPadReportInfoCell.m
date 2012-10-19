//
//  iPadReportInfoCell.m
//  iDoc
//
//  Created by Olga Geets on 17.10.12.
//  Copyright (c) 2012 KORUS Consulting. All rights reserved.
//

#import "iPadReportInfoCell.h"

@implementation iPadReportInfoCell

- (id)initWithStyle:(UITableViewCellStyle)UITableViewCellStyle reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier])) {
		self.accessoryType = UITableViewCellAccessoryNone;
		self.selectionStyle = UITableViewCellSelectionStyleGray;
		self.backgroundColor = [UIColor clearColor];
		self.opaque = NO;
        
		checkReport = [[UIImageView alloc] initWithFrame:CGRectZero];
        checkReport.image = nil;
		checkReport.autoresizingMask = UIViewAutoresizingNone;
 		[[self contentView] addSubview:checkReport];
        
        nameReport = [[UILabel alloc] initWithFrame:CGRectZero];
		nameReport.hidden = NO;
		nameReport.opaque = YES;
		nameReport.enabled = YES;
		nameReport.numberOfLines = 2;
		nameReport.lineBreakMode = UILineBreakModeTailTruncation;
		nameReport.font = [UIFont systemFontOfSize:constMediumFontSize];
		nameReport.textColor = [iPadThemeBuildHelper commonTextFontColor1];
		nameReport.textAlignment = UITextAlignmentLeft;
		nameReport.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		nameReport.backgroundColor = [UIColor clearColor];
        nameReport.minimumFontSize = constMediumFontSize;
		[[self contentView] addSubview:nameReport];
        
        UIImage* attachmentImage = [UIImage imageNamed:[iPadThemeBuildHelper nameForImage:@"task_attachment_icon.png"]];
		attachment = [[UIImageView alloc] initWithFrame:CGRectZero];
        attachment.image = attachmentImage;
		attachment.autoresizingMask = UIViewAutoresizingNone;
 		[[self contentView] addSubview:attachment];        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
	self.backgroundView.frame = CGRectInset(self.backgroundView.frame, 5, 5);
    checkReport.frame = CGRectMake(10.0f, self.frame.size.height / 2 - 10, 20, 20);
    nameReport.frame = CGRectMake(40.0f, 0.0f, self.frame.size.width - 110, self.frame.size.height);
    attachment.frame = CGRectMake(self.frame.size.width - 60, self.frame.size.height / 2 - 15, 30, 30);
}

- (void)setNameReport:(NSString *)name {
	nameReport.text = name;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setChecked:(BOOL)check {
    if( check ) {
        checkReport.image = [UIImage imageNamed:[iPadThemeBuildHelper nameForImage:@"icon_mark_check_3"]];
    }
    else {
        checkReport.image = nil;
    }
}

- (BOOL)isChecked {
    return checkReport.image == nil ? NO : YES;
}

- (void)dealloc {
	[nameReport release];
    
    [super dealloc];
}

@end
