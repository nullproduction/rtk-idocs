//
//  ServerOperationQueueEntity.m
//  Medi_Pad
//
//  Created by mark2 on 4/23/11.
//  Copyright 2011 HFS. All rights reserved.
//

#import "ServerOperationQueueEntity.h"
#import "SupportFunctions.h"
#import "NSManagedObjectContext+CustomFetch.h"

#define constEntityName @"ServerOperationQueue"

@implementation ServerOperationQueueEntity

- (id)initWithContext:(NSManagedObjectContext *)newContext {
	if ((self = [super init])) {
		context = newContext;
	}
	return self;
}

- (NSArray *)getListForPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors {
    NSManagedObjectContext *moc = context;
    NSString *en = constEntityName;
    return [moc executeFetchRequestWithPredicate:predicate andEntityName:en andSortDescriptors:sortDescriptors];
	
}

- (NSArray *)getListForPredicate:(NSPredicate *)predicate sortDescriptor:(NSSortDescriptor *)sortDescriptor {
    return [self getListForPredicate:predicate sortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
}

- (NSArray *)getListForPredicate:(NSPredicate *)predicate {
    return [self getListForPredicate:predicate sortDescriptor:nil];
}

- (void)deleteAll {
    NSArray *items = [self getListForPredicate:nil];
    for (NSManagedObject *item in items) {
        [context deleteObject:item];
    }
    [context save:nil];
}

- (ServerOperationQueue *)getQueuedItemByName:(NSString *)newName andState:(NSString *)state {
    NSMutableArray *arguments = [[NSMutableArray alloc] init];
    [arguments addObject:newName];
    if ([state length])[arguments addObject:state];
    
    NSString *format = @"itemCaption == %@";
    if ([state length]) format = [format stringByAppendingString:@" AND statusCode == %@"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:format argumentArray:arguments];
    NSArray *items = [context executeFetchRequestWithPredicate:predicate 
												 andEntityName:constEntityName];
    
    ServerOperationQueue *item = ([items count] == 1) ? ((ServerOperationQueue *)[items objectAtIndex:0]) : nil;
	[arguments release];
    return item;
}

- (ServerOperationQueue *)appendItemToQueueWithName:(NSString *)newName {
    return [self appendItemToQueueWithName:newName visible:NO];
}

- (ServerOperationQueue *)appendItemToQueueWithName:(NSString *)newName visible:(BOOL)visible{
    return [self appendItemToQueueWithName:newName visible:visible group:0];
}

- (ServerOperationQueue *)appendItemToQueueWithName:(NSString *)newName visible:(BOOL)visible group:(int)group {
    //Не отображаемые в мониторинге записи всегда создаем - их может быть сколько угодно
    ServerOperationQueue *item = (visible 
                                        ? [self getQueuedItemByName:newName andState:nil] 
                                        : nil);
    //Иначе создаем новую
    if (!item) {
        item = [NSEntityDescription insertNewObjectForEntityForName:constEntityName 
                                             inManagedObjectContext:context]; 
        item.itemCaption = newName;
    }
    item.dateStarted = [NSDate date];
    item.dateEnqueued = [NSDate date];
    item.statusCodeEnum = DSEventStatusQueued;
    item.visible = [NSNumber numberWithBool:visible];
    item.group = [NSNumber numberWithInt:group];
    
    return item;
}

- (void)appendSubEvent:(NSString *)newMessage status:(DataSyncEventStatus)status toEvent:(ServerOperationQueue *)event {
    ServerOperationQueue *subEventEntity = [self appendItemToQueueWithName:[NSString stringWithFormat:@"%@_subevent",event.itemCaption] 
                                                                         visible:NO 
                                                                           group:[event.group intValue]];
    subEventEntity.dateFinished = [NSDate date];
    subEventEntity.statusCodeEnum = status;
    if (event.statusCodeEnum < status) {//ставим родителю fail
        event.statusCodeEnum = status;
    }
    subEventEntity.statusMessage = newMessage;
    
    [event addServerOperationQueueObject:subEventEntity];	
}

- (void)dealloc {
    [super dealloc];
}

@end
