//
//  TaskXmlParser.m
//  iDoc
//
//  Created by katrin on 14.04.11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import "TaskXmlParser.h"
#import "Constants.h"
#import "SMXMLDocument+RPC.h"
#import "ClientSettingsDataEntity.h"
#import "TaskDataEntity.h"
#import "DocDataEntity.h"
#import "SupportFunctions.h"
#import "DashboardItem.h"
#import "Doc.h"
#import "Task.h"
#import "TaskAction.h"
#import "DocAttachment.h"

@interface TaskXmlParser (PrivateMethods)
- (void)updateLocalStructureWithServerData:(NSArray *)tasks;
- (void)addActionsToTaskEntity:(Task *)task fromActionsSectionInReturnPacket:(SMXMLElement *)returnPacket;
- (void)addInfoToTaskDataEntity:(Task *)task fromTaskInfoSectionInReturnPacket:(SMXMLElement *)returnPacket;
@end

@implementation TaskXmlParser

- (id)initWithContext:(NSManagedObjectContext *)context {   
    if ((self = [super initWithContext:context])) {  
        clientSettingsEntity = [[ClientSettingsDataEntity alloc] initWithContext:context];
        taskEntity = [[TaskDataEntity alloc] initWithContext:context];
        docEntity = [[DocDataEntity alloc] initWithContext:context];
	}
	return self;
}

#pragma mark task block methods
- (void)updateLocalStructureWithServerData:(NSArray *)tasks {
    NSLog(@"TaskXmlParser updateLocalStructureWithServerData started for tasks count: %i", (tasks != nil) ? [tasks count] : 0);
        
    //помечаем документы связанные со стандартными задачами и сами стандартные задачи со статусом "рабочие" как "устаревшие"
    [taskEntity depreciateWorkingRegularTasks];
    [docEntity depreciateWorkingDocsWithRegularTasks];

    //анализируем
    for (SMXMLElement *taskNode in tasks) {
        SMXMLElement *taskData = [taskNode childNamed:@"Properties"];

        //анализ задачи
        NSString *taskId = [[[taskData childWithAttribute:@"name" value:@"item_id"] childNamed:@"Value"] value];        
        NSString *taskUpdateTime = [[[taskData childWithAttribute:@"name" value:@"taskupdatetime"] childNamed:@"Value"] value];
        NSDate *taskUpdateDate = [SupportFunctions convertXMLDateTimeStringToDate:taskUpdateTime];        
        Task *localTask = [taskEntity selectTaskById:taskId];
        
        //задача существует 
        if (localTask != nil) { 
            //задача не была еще обработана
            if (![constSyncStatusWorking isEqualToString:localTask.systemSyncStatus] &&
                ![constSyncStatusToLoad isEqualToString:localTask.systemSyncStatus]) { 
                //обновления не требуется
                if([taskUpdateDate compare:localTask.systemUpdateDate] == NSOrderedSame) {
                    localTask.systemSyncStatus = constSyncStatusWorking;
                }
                else { //обновление требуется
                    localTask.dashboardItems = nil;
                    [taskEntity deleteTaskActionsForTaskWithId:taskId];
                
                    localTask.systemUpdateDate = taskUpdateDate;
                    localTask.systemCurrentErrandId = 
                        [[[taskData childWithAttribute:@"name" value:@"currenterrandid"] childNamed:@"Value"] value]; 
                    NSString *taskTypesList = [[[taskData childWithAttribute:@"name" value:@"taskType"] childNamed:@"Value"] value]; 
                    NSArray *taskTypes = [taskTypesList componentsSeparatedByString: @","]; 
                    for (NSString *taskType in taskTypes) {
                        DashboardItem *dashboardItem = [clientSettingsEntity selectDashboardItemById:taskType];
                        if (dashboardItem != nil)
                            [localTask addDashboardItemsObject:dashboardItem];
                    }
                    localTask.systemSyncStatus = constSyncStatusToLoad; 
                }
            }
        }
        //новая задача
        else {
            localTask = [taskEntity createTask];
            localTask.id = taskId;
            localTask.systemUpdateDate = taskUpdateDate;
            localTask.systemCurrentErrandId = 
                [[[taskData childWithAttribute:@"name" value:@"currenterrandid"] childNamed:@"Value"] value];
            NSString *taskTypesList = [[[taskData childWithAttribute:@"name" value:@"taskType"] childNamed:@"Value"] value]; 
            localTask.dashboardItems = nil;
            NSArray *taskTypes = [taskTypesList componentsSeparatedByString: @","]; 
            for (NSString *taskType in taskTypes) {
                DashboardItem *dashboardItem = [clientSettingsEntity selectDashboardItemById:taskType];
                if (dashboardItem != nil)
                    [localTask addDashboardItemsObject:dashboardItem];
            }
            localTask.type = [NSNumber numberWithInt:ORDTaskTypeRegular];
            
            localTask.systemSyncStatus = constSyncStatusToLoad;
        }
       
        //анализ документа
        NSString *docId = [[[taskData childWithAttribute:@"name" value:@"sys_r_object_id"] childNamed:@"Value"] value];                
        NSString *docUpdateTime = [[[taskData childWithAttribute:@"name" value:@"documentupdatetime"] childNamed:@"Value"] value];
        NSDate *docUpdateDate = [SupportFunctions convertXMLDateTimeStringToDate:docUpdateTime];
        Doc *localDoc = [docEntity selectDocById:docId];
        //документ существует
        if (localDoc != nil) {
            //документ не был еще обработан
            if (![constSyncStatusWorking isEqualToString:localDoc.systemSyncStatus] &&
                ![constSyncStatusToLoad isEqualToString:localDoc.systemSyncStatus]) { 
                //обновления не требуется
                if([docUpdateDate compare:localDoc.systemUpdateDate] == NSOrderedSame) {
                    localDoc.systemSyncStatus = constSyncStatusWorking;
                } 
                //обновлениe требуется
                else { 
                    NSArray *attachments = [docEntity selectAttachmentsForDocWithId:docId];
                    for (DocAttachment *attachment in attachments) {     
                        [SupportFunctions deleteAttachment:attachment.fileName];
                    }
                    [docEntity deleteAttachmentsForDocWithId:docId];
                    [docEntity deleteEndorsementGroupsForDocWithId:docId];
                    [docEntity deleteErrandsForDocWithId:docId];
                    [docEntity deleteRequisitesForDocWithId:docId];
                    [docEntity unlinkRegularTasksFromDocWithId:docId];
                    localDoc.systemUpdateDate = docUpdateDate;
                    localDoc.systemSyncStatus = constSyncStatusToLoad;
                }
            }
        }
        //новый документ
        else {
            localDoc = [docEntity createDoc];
            localDoc.id = docId;
            localDoc.systemUpdateDate = docUpdateDate;
            localDoc.systemSyncStatus = constSyncStatusToLoad;
        }
        
        //добавление связи задачи и документа
        if (![taskEntity isTaskWithId:taskId linkedToDocWithId:docId]) {
            [localDoc addTasksObject:localTask];
        }
    }

    //исключаем из удаления документы для которых есть задачи "на контроле"
    NSArray *docs = [docEntity selectDocsForRemovalLinkedWithOnControlTasks];
    for (Doc *doc in docs) {
       doc.systemSyncStatus = constSyncStatusWorking; 
    }
    
    //удаляем устаревшие вложения, документы и задачи
    NSArray *attachments = [docEntity selectAttachmentsToDelete];
    for (DocAttachment *attachment in attachments) {     
        [SupportFunctions deleteAttachment:attachment.fileName];
    }
    [docEntity deleteDocsForRemoval];
    [taskEntity deleteTasksForRemoval];
    NSLog(@"TaskXmlParser updateLocalStructureWithServerData finished");    
}

