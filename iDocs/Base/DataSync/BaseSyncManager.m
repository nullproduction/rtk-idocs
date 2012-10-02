//
//  BaseSyncManager.m
//  iDoc
//
//  Created by mark2 on 7/11/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import "BaseSyncManager.h"
#import "CoreDataProxy.h"
#import "UserDefaults.h"

@implementation BaseSyncManager

- (id)initWithSyncDelegate:(id<BaseSyncManagerDelegate,BaseLoaderDelegate>)newDelegate {
    if ((self = [super init])) {
        syncQueueEntity = [[ServerOperationQueueEntity alloc] initWithContext:[[CoreDataProxy sharedProxy] workContext]];        
        syncDelegate = newDelegate;
    }
    return self;
}

- (void)cleanupSync {
}

- (void)prepareLaunch {
    NSLog(@"BaseSyncManager prepareLaunch");
    NSPersistentStoreCoordinator *coordinator = [[CoreDataProxy sharedProxy] persistentStoreCoordinator];
    syncContext = [[NSManagedObjectContext alloc] init];
    [syncContext setPersistentStoreCoordinator:coordinator];
    [syncContext setUndoManager:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(mergeChangesWithWorkingContext:) 
                                                 name:NSManagedObjectContextDidSaveNotification 
                                               object:syncContext];
}

- (void)launchSync {
}

- (void)mergeChangesWithWorkingContext:(NSNotification *)notification {
    NSLog(@"BaseSyncManager mergeChangesWithWorkingContext");
    [[[CoreDataProxy sharedProxy] workContext] mergeChangesFromContextDidSaveNotification:notification];
}

- (void)syncFinished {
    NSLog(@"BaseSyncManager syncFinished");
    NSError *error = nil;
    [syncContext save:&error];
    if (error != nil) {
        NSLog(@"CoreData saveData: Could Not Save Data: %@, %@", error, [error userInfo]);
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark BaseLoaderDelegate methods:
- (void)abortSync {
    NSLog(@"BaseSyncManager abortSync");
    [syncDelegate abortSync];
    [self syncFinished];
}

- (BOOL)isAbortSyncRequested {
    return [syncDelegate isAbortSyncRequested];
}

- (void)dealloc {
	[syncQueueEntity release];
    syncContext = nil;
    [super dealloc];
}
@end
