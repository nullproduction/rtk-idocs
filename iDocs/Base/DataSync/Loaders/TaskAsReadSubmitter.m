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
        self.syncModule = module;
        taskEntity = [[TaskDataEntity alloc] initWithContext:[[CoreDataProxy sharedProxy] workContext]];
        parser = [[ActionsSubmitResultXMLParser alloc] init];
        requests = [[NSMutableDictionary alloc] initWithCapacity:0];
	}
	return self;
}

- (void)webServiceProxyConnection:(NSString *)connectionId finishedDownloadingWithData:(NSMutableData *)data orError:(NSError *)error {
    NSLog(@"TaskAsReadSubmitter webServiceProxyConnection finishedDownloadingWithData");
    [super webServiceProxyConnection:connectionId finishedDownloadingWithData:data orError:error];

    NSString *taskId = [requests valueForKey:connectionId];
 
    if (error == nil) {
        NSLog(@"TaskAsReadSubmitter submitted");
        NSError *parseError = nil;
        BOOL resultParse = [parser parseTaskReadSubmitResult:data error:&parseError];
        
        if ( resultParse ) {
            [taskEntity deleteTaskAsReadWithId:taskId];
        }
        else {
            if( nil != parseError ) {
                NSLog(@"TaskAsReadSubmitter parsing failed:%@", [parseError localizedDescription]);                
            }
            else {
                NSLog(@"TaskAsReadSubmitter parsing failed");
            }
//            [self logEventWithCode:DSEventCodeLoaderSubevent
//                            status:DSEventStatusWarning
//                           message:[parseError localizedDescription]
//                       usingPrefix:NSLocalizedString(@"ActionsSubmitTaskAsReadParseFailedMessage", nil)];
        }
    }
    else {
        NSLog(@"TaskAsReadSubmitter ws failed:%@", [error localizedDescription]);
//        [self logEventWithCode:DSEventCodeLoaderSubevent
//                        status:DSEventStatusWarning
//                       message:[error localizedDescription]
//                   usingPrefix:NSLocalizedString(@"ActionsSubmitTaskAsReadWSFailedMessage", nil)];
    }

    -- requestsCount;
    if (requestsCount == 0)
        requestInProcess = NO;
    
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
        requestsCount = [tasks count];

        if ([tasks count] == 0) {
            NSLog(@"TaskAsReadSubmitter no data to sync");
            requestInProcess = NO;
        }
        else {
            for(TaskAsRead *task in tasks) {
                NSDictionary *requestData = [WebServiceRequests createRequestOfTaskAsRead:task.taskId forUser:[systemEntity userInfo]];
                NSLog(@"TaskAsReadSubmitter startLoad taskId %@", task.taskId);
                NSString* connId = [self startDataDownloading:requestData];
                [requests setValue:task.taskId forKey:connId];
            }
        }
    }
    else {
        NSLog(@"TaskAsReadSubmitter test mode - no syncing");
        [taskEntity deleteAllTasksAsRead];
        requestInProcess = NO;
    }
}

- (void)dealloc {
    [taskEntity release];
    [parser release];
    [requests release];

    [super dealloc];
}

@end
