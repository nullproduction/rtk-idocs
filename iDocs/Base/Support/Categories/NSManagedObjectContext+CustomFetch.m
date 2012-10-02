//
//  NSManagedObjectContext+CustomFetch.m
//  iSharePoint
//
//  Created by Laughedelic on 20.03.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSManagedObjectContext+CustomFetch.h"

@implementation NSManagedObjectContext (CustomFetch)

- (NSArray *)executeFetchRequestWithPredicate:(NSPredicate *)predicate 
                                andEntityName:(NSString *)entityName 
                            andSortDescriptors:(NSArray *)sortDescriptors {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self];
    [fetchRequest setEntity:entity];
    
    if (predicate != nil) {
        [fetchRequest setPredicate:predicate];
    }
    if (sortDescriptors != nil) {
        [fetchRequest setSortDescriptors:sortDescriptors];
    }
    
    NSError *errorFetch = nil;
    NSArray *items = [self executeFetchRequest:fetchRequest error:&errorFetch];
    if (errorFetch != nil) {
        NSLog(@"executeFetchRequestWithPredicate error: %@", [errorFetch localizedDescription]);
    }
    [fetchRequest release];    
    return items;    

}

- (NSArray *)executeFetchRequestWithPredicate:(NSPredicate *)predicate andEntityName:(NSString *)entityName {
    return [self executeFetchRequestWithPredicate:predicate andEntityName:entityName andSortDescriptors:nil];
}

- (NSArray *)executeFetchRequestFilteringByAttribute:(NSString *)key withValue:(NSString *)value andEntityName:(NSString *)entityName { 
    return [self executeFetchRequestWithPredicate:[NSPredicate predicateWithFormat:@"%K = %@", key, value]
                                    andEntityName:entityName];
}

- (NSArray *)distinctValuesForField:(NSString *)fieldName 
                     withEntityName:(NSString *)entityName 
                      withPredicate:(NSPredicate *)newPredicate {
    NSEntityDescription *entity = [NSEntityDescription  entityForName:entityName inManagedObjectContext:self];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    [request setResultType:NSDictionaryResultType];
    [request setReturnsDistinctResults:YES];
    [request setPropertiesToFetch:[NSArray arrayWithObject:fieldName]];
    
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:[NSSortDescriptor sortDescriptorWithKey:fieldName ascending:YES], nil];
    [request setSortDescriptors:sortDescriptors];
    [sortDescriptors release];
                                
    if (newPredicate != nil) {
        [request setPredicate:newPredicate];
    }
    
    NSError *error = nil;
    NSArray *objects = [self executeFetchRequest:request error:&error];    
    [request release];
    if (error != nil) {
        NSLog(@"distinctValuesForFields returned error: %@", [error localizedDescription]);
    }
    
    NSMutableArray *values = [[NSMutableArray alloc] init];
    for (NSDictionary *item in objects) {
        if ([item valueForKey:fieldName] != nil)
            [values addObject:[item valueForKey:fieldName]];
    }
    
    return [values autorelease];
}

- (NSInteger)executeCountRequestWithPredicate:(NSPredicate *)predicate andEntityName:en {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:en inManagedObjectContext:self];
    [fetchRequest setEntity:entity];
    
    if (predicate != nil) {
        [fetchRequest setPredicate:predicate];
    }
    NSError *errorFetch = nil;
    NSInteger cnt = [self countForFetchRequest:fetchRequest error:&errorFetch];
    if (errorFetch != nil) {
        NSLog(@"executeFetchRequestWithPredicate error: %@", [errorFetch localizedDescription]);
    }
    [fetchRequest release];    
    return cnt;
    
}



@end
