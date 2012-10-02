//
//  iPadDashboardWidgetsPanelViewController.h
//  iDoc
//
//  Created by mark2 on 1/26/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iPadBaseViewController.h"
#import "ClientSettingsDataEntity.h"
#import "iPadDashboardWidgetView.h"

@interface iPadDashboardWidgetsPanelViewController : iPadBaseViewController {		
}

- (id)initWithPlaceholder:(UIView *)placeholderView dashboard:(Dashboard *)newDashboard andCurrentPath:(NSArray *)curPath andDelegate:(id<iPadDashboardWidgetViewDelegate>)newDelegate;
- (void)loadValues;

@end
