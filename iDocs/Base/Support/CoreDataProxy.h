//
//  CoreDataProxy.h
//  yeehay
//
//  Created by rednekis on 9/2/10.
//  Copyright 2010 HFS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataProxy : NSObject {
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *workContext;
}

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain, readonly) NSManagedObjectContext *workContext;

+ (id)sharedProxy;
+ (void)resetSharedProxy;
+ (void)initSharedProxy;
- (id)init;
- (BOOL)saveWorkingContext;
+ (void)backupDB;
+ (void)restoreDB;

@end