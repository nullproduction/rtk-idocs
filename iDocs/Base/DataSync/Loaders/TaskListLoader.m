//
//  TaskListLoader.m
//  iDoc
//
//  Created by rednekis on 5/9/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import "TaskListLoader.h"
#import "SystemDataEntity.h"
#import "ORDSyncManager.h"


@interface TaskListLoader(PrivateMethods)
- (void)cleanupLocalData;
@end

@implementation TaskListLoader

- (id)initWithLoaderDelegate:(id<BaseLoaderDelegate>)newDelegate andContext:(NSManagedObjectContext *)context forSyncModule:(DataSyncModule)module {
    if ((self = [super initWithLoaderDelegate:newDelegate andContext:context])) {
        self.syncModule = module;
        requests = [[NSMutableDictionary alloc] initWithCapacity:0];  
        settingsEntity = [[ClientSettingsDataEntity alloc] initWithContext:context];
        parser = [[TaskXmlParser alloc] initWithContext:context];
	}
	return self;
}

- (void)webServiceProxyConnection:(NSString *)connectionId finishedDownloadingWithData:(NSMutableData *)data orError:(NSError *)error {
    [super webServiceProxyConnection:connectionId finishedDownloadingWithData:data orError:error];
  
    if (error == nil) {
        NSString *taskBlock = [requests valueForKey:connectionId];
        NSString *parseError = [parser parseAndInsertTaskData:data forTaskBlock:taskBlock];
        if (parseError != nil) {
            NSLog(@"TaskListLoader parsing failed:%@", parseError);
            [self cleanupLocalData];
            [self logEventWithCode:DSEventCodeLoaderSubevent 
                            status:DSEventStatusError 
                           message:parseError
                       usingPrefix:NSLocalizedString(@"TaskListSyncParseFailedMessage", nil)];                     
        }
        else {
            NSLog(@"TaskListLoader loaded");
        }
    }  
    else {
        NSLog(@"TaskListLoader ws failed:%@", [error localizedDescription]);  
        [self logEventWithCode:DSEventCodeLoaderSubevent 
                        status:DSEventStatusError 
                       message:[error localizedDescription]
                   usingPrefix:NSLocalizedString(@"TaskListSyncWSFailedMessage", nil)]; 
    }
    requestInProcess = NO;     
}
 
- (NSString *)returnPathForMockXml:(NSString *)connId {
    return [NSString stringWithFormat:@"%@%@%@", constTestTaskListDataFilePrefix, [requests valueForKey:connId], constTestFileExtension];
}

- (void)startLoad { 
    NSLog(@"TaskListLoader startLoad");
    //TODO remove multiple blocks logic
    NSArray *blocks = [settingsEntity selectDistinctTaskBlocks];
    if ([blocks count] > 0) {
        NSString *block = [blocks objectAtIndex:0];
        if (useTestData == NO) {
            NSDictionary *requestData = [WebServiceRequests createRequestOfTaskListInBlock:block forUser:[systemEntity userInfo]];
            NSString *connId = [self startDataDownloading:requestData];
            [requests setValue:[NSString stringWithFormat:@"for_block_%@", block] forKey:connId];
            //prepare test xml
            if (prepareTestData == YES)
                [self.mockXMLPaths setValue:[self returnPathForMockXml:connId] forKey:connId];
        } else {
            NSString *connId = [NSString stringWithFormat:@"conn_%@", block];
            [requests setValue:[NSString stringWithFormat:@"for_block_%@", block] forKey:connId];
            NSString *testDataXMLPath = [self returnPathForMockXml:connId];
            NSLog(@"Doc List On Control Data XML Path: %@", testDataXMLPath);
            NSMutableData *testDataXML 
                = [NSMutableData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:testDataXMLPath ofType:nil]];
            [self webServiceProxyConnection:connId finishedDownloadingWithData:testDataXML orError:nil];
        }
    } 
    else {
        requestInProcess = NO;
    }
}

- (void)cleanupLocalData {
    NSLog(@"TaskListLoader cleanupLocalData");
    //TODO clean up only updated data
    ORDSyncManager *manager = [[ORDSyncManager alloc] initForCleanupWithContext:syncContext];
    [manager cleanupORDUserDataForRegularTasks];
    [manager release];
}

- (void)dealloc {
    [parser release];
    [settingsEntity release];
    [requests release];
    [super dealloc];
}

@end
