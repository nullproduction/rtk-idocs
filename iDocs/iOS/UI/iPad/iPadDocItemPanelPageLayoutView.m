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
		self.bodyPanel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[self addSubview:self.bodyPanel];
        
        self.openInExtAppButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.openInExtAppButton setImage:[UIImage imageNamed:[iPadThemeBuildHelper nameForImage:@"open_in_external_app_button"]]
                            forState:UIControlStateNormal];
	}
	return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	self.bodyPanel.frame = self.bounds;
    self.openInExtAppButton.frame = CGRectMake(self.bodyPanel.bounds.origin.x + self.bodyPanel.bounds.size.width - 77,
                                          self.bodyPanel.bounds.origin.y + self.bodyPanel.bounds.size.height - 38, 
                                          26, 22);
}

- (void)dealloc {
	self.bodyPanel = nil;
    self.openInExtAppButton = nil;
    
    [super dealloc];
}


@end
