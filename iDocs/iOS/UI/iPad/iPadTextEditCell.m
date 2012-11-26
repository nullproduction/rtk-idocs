//
//  iPadTextEditCell.m
//  iDoc
//
//  Created by Dmitry Likhachev on 2/22/09.
//  Copyright 2009 KORUS Consulting. All rights reserved.
//

#import "iPadTextEditCell.h"
#import "Constants.h"
#import "iPadThemeBuildHelper.h"
#import <CoreGraphics/CoreGraphics.h>

@implementation iPadTextEditCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier])) {
		self.accessoryType = UITableViewCellAccessoryNone;
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		
		titleLabel = [[HFSUILabel labelWithFrame:CGRectZero forText:nil withColor:[iPadThemeBuildHelper titleForValueFontColor] andShadow:nil] retain];
		titleLabel.hidden = YES;
		[self.contentView addSubview:titleLabel];
		
		dataTextView = [[iDocUITextView alloc] initWithFrame:CGRectZero];
		dataTextView.hidden = YES;
		dataTextView.autoresizingMask = UIViewAutoresizingNone;

		valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(122.0f, 5.0f, 155.0f, 30.0f)];
		valueLabel.hidden = YES;
		valueLabel.lineBreakMode = UILineBreakModeWordWrap; 
		valueLabel.numberOfLines = 0; //calculated automatically :) 
		valueLabel.font = [UIFont systemFontOfSize:constMediumFontSize];
		valueLabel.textColor = [iPadThemeBuildHelper commonTextFontColor1];		
		valueLabel.textAlignment = UITextAlignmentLeft;
		valueLabel.contentMode = UIViewContentModeTopLeft;
		valueLabel.backgroundColor = [UIColor clearColor];
		valueLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;			
		[[self contentView] addSubview:valueLabel];
		
//		[dataTextView becomeFirstResponder];			
		[self.contentView addSubview:dataTextView];
    }
    return self;
}
- (void)initValueView:(NSString *)value forAccessType:(int)accessType {
	currentAccessType = accessType;
	if (accessType >= constAccessTypeViewWithLinks) {
		titleLabel.hidden = YES;
		valueLabel.hidden = YES;
		dataTextView.hidden = NO;
		dataTextView.text = value;
	}
	else {
		titleLabel.hidden = NO;
		valueLabel.hidden = NO;
		dataTextView.hidden = YES;
		valueLabel.text = value;
		self.selectionStyle = UITableViewCellSelectionStyleNone;
	}
}

- (void)layoutSubviews {
	[super layoutSubviews];
	CGRect titleFrame, textFrame;
	if (currentAccessType >= constAccessTypeViewWithLinks) {
		titleLabel.frame = CGRectZero;
		dataTextView.frame = CGRectInset(self.contentView.bounds, 5, 5);
	}
	else {
		CGRectDivide(self.contentView.bounds, &titleFrame, &textFrame, 30, CGRectMinYEdge);
		titleLabel.frame = CGRectOffset(CGRectInset(titleFrame, 9.0f+2.5f, 0), 9.0f-2.5f, 0);//18-5
		dataTextView.frame = CGRectInset(textFrame, 5, 0);
	}


	if (valueLabel.hidden) return;
	
	CGRect valueLabelGizmo = CGRectMake(titleLabel.frame.origin.x, dataTextView.frame.origin.y, titleLabel.frame.size.width, dataTextView.frame.size.height);
	CGSize valueLabelSize = [valueLabel.text drawInRect:valueLabelGizmo withFont:valueLabel.font];
	valueLabel.frame = CGRectMake(valueLabelGizmo.origin.x, valueLabelGizmo.origin.y, valueLabelSize.width, valueLabelSize.height);
}

- (void)setDelegate:(id<UITextViewDelegate>)newDelegate{
	dataTextView.delegate = newDelegate;
}

- (void)setValue:(NSString *)value {
	dataTextView.text = value;
}

- (void)setTitle:(NSString *)title {
	if (currentAccessType >= constAccessTypeViewWithLinks) {
		dataTextView.text = title;
	}
	else {
		titleLabel.text = title;
	}
}

- (NSString *)value {
	return dataTextView.text;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)dealloc {
	[titleLabel release];
	[dataTextView release];
	[valueLabel release];
    
    [super dealloc];
}


@end
