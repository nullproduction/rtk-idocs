//
//  DataSyncEventHandler.h
//  iDoc
//
//  Created by Konstantin Krupovich on 8/10/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@class ServerOperationQueueEntity;

@interface DataSyncEventHandler : NSObject {
}

+ (void)notifyForDatasyncEventWithCode:(DataSyncEventCode)eventCode 
                                 title:(NSString *)title 
                                status:(DataSyncEventStatus)status 
                               message:(NSString *)message 
                                sender:(id)sender;
@end
