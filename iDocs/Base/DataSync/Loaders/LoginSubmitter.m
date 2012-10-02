//
//  LoginLoader.m
//  iDoc
//
//  Created by rednekis on 8/10/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import "LoginSubmitter.h"
#import "LoginXmlParser.h"
#import "SupportFunctions.h"
#import "Constants.h"

@implementation LoginSubmitter

- (id)initWithLoaderDelegate:(id<BaseLoaderDelegate>)newDelegate andContext:(NSManagedObjectContext *)context forSyncModule:(DataSyncModule)module {
    if ((self = [super initWithLoaderDelegate:newDelegate andContext:context])) {
        syncModule = module;
	}
	return self;
}

- (void)webServiceProxyConnection:(NSString *)connectionId finishedDownloadingWithData:(NSMutableData *)data orError:(NSError *)error {
    [super webServiceProxyConnection:connectionId finishedDownloadingWithData:data orError:error];
    
    if (error == nil) {
        NSString *parseError = nil;
        if (useTestData == NO) {
            LoginXmlParser *loginParser = [[LoginXmlParser alloc] init];
            parseError = [loginParser parseLoginResponse:data];
            [loginParser release];
        }
        
        if(parseError != nil) {
            [syncContext rollback];
            NSLog(@"LoginSubmitter login failed: %@", parseError);
            [self logEventWithCode:DSEventCodeLoaderSubevent 
                            status:DSEventStatusError 
                           message:parseError 
                       usingPrefix:NSLocalizedString(@"LoginFailedMessage", nil)];
        }
        else {
            NSLog(@"LoginSubmitter login succeeded");
            NSError *error = nil;
            [syncContext save:&error];
            if (error != nil) {
                NSLog(@"CoreData saveData: Could not save Data: %@, %@", error, [error userInfo]);
                [self logEventWithCode:DSEventCodeLoaderSubevent 
                                status:DSEventStatusError 
                               message:[NSString stringWithFormat:@"%@ %@", error, [error userInfo]] 
                           usingPrefix:NSLocalizedString(@"LoginFailedMessage", nil)];
            }  
        }
    }
    else {
        NSLog(@"LoginSubmitter ws failed:%@", [error localizedDescription]);
        [self logEventWithCode:DSEventCodeLoaderSubevent 
                        status:DSEventStatusError 
                       message:[error localizedDescription] 
                   usingPrefix:NSLocalizedString(@"LoginFailedMessage", nil)];
    }
    requestInProcess = NO;
}

- (void)startLoad {
    NSLog(@"LoginSubmitter submitData");
    UserInfo *user = [systemEntity userInfo];
    user.ORDToken = [NSString stringWithFormat: @"%@_%.0f", @"token", [NSDate timeIntervalSinceReferenceDate] * 1000.0];	
    
    if (useTestData == NO) {
        NSDictionary *loginRequestData = [WebServiceRequests createCheckAuthRequestForUser:user];
        [wsProxy getServerDataForRequest:loginRequestData];
    }
    else {
        [self webServiceProxyConnection:nil finishedDownloadingWithData:nil orError:nil];
    }
}

- (void)dealloc {
    [super dealloc];
}

@end

