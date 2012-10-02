//
//  iPadDashboardIconView.h
//  iDoc
//
//  Created by rednekis on 10-12-20.
//  Copyright 2010 KORUS Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFSUILabel.h"
#import "DashboardItem.h"

@class iPadDashboardWidgetView;
@protocol iPadDashboardWidgetViewDelegate <NSObject>
- (void)dashboardWidgetPressedForInboxModule:(DashboardItem *)group;
- (void)dashboardWidgetPressedForFolder:(DashboardItem *)folder;
- (void)dashboardWidgetPressedForDocModule:(DashboardItem *)group;
@end

@interface iPadDashboardWidgetView : UIView {
	id<iPadDashboardWidgetViewDelegate> delegate;	
    DashboardItem *widgetInfo;
	UIImageView *widgetIconImageView;
	HFSUILabel *widgetNameLabel;
	HFSUILabel *newItemsQuantityLabel;
	HFSUILabel *overdueItemsQuantityLabel;
	UIButton *widgetButton;
}

- (id)initWithOrigin:(CGPoint)origin andMetaData:(DashboardItem *)data;
- (void)setDelegate:(id<iPadDashboardWidgetViewDelegate>)newDelegate;
- (void)enableWidget:(BOOL)enable;
- (void)setAllItemsQuantity:(int)quantity;
- (void)setNewItemsQuantity:(int)quantity;
- (void)setOverdueItemsQuantity:(int)quantity;
- (void)setNewItemsQuantityTextColor:(UIColor *)color;
- (void)setOverdueItemsQuantityTextColor:(UIColor *)color;
@end
