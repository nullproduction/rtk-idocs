//
//  iPadInboxRequisitesTabLayoutView.m
//  iDoc
//
//  Created by mark2 on 12/21/10.
//  Copyright 2010 KORUS Consulting. All rights reserved.
//

#import "iPadInboxRequisitesTabLayoutView.h"
#import "Constants.h"
#import "iPadThemeBuildHelper.h"

@implementation iPadInboxRequisitesTabLayoutView
@synthesize executorFieldIcon, executorFieldLabel, executorName, taskDocDescription, requisitesTablePlaceholder;

- (id)init {
    if((self = [super init])) {
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

		//executor icon
		executorFieldIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[iPadThemeBuildHelper nameForImage:@"executor_icon.png"]]];
		executorFieldIcon.autoresizingMask = UIViewAutoresizingNone;
		[self addSubview:executorFieldIcon];
		
		//executor title
		executorFieldLabel = [HFSUILabel labelWithFrame:CGRectZero forText:NSLocalizedString(@"ExecutorFieldTitle", nil) withColor:[iPadThemeBuildHelper commonTextFontColor1] andShadow:nil];
		executorFieldLabel.font = [UIFont systemFontOfSize:constLargeFontSize];
		executorFieldLabel.autoresizingMask = UIViewAutoresizingNone;
		[self addSubview:executorFieldLabel];
		
		//executor fio
		executorName = 
            [HFSUILabel labelWithFrame:CGRectZero forText:nil withColor:[iPadThemeBuildHelper commonTextFontColor1] andShadow:nil];
		executorName.font = [UIFont systemFontOfSize:constLargeFontSize];
		executorName.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addSubview:executorName];
		
		//separator
		separator = [[UIView alloc] initWithFrame:CGRectZero];
		separator.backgroundColor = [iPadThemeBuildHelper commonSeparatorColor];
		separator.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addSubview:separator];
		
		//doc description		
		taskDocDescription = [HFSUILabel labelWithFrame:CGRectZero forText:nil withColor:[iPadThemeBuildHelper commonTextFontColor1] andShadow:nil];
		taskDocDescription.font = [UIFont systemFontOfSize:constMediumFontSize];
		taskDocDescription.numberOfLines = 30;
		taskDocDescription.lineBreakMode = UILineBreakModeWordWrap;
		taskDocDescription.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addSubview:taskDocDescription];
				
		//requisites table placeholder
		requisitesTablePlaceholder = [[UIView alloc] initWithFrame:CGRectZero];
		requisitesTablePlaceholder.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:requisitesTablePlaceholder];
    }
    return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	CGRect executorFieldIconFrame = CGRectMake(25.0f, 12.0f, 31.0f, 31.0f);		
	CGRect executorFieldLabelFrame = CGRectMake(65.0f, 10.0f, 115.0f, 36.0f);
	CGRect executorNameFrame = CGRectMake(185.0f, 10.0f, self.frame.size.width - 210.0f, 36.0f);
	CGRect separatorFrame = CGRectMake(10.0f, 55.0f, self.frame.size.width - 20.0f, 1.0f);
	CGRect taskDocDescriptionFrame = CGRectMake(30.0f, 59.0f, self.frame.size.width - 60.0f, 0.0f);
	CGRect requisitesTableViewFrame = CGRectMake(10.0f, 61.0f, self.frame.size.width - 20.0f, self.frame.size.height - 100.0f);

    CGFloat height = 0.0f;
    if( taskDocDescription.text ) {
        CGSize maximumLabelSize = CGSizeMake(taskDocDescriptionFrame.size.width, 9999);
        CGSize expectedLabelSize = [taskDocDescription.text sizeWithFont:[UIFont fontWithName:taskDocDescription.font.fontName size:taskDocDescription.font.pointSize] constrainedToSize:maximumLabelSize lineBreakMode:UILineBreakModeWordWrap];
        height = expectedLabelSize.height;
    }
    if( height > 36.0f ) {
        taskDocDescriptionFrame.size.height = height;
        requisitesTableViewFrame.origin.y += height;
        requisitesTableViewFrame.size.height -= height;
    }
    else {
        taskDocDescriptionFrame.size.height = 36.0f;
        requisitesTableViewFrame.origin.y += 36.0f;
        requisitesTableViewFrame.size.height -= 36.0f;
    }
    
    executorFieldIcon.frame = executorFieldIconFrame;
	executorFieldLabel.frame = executorFieldLabelFrame;
	executorName.frame = executorNameFrame;
	separator.frame = separatorFrame;
	taskDocDescription.frame = taskDocDescriptionFrame;
	requisitesTablePlaceholder.frame = requisitesTableViewFrame;
}


- (void)dealloc {
	[executorFieldIcon release];
	[separator release];
	[requisitesTablePlaceholder release];
    [super dealloc];
}


@end
