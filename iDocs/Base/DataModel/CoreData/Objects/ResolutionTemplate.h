//
//  ResolutionTemplate.h
//  iDoc
//
//  Created by rednekis on 11-07-21.
//  Copyright (c) 2011 KORUS Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ResolutionTemplate : NSManagedObject {
@private
}

@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * text;

@end
