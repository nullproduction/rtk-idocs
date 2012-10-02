//
//  ClientSettingsDataEntity.h
//  iDoc
//
//  Created by rednekis on 10-12-20.
//  Copyright 2010 KORUS Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DashboardItem.h"
#import "Dashboard.h"
#import "GeneralSetting.h"


@interface ClientSettingsDataEntity : NSObject {
	NSManagedObjectContext *context; 
}

+ (NSString *)allTasksGroupId;
+ (NSString *)allTasksGroupName;

- (id)initWithContext:(NSManagedObjectContext *)newContext;

- (Dashboard *)createDashboard;
- (NSArray *)selectAllDashboards;
- (void)deleteAllDashboards;

- (DashboardItem *)createDashboardItem;
- (DashboardItem *)selectDashboardItemById:(NSString *)itemId;
- (NSArray *)selectDashboardItemsForBlock:(NSString *)block;
- (NSArray *)parentDashboardItemsForDashboardWithId:(int)dashboardId;
- (NSArray *)childsInDashboardItemWithId:(NSString *)itemId;
- (NSArray *)selectDistinctTaskBlocks;
- (NSArray *)selectAllDashboardItems;
- (NSArray *)selectAllWebDavDashboardItems;
- (void)deleteAllDashboardItems;
- (void)updateItemsCountInAllTaskDashboardItems;

- (GeneralSetting *)createGeneralSetting;
- (void)deleteAllGeneralSettings;
- (NSString *)logoIcon;
- (NSString *)logoIconWithName;
- (BOOL)showMajorExecutorErrandSign;
@end
