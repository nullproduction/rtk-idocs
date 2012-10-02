//
//  ServerOperationQueue.m
//  iDoc
//
//  Created by Konstantin Krupovich on 8/11/11.
//  Copyright (c) 2011 KORUS Consulting. All rights reserved.
//

#import "ServerOperationQueue.h"
#import "SupportFunctions.h"

@implementation ServerOperationQueue
@dynamic dateEnqueued;
@dynamic dataVersion;
@dynamic statusCode;
@dynamic visible;
@dynamic dateStarted;
@dynamic rowsFetched;
@dynamic statusMessage;
@dynamic group;
@dynamic itemCaption;
@dynamic dateFinished;
@dynamic parent;
@dynamic children;

static NSDictionary * serverOperationLabels = nil;

- (DataSyncEventStatus)statusCodeEnum {
    return [self.statusCode intValue];
}
- (void)setStatusCodeEnum:(DataSyncEventStatus)statusCodeEnum {
    self.statusCode = [NSNumber numberWithInt:statusCodeEnum];
}

- (NSString *)dateStartedString {
    return (self.dateStarted) ? [SupportFunctions convertDateToString:self.dateStarted withFormat:@"HH:mm:ss"]
    : @" -- : -- : --" ;
}

- (NSString *)dateFinishedString {
    return (self.dateFinished) ? [SupportFunctions convertDateToString:self.dateFinished withFormat:@"HH:mm:ss"]
    : @" -- : -- : --";
}

+ (NSDictionary *)serverOperationLabels {
    if (serverOperationLabels == nil) {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"ServerOperationList" ofType:@"plist"];
        serverOperationLabels = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    }
    return serverOperationLabels;
}
- (NSString *)serverOperationName {
    NSDictionary *items = [[self class] serverOperationLabels];
    NSString *val = [items valueForKey:self.itemCaption];    
    return ([val length]?val:self.itemCaption);
}

- (ServerOperationQueue *)setFinished {
    NSLog(@"%@",self.itemCaption);
    return [self setFinishedWithErrorMessage:nil];
}

- (ServerOperationQueue *)setProcess {
    self.statusCodeEnum = DSEventStatusProcessing;    
    return self;
}

- (ServerOperationQueue *)setFinishedWithErrorMessage:(NSString *)message {
    self.dateFinished = [NSDate date];
    // если ранее проставлен HFS_CONST_QUEUE_OP_FAILURE - оставляем его, иначе - по наличию сообщения 
    DataSyncEventStatus newStatus = ([message length] ? DSEventStatusError : DSEventStatusInfo);
    self.statusCodeEnum = (self.statusCodeEnum > newStatus 
                           ? self.statusCodeEnum 
                           : newStatus);
    
    self.statusMessage = (self.statusCodeEnum == DSEventStatusInfo
                          ? NSLocalizedString(@"SuccessMessage", nil)
                          : message);
    
    return self;
}

- (ServerOperationQueue *)setFinishedWithError:(NSError *)newError {
    return [self setFinishedWithErrorMessage:(newError?[newError localizedDescription]:@"unknown error")];
}

- (ServerOperationQueue *)setRowsFetchedCount:(int)newRowsFetched {
    self.rowsFetched = [NSNumber numberWithInt:newRowsFetched];
    
    return self;
}

- (void)addServerOperationQueueObject:(ServerOperationQueue *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"children" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"children"] addObject:value];
    [self didChangeValueForKey:@"children" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeServerOperationQueueObject:(ServerOperationQueue *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"children" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"children"] removeObject:value];
    [self didChangeValueForKey:@"children" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addServerOperationQueue:(NSSet *)value {    
    [self willChangeValueForKey:@"children" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"children"] unionSet:value];
    [self didChangeValueForKey:@"children" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeServerOperationQueue:(NSSet *)value {
    [self willChangeValueForKey:@"children" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"children"] minusSet:value];
    [self didChangeValueForKey:@"children" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


@end
