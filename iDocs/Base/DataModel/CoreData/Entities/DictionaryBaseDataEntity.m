//
//  DictionaryBaseDataEntity.m
//  iDoc
//
//  Created by rednekis on 11-07-21.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import "DictionaryBaseDataEntity.h"

@implementation DictionaryBaseDataEntity

- (id)initWithContext:(NSManagedObjectContext *)newContext andEntityName:(NSString *)newEntityName {
	if ((self = [super init])) {
		context = newContext;
        entityName = newEntityName;
	}
	return self;
}

- (NSArray *)selectAll {
    NSArray *items = [context executeFetchRequestWithPredicate:nil andEntityName:entityName andSortDescriptors:nil];
    return items;
}

- (void)deleteAll {
    NSArray *items = [context executeFetchRequestWithPredicate:nil andEntityName:entityName andSortDescriptors:nil];
    for (NSManagedObject *item in items) {
        [context deleteObject:[context objectWithID:[item objectID]]];
    }
}

- (void)deleteItemWithId:(NSString *)itemId {	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id = %@", itemId];
    NSArray *items = [context executeFetchRequestWithPredicate:predicate andEntityName:entityName andSortDescriptors:nil];
    
    for (NSManagedObject *item in items) {
        [context deleteObject:[context objectWithID:[item objectID]]];
    }	
}

- (void)updateItemWithData:(NSDictionary *)data { 
    NSString *itemId = [data valueForKey:@"idElement"];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id = %@", itemId];
    NSArray *items = [context executeFetchRequestWithPredicate:predicate andEntityName:entityName andSortDescriptors:nil];
    if ([items count] == 1) {
        NSManagedObject *item = [items objectAtIndex:0];
        [self updateItem:item withData:data];
    }
}

- (void)createItemWithData:(NSDictionary *)data { 
    NSManagedObjectModel *managedObjectModel = [[context persistentStoreCoordinator] managedObjectModel];
    NSEntityDescription *entity = [[managedObjectModel entitiesByName] objectForKey:entityName];
    NSManagedObject *item = [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
    [self updateItem:item withData:data];
    [item release];
}

- (void)updateItem:(NSManagedObject *)item withData:(NSDictionary *)data {    
}

- (void)dealloc {
	[super dealloc];
}

@end
