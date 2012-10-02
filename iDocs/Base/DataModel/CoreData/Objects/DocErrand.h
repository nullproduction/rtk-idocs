//
//  DocErrand.h
//  iDoc
//
//  Created by Likhachev Dmitry on 2/17/12.
//  Copyright (c) 2012 KORUS Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Doc, DocErrandAction, DocErrandExecutor;

@interface DocErrand : NSManagedObject

@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * authorId;
@property (nonatomic, retain) NSString *parentId;
@property (nonatomic, retain) NSNumber * systemSortIndex;
@property (nonatomic, retain) NSDate * dueDate;
@property (nonatomic, retain) NSString * authorName;
@property (nonatomic, retain) NSString * systemActionToSyncId;
@property (nonatomic, retain) NSString * number;
@property (nonatomic, retain) NSString * report;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSSet *executors;
@property (nonatomic, retain) NSSet *errandActions;
@property (nonatomic, retain) Doc *doc;
@end

@interface DocErrand (CoreDataGeneratedAccessors)

- (void)addExecutorsObject:(DocErrandExecutor *)value;
- (void)removeExecutorsObject:(DocErrandExecutor *)value;
- (void)addExecutors:(NSSet *)values;
- (void)removeExecutors:(NSSet *)values;
- (void)addErrandActionsObject:(DocErrandAction *)value;
- (void)removeErrandActionsObject:(DocErrandAction *)value;
- (void)addErrandActions:(NSSet *)values;
- (void)removeErrandActions:(NSSet *)values;
@end
