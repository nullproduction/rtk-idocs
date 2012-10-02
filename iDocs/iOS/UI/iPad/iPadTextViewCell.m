//
//  iPadTextViewCell.m
//  iDoc
//
//  Created by Dmitry Likhachev on 2/22/09.
//  Copyright 2009 KORUS Consulting. All rights reserved.
//

#import "iPadTextViewCell.h"
#import "Constants.h"
#import "iPadThemeBuildHelper.h"

@implementation iPadTextViewCell

- (id)initWithStyle:(UITableViewCellStyle)UITableViewCellStyle reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier])) {
		self.accessoryType = UITableViewCellAccessoryNone;
		self.selectionStyle = UITableViewCellSelectionStyleNone;

		titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(18.0f, 25.0f, 100.0f, 30.0f)];
		titleLabel.hidden = YES;
		titleLabel.opaque = YES;
		titleLabel.enabled = YES;
		titleLabel.font = [UIFont systemFontOfSize:constMediumFontSize];
		titleLabel.textAlignment = UITextAlignmentLeft;
		titleLabel.textColor = [iPadThemeBuildHelper titleForValueFontColor];
		titleLabel.backgroundColor =[UIColor clearColor];
		titleLabel.autoresizingMask = UIViewAutoresizingNone;			
		[[self contentView] addSubview:titleLabel];
		
		valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(122.0f, 5.0f, 155.0f, 70.0f)];
		valueLabel.hidden = YES;
		valueLabel.opaque = YES;
		valueLabel.enabled = YES;
		valueLabel.numberOfLines = 5;
		valueLabel.lineBreakMode = UILineBreakModeWordWrap;
		valueLabel.font = [UIFont systemFontOfSize:constMediumFontSize];
		valueLabel.textColor = [iPadThemeBuildHelper commonTextFontColor1];		
		valueLabel.textAlignment = UITextAlignmentLeft;
		valueLabel.backgroundColor = [UIColor clearColor];
		valueLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;			
		[[self contentView] addSubview:valueLabel];
    }
    return self;
}

- (void)setTitle:(NSString *)title {
	titleLabel.hidden = NO;
	titleLabel.text = title;	
}

- (void)setValue:(NSString *)value forAccessType:(int)accessType {
	valueLabel.hidden = NO;
	valueLabel.text = value;
	if (accessType == constAccessTypeAll) {
		self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	else {			
		self.accessoryType = UITableViewCellAccessoryNone;
	}	
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (void)dealloc {
	[titleLabel release];
	[valueLabel release];
    [super dealloc];
}


@end
