//
//  GeneralSetting.h
//  iDoc
//
//  Created by Likhachev Dmitry on 12/9/11.
//  Copyright (c) 2011 KORUS Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface GeneralSetting : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * value;

@end
