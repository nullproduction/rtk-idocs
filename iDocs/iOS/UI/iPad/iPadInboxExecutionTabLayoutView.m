//
//  iPadInboxExecutionTabLayoutView.m
//  iDoc
//
//  Created by mark2 on 12/21/10.
//  Copyright 2010 KORUS Consulting. All rights reserved.
//

#import "iPadInboxExecutionTabLayoutView.h"
#import "Constants.h"
#import "iPadDocExecutionCell.h"
#import "iPadThemeBuildHelper.h"

@interface iPadInboxExecutionTabLayoutView(PrivateMethods)
- (HFSUILabel *)tableHeaderLabelWithFrame:(CGRect)lFrame forText:(NSString *)tValue;
@end

@implementation iPadInboxExecutionTabLayoutView
@synthesize tableHeaderPlaceholder, tablePlaceholder, tableFilterButton;

- (id)init {
    if ((self = [super init])) {
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

		tableFilterPlaceholder = [[UIView alloc] init];
		tableFilterPlaceholder.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
		
//		tableFilterButton = 
//            [HFSUIButton prepareButtonWithIconForNormalState:[iPadThemeBuildHelper nameForImage:@"icon_mark_check_4.png"] 
//                                        iconForSelectedState:[iPadThemeBuildHelper nameForImage:@"icon_mark_check_3.png"] 
//                                                     caption:NSLocalizedString(@"OwnErrandsTitle", nil)
//                                                captionColor:[iPadThemeBuildHelper commonTextFontColor2]
//                                          captionShadowColor:nil];
//        tableFilterButton.buttonTitle.font = [UIFont systemFontOfSize:constMediumFontSize];
//		tableFilterButton.buttonTitle.textAlignment = UITextAlignmentCenter;
//		tableFilterButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
//		
//		[tableFilterPlaceholder addSubview:tableFilterButton];
		
		[self addSubview:tableFilterPlaceholder];
		
		tableHeaderPlaceholder = [[UIView alloc] init];
		tableHeaderPlaceholder.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		[self addSubview:tableHeaderPlaceholder];

		headerBottomBorder = [[UIView alloc] initWithFrame:CGRectZero];
		headerBottomBorder.backgroundColor = [iPadThemeBuildHelper commonSeparatorColor];
		[tableHeaderPlaceholder addSubview:headerBottomBorder];
		
		
		tableHeader0 = [self tableHeaderLabelWithFrame:CGRectZero forText:constEmptyStringValue];
		tableHeader1 = [self tableHeaderLabelWithFrame:CGRectZero forText:constEmptyStringValue];
		tableHeader2 = [self tableHeaderLabelWithFrame:CGRectZero forText:NSLocalizedString(@"NumberCellTitle", nil)];
		tableHeader3 = [self tableHeaderLabelWithFrame:CGRectZero forText:NSLocalizedString(@"AuthorCellTitle", nil)];
        tableHeader4 = [self tableHeaderLabelWithFrame:CGRectZero forText:NSLocalizedString(@"IsMajorExecutorCellTitle", nil)];
		tableHeader5 = [self tableHeaderLabelWithFrame:CGRectZero forText:NSLocalizedString(@"ExecutorCellTitle", nil)];
		tableHeader6 = [self tableHeaderLabelWithFrame:CGRectZero forText:NSLocalizedString(@"ErrandTextCellTitle", nil)];
        tableHeader7 = [self tableHeaderLabelWithFrame:CGRectZero forText:NSLocalizedString(@"ExecutionPeriodCellTitle", nil)];
        tableHeader8 = [self tableHeaderLabelWithFrame:CGRectZero forText:NSLocalizedString(@"AttachmentFilesCellTitle", nil)];
				
		[tableHeaderPlaceholder addSubview:tableHeader0];
		[tableHeaderPlaceholder addSubview:tableHeader1];
		[tableHeaderPlaceholder addSubview:tableHeader2];
		[tableHeaderPlaceholder addSubview:tableHeader3];
		[tableHeaderPlaceholder addSubview:tableHeader4];
		[tableHeaderPlaceholder addSubview:tableHeader5];
        [tableHeaderPlaceholder addSubview:tableHeader6];
        [tableHeaderPlaceholder addSubview:tableHeader7];
        [tableHeaderPlaceholder addSubview:tableHeader8];
								
		tablePlaceholder = [[UIView alloc] initWithFrame:CGRectZero];
		tablePlaceholder.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[self addSubview:tablePlaceholder];
    }
    return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];

	CGRect tableFilterPlaceholderFrame = CGRectMake(self.frame.size.width - 270.0f, 0.0f, self.frame.size.width, 50.0f);
	tableFilterPlaceholder.frame = tableFilterPlaceholderFrame;
	
	CGRect tableFilterButtonFrame = CGRectMake(40.0f, 20.0f, 200.0f, 24.0f);
	tableFilterButton.frame = tableFilterButtonFrame;

	CGRect tableHeaderFrame = CGRectMake(0.0f, 0.0f, self.frame.size.width, 40.0f);
	CGRect tableHeaderBounds = CGRectOffset(CGRectInset(tableHeaderFrame, 10.0f, 0.0f), -10.0f, 0.0f);
	tableHeaderPlaceholder.frame = CGRectOffset(tableHeaderBounds,10.0f, 60.0f);
	headerBottomBorder.frame = CGRectOffset(CGRectInset(tableHeaderBounds, 2.5f, tableHeaderFrame.size.height/2-0.5),2.5f,tableHeaderFrame.size.height/2-0.5);

	NSArray *cellFrames = [iPadDocExecutionCell prepareCellFrames:tableHeaderBounds];
		
	tableHeader0.frame = [[cellFrames objectAtIndex:0] CGRectValue];
	tableHeader1.frame = [[cellFrames objectAtIndex:1] CGRectValue];
	tableHeader2.frame = [[cellFrames objectAtIndex:2] CGRectValue];
	tableHeader3.frame = [[cellFrames objectAtIndex:3] CGRectValue];
	tableHeader4.frame = [[cellFrames objectAtIndex:4] CGRectValue];
	tableHeader5.frame = [[cellFrames objectAtIndex:5] CGRectValue];
    tableHeader6.frame = [[cellFrames objectAtIndex:6] CGRectValue];
    tableHeader7.frame = [[cellFrames objectAtIndex:7] CGRectValue];
    tableHeader8.frame = [[cellFrames objectAtIndex:8] CGRectValue];

	CGRect executionTablePlaceholderFrame = CGRectMake(10.0f, 100.0f, self.frame.size.width - 20.0f, self.frame.size.height - 100.0f);
	tablePlaceholder.frame = executionTablePlaceholderFrame;
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
	[tableFilterPlaceholder release];
	[headerBottomBorder release];
	[tableHeaderPlaceholder release];
	[tablePlaceholder release];
    
    [super dealloc];
}


@end
