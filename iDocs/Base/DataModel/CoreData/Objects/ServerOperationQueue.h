//
//  ServerOperationQueue.h
//  iDoc
//
//  Created by Konstantin Krupovich on 8/11/11.
//  Copyright (c) 2011 KORUS Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Constants.h"

@class ServerOperationQueue;

@interface ServerOperationQueue : NSManagedObject {
@private
}
@property (nonatomic, retain) NSDate *dateFinished;
@property (nonatomic, retain) NSDate *dateStarted;
@property (nonatomic, retain) NSString *itemCaption;
@property (nonatomic, retain) NSNumber *rowsFetched;
@property (nonatomic, retain) NSNumber *statusCode;
@property (nonatomic, retain) NSString *statusMessage;
@property (nonatomic, retain) NSDate *dateEnqueued;
@property (nonatomic, retain) NSString *dataVersion;
@property (nonatomic, retain) NSNumber *visible;
@property (nonatomic, retain) NSNumber *group;
@property (nonatomic, retain) ServerOperationQueue *parent;
@property (nonatomic, retain) NSSet *children;

// Extension
@property () DataSyncEventStatus statusCodeEnum;
@property (nonatomic, readonly) NSString *dateStartedString;
@property (nonatomic, readonly) NSString *dateFinishedString; 
@property (nonatomic, readonly) NSString *serverOperationName;
+ (NSDictionary *)serverOperationLabels;

- (ServerOperationQueue *)setFinished;
- (ServerOperationQueue *)setProcess;
- (ServerOperationQueue *)setFinishedWithErrorMessage:(NSString *)newErrorMessage;
- (ServerOperationQueue *)setFinishedWithError:(NSError *)newError;
- (ServerOperationQueue *)setRowsFetchedCount:(int)newRowsFetched;

- (void)addServerOperationQueueObject:(ServerOperationQueue *)value;
- (void)removeServerOperationQueueObject:(ServerOperationQueue *)value;
- (void)addServerOperationQueue:(NSSet *)value;
- (void)removeServerOperationQueue:(NSSet *)value;
@end
