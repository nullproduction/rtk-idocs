//
//  DocInfoLoader.m
//  iDoc
//
//  Created by mark2 on 6/10/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import "DocInfoLoader.h"
#import "ORDSyncManager.h"
#import "DocInfoLoadOperation.h"
#import "UserDefaults.h"

@implementation DocInfoLoader

@synthesize queue;

#pragma mark init methods
- (id)initWithLoaderDelegate:(id<BaseLoaderDelegate>)newDelegate 
                  andContext:(NSManagedObjectContext *)context 
               forSyncModule:(DataSyncModule)module {
    NSLog(@"DocInfoLoader initWithLoaderDelegate");
    if (self = [super initWithLoaderDelegate:newDelegate andContext:context]) {
        syncModule = module;
        docEntity = [[DocDataEntity alloc] initWithContext:context];
        self.queue = [[[NSOperationQueue alloc] init] autorelease];
        [queue setMaxConcurrentOperationCount:1];
	}
	return self;
}

- (NSArray *)loadSyncData {
    [self logEventWithCode:DSEventCodeLoaderStarted status:DSEventStatusUnknown message:nil usingPrefix:nil];
    
    NSMutableArray *emptyArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.errors = emptyArray;
    [emptyArray release];
    
    requestInProcess = YES;
    [self startLoad];
    while (requestInProcess == YES) {
        if ([loaderDelegate isAbortSyncRequested] == YES) {
            [queue cancelAllOperations];
        }
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    } 
    
    [self logEventWithCode:DSEventCodeLoaderFinished status:DSEventStatusUnknown message:nil usingPrefix:nil];
    return [NSArray arrayWithArray:errors];
}

- (void)startLoad {
    NSLog(@"DocInfoLoader startLoad");
    NSArray *docsToSync = [docEntity selectDocsToLoad];
    if ([docsToSync count] > 0) {
        [queue addObserver:self forKeyPath:@"operations" options:0 context:NULL];
        
        int packageId = 1;
        int docsInPackage;
        if(useTestData == NO) {
            docsInPackage = [UserDefaults intSettingByKey:constDocInfoPackageSize];
        }
        else { 
            NSError *error = nil;
            NSString *mockXmlFileName = [NSString stringWithFormat:@"%@%i%@", constTestDocInfoDataFilePrefix, packageId, constTestFileExtension]; 
            NSString *testDataFilePath = [[NSBundle mainBundle] pathForResource:mockXmlFileName ofType:nil];
            NSString *testData = [NSString stringWithContentsOfFile:testDataFilePath encoding:NSStringEncodingConversionAllowLossy error:&error];
            NSRegularExpression *expr = [NSRegularExpression regularExpressionWithPattern:@"<return>" options:NSRegularExpressionCaseInsensitive  error:&error];
            docsInPackage = [expr numberOfMatchesInString:testData options:0 range:NSMakeRange(0, [testData length])];
            NSLog(@"Number of docs In test Package '%@': %d", testDataFilePath, docsInPackage);
        }
        
        NSMutableArray *packageData = [[NSMutableArray alloc] initWithCapacity:docsInPackage];
        
        for (int i = 0; i < [docsToSync count]; i++) {
            [packageData addObject:((Doc *)[docsToSync objectAtIndex:i]).id];
            
            if (([packageData count] == docsInPackage) || (i == [docsToSync count] - 1)) {
                DocInfoLoadOperation *operation = 
                    [[DocInfoLoadOperation alloc] initWithPackageToSyncId:packageId packageToSyncData:packageData];
                [operation setDelegate:self];
                [operation setUseTestData:useTestData];
                [operation setPrepareTestData:prepareTestData];
                [queue addOperation:operation];
                [operation release];
                
                [packageData removeAllObjects];
                packageId++;
            }
        }
        [packageData release];
    }
    else {
		requestInProcess = NO;
    }
}

#pragma mark nsoperation queue methods
- (void)observeValueForKeyPath:(NSString *)keyPath 
                      ofObject:(id)object 
                        change:(NSDictionary *)change 
                       context:(void *)context {
    if (object == queue && [keyPath isEqualToString:@"operations"]) {
        if ([queue.operations count] == 0) {
            NSLog(@"DocInfoLoader queue has completed");
			requestInProcess = NO;	
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark operation methods
- (void)mergeOperationContextChangesWithMainContext:(NSNotification *)notification {
    [syncContext mergeChangesFromContextDidSaveNotification:notification];
}

- (void)reportOperationError:(NSArray *)errorInfo {
    [self logEventWithCode:[(NSNumber *)[errorInfo objectAtIndex:0] intValue] 
                    status:[(NSNumber *)[errorInfo objectAtIndex:1] intValue] 
                   message:(NSString *)[errorInfo objectAtIndex:2] 
               usingPrefix:(NSString *)[errorInfo objectAtIndex:3]];
}

- (void)operationFinished {  
}

- (void)dealloc {
    self.queue = nil;
    [docEntity release];
    
    [super dealloc];
}

@end
