//
//  iPadInboxItemPanelContentButtonsLayoutView.m
//  iDoc
//
//  Created by mark2 on 1/14/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import "iPadInboxModuleActionButtonsLayoutView.h"
#import "Constants.h"
#import "SupportFunctions.h"
#import "iPadThemeBuildHelper.h"
#import "TaskAction.h"
#import <QuartzCore/QuartzCore.h>


@interface iPadInboxModuleActionButtonsLayoutView(PrivateMethods)
- (HFSUIButton *)prepareButtonForMetadata:(TaskAction *)buttonMeta;
@end

@implementation iPadInboxModuleActionButtonsLayoutView

@synthesize buttons;

- (id)init {
    if ((self = [super init])) {
        statusLabel = [HFSUILabel labelWithFrame:CGRectZero 
                                         forText:nil 
                                       withColor:[iPadThemeBuildHelper commonHeaderFontColor1] 
                                       andShadow:[iPadThemeBuildHelper commonShadowColor2]];
        statusLabel.font = [UIFont boldSystemFontOfSize:constLargeFontSize];
        statusLabel.textAlignment = UITextAlignmentRight;
        statusLabel.hidden = YES;
        [self addSubview:statusLabel];

        buttonsContainer = [[UIView alloc] initWithFrame:self.bounds];
        buttonsContainer.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        buttonsContainer.hidden = YES;
        [self addSubview:buttonsContainer];        
        
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		buttons = [[NSMutableArray alloc] init];
    }
    return self;
}

- (HFSUIButton *)prepareButtonForMetadata:(TaskAction *)buttonMeta {
	NSString *buttonImageName = 
        ([buttonMeta.buttonColor isEqualToString:constTaskActionButtonColorRed] ? @"medium_color_button_1.png" : @"medium_color_button_2.png");
	HFSUIButton *newButton = [HFSUIButton prepareButtonWithBackImage:[iPadThemeBuildHelper nameForImage:buttonImageName] 
                                                             caption:buttonMeta.name 
                                                        captionColor:[iPadThemeBuildHelper commonButtonFontColor2]
                                                  captionShadowColor:[iPadThemeBuildHelper commonShadowColor2]
                                                                icon:nil];     
	newButton.buttonTitle.font = [UIFont systemFontOfSize:constMediumFontSize];
    newButton.buttonTitle.textAlignment = UITextAlignmentCenter;
	newButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
	return newButton;
}

- (void)removeButtonsAndStatus {
	[buttons removeAllObjects];
	for (UIView *subview in buttonsContainer.subviews) {
		[subview removeFromSuperview];
	}
    statusLabel.text = constEmptyStringValue;
    [self setNeedsLayout];
}

- (void)addButtons:(NSArray *)actions {
    statusLabel.hidden = YES;
    buttonsContainer.hidden = NO;
    
	[self removeButtonsAndStatus];
    for (int i = 0; i < [actions count]; i++) {
        //max 2 buttons
        if (i > 1) break;
        
        TaskAction *action = [actions objectAtIndex:i];
        HFSUIButton *newButton = [self prepareButtonForMetadata:action];
        [buttons addObject:newButton];
        [buttonsContainer addSubview:newButton];
	}
}

- (void)showActionStatus:(NSString *)status {
    statusLabel.hidden = NO;
    buttonsContainer.hidden = YES;    
	[self removeButtonsAndStatus];
    statusLabel.text = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"TaskStatusTitle", nil), status];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	int bCount = [buttons count];
    if (bCount > 0) {
        float bWidth = 132.0f; //ширина кнопки
        float bMargin = 5.0f; //поле и зазор между кнопками
        float buttonsWidth = (bWidth + bMargin) * bCount - bMargin; //ширина контрола с кнопками
        float buttonsOriginX = self.bounds.origin.x + self.bounds.size.width - buttonsWidth;
        buttonsContainer.frame = CGRectMake(buttonsOriginX, 0.0f, buttonsWidth, self.bounds.size.height);
        for (int i = 0; i < [buttons count]; i++) {
            ((HFSUIButton *)[buttons objectAtIndex:i]).frame = CGRectMake((bWidth + bMargin) * i, 13.0f, bWidth, 33.0f);
        } 
    }
    else {
        buttonsContainer.frame = CGRectZero;
    }
    
    statusLabel.frame = CGRectMake(0.0f, 0.0f, self.bounds.size.width, self.bounds.size.height);
}

#pragma mark -

- (void)dealloc {
    [buttonsContainer release];
	self.buttons = nil;
    [super dealloc];
}


@end
