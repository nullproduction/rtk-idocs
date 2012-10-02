//
//  ORDSyncManager.m
//  iDoc
//
//  Created by mark2 on 7/11/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import "ORDSyncManager.h"
#import "UserDefaults.h"
#import "EmployeeListDataEntity.h"
#import "EmployeeGroupDataEntity.h"
#import "ResolutionTemplateDataEntity.h"
#import "DocDataEntity.h"
#import "DocAttachment.h"
#import "TaskDataEntity.h"
#import "LoginSubmitter.h"
#import "ActionsSubmitter.h"
#import "DictionariesChunkLoader.h"
#import "TaskListLoader.h"
#import "AttachmentsLoader.h"
#import "TaskInfoLoader.h"
#import "DocInfoLoader.h"
#import "DocListOnControlLoader.h"
#import "ActionSubmitterOperation.h"
#import "UserDefaults.h"
#import "SyncController.h"

@implementation ORDSyncManager

- (id)initForCleanupWithContext:(NSManagedObjectContext *)newContext {
    if ((self = [super init])) {
        syncContext = newContext;
    }
    return self;
}

- (void)prepareLaunchActions {
    NSLog(@"ORDSyncManager prepareLaunch");
    [super prepareLaunch];
    [syncQueueEntity appendItemToQueueWithName:[[ActionsSubmitter class] description] visible:YES group:2];
}

- (void)prepareLaunch {
    NSLog(@"ORDSyncManager prepareLaunch");
    [super prepareLaunch];    
    [syncQueueEntity appendItemToQueueWithName:[[ActionsSubmitter class] description] visible:YES group:2];
    [syncQueueEntity appendItemToQueueWithName:[[DictionariesChunkLoader class] description] visible:YES group:2];
    [syncQueueEntity appendItemToQueueWithName:[[TaskListLoader class] description] visible:YES group:2];
    [syncQueueEntity appendItemToQueueWithName:[[DocListOnControlLoader class] description] visible:YES group:2];
    [syncQueueEntity appendItemToQueueWithName:[[TaskInfoLoader class] description] visible:YES group:2];
    [syncQueueEntity appendItemToQueueWithName:[[DocInfoLoader class] description] visible:YES group:2];
    [syncQueueEntity appendItemToQueueWithName:[[AttachmentsLoader class] description] visible:YES group:2];        
}

#pragma mark cleanup:
- (void)cleanupORDDictionariesData {
    NSLog(@"ORDSyncManager cleanupORDDictionariesData"); 
    EmployeeListDataEntity *employeeEntity = [[EmployeeListDataEntity alloc] initWithContext:syncContext];
    [employeeEntity deleteAll];
    [employeeEntity release]; 
    
    EmployeeGroupDataEntity *employeeGroupEntity = [[EmployeeGroupDataEntity alloc] initWithContext:syncContext];
    [employeeGroupEntity deleteAll];
    [employeeGroupEntity release]; 
    
    ResolutionTemplateDataEntity *resolutionTemplateEntity = [[ResolutionTemplateDataEntity alloc] initWithContext:syncContext];
    [resolutionTemplateEntity deleteAll];
    [resolutionTemplateEntity release]; 
    
    //удалить данные о последней дате синхронизации
    [UserDefaults saveValue:constEmptyStringValue forSetting:constDictionariesLastUpdatedDate];
}

- (void)cleanupORDUserData {
    NSLog(@"ORDSyncManager cleanupORDUserData"); 
    DocDataEntity *docEntity = [[DocDataEntity alloc] initWithContext:syncContext];
    TaskDataEntity *taskEntity = [[TaskDataEntity alloc] initWithContext:syncContext];  
    ActionToSyncDataEntity *actionsEntity = [[ActionToSyncDataEntity alloc] initWithContext:syncContext];
    
    NSArray *attachments = [docEntity selectAllAttachments];
    for (DocAttachment *attachment in attachments) {     
        [SupportFunctions deleteAttachment:attachment.fileName];
    }
    [docEntity deleteAllDocs];
    [taskEntity deleteAllTasks]; 
    [actionsEntity deleteAllActionsToSync];
    
    [docEntity release];
    [taskEntity release];
    [actionsEntity release];
}

