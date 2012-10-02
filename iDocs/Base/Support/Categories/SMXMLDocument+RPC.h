//
//  SMXMLDocument+RPC.h
//  iDoc
//
//  Created by Arthur Semenyutin on 8/1/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import "SMXMLDocument.h"

@interface SMXMLDocument (SMXMLDocument_RPC)

// NSError wrapper for fault code & string
- (NSError *)faultError;

- (id)initWithData:(NSData *)data RPCError:(NSError **)outError;
+ (SMXMLDocument *)documentWithData:(NSData *)data RPCError:(NSError **)outError;

@end
