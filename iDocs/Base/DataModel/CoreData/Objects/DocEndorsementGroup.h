//
//  DocEndorsementGroup.h
//  iDoc
//
//  Created by rednekis on 5/11/11.
//  Copyright (c) 2011 KORUS Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Doc, DocEndorsement;

@interface DocEndorsementGroup : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * systemSortIndex;
@property (nonatomic, retain) Doc * doc;
@property (nonatomic, retain) NSSet* endorsements;

@end