- (void)cleanupORDUserDataForRegularTasks {
    NSLog(@"ORDSyncManager cleanupORDUserDataForRegularTasks");
    DocDataEntity *docEntity = [[DocDataEntity alloc] initWithContext:syncContext];
    TaskDataEntity *taskEntity = [[TaskDataEntity alloc] initWithContext:syncContext];    
    
    NSArray *docs = [docEntity selectDocsLinkedOnlyWithRegularTasks];
    for (Doc *doc in docs) {
        for (DocAttachment *attachment in doc.attachments) {     
            [SupportFunctions deleteAttachment:attachment.fileName];
        }
    }
    [docEntity deleteDocsLinkedOnlyWithRegularTasks];
    //[taskEntity deleteRegularTasks]; 
    
    [docEntity release];
    [taskEntity release];
}

- (void)cleanupORDUserDataForOnControlTasks {
    NSLog(@"ORDSyncManager cleanupORDUserDataForOnControlTasks");
    DocDataEntity *docEntity = [[DocDataEntity alloc] initWithContext:syncContext];
    TaskDataEntity *taskEntity = [[TaskDataEntity alloc] initWithContext:syncContext];    
    
    NSArray *docs = [docEntity selectDocsLinkedOnlyWithOnControlTasks];
    for (Doc *doc in docs) {
        for (DocAttachment *attachment in doc.attachments) {     
            [SupportFunctions deleteAttachment:attachment.fileName];
        }
    }
    [docEntity deleteDocsLinkedOnlyWithOnControlTasks];
    //[taskEntity deleteOnControlTasks]; 
    
    [docEntity release];
    [taskEntity release];    
}

- (void)cleanupORDDataForTaskWithId:(NSString *)taskId {
    NSLog(@"ORDSyncManager cleanupORDDataForTaskithId:%@", taskId);
    
    TaskDataEntity *taskEntity = [[TaskDataEntity alloc] initWithContext:syncContext];  
    Task *task = [taskEntity selectTaskById:taskId];
    Doc *doc = task.doc;
    
    NSInteger tasksForDocCount = [doc.tasks count];
    NSString *docId = doc.id;
    
    doc = nil;
    task = nil;
    
    [taskEntity deleteTaskWithId:taskId];
    [taskEntity release];
    
    if (tasksForDocCount == 1) {
        DocDataEntity *docEntity = [[DocDataEntity alloc] initWithContext:syncContext];        
        NSArray *attachments = [docEntity selectAttachmentsForDocWithId:docId];
        for (DocAttachment *attachment in attachments) {     
            [SupportFunctions deleteAttachment:attachment.fileName];
        }
        [docEntity deleteDocWithId:docId];
        [docEntity release]; 
    }
}

- (void)cleanupORDDataForDocWithId:(NSString *)docId {
    NSLog(@"ORDSyncManager cleanupORDDataForDocWithId:%@", docId);
    DocDataEntity *docEntity = [[DocDataEntity alloc] initWithContext:syncContext];
    
    NSArray *attachments = [docEntity selectAttachmentsForDocWithId:docId];
    for (DocAttachment *attachment in attachments) {     
        [SupportFunctions deleteAttachment:attachment.fileName];
    }
    [docEntity deleteDocWithId:docId];
    
    [docEntity release];
}

- (void)cleanupORDDataForDocsWithIds:(NSArray *)docIds {
    NSLog(@"ORDSyncManager cleanupORDDataForDocs");
    DocDataEntity *docEntity = [[DocDataEntity alloc] initWithContext:syncContext];
    
    for (NSString *docId in docIds) {
        NSArray *attachments = [docEntity selectAttachmentsForDocWithId:docId];
        for (DocAttachment *attachment in attachments) {     
            [SupportFunctions deleteAttachment:attachment.fileName];
        }
        [docEntity deleteDocWithId:docId];
    }
    
    [docEntity release];
}

#pragma mark sync:
- (void)cleanupSync {
    NSLog(@"ORDSyncManager cleanupSync");
    [super cleanupSync];
    [self cleanupORDDictionariesData];
    [self cleanupORDUserData];
}

- (void)launchSyncActionsWithDelegate:(NSObject<BaseLoaderDelegate> *)newDelegate {
    NSLog(@"ORDSyncManager launchSyncActionsWithDelegate");
    [super launchSync];
    
    ActionSubmitterOperation *actionSubmitterOperation = [[[ActionSubmitterOperation alloc] initWithLoaderDelegate:newDelegate] autorelease];
    [actionSubmitterOperation start];
}

