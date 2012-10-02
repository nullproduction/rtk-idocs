//
//  DashboardItem.h
//  iDoc
//
//  Created by rednekis on 8/19/11.
//  Copyright (c) 2011 KORUS Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Dashboard, Task, TaskActionTemplate;

@interface DashboardItem : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSNumber * systemSortIndex;
@property (nonatomic, retain) NSNumber * countTotal;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSNumber * countNew;
@property (nonatomic, retain) NSNumber * countOverdue;
@property (nonatomic, retain) NSString * dashboardIcon;
@property (nonatomic, retain) NSString * block;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * parentId;
@property (nonatomic, retain) Dashboard *dashboard;
@property (nonatomic, retain) NSSet *tasks;
@property (nonatomic, retain) NSSet *actionTemplates;
@end

@interface DashboardItem (CoreDataGeneratedAccessors)

- (void)addTasksObject:(Task *)value;
- (void)removeTasksObject:(Task *)value;
- (void)addTasks:(NSSet *)values;
- (void)removeTasks:(NSSet *)values;

- (void)addActionTemplatesObject:(TaskActionTemplate *)value;
- (void)removeActionTemplatesObject:(TaskActionTemplate *)value;
- (void)addActionTemplates:(NSSet *)values;
- (void)removeActionTemplates:(NSSet *)values;

@end
