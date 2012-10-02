//
//  BaseLoader.m
//  iDoc
//
//  Created by rednekis on 5/9/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import "BaseLoader.h"
#import "UserDefaults.h"
#import "SupportFunctions.h"
#import "DataSyncEventHandler.h"

@implementation BaseLoader

@synthesize syncModule, syncContext, errors, mockXMLPaths, useTestData, prepareTestData;

- (id)initWithLoaderDelegate:(id<BaseLoaderDelegate>)newDelegate andContext:(NSManagedObjectContext *)context {	
    if ((self = [super init])) {
        loaderDelegate = newDelegate;
        self.syncContext = context;
        systemEntity = [[SystemDataEntity alloc] initWithContext:context];
        
        requestInProcess = NO;

		useTestData = [UserDefaults useTestData];
        prepareTestData = NO;        
        NSMutableDictionary *emptyDictionary = [[NSMutableDictionary alloc] init];
        self.mockXMLPaths = emptyDictionary;
        [emptyDictionary release];
	}
	return self;
}

#pragma mark synchronous request implementation
- (NSArray *)loadSyncData {
    [self logEventWithCode:DSEventCodeLoaderStarted status:DSEventStatusUnknown message:nil usingPrefix:nil];
    
    NSMutableArray *emptyArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.errors = emptyArray;
    [emptyArray release];
    
    requestInProcess = YES;
    [self startLoad];
    while (requestInProcess == YES) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
       //[[NSRunLoop currentRunLoop] runUntilDate:[[NSDate date] dateByAddingTimeInterval:0.1]];
    } 
    
    [self logEventWithCode:DSEventCodeLoaderFinished status:DSEventStatusUnknown message:nil usingPrefix:nil];
    return [NSArray arrayWithArray:errors];
}

- (void)startLoad {
}

- (NSString *)returnPathForMockXml:(NSString *)connId {
    return nil;    
}

- (void)logEventWithCode:(DataSyncEventCode)eventCode 
                  status:(DataSyncEventStatus)status 
                 message:(NSString *)msg 
             usingPrefix:(NSString *)prefix {
    if (status == DSEventStatusError) 
        [self.errors addObject:msg];
    if (prefix != nil) 
        msg = [NSString stringWithFormat:@"%@: %@", prefix, msg];
    [DataSyncEventHandler notifyForDatasyncEventWithCode:eventCode title:nil status:status message:msg sender:self];
}

+ (void)notifyAboutSkippedStep {
    [DataSyncEventHandler notifyForDatasyncEventWithCode:DSEventCodeLoaderFinished title:nil status:DSEventStatusUnknown message:nil sender:self];
}

- (void)dealloc {
    self.syncContext = nil;
    self.errors = nil;
    self.mockXMLPaths = nil;
    
    [systemEntity release];
	[super dealloc];
}

@end
