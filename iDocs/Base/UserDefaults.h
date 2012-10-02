//
//  UserDefaults.h
//  iDoc
//
//  Created by Arthur Semenyutin on 8/22/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface UserDefaults : NSObject

+ (NSString *)stringSettingByKey:(NSString *)key;
+ (int)intSettingByKey:(NSString *)key;
+ (float)floatSettingByKey:(NSString *)key;
+ (BOOL)boolSettingByKey:(NSString *)key;
+ (void)saveValue:(id)value forSetting:(NSString *)key;

+ (BOOL) useORDServer;
+ (BOOL) useWebDavServer;
+ (BOOL) useTestData;

+ (NSString *) ordServerUrl;
+ (NSString *) webDavServerUrl;

+ (NSString *) ordFolder;
+ (NSString *) webDavFolder;

@end
