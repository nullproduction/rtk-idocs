//
//  iPadInboxItemPanelButtonsLayoutView.m
//  iDoc
//
//  Created by mark2 on 12/21/10.
//  Copyright 2010 KORUS Consulting. All rights reserved.
//

#import "iPadInboxItemPanelButtonsLayoutView.h"
#import "HFSUILabel.h"
#import "Constants.h"
#import "iPadThemeBuildHelper.h"

@implementation iPadInboxItemPanelButtonsLayoutView

@synthesize attachmentsButton; 
@synthesize endorsementButton;
@synthesize executionButton;
@synthesize requisitesButton;

- (id)init {
    if ((self = [super init])) {
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		
		attachmentsButton = 
            [HFSUIButton prepareButtonWithBackImageForNormalState:[iPadThemeBuildHelper nameForImage:@"bottom_toolbar_left_button_normal.png"]
                                        backImageForSelectedState:[iPadThemeBuildHelper nameForImage:@"bottom_toolbar_left_button_selected.png"] 
                                                          caption:@"AttachmentsButtonTitle"
                                                     captionColor:[iPadThemeBuildHelper commonButtonFontColor1]
                                               captionShadowColor:[iPadThemeBuildHelper commonShadowColor1]
                                                             icon:nil];
		attachmentsButton.buttonTitle.font = [UIFont boldSystemFontOfSize:constMediumFontSize];
        attachmentsButton.buttonTitle.textAlignment = UITextAlignmentCenter;
        attachmentsButton.buttonTitle.font = [UIFont boldSystemFontOfSize:constMediumFontSize];          
        attachmentsButton.leftMargin = -5;
        attachmentsButton.buttonTitleOffset = -5;
        [self addSubview:attachmentsButton];

		endorsementButton = 
            [HFSUIButton prepareButtonWithBackImageForNormalState:[iPadThemeBuildHelper nameForImage:@"bottom_toolbar_middle_button_normal.png"] 
                                        backImageForSelectedState:[iPadThemeBuildHelper nameForImage:@"bottom_toolbar_middle_button_selected.png"] 
                                                          caption:@"EndorsementButtonTitle" 
                                                     captionColor:[iPadThemeBuildHelper commonButtonFontColor1]
                                               captionShadowColor:[iPadThemeBuildHelper commonShadowColor1]
                                                             icon:nil];
		endorsementButton.buttonTitle.font = [UIFont boldSystemFontOfSize:constMediumFontSize];
        endorsementButton.buttonTitle.textAlignment = UITextAlignmentCenter;        
        endorsementButton.leftMargin = -5;
        endorsementButton.buttonTitleOffset = -5;
        [self addSubview:endorsementButton];

		executionButton = 
            [HFSUIButton prepareButtonWithBackImageForNormalState:[iPadThemeBuildHelper nameForImage:@"bottom_toolbar_middle_button_normal.png"] 
                                        backImageForSelectedState:[iPadThemeBuildHelper nameForImage:@"bottom_toolbar_middle_button_selected.png"]
                                                          caption:@"ExecutionButtonTitle" 
                                                     captionColor:[iPadThemeBuildHelper commonButtonFontColor1]
                                               captionShadowColor:[iPadThemeBuildHelper commonShadowColor1]
                                                             icon:nil];
		executionButton.buttonTitle.font = [UIFont boldSystemFontOfSize:constMediumFontSize];
        executionButton.buttonTitle.textAlignment = UITextAlignmentCenter;        
        executionButton.leftMargin = -5;
        executionButton.buttonTitleOffset = -5;
        [self addSubview:executionButton];
        
		requisitesButton = 
            [HFSUIButton prepareButtonWithBackImageForNormalState:[iPadThemeBuildHelper nameForImage:@"bottom_toolbar_right_button_normal.png"]
                                        backImageForSelectedState:[iPadThemeBuildHelper nameForImage:@"bottom_toolbar_right_button_selected.png"] 
                                                          caption:@"RequisitesButtonTitle" 
                                                     captionColor:[iPadThemeBuildHelper commonButtonFontColor1]
                                               captionShadowColor:[iPadThemeBuildHelper commonShadowColor1]
                                                             icon:nil];
		requisitesButton.buttonTitle.font = [UIFont boldSystemFontOfSize:constMediumFontSize];
        requisitesButton.buttonTitle.textAlignment = UITextAlignmentCenter;        
        requisitesButton.leftMargin = -5;
        requisitesButton.buttonTitleOffset = -5;
        [self addSubview:requisitesButton];	
    }
    return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];

    CGRect f1, f2, f3, f4;
    CGRectDivide(CGRectOffset(CGRectInset(self.bounds, 5, 2.5f), 0, -2.5f), &f1, &f2, 103.0f, CGRectMinXEdge);
	attachmentsButton.frame = f1;
    CGRectDivide(f2, &f2, &f3, 124.0f, CGRectMinXEdge);
	endorsementButton.frame = f2;
    CGRectDivide(f3, &f3, &f4, 124.0f, CGRectMinXEdge);
	executionButton.frame = f3;
    requisitesButton.frame = f4;
}

- (void)dealloc {
    [super dealloc];
}


@end
