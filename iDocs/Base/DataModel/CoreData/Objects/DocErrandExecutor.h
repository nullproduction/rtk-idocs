//
//  DocErrandExecutor.h
//  iDoc
//
//  Created by Likhachev Dmitry on 12/20/11.
//  Copyright (c) 2011 KORUS Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DocErrand;

@interface DocErrandExecutor : NSManagedObject

@property (nonatomic, retain) NSString * executorId;
@property (nonatomic, retain) NSString * executorName;
@property (nonatomic, retain) NSNumber * isMajorExecutor;
@property (nonatomic, retain) NSNumber * systemSortIndex;
@property (nonatomic, retain) DocErrand * errand;

@end
