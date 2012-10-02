//
//  NSManagedObjectContext+CustomFetch.h
//  iSharePoint
//
//  Created by Laughedelic on 20.03.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (CustomFetch)

- (NSArray *)executeFetchRequestFilteringByAttribute:(NSString *)key withValue:(NSString *)value 
                                       andEntityName:(NSString *)entityName;

- (NSArray *)executeFetchRequestWithPredicate:(NSPredicate *)predicate 
                                andEntityName:(NSString *)entityName;

- (NSArray *)executeFetchRequestWithPredicate:(NSPredicate *)predicate 
                                andEntityName:(NSString *)entityName 
                            andSortDescriptors:(NSArray *)sortDescriptors;

//работает только с сохраненным контекстом!!! объекты, добавленные после последнего сохранения не попадут в выборку
- (NSArray *)distinctValuesForField:(NSString *)fieldName withEntityName:(NSString *)entityName withPredicate:(NSPredicate *)newPredicate;

- (NSInteger)executeCountRequestWithPredicate:(NSPredicate *)predicate andEntityName:en;

@end
