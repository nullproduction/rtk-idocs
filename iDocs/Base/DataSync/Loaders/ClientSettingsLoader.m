//
//  ClientSettingsLoader.m
//  iDoc
//
//  Created by rednekis on 5/9/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import "ClientSettingsLoader.h"
#import "ClientSettingsXmlParser.h"
#import "ClientSettingsDataEntity.h"
#import "UserDefaults.h"
#import "SupportFunctions.h"
#import "DocAttachment.h"
#import "TaskDataEntity.h"
#import "DocDataEntity.h"
#import "ClientSettingsDataEntity.h"
#import "ClientSettingsSyncManager.h"

@interface ClientSettingsLoader(PrivateMethods)
- (void)requestClientSettingsCheckSumFromServer;
- (void)getClientSettingsCheckSumFromResponseData:(NSData *)data;
- (void)analyzeClientSettingsCheckSum;
- (void)requestClientSettingsFromServer;
- (void)getClientSettingsDataFromResponseData:(NSData *)data;
- (void)cleanupLocalData;
- (void)parseAndInsertClientSettingsData:(NSData *)data;
@end

@implementation ClientSettingsLoader

@synthesize serverCheckSum;


#pragma mark web service methods
- (id)initWithLoaderDelegate:(id<BaseLoaderDelegate>)newDelegate andContext:(NSManagedObjectContext *)context forSyncModule:(DataSyncModule)module {
    if ((self = [super initWithLoaderDelegate:newDelegate andContext:context])) {
        self.syncModule = module;
        parser = [[ClientSettingsXmlParser alloc] initWithContext:context];
        self.serverCheckSum = constEmptyStringValue;
	}
	return self;
}

- (void)webServiceProxyConnection:(NSString *)connectionId finishedDownloadingWithData:(NSMutableData *)data orError:(NSError *)error {
    [super webServiceProxyConnection:connectionId finishedDownloadingWithData:data orError:error];
    
    if (error == nil) {
        if (checksumRequest == YES)
            [self getClientSettingsCheckSumFromResponseData:data];
        else
            [self getClientSettingsDataFromResponseData:data];
    }
    else {
        NSLog(@"ClientSettingsLoader ws failed:%@", [error localizedDescription]);
        [self cleanupLocalData];
        [self logEventWithCode:DSEventCodeLoaderSubevent 
                        status:DSEventStatusError 
                       message:NSLocalizedString(@"SettingsLoadWSFailedMessage", nil)
                   usingPrefix:[error localizedDescription]];
        requestInProcess = NO;
    }
}
   

#pragma mark client settings loading methods
- (void)startLoad {
    NSLog(@"ClientSettingsLoader startLoad"); 
    [self requestClientSettingsCheckSumFromServer];
}

- (NSString *)returnPathForMockXml:(NSString *)connId {
    return constClientSettingsDataFile;
}

- (void)requestClientSettingsCheckSumFromServer {
    NSLog(@"ClientSettingsLoader getClientSettingsCheckSumFromServer"); 
    checksumRequest = YES;
	if (useTestData == NO) {
		NSDictionary *requestData = [WebServiceRequests createClientSettingsCheckSumRequestForUser:[systemEntity userInfo]];
		[self startDataDownloading:requestData];
	} else { 
       self.serverCheckSum = constTestClientSettingsCheckSum; 
       [self analyzeClientSettingsCheckSum];
	} 
}

- (void)getClientSettingsCheckSumFromResponseData:(NSData *)data {
    NSLog(@"ClientSettingsLoader getClientSettingsCheckSumFromResponseData"); 
    NSError *error = nil;
    self.serverCheckSum = [parser getClientSettingsCheckSumFromData:data error:&error];
    if (error == nil) {
        [self analyzeClientSettingsCheckSum];
    }
    else {
        NSLog(@"ClientSettingsLoader checksum parsing failed:%@", [error localizedDescription]);
        //[self cleanupLocalData];
        [self logEventWithCode:DSEventCodeLoaderSubevent 
                        status:DSEventStatusError 
                       message:[error localizedDescription]
                   usingPrefix:NSLocalizedString(@"SettingsChecksumParseFailedMessage", nil)];
        requestInProcess = NO;
    }
}

