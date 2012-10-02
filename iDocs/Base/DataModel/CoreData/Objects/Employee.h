//
//  Employee.h
//  iDoc
//
//  Created by rednekis on 5/11/11.
//  Copyright (c) 2011 KORUS Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Employee : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * position;
@property (nonatomic, retain) NSString * organization;
@property (nonatomic, retain) NSString * subdivision;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSNumber * indexSection;

@end
