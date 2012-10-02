//
//  DocAttachment.h
//  iDoc
//
//  Created by rednekis on 5/19/11.
//  Copyright (c) 2011 KORUS Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Doc;

@interface DocAttachment : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * size;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * fileName;
@property (nonatomic, retain) Doc * doc;
@property (nonatomic, retain) NSNumber * systemLoaded;
@property (nonatomic, retain) NSNumber * systemSortIndex;

@end
