//
//  SystemDataEntity.h
//  iDoc
//
//  Created by rednekis on 5/8/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"

@interface SystemDataEntity : NSObject {
	NSManagedObjectContext *context;     
}

- (id)initWithContext:(NSManagedObjectContext *)newContext;

- (UserInfo *)userInfo;
- (void)deleteUserInfo;
@end
