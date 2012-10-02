//
//  ServerOperationQueueEntity.h
//  Medi_Pad
//
//  Created by mark2 on 4/23/11.
//  Copyright 2011 HFS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerOperationQueue.h"

@interface ServerOperationQueueEntity : NSObject {
	NSManagedObjectContext *context;     
}

- (id)initWithContext:(NSManagedObjectContext *)newContext;

- (ServerOperationQueue *)getQueuedItemByName:(NSString *)newName andState:(NSString *)state;
- (ServerOperationQueue *)appendItemToQueueWithName:(NSString *)newName;
- (ServerOperationQueue *)appendItemToQueueWithName:(NSString *)newName visible:(BOOL)visible;
- (ServerOperationQueue *)appendItemToQueueWithName:(NSString *)newName visible:(BOOL)visible group:(int)group;

- (NSArray *)getListForPredicate:(NSPredicate *)predicate;
- (NSArray *)getListForPredicate:(NSPredicate *)predicate 
                  sortDescriptor:(NSSortDescriptor *)sortDescriptor;
- (NSArray *)getListForPredicate:(NSPredicate *)predicate 
                 sortDescriptors:(NSArray *)sortDescriptors;
- (void)deleteAll;

- (void)appendSubEvent:(NSString *)newMessage status:(DataSyncEventStatus)status toEvent:(ServerOperationQueue *)event;

@end