- (void)analyzeClientSettingsCheckSum {
    NSLog(@"ClientSettingsLoader analyzeClientSettingsCheckSum");     
    NSString *localCheckSum = [UserDefaults stringSettingByKey:constClientSettingsServerCheckSum];
    
    //check local data
    ClientSettingsDataEntity *settingsEntity = [[ClientSettingsDataEntity alloc] initWithContext:syncContext];
    BOOL hasLocalData = ([[settingsEntity selectAllDashboardItems] count] > 0) ? YES : NO;
    [settingsEntity release];
    
    if (hasLocalData == NO || ![serverCheckSum isEqualToString:localCheckSum]) {
        NSLog(@"ClientSettingsLoader local client settings are old, need to load new client settings"); 
        [self requestClientSettingsFromServer];
    }
    else {
        NSLog(@"ClientSettingsLoader local client settings are up to date"); 
        requestInProcess = NO;
    }
}

- (void)requestClientSettingsFromServer {
    NSLog(@"ClientSettingsLoader requestClientSettingsFromServer");  
    checksumRequest = NO;
	if (useTestData == NO) {
		NSDictionary *requestData = [WebServiceRequests createClientSettingsSyncRequestForUser:[systemEntity userInfo]];
		NSString *connId = [self startDataDownloading:requestData];
        //prepare test xml
        if (prepareTestData == YES)
            [self.mockXMLPaths setValue:[self returnPathForMockXml:connId] forKey:connId];
	} 
    else {  
        NSString *connId = @"test_conn";
        NSString *testDataXMLPath = [self returnPathForMockXml:connId];
        NSLog(@"ClientSettings Data XML Path: %@", testDataXMLPath);
        NSMutableData *testDataXML 
            = [NSMutableData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:testDataXMLPath ofType:nil]];
        [self getClientSettingsDataFromResponseData:testDataXML];
	}
}

- (void)getClientSettingsDataFromResponseData:(NSData *)data {
    NSLog(@"ClientSettingsLoader getClientSettingsDataFromResponseData"); 
    NSError *error = nil;
    NSData *clientSettingsData = [parser getClientSettingsDataFromData:data error:&error];
    if (error == nil) {
        [self parseAndInsertClientSettingsData:clientSettingsData];
    }
    else {
        NSLog(@"ClientSettingsLoader clientSettings content extracting failed:%@", [error localizedDescription]);
        [self cleanupLocalData];
        [self logEventWithCode:DSEventCodeLoaderSubevent 
                        status:DSEventStatusError 
                       message:[error localizedDescription]
                   usingPrefix:NSLocalizedString(@"SettingsExtractContentFailedMessage", nil)];
        requestInProcess = NO;       
    }
}

- (void)parseAndInsertClientSettingsData:(NSData *)data {
    NSLog(@"ClientSettingsLoader parseAndInsertClientSettingsData");
    [self cleanupLocalData];
    NSString *parseError = [parser parseAndInsertClientSettingsData:data];
    if (parseError == nil) {
        [UserDefaults saveValue:self.serverCheckSum forSetting:constClientSettingsServerCheckSum];
    }
    else {
        NSLog(@"ClientSettingsLoader clientSettings parsing failed:%@", parseError);
        [self cleanupLocalData];
        [self logEventWithCode:DSEventCodeLoaderSubevent 
                        status:DSEventStatusError 
                       message:parseError
                   usingPrefix:NSLocalizedString(@"SettingsLoadParseFailedMessage", nil)];       
    }
    requestInProcess = NO;
}

- (void)cleanupLocalData {
    NSLog(@"ClientSettingsLoader cleanupLocalData");
    ClientSettingsSyncManager *manager = [[ClientSettingsSyncManager alloc] initForCleanupWithContext:syncContext];
    [manager cleanupSync];
    [manager release];
}

- (void)dealloc {
    [parser release];
    if( self.serverCheckSum != nil ) {
        self.serverCheckSum = nil;
    }
    
    [super dealloc];
}

@end