- (NSString *)parseAndInsertTaskData:(NSData *)data forTaskBlock:(NSString *)block { 
    NSLog(@"TaskXmlParser parseAndInsertDocsData forTaskBlock:%@ started", block); 
    NSMutableString* parseErr = [NSMutableString string];
    NSError *error = nil;
    
    self.parserPool = [[NSAutoreleasePool alloc] init];
    
    SMXMLDocument *document = [SMXMLDocument documentWithData:data RPCError:&error];
    if (error) {
        NSLog(@"TaskXmlParser parseAndInsertTaskData error: %@", [error localizedDescription]);
        [parseErr setString:[error localizedDescription]];
        [parserPool release];
        self.parserPool = nil;
        return (NSString *)parseErr;
    }

    SMXMLElement *returnPacket = [document.root descendantWithPath:@"Body.getMyTasksResponse.return"];
    NSArray *tasks = [returnPacket childrenNamed:@"DataObjects"];
    
    //обновление структуры локальных данных
    [self updateLocalStructureWithServerData:tasks];
    
    for (SMXMLElement *taskNode in tasks) {
        SMXMLElement *taskData = [taskNode childNamed:@"Properties"];
                
        NSString *docId = [[[taskData childWithAttribute:@"name" value:@"sys_r_object_id"] childNamed:@"Value"] value];         
        Doc *doc = [docEntity selectDocById:docId];
        if ([constSyncStatusToLoad isEqualToString:doc.systemSyncStatus]) {   
            NSString *docTypeName = [[[taskData childWithAttribute:@"name" value:@"ka_doc_kind"] childNamed:@"Value"] value];
            doc.typeName = docTypeName; 

            NSLog(@"DocDataEntity updated doc info:%@", docId); 
        } 
        else {
            NSLog(@"DocDataEntity doc:%@ data is up to date", docId);            
        }
    }
    
    [self saveParsedData];
    [parserPool release];
    self.parserPool = nil;
    
    NSLog(@"TaskXmlParser parseAndInsertTaskData for block:%@ finished", block);    
    return nil;
}


