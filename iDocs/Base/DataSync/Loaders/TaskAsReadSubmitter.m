//
//  TaskAsReadSubmitter.m
//  iDoc
//
//  Created by Olga Geets on 13.11.12.
//  Copyright (c) 2012 KORUS Consulting. All rights reserved.
//

#import "TaskAsReadSubmitter.h"

@implementation TaskAsReadSubmitter

- (id)initWithLoaderDelegate:(id<BaseLoaderDelegate>)newDelegate andContext:(NSManagedObjectContext *)context forSyncModule:(DataSyncModule)module {
    if ((self = [super initWithLoaderDelegate:newDelegate andContext:context])) {
        NSLog(@"TaskAsReadSubmitter initWithLoaderDelegate");
        syncModule = module;
        taskIds = [[NSMutableArray alloc] initWithCapacity:0];
        taskEntity = [[TaskDataEntity alloc] initWithContext:[[CoreDataProxy sharedProxy] workContext]];
        parser = [[ActionsSubmitResultXMLParser alloc] init];

	}
	return self;
}

- (void)webServiceProxyConnection:(NSString *)connectionId finishedDownloadingWithData:(NSMutableData *)data orError:(NSError *)error {
    NSLog(@"TaskAsReadSubmitter webServiceProxyConnection finishedDownloadingWithData");
    [super webServiceProxyConnection:connectionId finishedDownloadingWithData:data orError:error];
    NSLog(@"data %@", data);
    if (error == nil) {
        NSLog(@"TaskAsReadSubmitter submitted");
        NSError *parseError = nil;
        NSArray *results = [parser parseActionsSubmitResult:data error:&parseError];
        NSLog(@"results %@", [results description]);
        if (results != nil) {
            for(NSDictionary *result in results) {
                int status = [[result objectForKey:constDSEventDataKeyStatus] intValue];
                NSString *message = [result objectForKey:constDSEventDataKeyMessage];
                [self logEventWithCode:DSEventCodeLoaderSubevent status:status message:message usingPrefix:nil];
            }
            for (NSString * taskId in taskIds) {
                [taskEntity deleteTaskAsReadWithId:taskId];
            }
        }
        else {
            NSLog(@"TaskAsReadSubmitter parsing failed");
            [self logEventWithCode:DSEventCodeLoaderSubevent
                            status:DSEventStatusError
                           message:[parseError localizedDescription]
                       usingPrefix:NSLocalizedString(@"ActionsSubmitTaskAsReadFailedMessage", nil)];
        }   
    }
    else {
        NSLog(@"ActionsSubmitter ws failed:%@", [error localizedDescription]);
        [self logEventWithCode:DSEventCodeLoaderSubevent
                        status:DSEventStatusError
                       message:[error localizedDescription]
                   usingPrefix:NSLocalizedString(@"ActionsSubmitTaskAsReadFailedMessage", nil)];
    }
    requestInProcess = NO;
    
    // save action sync status to db
    error = nil;
    [syncContext save:&error];
    if (error != nil) {
        NSLog(@"CoreData saveData: Could not save Data: %@, %@", [error description], [error userInfo]);
    }
}

- (void)startLoad {
    NSLog(@"TaskAsReadSubmitter submitData");
    if (useTestData == NO) {
        NSArray *tasks = [taskEntity selectAllTasksAsRead];
        if ([tasks count] == 0) {
            NSLog(@"TaskAsReadSubmitter no data to sync");
            requestInProcess = NO;
        }
        else {
            [taskIds removeAllObjects];
            for (TaskAsRead *task in tasks) {
                [taskIds addObject:task.taskId];
                NSLog(@"startLoad task.taskId %@", task.taskId);
            }

//            for(TaskAsRead *task in tasks) {
                NSDictionary *requestData = [WebServiceRequests createRequestOfTaskAsRead:((TaskAsRead *)[tasks objectAtIndex:0]).taskId forUser:[systemEntity userInfo]];
                NSLog(@"startLoad requestData %@", [requestData description]);
                [self startDataDownloading:requestData];
//            }
        }
    }
    else {
        NSLog(@"TaskAsReadSubmitter test mode - no syncing");
        [taskEntity deleteAllTasksAsRead];
        requestInProcess = NO;
    }
}

- (void)dealloc {
    NSLog(@"TaskAsReadSubmitter dealloc");
    [taskEntity release];
    [taskIds release];
    [parser release];
    
    [super dealloc];
}

@end