- (void)launchSync {
    NSLog(@"ORDSyncManager launchSync");
    [super launchSync];
    
    int lastCompletedStep = [SyncController lastCompletedStep];
    int currentStep;

    if ([self isAbortSyncRequested] == NO)  {
        currentStep = [syncDelegate currentStep];
        if ((lastCompletedStep == 0 || lastCompletedStep <= currentStep)) {
            ActionsSubmitter *actionsSubmitter = 
                [[ActionsSubmitter alloc] initWithLoaderDelegate:self andContext:syncContext forSyncModule:DSModuleORDServer]; 
            [actionsSubmitter loadSyncData];
            [actionsSubmitter release];
        }
        else {
            [ActionsSubmitter notifyAboutSkippedStep];    
        }
        [syncDelegate incrementCurrentStep];
    }
    
    if ([self isAbortSyncRequested] == NO) {
        currentStep = [syncDelegate currentStep];
        if (lastCompletedStep == 0 || lastCompletedStep <= currentStep) {    
            DictionariesChunkLoader *dictionariesLoader = 
                [[DictionariesChunkLoader alloc] initWithLoaderDelegate:self andContext:syncContext forSyncModule:DSModuleORDServer];
            [dictionariesLoader loadSyncData];
            [dictionariesLoader release];
        }
        else {
            [DictionariesChunkLoader notifyAboutSkippedStep];    
        }
        [syncDelegate incrementCurrentStep];    
    }
    
    NSArray *regularErrors = [NSArray array];
    if ([self isAbortSyncRequested] == NO) {
        currentStep = [syncDelegate currentStep];
        if (lastCompletedStep == 0 || lastCompletedStep <= currentStep) {
            TaskListLoader *taskListLoader = 
                [[TaskListLoader alloc] initWithLoaderDelegate:self andContext:syncContext forSyncModule:DSModuleORDServer];
            regularErrors = [taskListLoader loadSyncData];
            [taskListLoader release];
        }
        else {
            [TaskListLoader notifyAboutSkippedStep];    
        }
        [syncDelegate incrementCurrentStep];
    }
    
    NSArray *onControlErrors = [NSArray array];
    if ([self isAbortSyncRequested] == NO) {
        currentStep = [syncDelegate currentStep];
        if (lastCompletedStep == 0 || lastCompletedStep <= currentStep) {
            DocListOnControlLoader * docListOnControlLoader = 
                [[DocListOnControlLoader alloc] initWithLoaderDelegate:self andContext:syncContext forSyncModule:DSModuleORDServer];
            onControlErrors = [docListOnControlLoader loadSyncData];
            [docListOnControlLoader release];
        }
        else {
            [DocListOnControlLoader notifyAboutSkippedStep];    
        }
        [syncDelegate incrementCurrentStep];
    }
    
    if ([self isAbortSyncRequested] == NO && ([regularErrors count] > 0 || [onControlErrors count] > 0)) {
        [syncDelegate abortSync];
        //TO DO add fail messages to remain requests
    }
    else {
        if ([self isAbortSyncRequested] == NO) {
            currentStep = [syncDelegate currentStep];
            if (lastCompletedStep == 0 || lastCompletedStep <= currentStep) {
                TaskInfoLoader *taskInfoLoader = 
                    [[TaskInfoLoader alloc] initWithLoaderDelegate:self andContext:syncContext forSyncModule:DSModuleORDServer];
                [taskInfoLoader loadSyncData];
                [taskInfoLoader release];
            }
            else {
                [TaskInfoLoader notifyAboutSkippedStep];    
            }
            [syncDelegate incrementCurrentStep];
        }

        if ([self isAbortSyncRequested] == NO) {
            currentStep = [syncDelegate currentStep];
            if (lastCompletedStep == 0 || lastCompletedStep <= currentStep) {
                DocInfoLoader *docInfoLoader = 
                    [[DocInfoLoader alloc] initWithLoaderDelegate:self andContext:syncContext forSyncModule:DSModuleORDServer];
                [docInfoLoader loadSyncData];
                [docInfoLoader release];
            }
            else {
                [DocInfoLoader notifyAboutSkippedStep];    
            }
            [syncDelegate incrementCurrentStep];
        }
        
        if ([self isAbortSyncRequested] == NO) {
            currentStep = [syncDelegate currentStep];
            if (lastCompletedStep == 0 || lastCompletedStep <= currentStep) {
                AttachmentsLoader *attachmentsLoader = 
                    [[AttachmentsLoader alloc] initWithLoaderDelegate:self andContext:syncContext forSyncModule:DSModuleORDServer];
                [attachmentsLoader loadSyncData];
                [attachmentsLoader release];
            }
            else {
                [AttachmentsLoader notifyAboutSkippedStep];    
            }
            [syncDelegate incrementCurrentStep];
        }
    }
    [self syncFinished];
}


- (void)dealloc {
    [super dealloc];
}
@end
