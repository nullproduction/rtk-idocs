//
//  CoreDataProxy.m
//  yeehay
//
//  Created by rednekis on 9/2/10.
//  Copyright 2010 HFS. All rights reserved.
//

#import "CoreDataProxy.h"
#import "Constants.h"

static CoreDataProxy *sharedProxyInstance = nil;

@interface CoreDataProxy(PrivateMethods)
+ (NSString *)dbFilePath;
+ (void)copyFileByPath:(NSString *)sourcePath toPath:(NSString *)destPath;
@end

@implementation CoreDataProxy

#pragma mark CoreDataProxy init
+ (void)initialize {
  if (self == [CoreDataProxy class]) {
    sharedProxyInstance = [[self alloc] init];
  }
}

+ (void)resetSharedProxy {
    if (sharedProxyInstance != nil) {
        [sharedProxyInstance release];
        sharedProxyInstance = nil;
    }
}

+ (void)initSharedProxy {
    if (sharedProxyInstance == nil)
        sharedProxyInstance = [[self alloc] init];  
}

+ (id)sharedProxy {
  return sharedProxyInstance;
}

- (id)init {
	NSLog(@"CoreDataProxy init");
	if((self = [super init])) {
		[self workContext];
	}
	return self;
}

- (BOOL)saveWorkingContext {
    NSError *error;
    BOOL saved = [workContext save:&error];
    if (saved != YES) {
        NSLog(@"CoreData saveData: Could Not Save Data: %@, %@", error, [error userInfo]);
    }
    return saved;
}

#pragma mark Core Data stack
/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)workContext {
    if (workContext != nil) {
        return workContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        workContext = [[NSManagedObjectContext alloc] init];
        [workContext setPersistentStoreCoordinator:coordinator];
    }
    return workContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:@"iDoc" ofType:@"momd"];
    NSURL *momURL = [NSURL fileURLWithPath:path];  
    managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:momURL];   
    return managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {    
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
    
    NSURL *storeUrl = [NSURL fileURLWithPath: [CoreDataProxy dbFilePath]];
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    
    NSError *error;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error]) {
        NSLog(@"CoreDataProxy: Could Not Start Persistent Store: %@, %@", error, [error userInfo]);
    }    
    
    return persistentStoreCoordinator;
}


#pragma mark DB file path
+ (NSString *)dbFilePath {
	NSString *filePath = [[NSUserDefaults standardUserDefaults] objectForKey:constDBFilePath];
	if (!filePath) {
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		filePath = ([paths count] > 0) ? [[paths objectAtIndex:0] stringByAppendingPathComponent: constDBFile] : nil;
	}
    return filePath;
}

#pragma mark 
+ (void)restoreDB {
    NSString *source = [CoreDataProxy dbFilePath];
    NSString *dest = [source stringByAppendingString:constBackupExtension];
    [CoreDataProxy copyFileByPath:dest toPath:source];
}

+ (void)backupDB {
    NSString *source = [CoreDataProxy dbFilePath];
    NSString *dest = [source stringByAppendingString:constBackupExtension];
    [CoreDataProxy copyFileByPath:source toPath:dest];
}

+ (void)copyFileByPath:(NSString *)sourcePath toPath:(NSString *)destPath {
    NSFileManager *manager = [NSFileManager defaultManager];
    NSError *error = nil;
    
    if ([manager fileExistsAtPath:destPath] == YES) {
        [manager removeItemAtPath:destPath error:&error]; 
    }
    
    if(error != nil) {
        NSLog(@"CoreData backupDb: %@", error);
    }
    else {
        [manager copyItemAtPath:sourcePath toPath:destPath error:&error];
        if(error != nil) {
            NSLog(@"CoreData backupDb: %@", error);
        }
    }
}

#pragma mark Memory management
- (void)dealloc {    
    [workContext release];
    [managedObjectModel release];
    [persistentStoreCoordinator release];
    [super dealloc];
}


@end
