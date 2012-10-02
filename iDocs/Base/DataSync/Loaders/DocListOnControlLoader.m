//
//  DocListOnControlLoader.m
//  iDoc
//
//  Created by Konstantin Krupovich on 8/17/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import "DocListOnControlLoader.h"
#import "SystemDataEntity.h"
#import "ORDSyncManager.h"

@interface DocListOnControlLoader(PrivateMethods)
- (void)cleanupLocalData;
@end

@implementation DocListOnControlLoader

- (id)initWithLoaderDelegate:(id<BaseLoaderDelegate>)newDelegate andContext:(NSManagedObjectContext *)context forSyncModule:(DataSyncModule)module {
    if ((self = [super initWithLoaderDelegate:newDelegate andContext:context])) {
        self.syncModule = module;
        settingsEntity = [[ClientSettingsDataEntity alloc] initWithContext:context];
        parser = [[DocListOnControlXmlParser alloc] initWithContext:context];
	}
	return self;
}

- (void)webServiceProxyConnection:(NSString *)connectionId finishedDownloadingWithData:(NSMutableData *)data orError:(NSError *)error {
    [super webServiceProxyConnection:connectionId finishedDownloadingWithData:data orError:error];
    
    if (error == nil) {
        NSString *parseError = [parser parseAndInsertDocListData:data];
        if (parseError != nil) {
            NSLog(@"DocListOnControlLoader parsing failed:%@", parseError);
            [self cleanupLocalData];
            [self logEventWithCode:DSEventCodeLoaderSubevent 
                            status:DSEventStatusError 
                           message:parseError
                       usingPrefix:NSLocalizedString(@"DocListOnControlLoaderSyncParseFailedMessage", nil)];                     
        }
        else {
            NSLog(@"DocListOnControlLoader loaded");
        }
    }  
    else {
        NSLog(@"DocListOnControlLoader ws failed:%@", [error localizedDescription]);  
        [self logEventWithCode:DSEventCodeLoaderSubevent 
                        status:DSEventStatusError 
                       message:[error localizedDescription]
                   usingPrefix:NSLocalizedString(@"DocListOnControlLoaderSyncWSFailedMessage", nil)]; 
    }
    requestInProcess = NO;     
}

- (NSString *)returnPathForMockXml:(NSString *)connId {
    return [NSString stringWithFormat:@"%@%@", constTestDocListOnControlDataFilePrefix, constTestFileExtension];
}

- (void)startLoad { 
    NSLog(@"DocListOnControlLoader startLoad");
    
    DashboardItem *onControlFolder = [settingsEntity selectDashboardItemById:constOnControlFolderId];
    if (onControlFolder != nil) { //обработка предусмотрена только для конфигураций, включающих папку "На контроле"
        if (useTestData == NO) {
            NSDictionary *requestData = [WebServiceRequests createRequestOfDocListOnControlForUser:[systemEntity userInfo]];
            NSString *connId = [self startDataDownloading:requestData];
            //prepare test xml
            if (prepareTestData == YES)
                [self.mockXMLPaths setValue:[self returnPathForMockXml:connId] forKey:connId];
        } 
        else {
            NSString *connId = @"test_conn";
            NSString *testDataXMLPath = [self returnPathForMockXml:connId];
            NSLog(@"Doc List On Control Data XML Path: %@", testDataXMLPath);
            NSMutableData *testDataXML 
                = [NSMutableData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:testDataXMLPath ofType:nil]];  
            [self webServiceProxyConnection:connId finishedDownloadingWithData:testDataXML orError:nil];
        }
    }
    else {
        NSLog(@"DocListOnControlLoader no 'on control' folder - remove 'on control' data");
        [self cleanupLocalData];
        requestInProcess = NO;
    }
}

- (void)cleanupLocalData {
    NSLog(@"DocListOnControlLoader cleanupLocalData");
    ORDSyncManager *manager = [[ORDSyncManager alloc] initForCleanupWithContext:syncContext];
    [manager cleanupORDUserDataForOnControlTasks];
    [manager release];
}

- (void)dealloc {
    [parser release];
    [settingsEntity release];
    [super dealloc];
}

@end
