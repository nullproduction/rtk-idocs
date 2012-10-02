//
//  NSManagedObject+Clone.h
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (Clone)

- (NSManagedObject *)cloneInContext:(NSManagedObjectContext *)context
                    excludeEntities:(NSArray *)namesOfEntitiesToExclude;

@end
