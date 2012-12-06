//
//  ActionsSubmitResultXMLParser.m
//  iDoc
//
//  Created by rednekis on 8/12/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import "ActionsSubmitResultXMLParser.h"
#import "SMXMLDocument+RPC.h"
#import "SupportFunctions.h"
#import "Constants.h"

#define constActionResultError @"Error"
#define constActionResultOk @"Ok"

@interface ActionsSubmitResultXMLParser(PrivateMethods)
- (void)addResultWithStatus:(DataSyncEventStatus)status andMessage:(NSString *)message;
@end

@implementation ActionsSubmitResultXMLParser

- (id)init {   
    if ((self = [super init])) {  
        results = [[NSMutableArray alloc] initWithCapacity:0];
	}
	return self;
}

- (NSArray *)parseActionsSubmitResult:(NSData *)data error:(NSError **)parseError {
    NSLog(@"ActionsSubmitResultXMLParser parseActionsSubmitResult");
    if (results == nil)    
        results = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSError *error = nil;
    self.parserPool = [[NSAutoreleasePool alloc] init];
    
    SMXMLDocument *document = [SMXMLDocument documentWithData:data RPCError:&error];
    if (error) {
        NSLog(@"ActionsSubmitResultXMLParser parseContent error: %@", [error localizedDescription]);
        if (parseError)
            *parseError = [error retain];
        [parserPool release];
        self.parserPool = nil;
        return nil;
    }
    
    SMXMLElement *resultPacket = [document.root descendantWithPath:@"Body.executeActionResponse.return"];
    NSArray *actionResults = [resultPacket childrenNamed:@"DataObjects"];
    for (SMXMLElement *actionResult in actionResults) { 
        SMXMLElement *data = [actionResult childNamed:@"Properties"];
        NSString *docId = [[[data childWithAttribute:@"name" value:@"document_id"] childNamed:@"Value"] value];
        NSString *taskId = [[[data childWithAttribute:@"name" value:@"task_id"] childNamed:@"Value"] value];
        //NSString *actionId = [[[data childWithAttribute:@"name" value:@"action_id"] childNamed:@"Value"] value];
        NSString *result = [[[data childWithAttribute:@"name" value:@"result"] childNamed:@"Value"] value];
        NSString *reason = [[[data childWithAttribute:@"name" value:@"reason"] childNamed:@"Value"] value];
        
        int status = ([constActionResultError isEqualToString:result]) ? DSEventStatusWarning : DSEventStatusInfo;
        NSString *message = [NSString stringWithFormat:@"%@ %@ %@ %@: %@ %@", 
                             NSLocalizedString(@"ActionSubmitResultMessage", nil), 
                             taskId,
                             NSLocalizedString(@"ByDocumentMessage", nil),
                             docId, 
                             result, 
                             ([reason length] > 0) ? reason : constEmptyStringValue];
        [self addResultWithStatus:status andMessage:message];
    }
    
    [parserPool release];
    self.parserPool = nil;
    
    return [NSArray arrayWithArray:results];
}

- (void)addResultWithStatus:(DataSyncEventStatus)status andMessage:(NSString *)message {
    if (results == nil)
        results = [[NSMutableArray alloc] initWithCapacity:0];  
    NSDictionary *result =
        [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[NSNumber numberWithInt:status], message, nil] 
                                    forKeys:[NSArray arrayWithObjects:constDSEventDataKeyStatus, constDSEventDataKeyMessage, nil]]; 
    [results addObject:result];
 }

- (BOOL)parseTaskReadSubmitResult:(NSData *)data error:(NSError **)parseError {
    NSLog(@"ActionsSubmitResultXMLParser parseTaskReadSubmitResult");
    if (results == nil)
        results = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSError *error = nil;
    self.parserPool = [[NSAutoreleasePool alloc] init];
    
    SMXMLDocument *document = [SMXMLDocument documentWithData:data RPCError:&error];
    if (error) {
        NSLog(@"ActionsSubmitResultXMLParser parseContent error: %@", [error localizedDescription]);
        if (parseError)
            *parseError = [error retain];
        [parserPool release];
        self.parserPool = nil;
        return NO;
    }
    
    SMXMLElement *resultPacket = [document.root descendantWithPath:@"Body.setTaskAsReadResponse"];
    NSLog(@"resultPacket %@", resultPacket);
    if( resultPacket ) {
        [parserPool release];
        self.parserPool = nil;
        return YES;
    }
    else {
        [parserPool release];
        self.parserPool = nil;
        return NO;
    }
}

- (void)dealloc {
    [results release];
    
    [super dealloc];
}

@end
