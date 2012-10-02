//
//  ClientSettingsSyncManager.m
//  iDoc
//
//  Created by mark2 on 7/11/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import "ClientSettingsSyncManager.h"
#import "UserDefaults.h"
#import "ClientSettingsLoader.h"
#import "LoginSubmitter.h"

@implementation ClientSettingsSyncManager

- (id)initForCleanupWithContext:(NSManagedObjectContext *)newContext {
    if (self = [super init]) {
        syncContext = newContext;
    }
    return self;
}

- (void)prepareLaunch {
    NSLog(@"ClientSettingsSyncManager prepareLaunch");
    [super prepareLaunch];
    [syncQueueEntity appendItemToQueueWithName:[[LoginSubmitter class] description] visible:YES group:1];
    [syncQueueEntity appendItemToQueueWithName:[[ClientSettingsLoader class] description] visible:YES group:1];
}

- (void)launchSync {
    NSLog(@"ClientSettingsSyncManager launchSync");
     
        [super launchSync];
        
        NSArray *errors;
        
        LoginSubmitter *loginSubmitter = [[LoginSubmitter alloc] initWithLoaderDelegate:self andContext:syncContext forSyncModule:DSModuleClientSettings];
        errors = [loginSubmitter loadSyncData]; 
        BOOL loginFailed = ([errors count] > 0) ? YES : NO;
        [loginSubmitter release];
        
        if (loginFailed == YES) {
            [syncDelegate abortSync];
        } 
        else {
            if ([self isAbortSyncRequested] == NO) {
                int lastCompletedStep = [[syncDelegate class] lastCompletedStep];
                int currentStep = [syncDelegate currentStep];
                if (lastCompletedStep == 0 || lastCompletedStep <= currentStep) {
                    ClientSettingsLoader *settingsLoader = 
                        [[ClientSettingsLoader alloc] initWithLoaderDelegate:self andContext:syncContext forSyncModule:DSModuleClientSettings];
                    errors = [settingsLoader loadSyncData];
                    [settingsLoader release];
                }
                else {
                    [ClientSettingsLoader notifyAboutSkippedStep];    
                }
                if ([errors count] > 0) 
                    [syncDelegate abortSync];
                else
                    [syncDelegate incrementCurrentStep];
            }
        }
 
    [self syncFinished];
}

- (void)cleanupSync {
    NSLog(@"ClientSettingsSyncManager cleanupSync");
    [super cleanupSync];
    
    ClientSettingsDataEntity *clientSettingsEntity = [[ClientSettingsDataEntity alloc] initWithContext:syncContext];
    DocDataEntity *docEntity = [[DocDataEntity alloc] initWithContext:syncContext];
    TaskDataEntity *taskEntity = [[TaskDataEntity alloc] initWithContext:syncContext];

    [UserDefaults saveValue:constEmptyStringValue forSetting:constClientSettingsServerCheckSum];
    
    NSArray *attachments = [docEntity selectAllAttachments];
    for (DocAttachment *attachment in attachments) {     
        [SupportFunctions deleteAttachment:attachment.fileName];
    }
    [docEntity deleteAllDocs];
    [taskEntity deleteAllTasks]; 
    [clientSettingsEntity deleteAllDashboards];
    [clientSettingsEntity deleteAllGeneralSettings];
    
    [docEntity release];
    [taskEntity release];
    [clientSettingsEntity release];
    
    [SupportFunctions deleteAllWebDavFolders];
}


- (void)dealloc {    
    [super dealloc];
}
@end
