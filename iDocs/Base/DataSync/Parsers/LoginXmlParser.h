//
//  LoginXmlParser.h
//  iDoc
//
//  Created by Michael Syasko on 6/22/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseXmlParser.h"

@interface LoginXmlParser : BaseXmlParser {
}

- (id)init;
- (NSString *)parseLoginResponse:(NSData *)data;

@end
