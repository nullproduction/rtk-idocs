//
//  DocInfoLoadOperation.m
//  iDoc
//
//  Created by rednekis on 04/10/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import "DocInfoLoadOperation.h"
#import "DocAttachment.h"
#import "DocXmlParser.h"
#import "UserDefaults.h"
#import "Constants.h"
#import "CoreDataProxy.h"
#import "SupportFunctions.h"
#import "WebServiceRequests.h"

@interface DocInfoLoadOperation(PrivateMethods)
- (void)cleanupLocalDataForDocs:(NSArray *)docIds;
- (NSString *)pathForMockXml;
@end

@implementation DocInfoLoadOperation

@synthesize downloadAndParsePool, wsProxy, wsError, responseData, operationContext, packageData;

#pragma mark init operation
- (id)initWithPackageToSyncId:(int)packageToSyncId packageToSyncData:(NSArray *)packageToSyncData {
    if (self = [super init]) {
        packageId = packageToSyncId;
        packageData = [packageToSyncData copy];
        
        executing = NO;
        finished = NO;
        
        useTestData = NO;
        prepareTestData = NO;
		parentThread = [NSThread currentThread];
	}
	return self;
}

- (void)setDelegate:(id<LoadOperationDelegate>)newDelegate {
    delegate = newDelegate;
}

- (void)setUseTestData:(BOOL)isUsingTestData {
    useTestData = isUsingTestData; 
}

- (void)setPrepareTestData:(BOOL)isPreparingTestData {
    prepareTestData = isPreparingTestData;
}

- (void)mergeChangesWithSyncContext:(NSNotification *)notification {
    NSLog(@"DocInfoLoadOperation mergeChangesWithSyncContext");
    if (delegate != nil && [delegate respondsToSelector:@selector(mergeOperationContextChangesWithMainContext:)]) {
		[delegate performSelector:@selector(mergeOperationContextChangesWithMainContext:)
						 onThread:parentThread
					   withObject:notification
					waitUntilDone:NO];
    }
    NSManagedObjectContext *workContext = [[CoreDataProxy sharedProxy] workContext];
	[workContext performSelector:@selector(mergeChangesFromContextDidSaveNotification:)
					 onThread:parentThread
				   withObject:notification
				   waitUntilDone:NO];
}

#pragma mark nsoperation methods
- (BOOL)isConcurrent {
    return YES;
}

- (BOOL)isExecuting {
    return executing;
}

- (BOOL)isFinished {
    return finished;
}

