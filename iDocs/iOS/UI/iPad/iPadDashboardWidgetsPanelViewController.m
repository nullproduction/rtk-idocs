//
//  iPadDashboardWidgetsPanelViewController.m
//  iDoc
//
//  Created by mark2 on 1/26/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import "iPadDashboardWidgetsPanelViewController.h"
#import "iPadDashboardWidgetsPanelLayoutView.h"
#import "iPadDashboardLayoutView.h"

@implementation iPadDashboardWidgetsPanelViewController

- (id)initWithPlaceholder:(iPadDashboardLayoutView *)placeholderView dashboard:(Dashboard *)newDashboard andCurrentPath:(NSArray *)curPath andDelegate:(id<iPadDashboardWidgetViewDelegate>)newDelegate {
	if ((self = [super initWithNibName:nil bundle:nil])) {
	 	iPadDashboardWidgetsPanelLayoutView *container = 
            [[iPadDashboardWidgetsPanelLayoutView alloc] initDashboardWidgetsByItems:newDashboard andCurrentPath:curPath withDelegate:newDelegate];
		container.frame = placeholderView.contentBodyPanel.bounds;
		self.view = container;
		[placeholderView addContentPanel:container];
        [container release];
	}
	return self;
}

- (void)loadValues {
    iPadDashboardWidgetsPanelLayoutView *container = (iPadDashboardWidgetsPanelLayoutView *)self.view;
    [container loadValuesForTaskGroupWidgets];
    [container setNeedsLayout];
}

- (void)dealloc {
    [super dealloc];
}

@end
