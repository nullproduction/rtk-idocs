//
//  TaskActionTemplate.h
//  iDoc
//
//  Created by rednekis on 8/19/11.
//  Copyright (c) 2011 KORUS Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DashboardItem;

@interface TaskActionTemplate : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * resultText;
@property (nonatomic, retain) NSNumber * isFinal;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSNumber * systemSortIndex;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * buttonColor;
@property (nonatomic, retain) DashboardItem *dashboardItem;

@end
