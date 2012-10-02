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
		bodyPanel = [[UIView alloc] init];
		bodyPanel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[self addSubview:bodyPanel];
    }
	return self;
}

- (void)layoutSubviews{

	[super layoutSubviews];

	bodyPanel.frame = self.bounds;
}

- (void)dealloc {
	[bodyPanel release];
    [super dealloc];
}


@end
