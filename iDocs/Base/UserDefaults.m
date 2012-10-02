//
//  UserDefaults.m
//  iDoc
//
//  Created by Arthur Semenyutin on 8/22/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import "UserDefaults.h"

@implementation UserDefaults

+ (NSString *)stringSettingByKey:(NSString *)key {
	return [[NSUserDefaults standardUserDefaults] valueForKey:key];
}

+ (int)intSettingByKey:(NSString *)key {
	return [[[NSUserDefaults standardUserDefaults] objectForKey:key] intValue];
}

+ (float)floatSettingByKey:(NSString *)key {
	return [[[NSUserDefaults standardUserDefaults] objectForKey:key] floatValue];
}

+ (BOOL)boolSettingByKey:(NSString *)key {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:key] boolValue];
}

+ (void)saveValue:(id)value forSetting:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:key];
    [defaults synchronize];    
}

+ (BOOL) useORDServer {
	return [self boolSettingByKey:constUseORDServer];
}

+ (BOOL) useWebDavServer {
	return [self boolSettingByKey:constUseWebDavServer];	
}

+ (NSString *) ordServerUrl {
	return [self stringSettingByKey:constORDServerUrl];
}

+ (NSString *) webDavServerUrl {
	return [self stringSettingByKey:constWebDavServerUrl];
}

+ (BOOL) useTestData {
	return [self boolSettingByKey:constUseTestData];		
}

+ (NSString *) ordFolder {
	NSString *folderPath = [[NSUserDefaults standardUserDefaults] objectForKey:constORDFolderPath];
	if (!folderPath) {
		NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		folderPath = [documentsDirectory stringByAppendingPathComponent:constORDFolder];			
	}
	return folderPath;	
}

+ (NSString *) webDavFolder {
	NSString *folderPath = [[NSUserDefaults standardUserDefaults] objectForKey:constWebDavFolderPath];
	if (!folderPath) {
		NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		folderPath = [documentsDirectory stringByAppendingPathComponent:constWebDavFolder];			
	}
	return folderPath;
}


@end
