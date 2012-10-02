//
//  Task.h
//  iDoc
//
//  Created by rednekis on 5/28/11.
//  Copyright (c) 2011 KORUS Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DashboardItem, Doc, TaskAction;

@interface Task : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * dueDate;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSNumber * isViewed;
@property (nonatomic, retain) Doc * doc;
@property (nonatomic, retain) NSSet* dashboardItems;
@property (nonatomic, retain) NSSet* actions;
@property (nonatomic, retain) NSString * systemCurrentErrandId;
@property (nonatomic, retain) NSString * systemSyncStatus;
@property (nonatomic, retain) NSDate * systemUpdateDate;
@property (nonatomic, retain) NSNumber * systemActionIsProcessed;
@property (nonatomic, retain) NSString * systemActionResultText;
@property (nonatomic, retain) NSNumber * systemHasDueDate;


- (void)addDashboardItemsObject:(DashboardItem *)value;
- (void)removeDashboardItemsObject:(DashboardItem *)value;
- (void)addDashboardItems:(NSSet *)value;
- (void)removeDashboardItems:(NSSet *)value;
- (void)addActionsObject:(TaskAction *)value;
- (void)removeActionsObject:(TaskAction *)value;
- (void)addActions:(NSSet *)value;
- (void)removeActions:(NSSet *)value;
@end
