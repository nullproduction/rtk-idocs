//
//  ActionsToSyncUploader.m
//  iDoc
//
//  Created by rednekis on 5/9/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import "ActionsSubmitter.h"
#import "ActionToSyncDataEntity.h"
#import "ActionToSync.h"

@implementation ActionsSubmitter

- (id)initWithLoaderDelegate:(id<BaseLoaderDelegate>)newDelegate andContext:(NSManagedObjectContext *)context forSyncModule:(DataSyncModule)module {
    if ((self = [super initWithLoaderDelegate:newDelegate andContext:context])) {
        syncModule = module;
        actionsEntity = [[ActionToSyncDataEntity alloc] initWithContext:context];
        parser = [[ActionsSubmitResultXMLParser alloc] init];
        actionIds = [[NSMutableArray alloc] initWithCapacity:0];
	}
	return self;
}

- (void)webServiceProxyConnection:(NSString *)connectionId finishedDownloadingWithData:(NSMutableData *)data orError:(NSError *)error {
    [super webServiceProxyConnection:connectionId finishedDownloadingWithData:data orError:error];
    
    if (error == nil) {
        NSLog(@"ActionsSubmitter actions submitted");
        NSError *parseError = nil;
        NSArray *results = [parser parseActionsSubmitResult:data error:&parseError];
        if (parseError == nil) {
            for(NSDictionary *result in results) {
                int status = [[result objectForKey:constDSEventDataKeyStatus] intValue];
                NSString *message = [result objectForKey:constDSEventDataKeyMessage];
                [self logEventWithCode:DSEventCodeLoaderSubevent status:status message:message usingPrefix:nil];
            }
            for (NSString *actionId in actionIds) {
                [actionsEntity deleteActionToSyncWithId:actionId];
            }
        }
        else {
            NSLog(@"ActionsSubmitter parsing failed");
            for (NSString *actionId in actionIds) {
                [actionsEntity setSyncStatus:constSyncStatusWorking forActionToSyncWithId:actionId];
            }
            [self logEventWithCode:DSEventCodeLoaderSubevent 
                            status:DSEventStatusError 
                           message:[parseError localizedDescription]
                       usingPrefix:NSLocalizedString(@"ActionsSubmitParseFailedMessage", nil)];            
//            [parseError release];
            parseError = nil;
        }
    }  
    else {
        NSLog(@"ActionsSubmitter ws failed:%@", [error localizedDescription]);  
        for (NSString *actionId in actionIds) {
            [actionsEntity setSyncStatus:constSyncStatusWorking forActionToSyncWithId:actionId];
        }
        [self logEventWithCode:DSEventCodeLoaderSubevent 
                        status:DSEventStatusError 
                       message:[error localizedDescription]
                   usingPrefix:NSLocalizedString(@"ActionsSubmitWSFailedMessage", nil)];
    }
    requestInProcess = NO;
    
    // save action sync status to db
    error = nil;
    [syncContext save:&error];
    if (error != nil) {
        NSLog(@"CoreData saveData: Could not save Data: %@, %@", [error description], [error userInfo]);
    }
}

- (void)startLoad {
    NSLog(@"ActionsSubmitter submitData");
    if (useTestData == NO) {
        NSArray *actions = [actionsEntity selectActionsToSync];
        if ([actions count] == 0) {
            NSLog(@"ActionsSubmitter no data to sync");
            requestInProcess = NO;
        }
        else {
            [actionIds removeAllObjects];
            for (ActionToSync *action in actions) {
                [actionIds addObject:action.id];
                action.systemSyncStatus = constSyncStatusInSync; 
            }
            // save action sync status to db
            NSError *error = nil;
            [syncContext save:&error];
            if (error != nil) {
                NSLog(@"CoreData saveData: Could not save Data: %@, %@", [error description], [error userInfo]);
            }
            
            NSDictionary *requestData = [WebServiceRequests createRequestOfActionsToSyncSubmit:actions forUser:[systemEntity userInfo]];
            [self startDataDownloading:requestData];            
        }
    } 
    else {
        NSLog(@"ActionsSubmitter test mode - no syncing");
        [actionsEntity deleteAllActionsToSync];
        requestInProcess = NO;
    }
}

- (void)dealloc {
    [actionIds release];
    [parser release];
    [actionsEntity release];
    
    [super dealloc];
}

@end
