//
//  iPadInboxExecutionTabLayoutView.m
//  iDoc
//
//  Created by mark2 on 12/21/10.
//  Copyright 2010 KORUS Consulting. All rights reserved.
//

#import "iPadInboxEndorsementTabLayoutView.h"
#import "iPadDocEndorsementCell.h"
#import "Constants.h"
#import "iPadThemeBuildHelper.h"

@interface iPadInboxEndorsementTabLayoutView(PrivateMethods)
- (HFSUILabel *)tableHeaderLabelWithFrame:(CGRect)lFrame forText:(NSString *)tValue;
@end

@implementation iPadInboxEndorsementTabLayoutView
@synthesize tableHeaderPlaceholder, tablePlaceholder;

- (id)init {
    if ((self = [super init])) {
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

		tableHeaderPlaceholder = [[UIView alloc] init];
		tableHeaderPlaceholder.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		[self addSubview:tableHeaderPlaceholder];
		
		headerBottomBorder = [[UIView alloc] initWithFrame:CGRectZero];
		headerBottomBorder.backgroundColor = [iPadThemeBuildHelper commonSeparatorColor];
		[tableHeaderPlaceholder addSubview:headerBottomBorder];
		
		tableHeader1 = [self tableHeaderLabelWithFrame:CGRectZero forText:NSLocalizedString(@"EndorsementStatusCellTitle", nil)];
		tableHeader2 = [self tableHeaderLabelWithFrame:CGRectZero forText:NSLocalizedString(@"PositionCellTitle", nil)];
		tableHeader3 = [self tableHeaderLabelWithFrame:CGRectZero forText:NSLocalizedString(@"PersonCellTitle", nil)];
		tableHeader4 = [self tableHeaderLabelWithFrame:CGRectZero forText:NSLocalizedString(@"DecisionCellTitle", nil)];
		tableHeader5 = [self tableHeaderLabelWithFrame:CGRectZero forText:NSLocalizedString(@"DateCellTitle", nil)];
		tableHeader6 = [self tableHeaderLabelWithFrame:CGRectZero forText:NSLocalizedString(@"CommentCellTitle", nil)];
		
		[tableHeaderPlaceholder addSubview:tableHeader1];
		[tableHeaderPlaceholder addSubview:tableHeader2];
		[tableHeaderPlaceholder addSubview:tableHeader3];
		[tableHeaderPlaceholder addSubview:tableHeader4];
		[tableHeaderPlaceholder addSubview:tableHeader5];
		[tableHeaderPlaceholder addSubview:tableHeader6];		
		
		tablePlaceholder = [[UIView alloc] initWithFrame:CGRectZero];
		tablePlaceholder.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[self addSubview:tablePlaceholder];
	}
    return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];

	CGRect tableHeaderFrame = CGRectMake(0.0f, 0.0f, self.frame.size.width, 50.0f);
	CGRect tableHeaderBounds = CGRectInset(tableHeaderFrame, 10.0f, 0.0f);
	tableHeaderPlaceholder.frame = tableHeaderFrame;
	headerBottomBorder.frame = CGRectOffset(CGRectInset(tableHeaderBounds, 2.5f, tableHeaderFrame.size.height/2-0.5), 2.5f, tableHeaderFrame.size.height/2-0.5);
	
	NSArray *cellFrames = [iPadDocEndorsementCell prepareCellFrames:tableHeaderBounds];
	
	tableHeader1.frame = [[cellFrames objectAtIndex:0] CGRectValue];
	tableHeader2.frame = [[cellFrames objectAtIndex:1] CGRectValue];
	tableHeader3.frame = [[cellFrames objectAtIndex:2] CGRectValue];
	tableHeader4.frame = [[cellFrames objectAtIndex:3] CGRectValue];
	tableHeader5.frame = [[cellFrames objectAtIndex:4] CGRectValue];
	tableHeader6.frame = [[cellFrames objectAtIndex:5] CGRectValue];
	
	CGRect tablePlaceholderFrame = CGRectMake(10.0f, tableHeaderFrame.size.height, self.frame.size.width - 20.0f, self.frame.size.height - 100.0f);
	tablePlaceholder.frame = tablePlaceholderFrame;	
}


- (HFSUILabel *)tableHeaderLabelWithFrame:(CGRect)lFrame forText:(NSString *)tValue {
	HFSUILabel *newLabel = [HFSUILabel labelWithFrame:lFrame forText:tValue withColor:[iPadThemeBuildHelper commonTableHeaderFontColor] andShadow:nil];
	newLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
	newLabel.font = [UIFont systemFontOfSize:constMediumFontSize];
	newLabel.textAlignment = UITextAlignmentLeft;
	newLabel.text = tValue;
    
	return newLabel;
}

- (void)dealloc {		
	[tableHeaderPlaceholder release];
	[headerBottomBorder release];
	[tablePlaceholder release];
	[super dealloc];
}

@end
