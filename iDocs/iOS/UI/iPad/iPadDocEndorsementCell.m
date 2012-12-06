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
				
        statusImage = [[UIImageView alloc] initWithFrame:CGRectZero];;
		statusImage.contentMode = UIViewContentModeCenter;
		statusImage.backgroundColor = [UIColor clearColor];
		[[self contentView] addSubview:statusImage];
		
		UILabel* positionLabel_ = [[UILabel alloc] initWithFrame:CGRectZero];
        self.positionLabel = positionLabel_;
        [positionLabel_ release];
		self.positionLabel.textColor = [iPadThemeBuildHelper commonTextFontColor1];
		self.positionLabel.numberOfLines = 0;
		self.positionLabel.font = [UIFont systemFontOfSize:constMediumFontSize];
		self.positionLabel.textAlignment = UITextAlignmentLeft;
		self.positionLabel.backgroundColor = [UIColor clearColor];
		self.positionLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		[[self contentView] addSubview:self.positionLabel];
		
		UILabel* personLabel_ = [[UILabel alloc] initWithFrame:CGRectZero];
        self.personLabel = personLabel_;
        [personLabel_ release];
		self.personLabel.textColor = [iPadThemeBuildHelper commonTextFontColor1];
		self.personLabel.numberOfLines = 0;
		self.personLabel.font = [UIFont systemFontOfSize:constMediumFontSize];
		self.personLabel.textAlignment = UITextAlignmentLeft;
		self.personLabel.backgroundColor = [UIColor clearColor];
		self.personLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;			
		[[self contentView] addSubview:self.personLabel];
		
		UILabel* decisionLabel_ = [[UILabel alloc] initWithFrame:CGRectZero];
		self.decisionLabel = decisionLabel_;
        [decisionLabel_ release];
		self.decisionLabel.textColor = [iPadThemeBuildHelper commonTextFontColor1];
		self.decisionLabel.numberOfLines = 0;
		self.decisionLabel.font = [UIFont systemFontOfSize:constMediumFontSize];
		self.decisionLabel.textAlignment = UITextAlignmentLeft;
		self.decisionLabel.backgroundColor = [UIColor clearColor];
		self.decisionLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		[[self contentView] addSubview:self.decisionLabel];
		
		UILabel* dateLabel_ = [[UILabel alloc] initWithFrame:CGRectZero];
		self.dateLabel = dateLabel_;
        [dateLabel_ release];
		self.dateLabel.textColor = [iPadThemeBuildHelper commonTextFontColor1];
		self.dateLabel.numberOfLines = 0;
		self.dateLabel.font = [UIFont systemFontOfSize:constMediumFontSize];
		self.dateLabel.textAlignment = UITextAlignmentLeft;
		self.dateLabel.backgroundColor = [UIColor clearColor];
		self.dateLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		[[self contentView] addSubview:self.dateLabel];

		UILabel* commentLabel_ = [[UILabel alloc] initWithFrame:CGRectZero];
		self.commentLabel = commentLabel_;
        [commentLabel_ release];
		self.commentLabel.textColor = [iPadThemeBuildHelper commonTextFontColor1];
		self.commentLabel.numberOfLines = 0;
		self.commentLabel.font = [UIFont systemFontOfSize:constMediumFontSize];
		self.commentLabel.textAlignment = UITextAlignmentLeft;
		self.commentLabel.backgroundColor = [UIColor clearColor];
		self.commentLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		[[self contentView] addSubview:self.commentLabel];
		
		
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
	self.positionLabel.frame = [self resizeLabelFrame:[[cellFrames objectAtIndex:1] CGRectValue] forText:self.positionLabel.text andFont:self.positionLabel.font];
	self.personLabel.frame =	[self resizeLabelFrame:[[cellFrames objectAtIndex:2] CGRectValue] forText:self.personLabel.text andFont:self.personLabel.font];
	self.decisionLabel.frame = [self resizeLabelFrame:[[cellFrames objectAtIndex:3] CGRectValue] forText:self.decisionLabel.text andFont:self.decisionLabel.font];
	self.dateLabel.frame = [self resizeLabelFrame:[[cellFrames objectAtIndex:4] CGRectValue] forText:self.dateLabel.text andFont:self.dateLabel.font];
	self.commentLabel.frame = [self resizeLabelFrame:[[cellFrames objectAtIndex:5] CGRectValue] forText:self.commentLabel.text andFont:self.commentLabel.font];
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
    
    self.positionLabel = nil;
	self.personLabel = nil;
	self.decisionLabel = nil;
	self.dateLabel = nil;
	self.commentLabel = nil;
    
    [super dealloc];
}


@end
