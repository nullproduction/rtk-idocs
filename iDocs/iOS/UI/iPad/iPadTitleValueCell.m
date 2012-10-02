//
//  iPadTitleValueCell.m
//  iDoc
//
//  Created by Dmitry Likhachev on 2/22/09.
//  Copyright 2009 KORUS Consulting. All rights reserved.
//

#import "iPadTitleValueCell.h"
#import "Constants.h"
#import "iPadThemeBuildHelper.h"

@implementation iPadTitleValueCell

- (id)initWithStyle:(UITableViewCellStyle)UITableViewCellStyle reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier])) {		
		self.selectionStyle = UITableViewCellSelectionStyleNone;	
		viewLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		viewLabel.hidden = YES;
		[[self contentView] addSubview:viewLabel];
		
		titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(18.0f, 5.0f, 100.0f, self.contentView.bounds.size.height-10.0f)];
		titleLabel.hidden = YES;
		titleLabel.opaque = YES;
		titleLabel.enabled = YES;
		titleLabel.font = [UIFont systemFontOfSize:constMediumFontSize];
		titleLabel.textColor = [iPadThemeBuildHelper titleForValueFontColor];
		titleLabel.textAlignment = UITextAlignmentLeft;
		titleLabel.backgroundColor = [UIColor clearColor];
		titleLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight;			
		[[self contentView] addSubview:titleLabel];
		
		valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(122.0f, 5.0f, self.contentView.bounds.size.width - 122.0f, self.contentView.bounds.size.height-10.0f)];
		valueLabel.hidden = YES;
		valueLabel.opaque = YES;
		valueLabel.enabled = YES;
		valueLabel.numberOfLines = 1;
		valueLabel.font = [UIFont systemFontOfSize:constMediumFontSize];
		valueLabel.textColor = [iPadThemeBuildHelper commonTextFontColor1];		
		valueLabel.textAlignment = UITextAlignmentLeft;
		valueLabel.backgroundColor = [UIColor clearColor];
		valueLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;			
		[[self contentView] addSubview:valueLabel];
    }
    return self;
}

- (void)initValueView:(NSString *)view withValue:(NSString *)value forAccessType:(int)accessType {
	viewLabel.text = view;
	valueLabel.text = value;
	//if view = checkbox
	if ([constParamViewCheckbox isEqualToString:view]) {		
		valueLabel.hidden = YES;
		[self setAccessoryCheckmarkChecked:(value != nil && [constCheckedValue isEqualToString:value]) ? YES : NO];
		self.accessoryType = UITableViewCellAccessoryCheckmark;
		[self enableAccessoryCheckmark:(accessType == constAccessTypeAll) ? YES : NO];
		self.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	//if view = text
	else {		
		valueLabel.hidden = NO;
		if (accessType >= constAccessTypeViewWithLinks) {
			self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}
		else {			
			self.accessoryType = UITableViewCellAccessoryNone;
		}		
	}
}

- (void)setTitle:(NSString *)title {
	titleLabel.hidden = NO;
	titleLabel.text = title;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)dealloc {
	[viewLabel release];	
	[titleLabel release];
	[valueLabel release];
    [super dealloc];
}

@end

