//
//  DocListOnControlXmlParser.m
//  iDoc
//
//  Created by Konstantin Krupovich on 8/18/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import "DocListOnControlXmlParser.h"
#import "Constants.h"
#import "SMXMLDocument+RPC.h"
#import "ClientSettingsDataEntity.h"
#import "TaskDataEntity.h"
#import "DocDataEntity.h"
#import "SupportFunctions.h"
#import "DashboardItem.h"
#import "Doc.h"
#import "Task.h"
#import "DocAttachment.h"
#import "TaskAction.h"
#import "DocListOnControlLoader.h"


@interface DocListOnControlXmlParser (PrivateMethods)
- (void)updateLocalStructureWithServerData:(NSArray *)docs;
@end

@implementation DocListOnControlXmlParser

- (id)initWithContext:(NSManagedObjectContext *)context {   
    if ((self = [super initWithContext:context])) {  
        clientSettingsEntity = [[ClientSettingsDataEntity alloc] initWithContext:context];
        taskEntity = [[TaskDataEntity alloc] initWithContext:context];
        docEntity = [[DocDataEntity alloc] initWithContext:context];
	}
	return self;
}

- (NSString *)parseAndInsertDocListData:(NSData *)data {
    NSLog(@"DocListOnControlXmlParser parseAndInsertDocsData started");  
    self.parserPool = [[NSAutoreleasePool alloc] init];
    
    NSError *error = nil;
    SMXMLDocument *document = [SMXMLDocument documentWithData:data RPCError:&error];
    if (error) {
        NSLog(@"DocListOnControlXmlParser parseAndInsertDocData error: %@", [error localizedDescription]);
        return [error localizedDescription];
    }
    
    SMXMLElement *returnPacket = [document.root descendantWithPath:@"Body.getMyDocumentsResponse.return"];    
    NSArray *docs = [returnPacket childrenNamed:@"DataObjects"];
    //обновление структуры локальных данных
    [self updateLocalStructureWithServerData:docs];
    
    [self saveParsedData];
    [parserPool release];
    self.parserPool = nil;
    
    NSLog(@"DocListOnControlXmlParser parseAndInsertDocsData finished");     
    return nil;
}

- (void)updateLocalStructureWithServerData:(NSArray *)docs {
    NSLog(@"DocListOnControlXmlParser updateLocalStructureWithServerData started for docs count: %i", (docs != nil) ? [docs count] : 0);
    
    //помечаем документы и задачи "на контроле" со статусом "рабочие" как "устаревшие"
    [taskEntity depreciateWorkingOnControlTasks];
    [docEntity depreciateWorkingDocsWithOnControlTasks];
    
    //анализируем
    for (SMXMLElement *doc in docs) {
        SMXMLElement *docData = [doc childNamed:@"Properties"];
        
        //анализ задачи
        NSString *docId = [[[docData childWithAttribute:@"name" value:@"r_object_id"] childNamed:@"Value"] value];        
        NSString *docUpdateTime = [[[docData childWithAttribute:@"name" value:@"documentupdatetime"] childNamed:@"Value"] value];
        NSDate *docUpdateDate = [SupportFunctions convertXMLDateTimeStringToDate:docUpdateTime];
        //NSString *docName = [[[docData childWithAttribute:@"name" value:@"ka_object_name"] childNamed:@"Value"] value];
        
        //обработка документа        
        Doc *localDoc = [docEntity selectDocById:docId];
        if (localDoc != nil) { //документ существует
            //документ не был еще обработан
            if (![constSyncStatusWorking isEqualToString:localDoc.systemSyncStatus] &&
                ![constSyncStatusToLoad isEqualToString:localDoc.systemSyncStatus]) { 
                //обновления не требуется
                if([docUpdateDate compare:localDoc.systemUpdateDate] == NSOrderedSame) {
                    localDoc.systemSyncStatus = constSyncStatusWorking;
                } //обновление требуется
                else { 
                    NSArray *attachments = [docEntity selectAttachmentsForDocWithId:docId];
                    for (DocAttachment *attachment in attachments) {     
                        [SupportFunctions deleteAttachment:attachment.fileName];
                    }
                    [docEntity deleteAttachmentsForDocWithId:docId];
                    [docEntity deleteEndorsementGroupsForDocWithId:docId];
                    [docEntity deleteErrandsForDocWithId:docId];
                    [docEntity deleteRequisitesForDocWithId:docId];
                    localDoc.systemUpdateDate = docUpdateDate;
                    localDoc.systemSyncStatus = constSyncStatusToLoad;
                }
            }
        }
        else { //новый документ
            localDoc = [docEntity createDoc];
            localDoc.id = docId;
            localDoc.systemUpdateDate = docUpdateDate;
            localDoc.systemSyncStatus = constSyncStatusToLoad;
        }
        
        //обработка задачи
        Task *localTask = [taskEntity selectTaskOnControlForDocWithId:docId];
        //задача существует
        if (localTask != nil) { 
            //документ по задаче должен быть обновлен - пересоздаем действия по документу
            if([constSyncStatusToLoad isEqualToString:localDoc.systemSyncStatus]) {
                [taskEntity deleteTaskActionsForTaskWithId:localTask.id];
                [taskEntity createActionsFromTemplatesForTaskWithId:localTask.id];
                localTask.systemUpdateDate = localDoc.systemUpdateDate;
            }

        }
        //задачи нет - добавляем новую задачу "на контроле"
        else { 
            localTask = [taskEntity createTaskOnControlForDocWithId:docId];
        }
        localTask.systemSyncStatus = constSyncStatusWorking;
    }
    
    //исключаем из удаления документы для которых есть стандартные задачи
    NSArray *docsWithRegularTasks = [docEntity selectDocsForRemovalLinkedWithRegularTasks];
    for (Doc *doc in docsWithRegularTasks) {
        doc.systemSyncStatus = constSyncStatusWorking; 
    }
    
    //удаляем устаревшие вложения, документы и задачи
    NSArray *attachments = [docEntity selectAttachmentsToDelete];
    for (DocAttachment *attachment in attachments) {     
        [SupportFunctions deleteAttachment:attachment.fileName];
    }
    [docEntity deleteDocsForRemoval];
    [taskEntity deleteTasksForRemoval];
    NSLog(@"DocListOnControlXmlParser updateLocalStructureWithServerData finished");    
}

- (void)dealloc {
    [clientSettingsEntity release];
    [taskEntity release];
    [docEntity release];
    [super dealloc];
}

@end
