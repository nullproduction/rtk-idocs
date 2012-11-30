//
//  iPadDashboardWidgetsPanelLayoutView.m
//  iDoc
//
//  Created by mark2 on 1/27/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import "iPadDashboardWidgetsPanelLayoutView.h"
#import "Constants.h"
#import "ClientSettingsDataEntity.h"
#import "TaskDataEntity.h"
#import "CoreDataProxy.h"
#import "iPadThemeBuildHelper.h"

@interface iPadDashboardWidgetsPanelLayoutView(PrivateMethods)
- (void)layoutDashBoardWidgets;
- (NSString *)dashboardName:(Dashboard *)curDashboard andCurrentPath:(NSArray *)curPath;
@end


@implementation iPadDashboardWidgetsPanelLayoutView

- (void)layoutSubviews {
	[super layoutSubviews];
    [self layoutDashBoardWidgets];
}

- (id)initDashboardWidgetsByItems:(Dashboard *)newDashboard andCurrentPath:(NSArray *)curPath withDelegate:(id<iPadDashboardWidgetViewDelegate>)widgetDelegate {
	NSLog(@"iPadDashboardWidgetsPanelLayoutView initDashboardWidgetsInContentPanel");	
	if ((self = [super init])) {
		widgetsStartTag = 100;
		separatorsStartTag = 200;

        ClientSettingsDataEntity *clientSettings = 
            [[ClientSettingsDataEntity alloc] initWithContext:[[CoreDataProxy sharedProxy] workContext]];
        
        DashboardItem *lastFolder = (DashboardItem *)[curPath lastObject];
        if (lastFolder) 
            dashboardItems = [[clientSettings childsInDashboardItemWithId:lastFolder.id] mutableCopy];
        else
            dashboardItems = [[clientSettings parentDashboardItemsForDashboardWithId:[newDashboard.id intValue]] mutableCopy];
        [clientSettings release];
        
		dashboardBackLabelPanel = [[UIView alloc] init];
		dashboardBackLabelPanel.autoresizingMask = UIViewAutoresizingNone;
        dashboardBackLabelPanel.backgroundColor = [iPadThemeBuildHelper dashboardHeaderBackColor];
        [self addSubview:dashboardBackLabelPanel];

        UIColor *fontColor = [iPadThemeBuildHelper dashboardHeaderFontColor];
        dashboardNameLabel = [HFSUILabel labelWithFrame:CGRectZero forText:[self dashboardName:newDashboard andCurrentPath:curPath] withColor:fontColor andShadow:nil];
        dashboardNameLabel.font = [UIFont boldSystemFontOfSize:constMediumFontSize];
		dashboardNameLabel.autoresizingMask = UIViewAutoresizingNone;
		[self addSubview:dashboardNameLabel];
		
        int totalElements = [dashboardItems count];
		for (int i = 0; i < totalElements; i++) {
			//add widgets
            DashboardItem *item = (DashboardItem *)[dashboardItems objectAtIndex:i];
			iPadDashboardWidgetView *widgetView = [[iPadDashboardWidgetView alloc] initWithOrigin:CGPointMake(0.0f, 0.0f) andMetaData:item];			
			[widgetView setDelegate:widgetDelegate];
			widgetView.tag = widgetsStartTag + i;
            
			[self addSubview:widgetView];
            [widgetView release];
		}
		for (int j = 0; j < 4; j++) {
			UIView *separator = [[UIView alloc] init];
			separator.tag = separatorsStartTag + j;
			separator.backgroundColor = [iPadThemeBuildHelper commonSeparatorColor];
			separator.frame = CGRectZero;
			[self addSubview:separator];
            [separator release];
		}
	}		
	return self;
}

- (NSString *)dashboardName:(Dashboard *)curDashboard andCurrentPath:(NSArray *)curPath{
    NSString *dashboardName = curDashboard.name;
    for (DashboardItem *items in curPath) {
        dashboardName  = [dashboardName stringByAppendingFormat: @" / %@", items.name];
    }
    return dashboardName;
}


