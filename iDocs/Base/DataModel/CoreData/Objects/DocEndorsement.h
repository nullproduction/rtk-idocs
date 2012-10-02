//
//  DocEndorsement.h
//  iDoc
//
//  Created by rednekis on 5/11/11.
//  Copyright (c) 2011 KORUS Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Doc, DocEndorsementGroup;

@interface DocEndorsement : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSString * personId;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * decision;
@property (nonatomic, retain) NSString * personName;
@property (nonatomic, retain) NSString * personPosition;
@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSNumber * systemSortIndex;
@property (nonatomic, retain) NSDate * endorsementDate;
@property (nonatomic, retain) Doc * doc;
@property (nonatomic, retain) DocEndorsementGroup * group;

@end
