//
//  LoginXmlParser.m
//  iDoc
//
//  Created by Michael Syasko on 6/22/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import "LoginXmlParser.h"
#import "SMXMLDocument+RPC.h"
#import "SupportFunctions.h"

@implementation LoginXmlParser

- (id)init {   
    if ((self = [super init])) {    
	}
	return self;
}

- (NSString *)parseLoginResponse:(NSData *)data {
    NSLog(@"LoginXmlParser parseContent");
    NSMutableString* parseErr = [NSMutableString string];
    NSError *error = nil;
    
    self.parserPool = [[NSAutoreleasePool alloc] init];
    
    SMXMLDocument *document = [SMXMLDocument documentWithData:data RPCError:&error];
    if (error != nil) {
        [parseErr setString:[error localizedDescription]];
        [parserPool release];
        self.parserPool = nil;
        return (NSString *)parseErr;
    }
    
    NSString *dmTicket = [[document.root descendantWithPath:@"Body.getLoginTicketResponse.return"] value];
    if ([dmTicket length] == 0) {
        [parseErr setString:NSLocalizedString(@"NoDMTicketMessage", nil)];
        [parserPool release];
        self.parserPool = nil;
        return (NSString *)parseErr;
    }
    
    [parserPool release];
    self.parserPool = nil;
    return nil;
}

@end
