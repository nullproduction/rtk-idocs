//
//  TaskInfoLoader.m
//  iDoc
//
//  Created by mark2 on 6/10/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import "TaskInfoLoader.h"
#import "ORDSyncManager.h"

@interface TaskInfoLoader(PrivateMethods)
- (void)cleanupLocalDataForTaskWithId:(NSString *)taskId;
@end

@implementation TaskInfoLoader

- (id)initWithLoaderDelegate:(id<BaseLoaderDelegate>)newDelegate andContext:(NSManagedObjectContext *)context forSyncModule:(DataSyncModule)module {
    self = [super initWithLoaderDelegate:newDelegate andContext:context];
    if (self != nil) {
        self.syncModule = module;
        requests = [[NSMutableDictionary alloc] initWithCapacity:0];
        parser = [[TaskXmlParser alloc] initWithContext:context];
        taskEntity = [[TaskDataEntity alloc] initWithContext:context];
	}
	return self;
}

- (void)webServiceProxyConnection:(NSString *)connectionId finishedDownloadingWithData:(NSMutableData *)data orError:(NSError *)error {
    [super webServiceProxyConnection:connectionId finishedDownloadingWithData:data orError:error];
    
    NSString *taskId = [requests valueForKey:connectionId];    
    if (error == nil) {
        NSString *parseError = [parser parseAndInsertTaskData:data forTaskId:taskId];
        if (parseError != nil) {
            NSLog(@"TaskInfoLoader parsing for task:%@ failed:%@", taskId, parseError);
            [self cleanupLocalDataForTaskWithId:taskId];
            [self logEventWithCode:DSEventCodeLoaderSubevent 
                            status:DSEventStatusWarning 
                           message:[NSString stringWithFormat:@"%@: %@", taskId, parseError]
                       usingPrefix:NSLocalizedString(@"TaskInfoLoadParseFailedMessage", nil)];        
        }
        else {
            NSLog(@"TaskInfoLoader task %@ loaded", taskId);
        }
    }  
    else {
        NSLog(@"TaskInfoLoader ws request for task:%@ failed:%@", taskId, [error localizedDescription]); 
        [self cleanupLocalDataForTaskWithId:taskId];
        [self logEventWithCode:DSEventCodeLoaderSubevent 
                        status:DSEventStatusWarning 
                       message:[NSString stringWithFormat:@"%@: %@", taskId, [error localizedDescription]]
                   usingPrefix:NSLocalizedString(@"TaskInfoLoadWSFailedMessage", nil)];  
    }
    
    -- requestsCount;
    if (requestsCount == 0)              
        requestInProcess = NO;
}

- (NSString *)returnPathForMockXml:(NSString *)connId { 
    return [NSString stringWithFormat:@"%@%@%@", constTestTaskInfoDataFilePrefix, [requests valueForKey:connId], constTestFileExtension];
}

- (void)startLoad {
    NSLog(@"TaskInfoLoader startLoad");
    NSArray *tasksToSync = [taskEntity selectTasksToLoad];   
    if ([tasksToSync count] > 0) {
        requestsCount = [tasksToSync count];
        for (Task *task in tasksToSync) {
            if (useTestData == NO) {
                NSDictionary *requestData = [WebServiceRequests createRequestOfTaskInfoForTaskId:task.id andDocId:task.doc.id forUser:[systemEntity userInfo]];
                NSString *connId = [self startDataDownloading:requestData];
                [requests setValue:task.id forKey:connId];
                //prepare test xml
                if (prepareTestData == YES)
                    [self.mockXMLPaths setValue:[self returnPathForMockXml:connId] forKey:connId];
            } 
            else {
                NSString *connId = [NSString stringWithFormat:@"conn_%@", task.id];
                [requests setValue:task.id forKey:connId];
                NSString *testDataXMLPath = [self returnPathForMockXml:connId];
                NSLog(@"Task Info Data XML Path: %@", testDataXMLPath);
                NSMutableData *testDataXML 
                    = [NSMutableData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:testDataXMLPath ofType:nil]];
                [self webServiceProxyConnection:connId finishedDownloadingWithData:testDataXML orError:nil];
            }
        }
    }
    else {
        requestInProcess = NO;
    }
}

- (void)cleanupLocalDataForTaskWithId:(NSString *)taskId {
    NSLog(@"TaskInfoLoader cleanupLocalDataForTaskithId:%@", taskId);
    ORDSyncManager *manager = [[ORDSyncManager alloc] initForCleanupWithContext:syncContext];
    [manager cleanupORDDataForTaskWithId:taskId];
    [manager release];
}

- (void)dealloc {
    [taskEntity release];
    [parser release];
    [requests release];
    [super dealloc];
}


@end
