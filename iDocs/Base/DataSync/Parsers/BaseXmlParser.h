//
//  BaseXmlParser.h
//  iDoc
//
//  Created by Konstantin Krupovich on 8/23/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface BaseXmlParser : NSObject {
    NSAutoreleasePool *parserPool;
    NSManagedObjectContext *parserContext;
}

// The autorelease pool property is assign because autorelease pools cannot be retained.
@property (nonatomic, assign) NSAutoreleasePool *parserPool;
@property (nonatomic, assign) NSManagedObjectContext *parserContext;

- (id)initWithContext:(NSManagedObjectContext *)context;
- (void)saveParsedData;

@end
