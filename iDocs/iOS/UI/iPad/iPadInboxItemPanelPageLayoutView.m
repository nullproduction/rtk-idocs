//
//  iPadInboxItemPanelPageLayoutView.m
//  iDoc
//
//  Created by mark2 on 12/21/10.
//  Copyright 2010 KORUS Consulting. All rights reserved.
//

#import "iPadInboxItemPanelPageLayoutView.h"

@implementation iPadInboxItemPanelPageLayoutView

@synthesize bodyPanel;

- (id)init{
	if ((self = [super init])) {
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		
		//body
		UIView* view = [[UIView alloc] init];
        self.bodyPanel = view;
        [view release];
        
		self.bodyPanel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[self addSubview:self.bodyPanel];
    }
	return self;
}

- (void)layoutSubviews {
    NSLog(@"iPadInboxItemPanelPageLayoutView layoutSubviews");
	[super layoutSubviews];

	self.bodyPanel.frame = self.bounds;
}

- (void)dealloc {
	self.bodyPanel = nil;
    
    [super dealloc];
}


@end