- (void)layoutDashBoardWidgets {
	NSLog(@"iPadDashboardWidgetsPanelLayoutView layoutDashBoardWidgetsInPanel");
	BOOL isPortaitOrientation = [self isInPortraitOrientation];

	dashboardBackLabelPanel.frame = CGRectInset(CGRectMake(0.0f, 0.0f, self.bounds.size.width, 50.0f), 2, 2);
    dashboardNameLabel.frame = CGRectInset(CGRectMake(0.0f, 0.0f, dashboardBackLabelPanel.bounds.size.width, dashboardBackLabelPanel.bounds.size.height), 20, 0);
    
	//clear old separators
	for (int j = 0; j < (isPortaitOrientation ? 3 : 4); j++) {
		UIView *separator = [self viewWithTag:separatorsStartTag + j];
		separator.frame = CGRectZero;
	}
	
	int separatorIndex = 0;
	int numberOfWidgetsInRow = (isPortaitOrientation ? 2 : 3);
	int currentWidgetInRow = 0;

	int totalElements = [dashboardItems count];
	for (int i = 0; i < totalElements; i++) {
		UIView *widgetView = [self viewWithTag:widgetsStartTag + i];
		
		++currentWidgetInRow;
		if (currentWidgetInRow > numberOfWidgetsInRow) {
			currentWidgetInRow = 1;
		}
		float offsetX = (isPortaitOrientation ? 60.0f : 30.0f);
		float offsetY = (isPortaitOrientation ? 14.0f : 34.0f);
		float scaleY = (isPortaitOrientation ? 1.0f : 20.0f);
		float originX = offsetX + (widgetView.frame.size.width + 1.0f) * (currentWidgetInRow - 1); 
		float originY = offsetY + (widgetView.frame.size.height + scaleY) * floor(i / numberOfWidgetsInRow);
		CGPoint origin = CGPointMake(originX, originY);

		CGRect wframe = widgetView.frame;
		wframe.origin = origin;
		[widgetView setFrame:wframe];

		if (i > 0 && currentWidgetInRow == 1) {
			UIView *separator = [self viewWithTag:separatorsStartTag + separatorIndex];
			separator.frame = CGRectMake(20, wframe.origin.y-offsetY/2, self.frame.size.width-20.0f*2, 1.0f);
			separatorIndex++;
		}
		
	}
}

- (void)loadValuesForTaskGroupWidgets {
	NSLog(@"iPadDashboardWidgetsPanelLayoutView loadValuesForTaskGroupWidgets"); 

    for (int i = 0; i < [dashboardItems count]; i++) {
		iPadDashboardWidgetView *widget = (iPadDashboardWidgetView *)[self viewWithTag:widgetsStartTag + i];
        [widget enableWidget:YES];
        
        DashboardItem *item = ((DashboardItem *)[dashboardItems objectAtIndex:i]);
        if([item.type isEqualToString:constWidgetTypeWebDavFolder] ||
           [item.type isEqualToString:constWidgetTypeORDGroup]) {
            //reset widget current data
            [widget setAllItemsQuantity:0];
            [widget setNewItemsQuantity:0];
            [widget setNewItemsQuantityTextColor:[iPadThemeBuildHelper dashboardWidgetTextFontNormalColor]];
            [widget setOverdueItemsQuantity:0];
            [widget setOverdueItemsQuantityTextColor:[iPadThemeBuildHelper dashboardWidgetTextFontNormalColor]];
            
            //update widget current data with new values
            [widget setAllItemsQuantity:[item.countTotal intValue]];
            if( ![item.id isEqualToString:constOnControlFolderId] ) {
                [widget setNewItemsQuantity:[item.countNew intValue]];
                if (item.countNew > 0) {
                    [widget setNewItemsQuantityTextColor:[iPadThemeBuildHelper dashboardWidgetTextFontNewColor]];
                }
                [widget enableNewItemsLabel:YES];
            }
            else {
                [widget enableNewItemsLabel:NO];
            }
            
            [widget setOverdueItemsQuantity:[item.countOverdue intValue]];
            if (item.countOverdue > 0) {
                [widget setOverdueItemsQuantityTextColor:[iPadThemeBuildHelper dashboardWidgetTextFontOverdueColor]];
            }
		}
	}
}

- (void)dealloc {
    [dashboardBackLabelPanel release];
    [dashboardItems release];
    [super dealloc];
}


@end
