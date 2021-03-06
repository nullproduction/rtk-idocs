//
//  ActionSubmitterOperation.m
//  iDoc
//
//  Created by mmakankov on 14.02.12.
//  Copyright (c) 2012 KORUS Consulting. All rights reserved.
//

#import "ActionSubmitterOperation.h"
#import "Constants.h"
#import "CoreDataProxy.h"

@implementation ActionSubmitterOperation

- (id)initWithLoaderDelegate:(NSObject<BaseLoaderDelegate> *)newDelegate {
    if (self = [super init]) {
        delegate = newDelegate;
        parentThread = [NSThread currentThread];
        executing = NO;
        finished = NO;
	}
	return self;
}

- (void)mergeChangesWithSyncContext:(NSNotification *)notification {
    NSManagedObjectContext *workContext = [[CoreDataProxy sharedProxy] workContext];
	[workContext performSelector:@selector(mergeChangesFromContextDidSaveNotification:)
                        onThread:parentThread
                      withObject:notification
				   waitUntilDone:YES];
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
    NSLog(@"ActionSubmitterOperation start");
    if (![self isCancelled]) {
        [self willChangeValueForKey:@"isExecuting"];
        [NSThread detachNewThreadSelector:@selector(main) toTarget:self withObject:nil];
        executing = YES;
        [self didChangeValueForKey:@"isExecuting"];
    }
}

- (void)main {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    NSPersistentStoreCoordinator *coordinator = [[CoreDataProxy sharedProxy] persistentStoreCoordinator];
    NSManagedObjectContext *operationContext = [[NSManagedObjectContext alloc] init];
    [operationContext setPersistentStoreCoordinator:coordinator];
    [operationContext setUndoManager:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(mergeChangesWithSyncContext:) 
                                                 name:NSManagedObjectContextDidSaveNotification 
                                               object:operationContext];
    
    ActionsSubmitter *actionsSubmitter = 
        [[ActionsSubmitter alloc] initWithLoaderDelegate:nil andContext:operationContext forSyncModule:DSModuleORDServer];
    [actionsSubmitter loadSyncData];
    [actionsSubmitter release];
    
    NSError *error = nil;
    [operationContext save:&error];
    if (error != nil) {
        NSLog(@"CoreData saveData: Could Not Save Data: %@, %@", error, [error userInfo]);
    }
    [operationContext release];
    
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    finished = YES;
    executing = NO;
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
    
    [pool release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [delegate performSelector:@selector(actionsSubmitFinished) onThread:parentThread withObject:nil waitUntilDone:NO];
    NSLog(@"ActionSubmitterOperation finish");
}

- (void)dealloc {
    [super dealloc];
}

@end