#pragma mark task info methods
- (NSString *)parseAndInsertTaskData:(NSData *)data forTaskId:(NSString *)taskId {   
    NSLog(@"TaskXmlParser parseAndInsertTaskData for forTaskId:%@", taskId); 
    NSMutableString* parseErr = [NSMutableString string];
    NSError *error = nil;

    self.parserPool = [[NSAutoreleasePool alloc] init];
    
    SMXMLDocument *document = [SMXMLDocument documentWithData:data RPCError:&error];
    if (error) {
        NSLog(@"TaskXmlParser parseAndInsertTaskData error: %@", [error localizedDescription]);
        [parseErr setString:[error localizedDescription]];
        [parserPool release];
        self.parserPool = nil;
        return (NSString *)parseErr;
    }
    
    SMXMLElement *returnPacket = [document.root descendantWithPath:@"Body.getTaskDescriptionResponse.return"];
    Task *task = [taskEntity selectTaskById:taskId];
    [self addActionsToTaskEntity:task fromActionsSectionInReturnPacket:returnPacket];
    [self addInfoToTaskDataEntity:task fromTaskInfoSectionInReturnPacket:returnPacket];
    
    task.systemSyncStatus = constSyncStatusWorking;
    
    [self saveParsedData];
    [parserPool release];
    self.parserPool = nil;
    
    return nil;
}

- (void)addInfoToTaskDataEntity:(Task *)task fromTaskInfoSectionInReturnPacket:(SMXMLElement *)returnPacket {        
    SMXMLElement *dictionariesSection = [returnPacket descendantWithPath:@"Dictionaries"];
    NSArray *dictionaries = [dictionariesSection childrenNamed:@"DataObjects"];
    
    SMXMLElement *taskInfoSection = [returnPacket descendantWithPath:@"TaskInfoButton.Properties"];
    NSString *taskId = [[[taskInfoSection childWithAttribute:@"name" value:@"kpa_task:Задача"] childNamed:@"Value"] value];
    for (SMXMLElement *dictionary in dictionaries) { 
        SMXMLElement *dictData = [dictionary childNamed:@"Properties"]; 
        NSString *dictId = [[[dictData childWithAttribute:@"name" value:@"column0"] childNamed:@"Value"] value];
        if ([taskId isEqualToString:dictId]) {
            NSString *taskName = [[[dictData childWithAttribute:@"name" value:@"column1"] childNamed:@"Value"] value];
            task.name = taskName;
            NSString *isTaskViewed = [[[dictData childWithAttribute:@"name" value:@"column4"] childNamed:@"Value"] value];
            task.isViewed = [NSNumber numberWithInt:[isTaskViewed intValue]];
            NSString *dueDate = [[[dictData childWithAttribute:@"name" value:@"column5"] childNamed:@"Value"] value];
            task.dueDate = [SupportFunctions convertXMLDateTimeStringToDate:dueDate];
            task.systemHasDueDate = [NSNumber numberWithBool:((task.dueDate != nil) ? YES : NO)];
            break;
        }
    }        
}

- (void)addActionsToTaskEntity:(Task *)task fromActionsSectionInReturnPacket:(SMXMLElement *)returnPacket {       
    SMXMLElement *actionsSection = [returnPacket descendantWithPath:@"ActionButton"];
    NSArray *records = [actionsSection childrenNamed:@"DataObjects"];
    int  sortIndex = 1;
    for (SMXMLElement *record in records) { 
        SMXMLElement *data = [record childNamed:@"Properties"];
        
        TaskAction *taskAction = [taskEntity createTaskAction];
        NSString *actionName = [[[data childWithAttribute:@"name" value:@"action_name"] childNamed:@"Value"] value];
        taskAction.name = actionName;
        NSString *actionId = [[[data childWithAttribute:@"name" value:@"action_id"] childNamed:@"Value"] value];
        taskAction.id = actionId;
        NSString *actionType = [[[data childWithAttribute:@"name" value:@"action_type"] childNamed:@"Value"] value];
        taskAction.type = actionType;
        NSString *actionButtonColor = [[[data childWithAttribute:@"name" value:@"color"] childNamed:@"Value"] value];
        taskAction.buttonColor = actionButtonColor;
        NSString *actionIsFinal = [[[data childWithAttribute:@"name" value:@"isFinal"] childNamed:@"Value"] value];
        bool isFinal = [actionIsFinal boolValue];
        taskAction.isFinal = [NSNumber numberWithBool:isFinal];
        NSString *actionResultText = [[[data childWithAttribute:@"name" value:@"resultText"] childNamed:@"Value"] value];
        taskAction.resultText = actionResultText;
        taskAction.task = task;
        taskAction.systemSortIndex = [NSNumber numberWithInt:sortIndex];
        
        sortIndex ++;
    }
}


- (void)dealloc {
    [clientSettingsEntity release];
    [taskEntity release];
    [docEntity release];
    [super dealloc];
}

@end
