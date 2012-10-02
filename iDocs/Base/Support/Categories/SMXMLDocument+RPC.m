//
//  SMXMLDocument+RPC.m
//  iDoc
//
//  Created by Arthur Semenyutin on 8/1/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import "SMXMLDocument+RPC.h"

static NSString * kFaultTagPath = @"Body.Fault";
static NSString * kFaultCodeTag = @"faultcode";
static NSString * kFaultStringTag = @"faultstring";
static NSString * kUnknownErrorString = @"Unknown RPC error";
static const NSInteger kUnknownErrorCode = 0;

@implementation SMXMLDocument (SMXMLDocument_RPC)

- (BOOL)isFault {
	return ([self.root descendantWithPath:kFaultTagPath] != nil);
}

- (NSInteger)faultCode {
    SMXMLElement * fault = [self.root descendantWithPath:kFaultTagPath];
    if (!fault) return kUnknownErrorCode;
	
	SMXMLElement * faultstring = [fault childNamed:kFaultCodeTag];
	return (faultstring) ? [faultstring.value integerValue] : kUnknownErrorCode;
}

- (NSString *)faultString {
    SMXMLElement * fault = [self.root descendantWithPath:kFaultTagPath];
    if (!fault) return nil;

	// TODO: конвертировать коды ошибок сервера вида S:Server в числовые константы.
	SMXMLElement * faultstring = [fault childNamed:kFaultStringTag];
	return (faultstring) ? faultstring.value : kUnknownErrorString;
}

- (NSError *)faultError {
	NSDictionary * detail = [NSDictionary
							 dictionaryWithObjectsAndKeys:[self faultString],
							 NSLocalizedDescriptionKey, nil];
	NSString * bundleId = [[[NSBundle mainBundle] infoDictionary]
						   objectForKey:@"CFBundleIdentifier"];
    return [NSError errorWithDomain:bundleId code:[self faultCode] userInfo:detail];
}

- (id)initWithData:(NSData *)data RPCError:(NSError **)outError {
	self = [self initWithData:data error:outError];
	if (self && [self isFault]) {
		if (outError)
			*outError = [self faultError];
		[self release];
		return nil;
	}
	return self;
}

+ (SMXMLDocument *)documentWithData:(NSData *)data RPCError:(NSError **)outError {
	return [[[SMXMLDocument alloc] initWithData:data RPCError:outError] autorelease];
}


@end