- (void)start { 
    NSLog(@"DocInfoLoadOperation start");
    if (![self isCancelled]) {
        
        [self willChangeValueForKey:@"isExecuting"];
        executing = YES;
        [self didChangeValueForKey:@"isExecuting"];
        
        self.downloadAndParsePool = [[NSAutoreleasePool alloc] init];
        
        wsProxy = [[WebServiceProxy alloc] init];
		[wsProxy setDelegate:self];
        self.responseData = nil;
        
        NSPersistentStoreCoordinator *coordinator = [[CoreDataProxy sharedProxy] persistentStoreCoordinator];
        operationContext = [[NSManagedObjectContext alloc] init];
        [operationContext setPersistentStoreCoordinator:coordinator];
        [operationContext setUndoManager:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(mergeChangesWithSyncContext:) 
                                                     name:NSManagedObjectContextDidSaveNotification 
                                                   object:operationContext];
        
        self.wsError = nil;
                
        if (useTestData == NO) {
            requestInProcess = YES;
            
            SystemDataEntity *systemEntity = [[SystemDataEntity alloc] initWithContext:operationContext];
            NSDictionary *requestData = [WebServiceRequests createRequestOfDocs:packageData forUser:[systemEntity userInfo]];
            [systemEntity release];
            [wsProxy getServerDataForRequest:requestData];
            
            while (requestInProcess == YES) {
                [[NSRunLoop currentRunLoop] runUntilDate:[[NSDate date] dateByAddingTimeInterval:0.1]];
            } 
        }
        else {
            NSString *testDataFile = [[NSBundle mainBundle] pathForResource:[self pathForMockXml] ofType:nil];
            NSMutableData *testDataXML = [NSMutableData dataWithContentsOfFile:testDataFile];
            self.responseData = testDataXML;
            self.wsError = nil;
        }
        
        if (wsError == nil) {
            DocXmlParser *parser = [[DocXmlParser alloc] initWithContext:operationContext];
            NSString *parseError = [parser parseAndInsertDocsData:responseData];
            [parser release];
            if (parseError != nil) {
                NSLog(@"DocInfoLoader parsing failed: %@", parseError);
                [self cleanupLocalDataForDocs:packageData];
                NSArray *errorInfo = [NSArray arrayWithObjects:[NSNumber numberWithInt:DSEventCodeLoaderSubevent], 
                                      [NSNumber numberWithInt:DSEventStatusError], 
                                      parseError, 
                                      NSLocalizedString(@"DocInfoLoadParseFailedMessage", nil), nil];
                if (delegate != nil && [delegate respondsToSelector:@selector(reportOperationError:)]) {
					[delegate performSelector:@selector(reportOperationError:)
										onThread:parentThread
									  withObject:errorInfo
								   waitUntilDone:YES];
                }
            }
            else {
                NSLog(@"DocInfoLoadOperation docs loaded");
            }
        }  
        else {
            NSLog(@"DocInfoLoadOperation ws failed:%@", [wsError localizedDescription]); 
            [self cleanupLocalDataForDocs:packageData];
            NSArray *errorInfo = [NSArray arrayWithObjects:[NSNumber numberWithInt:DSEventCodeLoaderSubevent], 
                                  [NSNumber numberWithInt:DSEventStatusError], 
                                  [wsError localizedDescription], 
                                  NSLocalizedString(@"DocInfoLoadWSFailedMessage", nil), nil];
            if (delegate != nil && [delegate respondsToSelector:@selector(reportOperationError:)]) {
				[delegate performSelector:@selector(reportOperationError:)
								 onThread:parentThread
							   withObject:errorInfo
							waitUntilDone:YES];
            }
        }
        
        self.operationContext = nil;
        self.responseData = nil;
        self.wsError = nil;
        self.wsProxy = nil;
        
        [downloadAndParsePool release];
        self.downloadAndParsePool = nil;
        
        [self willChangeValueForKey:@"isExecuting"];
        [self willChangeValueForKey:@"isFinished"];
        finished = YES;
        executing = NO;
        [self didChangeValueForKey:@"isExecuting"];
        [self didChangeValueForKey:@"isFinished"];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        
        if (delegate != nil && [delegate respondsToSelector:@selector(operationFinished)]) {
			[delegate performSelector:@selector(operationFinished)
							 onThread:parentThread
						   withObject:nil
						waitUntilDone:YES];
        }
    }
}

#pragma mark webProxy delegate methods
- (void)webServiceProxyConnection:(NSString *)connectionId finishedDownloadingWithData:(NSMutableData *)data orError:(NSError *)error {
    NSLog(@"DocInfoLoadOperation requestFinished");
    if (prepareTestData == YES && error == nil) {
        [SupportFunctions createMockOutputFile:[self pathForMockXml] withData:data];
    }
    self.responseData = data;
    self.wsError = error;
    requestInProcess = NO;
}


#pragma mark support methods
- (void)cleanupLocalDataForDocs:(NSArray *)docIds {
    NSLog(@"DocInfoLoadOperation cleanupLocalDataForDocs");
    DocDataEntity *docEntity = [[DocDataEntity alloc] initWithContext:operationContext];
    
    for (NSString *docId in docIds) {
        NSArray *attachments = [docEntity selectAttachmentsForDocWithId:docId];
        for (DocAttachment *attachment in attachments) {     
            [SupportFunctions deleteAttachment:attachment.fileName];
        }
        [docEntity deleteDocWithId:docId];
    }
    
    [docEntity release];
    
    NSError *error = nil;
    [operationContext save:&error];
    if (error != nil) {
        NSLog(@"Error saving operation context: %@", [[self class] description]);
    }
}

- (NSString *)pathForMockXml {
    return [NSString stringWithFormat:@"%@%i%@", constTestDocInfoDataFilePrefix, packageId, constTestFileExtension];   
}

- (void)dealloc {
	[packageData release];
    
    if( self.wsProxy != nil )
         self.wsProxy = nil;
    
    if( self.wsError != nil )
        self.wsError = nil;

    if( self.responseData != nil )
        self.responseData = nil;

    if( self.operationContext != nil )
        self.operationContext = nil;

    [self setDelegate:nil];
    
    [super dealloc];
}

@end
