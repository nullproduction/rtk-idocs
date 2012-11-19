//
//  TaskDataEntity.h
//  iDoc
//
//  Created by rednekis on 5/8/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Task.h"
#import "TaskAction.h"
#import "Doc.h"
#import "Constants.h"
#import "TaskAsRead.h"


@interface TaskDataEntity : NSObject {
	NSManagedObjectContext *context;     
}

- (id)initWithContext:(NSManagedObjectContext *)newContext;

- (Task *)createTask;
- (Task *)createTaskOnControlForDocWithId:(NSString *)docId;
- (Task *)selectTaskById:(NSString *)taskId;
- (Task *)selectTaskOnControlForDocWithId:(NSString *)docId;
- (NSArray *)selectAllTasks;
- (NSArray *)selectRegularTasks;
- (NSArray *)selectOnControlTasks;
- (NSArray *)selectTasksInDashboardItemWithId:(NSString *)dashboardItemId sortByFields:(NSArray *)sortArray;
- (NSArray *)selectTasksToLoad;
- (NSArray *)selectTasksWithDocsToLoad;
- (void)deleteTasksInDashboardItemWithId:(NSString *)dashboardItemId;
- (BOOL)isTaskWithId:(NSString *)taskId inDashboardItem:(NSString *)dashboardItemId;
- (BOOL)isTaskWithId:(NSString *)taskId linkedToDocWithId:(NSString *)docId;
- (void)deleteTaskWithId:(NSString *)taskId;
- (void)deleteAllTasks;
- (void)deleteRegularTasks;
- (void)deleteOnControlTasks;
- (void)deleteTasksForRemoval;
- (void)depreciateWorkingRegularTasks;
- (void)depreciateWorkingOnControlTasks;
- (void)setActionProcessedWithStatus:(NSString *)status forTaskWithId:(NSString *)taskId;
- (BOOL)isTasksExistsWithType:(ORDTaskType)type;

- (TaskAction *)createTaskAction;
- (void)createActionsFromTemplatesForTaskWithId:(NSString *)taskId;
- (NSArray *)selectTaskActionsforTaskWithId:(NSString *)taskId;
- (void)deleteTaskActionsForTaskWithId:(NSString *)taskId;

- (TaskAsRead *)createTaskAsRead;
- (void)deleteTaskAsReadWithId:(NSString *)taskId;
- (NSArray *)selectAllTasksAsRead;
- (void)deleteAllTasksAsRead;

@end
