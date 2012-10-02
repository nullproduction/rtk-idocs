//
//  iPadDashboardWidgetsPanelLayoutView.h
//  iDoc
//
//  Created by mark2 on 1/27/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
// 

#import <UIKit/UIKit.h>
#import "BaseLayoutView.h"
#import "iPadDashboardWidgetView.h"
#import "DashboardItem.h"
#import "Dashboard.h"

@interface iPadDashboardWidgetsPanelLayoutView : BaseLayoutView {
	NSArray *dashboardItems;
    int widgetsStartTag;
	int separatorsStartTag;
    
    HFSUILabel *dashboardNameLabel;
    UIView *dashboardBackLabelPanel;
}

- (id)initDashboardWidgetsByItems:(Dashboard *)newDashboard andCurrentPath:(NSArray *)curPath withDelegate:(id<iPadDashboardWidgetViewDelegate>)widgetDelegate;
- (void)loadValuesForTaskGroupWidgets;
@end
