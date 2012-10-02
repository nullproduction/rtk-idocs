//
//  TaskAction.h
//  iDoc
//
//  Created by rednekis on 5/25/11.
//  Copyright (c) 2011 KORUS Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Task;

@interface TaskAction : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * systemSortIndex;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * buttonColor;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSNumber * isFinal;
@property (nonatomic, retain) NSString * resultText;
@property (nonatomic, retain) Task * task;

@end
