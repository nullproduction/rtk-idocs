//
//  DebugUtils.h
//  yeehay
//
//  Created by rednekis on 7/26/10.
//  Copyright 2010 HFS. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DebugUtils : NSObject {
}

+ (void)debugData:(NSData *)data toFile:(NSString *)fileName;
+ (void)debugDictionary:(NSDictionary *)dict toFile:(NSString *)fileName;
+ (void)debugArray:(NSArray *)array toFile:(NSString *)fileName;
+ (NSString *)createDebugOutputPath:(NSString *)fileName;

@end
