//
//  iPadDocItemPanelPageLayoutView.m
//  iDoc
//
//  Created by mark2 on 12/21/10.
//  Copyright 2010 KORUS Consulting. All rights reserved.
//

#import "iPadDocItemPanelPageLayoutView.h"
#import "SupportFunctions.h"
#import "iPadThemeBuildHelper.h"

@implementation iPadDocItemPanelPageLayoutView

@synthesize bodyPanel, openInExtAppButton;

- (id)init {
	if ((self = [super init])) {
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        UIView *view = [[UIView alloc] init];
		self.bodyPanel = view;
        [view release];
		bodyPanel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[self addSubview:bodyPanel];
        
        self.openInExtAppButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [openInExtAppButton setImage:[UIImage imageNamed:[iPadThemeBuildHelper nameForImage:@"open_in_external_app_button"]]
                            forState:UIControlStateNormal];
	}
	return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	bodyPanel.frame = self.bounds;
    openInExtAppButton.frame = CGRectMake(bodyPanel.bounds.origin.x + bodyPanel.bounds.size.width - 77, 
                                          bodyPanel.bounds.origin.y + bodyPanel.bounds.size.height - 38, 
                                          26, 22);
}

- (void)dealloc {
	self.bodyPanel = nil;
    self.openInExtAppButton = nil;
    
    [super dealloc];
}


@end
