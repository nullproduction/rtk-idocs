//
//  BaseLoader.h
//  iDoc
//
//  Created by rednekis on 5/9/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Constants.h"
#import "SystemDataEntity.h"
#import "BaseLoaderDelegate.h"

@interface BaseLoader : NSObject {  
    DataSyncModule syncModule;
    
    NSMutableArray *errors;
    
	BOOL useTestData;
    BOOL requestInProcess;
    
	id<BaseLoaderDelegate> loaderDelegate;   
    NSManagedObjectContext *syncContext;        
    SystemDataEntity *systemEntity;
    
    BOOL prepareTestData;    
    NSMutableDictionary *mockXMLPaths;
}

@property (nonatomic, retain) NSMutableDictionary *mockXMLPaths;
@property () DataSyncModule syncModule;
@property (nonatomic, retain) NSManagedObjectContext *syncContext; 
@property (nonatomic, retain) NSMutableArray *errors;
@property () BOOL useTestData;
@property () BOOL prepareTestData;

- (NSString *)returnPathForMockXml:(NSString *)connId;
- (id)initWithLoaderDelegate:(id<BaseLoaderDelegate>)newDelegate andContext:(NSManagedObjectContext *)context;
- (void)startLoad;
- (NSArray *)loadSyncData;
- (void)logEventWithCode:(DataSyncEventCode)eventCode 
                  status:(DataSyncEventStatus)status 
                 message:(NSString *)msg 
             usingPrefix:(NSString *)prefix;
+ (void)notifyAboutSkippedStep;
@end
