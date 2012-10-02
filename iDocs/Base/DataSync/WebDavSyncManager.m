//
//  WebDavSyncManager.m
//  iDoc
//
//  Created by mark2 on 7/11/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import "WebDavSyncManager.h"
#import "UserDefaults.h"

@interface WebDavSyncManager(PrivateMethods)
- (void)syncFinished;
@end

@implementation WebDavSyncManager

- (void)prepareLaunch {
    NSLog(@"WebDavSyncManager prepareLaunch");
    [super prepareLaunch];
    [syncQueueEntity appendItemToQueueWithName:[[DataContentLoader class] description] visible:YES group:3];                
}

- (void)cleanupSync {
    NSLog(@"WebDavSyncManager cleanupSync");
    [super cleanupSync];
    [SupportFunctions deleteAllWebDavFolders];
}

#pragma mark sync:
- (void)launchSync {
    NSLog(@"WebDavSyncManager webDavLoadDataStart"); 
    [super launchSync];
    
    if ([self isAbortSyncRequested] == NO) {
        int lastCompletedStep = [[syncDelegate class] lastCompletedStep];
        int currentStep = [syncDelegate currentStep];
        if (lastCompletedStep == 0 || lastCompletedStep <= currentStep) {
            DataContentLoader *dataContentLoader = 
                [[DataContentLoader alloc] initForSyncWithDelegate:self andContext:syncContext forSyncModule:DSModuleWebDavServer];     
            [dataContentLoader loadSyncData];
            [dataContentLoader release];
        }
        else {
            [DataContentLoader notifyAboutSkippedStep];    
        }
        [syncDelegate incrementCurrentStep];
    }

    [self syncFinished];
}

- (void)dealloc {
    [super dealloc];
}

@end
