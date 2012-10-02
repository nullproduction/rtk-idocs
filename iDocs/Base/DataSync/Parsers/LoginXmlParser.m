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
    self.parserPool = [[NSAutoreleasePool alloc] init];
    
    NSError *error = nil;
    SMXMLDocument *document = [SMXMLDocument documentWithData:data RPCError:&error];
    if (error != nil) {
        return [error localizedDescription];
    }
    
    NSString *dmTicket = [[document.root descendantWithPath:@"Body.getLoginTicketResponse.return"] value];
    if ([dmTicket length] == 0) {
        return NSLocalizedString(@"NoDMTicketMessage", nil);        
    }
    
    [parserPool release];
    self.parserPool = nil;
    
    return nil;
}
@end
