//
//  DocInfoLoadOperation.h
//  iDoc
//
//  Created by mark2 on 6/10/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DocInfoLoader.h"
#import "LoadOperationDelegate.h"
#import "WebServiceProxy.h"

@interface DocInfoLoadOperation : NSOperation <WebServiceProxyDelegate> { 
    NSObject <LoadOperationDelegate> *delegate;
    int packageId;
    NSArray *packageData;
    
    NSAutoreleasePool *downloadAndParsePool;
    NSManagedObjectContext *operationContext;
    
	WebServiceProxy *wsProxy;
    NSError *wsError;
    NSMutableData *responseData;
    BOOL requestInProcess;
    
    BOOL executing;
    BOOL finished;
    
    BOOL useTestData;
    BOOL prepareTestData;
	
	NSThread * parentThread;
}

@property (nonatomic, assign) NSAutoreleasePool *downloadAndParsePool;

@property (nonatomic, retain) WebServiceProxy *wsProxy;
@property (nonatomic, retain) NSError *wsError;
@property (nonatomic, retain) NSMutableData *responseData;

@property (nonatomic, retain) NSManagedObjectContext *operationContext;
@property (nonatomic, retain) NSArray *packageData;

- (id)initWithPackageToSyncId:(int)packageToSyncId packageToSyncData:(NSArray *)packageToSyncData;
- (void)setDelegate:(id<LoadOperationDelegate>)newDelegate;
- (void)setUseTestData:(BOOL)isUsingTestData;
- (void)setPrepareTestData:(BOOL)isPreparingTestData;

@end
