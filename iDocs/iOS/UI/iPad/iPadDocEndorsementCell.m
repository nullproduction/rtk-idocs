//
//  iPadTaskEndorsementCell.m
//  iDoc
//
//  Created by Dmitry Likhachev on 1/31/10.
//  Copyright 2009 KORUS Consulting. All rights reserved.
//

#import "iPadDocEndorsementCell.h"
#import "Constants.h"
#import "iPadThemeBuildHelper.h"

@interface iPadDocEndorsementCell(PrivateMethods)
- (CGRect)resizeLabelFrame:(CGRect)labelFrame forText:(NSString *)labelText andFont:(UIFont *)labelFont;
@end


@implementation iPadDocEndorsementCell

@synthesize positionLabel, personLabel, decisionLabel, dateLabel, commentLabel;

- (id)initWithStyle:(UITableViewCellStyle)UITableViewCellStyle reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier])) {
		self.accessoryType = UITableViewCellAccessoryNone;
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		self.backgroundColor = [UIColor clearColor];
		self.opaque = NO;
				
		statusImage = [[UIImageView alloc] initWithFrame:CGRectZero];
		statusImage.contentMode = UIViewContentModeCenter;
		statusImage.backgroundColor = [UIColor clearColor];
		[[self contentView] addSubview:statusImage];
		
		positionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		positionLabel.textColor = [iPadThemeBuildHelper commonTextFontColor1];		
		positionLabel.numberOfLines = 0;
		positionLabel.font = [UIFont systemFontOfSize:constMediumFontSize];
		positionLabel.textAlignment = UITextAlignmentLeft;
		positionLabel.backgroundColor = [UIColor clearColor];
		positionLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;			
		[[self contentView] addSubview:positionLabel];
		
		personLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		personLabel.textColor = [iPadThemeBuildHelper commonTextFontColor1];		
		personLabel.numberOfLines = 0;
		personLabel.font = [UIFont systemFontOfSize:constMediumFontSize];
		personLabel.textAlignment = UITextAlignmentLeft;
		personLabel.backgroundColor = [UIColor clearColor];
		personLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;			
		[[self contentView] addSubview:personLabel];
		
		decisionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		decisionLabel.textColor = [iPadThemeBuildHelper commonTextFontColor1];		
		decisionLabel.numberOfLines = 0;
		decisionLabel.font = [UIFont systemFontOfSize:constMediumFontSize];
		decisionLabel.textAlignment = UITextAlignmentLeft;
		decisionLabel.backgroundColor = [UIColor clearColor];
		decisionLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;			
		[[self contentView] addSubview:decisionLabel];
		
		dateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		dateLabel.textColor = [iPadThemeBuildHelper commonTextFontColor1];		
		dateLabel.numberOfLines = 0;
		dateLabel.font = [UIFont systemFontOfSize:constMediumFontSize];
		dateLabel.textAlignment = UITextAlignmentLeft;
		dateLabel.backgroundColor = [UIColor clearColor];
		dateLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;			
		[[self contentView] addSubview:dateLabel];

		commentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		commentLabel.textColor = [iPadThemeBuildHelper commonTextFontColor1];	
		commentLabel.numberOfLines = 0;
		commentLabel.font = [UIFont systemFontOfSize:constMediumFontSize];
		commentLabel.textAlignment = UITextAlignmentLeft;
		commentLabel.backgroundColor = [UIColor clearColor];
		commentLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;			
		[[self contentView] addSubview:commentLabel];
		
		
    }
    return self;
}

- (CGRect)resizeLabelFrame:(CGRect)labelFrame forText:(NSString *)labelText andFont:(UIFont *)labelFont {
	if (isinf(labelFrame.origin.x) || isinf(labelFrame.origin.y) || isnan(labelFrame.size.width) || isnan(labelFrame.size.height)) 
		return CGRectZero;
	
	CGSize valueLabelSize = [labelText drawInRect:labelFrame withFont:labelFont];
	return CGRectMake(labelFrame.origin.x, labelFrame.origin.y, valueLabelSize.width, valueLabelSize.height);
}

- (void)layoutSubviews {
	[super layoutSubviews];
	self.backgroundView.frame = CGRectInset(self.backgroundView.frame, 20.0f, 0.0f);
	CGRect tgtFrame = self.bounds;
	NSArray *cellFrames = [iPadDocEndorsementCell prepareCellFrames:tgtFrame];
	
	statusImage.frame = [[cellFrames objectAtIndex:0] CGRectValue];
	positionLabel.frame = [self resizeLabelFrame:[[cellFrames objectAtIndex:1] CGRectValue] forText:positionLabel.text andFont:positionLabel.font];
	personLabel.frame =	[self resizeLabelFrame:[[cellFrames objectAtIndex:2] CGRectValue] forText:personLabel.text andFont:personLabel.font];
	decisionLabel.frame = [self resizeLabelFrame:[[cellFrames objectAtIndex:3] CGRectValue] forText:decisionLabel.text andFont:decisionLabel.font];
	dateLabel.frame = [self resizeLabelFrame:[[cellFrames objectAtIndex:4] CGRectValue] forText:dateLabel.text andFont:dateLabel.font];
	commentLabel.frame = [self resizeLabelFrame:[[cellFrames objectAtIndex:5] CGRectValue] forText:commentLabel.text andFont:commentLabel.font];
}

+ (NSArray *)prepareCellFrames:(CGRect)rowFrame {
	CGRect c1Frame,c2Frame,c3Frame,c4Frame,c5Frame,c6Frame;
	CGRectDivide(rowFrame, &c1Frame, &c2Frame, 70.0f, CGRectMinXEdge);
	CGRectDivide(c2Frame, &c2Frame, &c3Frame, 160.0f, CGRectMinXEdge);
	CGRectDivide(c3Frame, &c3Frame, &c4Frame, 129.0f, CGRectMinXEdge);
	CGRectDivide(c4Frame, &c4Frame, &c5Frame, 123.0f, CGRectMinXEdge);
	CGRectDivide(c5Frame, &c5Frame, &c6Frame, 88.0f, CGRectMinXEdge);
		
	return [NSArray arrayWithObjects:
			[NSValue valueWithCGRect:CGRectInset(c1Frame, 5.0f, 5.0f)],
			[NSValue valueWithCGRect:CGRectInset(c2Frame, 5.0f, 5.0f)],
			[NSValue valueWithCGRect:CGRectInset(c3Frame, 5.0f, 5.0f)],
			[NSValue valueWithCGRect:CGRectInset(c4Frame, 5.0f, 5.0f)],
			[NSValue valueWithCGRect:CGRectInset(c5Frame, 5.0f, 5.0f)],
			[NSValue valueWithCGRect:CGRectInset(c6Frame, 5.0f, 5.0f)], nil];
}

- (void)setStatusImage:(NSString *)imageName {
	[statusImage setImage:(imageName != nil) ? [UIImage imageNamed:imageName] : nil];	
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)dealloc {	
	[statusImage release];
	[personLabel release];
	[positionLabel release];
	[decisionLabel release];
	[dateLabel release]; 
	[commentLabel release];
    [super dealloc];
}


@end
