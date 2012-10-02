//
//  DebugUtils.m
//  yeehay
//
//  Created by rednekis on 7/26/10.
//  Copyright 2010 HFS. All rights reserved.
//

#import "DebugUtils.h"


@implementation DebugUtils

#pragma mark custom methods - mac data debug
+ (void)debugData:(NSData *)data toFile:(NSString *)fileName {
#if TARGET_IPHONE_SIMULATOR
	NSString *debugOutput = [self createDebugOutputPath:fileName];
	[data writeToFile:debugOutput atomically:NO];
#endif
}

+ (void)debugDictionary:(NSDictionary *)dict toFile:(NSString *)fileName {
#if TARGET_IPHONE_SIMULATOR
	NSString *debugOutput = [self createDebugOutputPath:fileName];
	[dict writeToFile:debugOutput atomically:NO];
#endif
}

+ (void)debugArray:(NSArray *)array toFile:(NSString *)fileName {
#if TARGET_IPHONE_SIMULATOR
	NSString *debugOutput = [self createDebugOutputPath:fileName];
	[array writeToFile:debugOutput atomically:NO];
#endif
}


+ (NSString *)createDebugOutputPath:(NSString *)fileName {
	NSString *debugOutput = [NSString stringWithFormat: @"%@%@%@%.0f_%@", 
							 @"/Users/",
							 NSUserName(),
							 @"/Downloads/debugOutput/", 
							 [NSDate timeIntervalSinceReferenceDate] * 1000.0, 
							 fileName];
	return debugOutput;
}


@end
