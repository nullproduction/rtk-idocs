//
//  DocRequisite.h
//  iDoc
//
//  Created by rednekis on 5/11/11.
//  Copyright (c) 2011 KORUS Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Doc;

@interface DocRequisite : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * value;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * systemSortIndex;
@property (nonatomic, retain) Doc * doc;

@end
