//
//  BaseXmlParser.m
//  iDoc
//
//  Created by Konstantin Krupovich on 8/23/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import "BaseXmlParser.h"


@implementation BaseXmlParser

@synthesize parserPool, parserContext;

- (id)initWithContext:(NSManagedObjectContext *)context {
    if (self = [super init]) {
        self.parserContext = context;
    }
    return self;
}

- (void)onStartParsing {
}

- (void)saveParsedData {
    NSError *error = nil;
    [parserContext save:&error];
    if (error != nil) {
        NSLog(@"Error saving context after parsing data in parser: %@", [[self class] description]);
    }
}

- (void)dealloc {
    self.parserContext = nil;
    [super dealloc];
}

@end
