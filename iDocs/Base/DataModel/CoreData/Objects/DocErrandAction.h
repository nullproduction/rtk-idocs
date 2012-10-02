//
//  DocErrandAction.h
//  iDoc
//
//  Created by Likhachev Dmitry on 12/21/11.
//  Copyright (c) 2011 KORUS Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DocErrand;

@interface DocErrandAction : NSManagedObject

@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSNumber * systemSortIndex;
@property (nonatomic, retain) DocErrand *errand;

@end
