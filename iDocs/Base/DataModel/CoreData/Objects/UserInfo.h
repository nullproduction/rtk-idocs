//
//  UserInfo.h
//  iDoc
//
//  Created by rednekis on 11-06-23.
//  Copyright (c) 2011 KORUS Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UserInfo : NSManagedObject {
@private
}

@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * fio;
@property (nonatomic, retain) NSString * organization;
@property (nonatomic, retain) NSString * subdivision;
@property (nonatomic, retain) NSString * position;
@property (nonatomic, retain) NSString * ORDLogin;
@property (nonatomic, retain) NSString * ORDRepository;
@property (nonatomic, retain) NSString * ORDToken;
@property (nonatomic, retain) NSNumber * ORDListSortType;
@property (nonatomic, retain) NSString * webDavLogin;
@property (nonatomic, retain) NSString * webDavToken;
@property (nonatomic, retain) NSNumber * webDavListSortType;

@end
