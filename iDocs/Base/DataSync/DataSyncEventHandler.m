//
//  DataSyncEventHandler.m
//  iDoc
//
//  Created by Konstantin Krupovich on 8/10/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import "DataSyncEventHandler.h"
#import "ServerOperationQueueEntity.h"
#import "CoreDataProxy.h"

@implementation DataSyncEventHandler

- (id)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receiveNotification:) 
                                                     name:constDataSyncEventNotification
                                                   object:nil];
    }
    
    return self;
}

- (void)receiveNotification:(NSNotification *)notification {    
    if ([[notification name] isEqualToString:constDataSyncEventNotification]){
        NSDictionary *userInfo = [notification userInfo];
        DataSyncEventCode eventCode = [[userInfo valueForKey:constDSEventDataKeyCode] intValue];
        DataSyncEventStatus statusCode = [[userInfo valueForKey:constDSEventDataKeyStatus] intValue];
        NSString *senderClassName = [userInfo valueForKey:constDSEventDataKeySenderClassName];

        ServerOperationQueueEntity *serverOpQueueEntity = [[ServerOperationQueueEntity alloc] initWithContext:[[CoreDataProxy sharedProxy] workContext]];
        
        switch (eventCode) {
            case DSEventCodeSyncModuleStarted:
                break;
            case DSEventCodeSyncModuleFinished:
                break;
            case DSEventCodeLoaderStarted:
            {
                ServerOperationQueue *queuedItem = [serverOpQueueEntity getQueuedItemByName:senderClassName andState:nil];
                [queuedItem setProcess];
                [[NSRunLoop currentRunLoop] runUntilDate:[[NSDate date] dateByAddingTimeInterval:0.1]];
            }
                break;
            case DSEventCodeLoaderFinished:
            {
                ServerOperationQueue *queuedItem = [serverOpQueueEntity getQueuedItemByName:senderClassName andState:nil];
                [queuedItem setFinishedWithErrorMessage:[userInfo valueForKey:constDSEventDataKeyMessage]];
                [[NSRunLoop currentRunLoop] runUntilDate:[[NSDate date] dateByAddingTimeInterval:0.1]];                
            }
                break;
            case DSEventCodeLoaderSubevent:
            {
                ServerOperationQueue *queuedItem = [serverOpQueueEntity getQueuedItemByName:senderClassName andState:nil];
                [serverOpQueueEntity appendSubEvent:[userInfo valueForKey:constDSEventDataKeyMessage]
                                    status:statusCode toEvent:queuedItem];
            }
                break;
            default:
                break;
        }
        
        [serverOpQueueEntity release];
    }
}

+ (void)notifyForDatasyncEventWithCode:(DataSyncEventCode)eventCode 
                                    title:(NSString *)title 
                                   status:(DataSyncEventStatus)status 
                                  message:(NSString *)message 
                                   sender:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:constDataSyncEventNotification 
            object:sender 
          userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                    [NSNumber numberWithInt:eventCode], constDSEventDataKeyCode, 
                    ([title length] ? title:constEmptyStringValue), constDSEventDataKeyTitle, 
                    [NSNumber numberWithInt:status], constDSEventDataKeyStatus,
                    ([message length] ? message:constEmptyStringValue), constDSEventDataKeyMessage,
                    [[sender class] description], constDSEventDataKeySenderClassName,
                    nil]]; 
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

@end
