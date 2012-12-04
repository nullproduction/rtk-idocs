//
//  iPadDashboardIconView.m
//  iDoc
//
//  Created by rednekis on 10-12-20.
//  Copyright 2010 KORUS Consulting. All rights reserved.
//

#import "iPadDashboardWidgetView.h"
#import "Constants.h"
#import "iPadThemeBuildHelper.h"

#define constDefaultWidgetIcon @"icon_general_folder.png"

@implementation iPadDashboardWidgetView

#pragma mark custom methods - init
- (id)initWithOrigin:(CGPoint)origin andMetaData:(DashboardItem *)data { 
	NSLog(@"iPadDashboardTaskGroupWidget init with groupId: %@", data.id);
	float width = 325.0f;
	float height = 170.0f;
	CGRect frame = CGRectMake(origin.x, origin.y, width, height);
    if ((self = [super initWithFrame:frame])) {
        self.autoresizingMask = UIViewAutoresizingNone;
		self.autoresizesSubviews = NO;
		self.backgroundColor = [UIColor clearColor];

		widgetInfo = data;
		
		CGRect widgetIconImageViewFrame = CGRectMake(10.0f, (height - 81.0f)/2, 81.0f, 81.0f);
		widgetIconImageView = [[UIImageView alloc] initWithFrame:widgetIconImageViewFrame];
        UIImage *widgetImage = [UIImage imageNamed:[iPadThemeBuildHelper nameForImage:widgetInfo.dashboardIcon]];
        if (widgetImage == nil)
            widgetImage = [UIImage imageNamed:[iPadThemeBuildHelper nameForImage:constDefaultWidgetIcon]];
		widgetIconImageView.image = widgetImage;
		[self addSubview:widgetIconImageView];
		
		CGRect widgetNameLabelFrame = CGRectMake(101.0f, (height - 81.0f)/2, width - 111.0f, 40.0f);		
		widgetNameLabel = 
			[HFSUILabel labelWithFrame:widgetNameLabelFrame forText:nil withColor:[iPadThemeBuildHelper dashboardWidgetTitleFontColor] andShadow:nil];
        [self setAllItemsQuantity:0];
		widgetNameLabel.numberOfLines = 2;
		widgetNameLabel.lineBreakMode = UILineBreakModeWordWrap;
		widgetNameLabel.font = [UIFont boldSystemFontOfSize:constLargeFontSize];								  
		[self addSubview:widgetNameLabel];		
		
		CGRect newItemsQuantityLabelFrame = CGRectMake(101.0f, (height - 81.0f)/2 + 40.0f, width - 111.0f, 20.0f);		
		newItemsQuantityLabel = 
			[HFSUILabel labelWithFrame:newItemsQuantityLabelFrame forText:nil withColor:[iPadThemeBuildHelper dashboardWidgetTextFontNormalColor] andShadow:nil];
		[self setNewItemsQuantity:0];
        newItemsQuantityLabel.font = [UIFont boldSystemFontOfSize:constMediumFontSize];								  
		[self addSubview:newItemsQuantityLabel];
		
		CGRect overdueItemsQuantityLabelFrame = CGRectMake(101.0f, (height - 81.0f)/2 + 60.0f, width - 111.0f, 20.0f);		
		overdueItemsQuantityLabel = 
			[HFSUILabel labelWithFrame:overdueItemsQuantityLabelFrame forText:nil withColor:[iPadThemeBuildHelper dashboardWidgetTextFontNormalColor] andShadow:nil];
        [self setOverdueItemsQuantity:0];
        overdueItemsQuantityLabel.font = [UIFont boldSystemFontOfSize:constMediumFontSize];	
		[self addSubview:overdueItemsQuantityLabel];
		
		widgetButton = [UIButton buttonWithType:UIButtonTypeCustom];
		widgetButton.frame = self.bounds;
		widgetButton.enabled = NO;
		[widgetButton addTarget:self action:@selector(widgetButtonPressed) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:widgetButton];
    }
    return self;
}

#pragma mark custom methods - view behavior
- (void)setDelegate:(id<iPadDashboardWidgetViewDelegate>)newDelegate {
	delegate = newDelegate;
}

- (void)widgetButtonPressed {
	NSLog(@"iPadDashboardTaskGroupWidget with groupId: %@ widgetButtonPressed", widgetInfo.id);
        if ([widgetInfo.type isEqualToString:constWidgetTypeORDGroup]) {
            if (delegate != nil && [delegate respondsToSelector:@selector(dashboardWidgetPressedForInboxModule:)])
                [delegate dashboardWidgetPressedForInboxModule:widgetInfo];
        }
        else if ([widgetInfo.type isEqualToString:constWidgetTypeWebDavFolder]) {
            if (delegate != nil && [delegate respondsToSelector:@selector(dashboardWidgetPressedForDocModule:)])            
                [delegate dashboardWidgetPressedForDocModule:widgetInfo];
        }
        else {
            if (delegate != nil && [delegate respondsToSelector:@selector(dashboardWidgetPressedForFolder:)])            
                [delegate dashboardWidgetPressedForFolder:widgetInfo];
        }
}

- (void)enableWidget:(BOOL)enable {
	widgetButton.enabled = enable;
}

- (void)setAllItemsQuantity:(int)quantity {
	NSString *name;
    if ([widgetInfo.type isEqualToString:constWidgetTypeFolder] || [widgetInfo.type isEqualToString:constWidgetTypeWebDavFolder]) {
        name = widgetInfo.name;
    }
    else {
        name = [NSString stringWithFormat:@"%@ (%i)", widgetInfo.name, quantity];
    }
	widgetNameLabel.text = name;	
}

- (void)setNewItemsQuantity:(int)quantity {
	NSString *name;
    if ([widgetInfo.type isEqualToString:constWidgetTypeFolder] || [widgetInfo.type isEqualToString:constWidgetTypeWebDavFolder]) {
        name = nil;
    }
    else {
        name = [NSString stringWithFormat:@"%@ (%i)", NSLocalizedString(@"NewItemsQuantityTitle", nil), quantity];
    }
	newItemsQuantityLabel.text = name;	
}

- (void)setNewItemsQuantityTextColor:(UIColor *)color {
	newItemsQuantityLabel.textColor = color;	
}

- (void)setOverdueItemsQuantity:(int)quantity {
	NSString *name;
    if ([widgetInfo.type isEqualToString:constWidgetTypeFolder] || [widgetInfo.type isEqualToString:constWidgetTypeWebDavFolder]) {
        name = nil;
    }
    else {
        name = [NSString stringWithFormat:@"%@ (%i)", NSLocalizedString(@"OverdueItemsQuantityTitle", nil), quantity];
    }
	overdueItemsQuantityLabel.text = name;	
}

- (void)setOverdueItemsQuantityTextColor:(UIColor *)color {
	overdueItemsQuantityLabel.textColor = color;	
}

- (void)enableNewItemsLabel:(BOOL)enable {
    if( !enable ) {
        newItemsQuantityLabel.hidden = YES;
    }
    else {
        newItemsQuantityLabel.hidden = NO;
    }
}

- (void)dealloc {
	[widgetIconImageView release];
    
//    [self setDelegate:nil];
    
    [super dealloc];
}


@end
