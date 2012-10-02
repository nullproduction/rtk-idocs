//
//  DocNotice.h
//  iDoc
//
//  Created by rednekis on 9/8/11.
//  Copyright (c) 2011 KORUS Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Doc;

@interface DocNotice : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * fromPersonId;
@property (nonatomic, retain) NSString * fromPersonName;
@property (nonatomic, retain) NSDate * sendDate;
@property (nonatomic, retain) NSString * toPersonId;
@property (nonatomic, retain) NSString * toPersonName;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSNumber * systemSortIndex;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) Doc *doc;

@end
