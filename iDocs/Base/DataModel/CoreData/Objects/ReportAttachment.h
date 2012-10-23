//
//  ReportAttachment.h
//  iDoc
//
//  Created by koulikovar on 18.10.12.
//  Copyright (c) 2012 KORUS Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DocErrand;

@interface ReportAttachment : NSManagedObject

@property (nonatomic, retain) NSString * reportId;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * reportText;
@property (nonatomic, retain) NSNumber * size;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * systemName;
@property (nonatomic, retain) NSNumber * accepted;
@property (nonatomic, retain) DocErrand *errand;

@end
