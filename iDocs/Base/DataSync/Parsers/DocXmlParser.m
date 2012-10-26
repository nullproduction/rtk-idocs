//
//  DocXmlParser.m
//  iDoc
//
//  Created by katrin on 14.04.11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import "DocXmlParser.h"
#import "SMXMLDocument+RPC.h"
#import "TaskDataEntity.h"
#import "DocDataEntity.h"
#import "SupportFunctions.h"
#import "Doc.h"
#import "DocAttachment.h"
#import "DocErrand.h"
#import "DocRequisite.h"
#import "DocEndorsementGroup.h"
#import "DocEndorsement.h"
#import "DocNotice.h"
#import "Task.h"
#import "TaskAction.h"

#define attachmentIdIndex 0
#define attachmentNameIndex 1
#define attachmentSizeIndex 2
#define attachmentTypeIndex 3

@interface DocXmlParser(PrivateMethods)
- (NSString *)getDocIdFromRecord:(SMXMLElement *)record;
- (void)updateDocEntity:(Doc *)doc withGeneralSectionInRecord:(SMXMLElement *)record;
- (void)updateDocEntity:(Doc *)doc withInfoSectionInRecord:(SMXMLElement *)record;
- (void)addAttachmentsToDocEntity:(Doc *)doc fromFilesSectionInRecord:(SMXMLElement *)record;
- (void)addReportAttachmentToErrandEntityWithDoc:(Doc *)doc fromExecutionSectionInRecord:(SMXMLElement *)record;
- (void)addErrandsToDocEntity:(Doc *)doc fromExecutionSectionInRecord:(SMXMLElement *)record;
- (void)sortErrandsForDoc:(Doc *)doc;
- (void)addRequisitesToDocEntity:(Doc *)doc fromRequisitesSectionInRecord:(SMXMLElement *)record;
- (void)addEndorsementsToDocEntity:(Doc *)doc fromEndorsementSectionInRecord:(SMXMLElement *)record;
- (void)addNoticesToDocEntity:(Doc *)doc fromAcquaintanceSectionInRecord:(SMXMLElement *)record;
@end

@implementation DocXmlParser

- (id)initWithContext:(NSManagedObjectContext *)context {   
    if ((self = [super initWithContext:context])) {        
        taskEntity = [[TaskDataEntity alloc] initWithContext:context];
        docEntity = [[DocDataEntity alloc] initWithContext:context];
	}
	return self;
}

- (NSString *)parseAndInsertDocsData:(NSData *)data {
    NSLog(@"DocXmlParser parseAndInsertDocsData started");  
    self.parserPool = [[NSAutoreleasePool alloc] init];
    
    NSError *error = nil;
    SMXMLDocument *document = [SMXMLDocument documentWithData:data RPCError:&error];
    if (error) {
        NSLog(@"DocXmlParser parseAndInsertDocData error: %@", [error localizedDescription]);
        return [error localizedDescription];
    }
        
    SMXMLElement *returnPacket = [document.root descendantWithPath:@"Body.getDocDescriptionWithContentPackageResponse"];    
    NSArray *records = [returnPacket childrenNamed:@"return"];
    for (SMXMLElement *record in records) { 
        NSString *docId = [self getDocIdFromRecord:record]; 
        Doc *doc = [docEntity selectDocById:docId];
        
        NSLog(@"%@",record);
        
        //add doc info
        if ([constSyncStatusToLoad isEqualToString:doc.systemSyncStatus]) {
            [self updateDocEntity:doc withGeneralSectionInRecord:record];
            [self updateDocEntity:doc withInfoSectionInRecord:record];        
            [self addAttachmentsToDocEntity:doc fromFilesSectionInRecord:record];
            [self addErrandsToDocEntity:doc fromExecutionSectionInRecord:record];
            [self sortErrandsForDoc:doc];
            [self addReportAttachmentToErrandEntityWithDoc:doc fromExecutionSectionInRecord:record];
            [self addRequisitesToDocEntity:doc fromRequisitesSectionInRecord:record];
            [self addEndorsementsToDocEntity:doc fromEndorsementSectionInRecord:record];
        
            doc.systemSyncStatus = constSyncStatusWorking;
        }
        else {
            NSLog(@"DocXmlParser doc:%@ is already updated", docId);        
        }
        NSLog(@"DocXmlParser parsed data for doc:%@", docId); 
    }
    
    [self saveParsedData];
    [parserPool release];
    self.parserPool = nil;
    
    NSLog(@"DocXmlParser parseAndInsertDocsData finished");     
    return nil;    
}

- (NSString *)getDocIdFromRecord:(SMXMLElement *)record {
    SMXMLElement *generalSection = [record descendantWithPath:@"General.Properties"];
    NSString *docId = [[[generalSection childWithAttribute:@"name" value:@"r_object_id:r_object_id"] childNamed:@"Value"] value];
    return docId;
}

- (void)updateDocEntity:(Doc *)doc withGeneralSectionInRecord:(SMXMLElement *)record {
    SMXMLElement *generalSection = [record descendantWithPath:@"General.Properties"];
    
    NSString *regNumber = [[[generalSection childWithAttribute:@"name" value:@"ka_registration_number:Рег. номер"] childNamed:@"Value"] value];
    doc.regNumber = regNumber;
    NSString *regDate = [[[generalSection childWithAttribute:@"name" value:@"ka_registration_date:Дата регистрации"] childNamed:@"Value"] value];    
    doc.regDate = [SupportFunctions convertXMLDateTimeStringToDate:regDate];    
}

- (void)updateDocEntity:(Doc *)doc withInfoSectionInRecord:(SMXMLElement *)record {
    SMXMLElement *generalSection = [record descendantWithPath:@"Info.Properties"];
    NSString *docDesc = [[[generalSection childWithAttribute:@"name" value:@"object_name:object_name"] childNamed:@"Value"] value];
    doc.desc = docDesc;
 
    NSString *ownerId = [[[generalSection childWithAttribute:@"name" value:@"ka_owner_name:Владелец"] childNamed:@"Value"] value];    
    SMXMLElement *dictionariesSection = [record descendantWithPath:@"Dictionaries"];
    NSArray *dictionaries = [dictionariesSection childrenNamed:@"DataObjects"];
    for (SMXMLElement *dictionary in dictionaries) { 
        SMXMLElement *dictData = [dictionary childNamed:@"Properties"]; 
        NSString *dictId = [[[dictData childWithAttribute:@"name" value:@"column0"] childNamed:@"Value"] value];
        if ([ownerId isEqualToString:dictId]) {
            doc.ownerId = ownerId;
            NSString *ownerName = [[[dictData childWithAttribute:@"name" value:@"column1"] childNamed:@"Value"] value]; 
            doc.ownerName = ownerName;
            break;
        }
    }
}

- (void)addAttachmentsToDocEntity:(Doc *)doc fromFilesSectionInRecord:(SMXMLElement *)record {       
    SMXMLElement *filesSection = [record descendantWithPath:@"Files"];
    NSArray *files = [filesSection childrenNamed:@"DataObjects"];
    int sortIndex = 1;
    for (SMXMLElement *file in files) { 
        SMXMLElement *data = [file childNamed:@"Properties"];
        
        DocAttachment *docAttachment = [docEntity createDocAttachment];
        NSString *attachmentId = [[[data childWithAttribute:@"name" value:@"r_object_id"] childNamed:@"Value"] value];
        docAttachment.id = attachmentId;
        NSString *attachmentName = [[[data childWithAttribute:@"name" value:@"object_name"] childNamed:@"Value"] value];
        docAttachment.name = attachmentName;
        NSString *attachmentType = [[[data childWithAttribute:@"name" value:@"a_content_type"] childNamed:@"Value"] value];
        docAttachment.type = attachmentType;
        NSString *attachmentSize = [[[data childWithAttribute:@"name" value:@"r_content_size"] childNamed:@"Value"] value];
        docAttachment.size = [NSNumber numberWithInt:[attachmentSize intValue]];
        
        //NSString *fileName = [NSString stringWithFormat:@"%@_%@", docAttachment.id, [attachmentName stringByReplacingOccurrencesOfString:@"/" withString:@"_"]]; 
        NSString *extensionName = ([attachmentName pathExtension] != nil) ? [attachmentName pathExtension] : constDefaultFileExtension;
        NSString *fileName = [NSString stringWithFormat:@"%@_%@.%@", doc.id, docAttachment.id, extensionName];
        docAttachment.fileName = fileName;
        
        docAttachment.systemLoaded = [NSNumber numberWithBool:NO];
        docAttachment.doc = doc;
        
        docAttachment.systemSortIndex = [NSNumber numberWithInt:sortIndex];
        sortIndex ++;
    }
}

- (void)addReportAttachmentToErrandEntityWithDoc:(Doc *)doc fromExecutionSectionInRecord:(SMXMLElement *)record
{
    SMXMLElement *reportsSection = [record descendantWithPath:@"Reports"];
    NSArray *reports = [reportsSection childrenNamed:@"DataObjects"];

    for (SMXMLElement *currentReport in reports)
    {
        SMXMLElement *reportProperties = [currentReport childNamed:@"Properties"];
        
        NSString *currentErrandId = [[[reportProperties childWithAttribute:@"name" value:@"errand_id"] childNamed:@"Value"] value];
        DocErrand *currentErrand = [docEntity selectErrandWithId:currentErrandId inDocWithId:doc.id];
        NSString *reportText = [[[reportProperties childWithAttribute:@"name" value:@"report_text"] childNamed:@"Value"] value];
        NSString *reportId = [[[reportProperties childWithAttribute:@"name" value:@"report_id"] childNamed:@"Value"] value];
        NSString *accepted = [[[reportProperties childWithAttribute:@"name" value:@"accepted"] childNamed:@"Value"] value];
        SMXMLElement *attachmentGroup = [reportProperties childWithAttribute:@"name" value:@"attachments"];
        NSArray *attachments = [attachmentGroup childrenNamed:@"Values"];
        
        if([attachments count] > 0)
        {
            for (SMXMLElement *currentAttachment in attachments)
            {
                ReportAttachment *reportAttachmentEntity = [docEntity createReportAttachment];
                
                reportAttachmentEntity.reportId = reportId;
                reportAttachmentEntity.reportText = reportText;
                reportAttachmentEntity.errand = currentErrand;
                reportAttachmentEntity.accepted = [NSNumber numberWithInt:[accepted intValue]];
                
                NSString *attachmentString = [currentAttachment value];
                NSArray *attachmentProperties = [attachmentString componentsSeparatedByString:@";"];
                
                NSString *attachmentId = [attachmentProperties objectAtIndex:attachmentIdIndex];
                reportAttachmentEntity.id = attachmentId;
                NSString *attachmentName = [attachmentProperties objectAtIndex:attachmentNameIndex];
                reportAttachmentEntity.name = attachmentName;
                NSString *attachmentSystemName = [NSString stringWithFormat:@"%@_%@",attachmentId,attachmentName];
                reportAttachmentEntity.systemName = attachmentSystemName;
                NSString *attachmentSize = [attachmentProperties objectAtIndex:attachmentSizeIndex];
                reportAttachmentEntity.size = [NSNumber numberWithInt:[attachmentSize intValue]];
                NSString *attachmentType = [attachmentProperties objectAtIndex:attachmentTypeIndex];
                reportAttachmentEntity.type = attachmentType;
                
//                NSLog(@"atc dev log: %@ %@ %@ %@",currentErrandId,reportText,reportId,attachmentString);
            }
        }
        else
        {
            ReportAttachment *reportAttachmentEntity = [docEntity createReportAttachment];
            
            reportAttachmentEntity.reportId = reportId;
            reportAttachmentEntity.reportText = reportText;
            reportAttachmentEntity.errand = currentErrand;
            reportAttachmentEntity.accepted = [NSNumber numberWithInt:[accepted intValue]];
        }
    }
}

- (void)addErrandsToDocEntity:(Doc *)doc fromExecutionSectionInRecord:(SMXMLElement *)record {
    SMXMLElement *dictionariesSection = [record descendantWithPath:@"Dictionaries"];
    NSArray *dictionaries = [dictionariesSection childrenNamed:@"DataObjects"];
    
    SMXMLElement *executionSection = [record descendantWithPath:@"Execution.Properties"];
    SMXMLElement *errandGroup = [executionSection childWithAttribute:@"name" value:@"kpa_person_execution:Исполнение"];
    NSArray *errands = [errandGroup childrenNamed:@"Values"];
    for (SMXMLElement *errand in errands) { 
        NSString *errandId = [errand value];
        for (SMXMLElement *dictionary in dictionaries) { 
            SMXMLElement *dictData = [dictionary childNamed:@"Properties"]; 
            NSString *dictId = [[[dictData childWithAttribute:@"name" value:@"column0"] childNamed:@"Value"] value];
            if ([errandId isEqualToString:dictId]) {
                DocErrand *errand = [docEntity createDocErrand];
                errand.id = dictId;
                NSString *dueDate = [[[dictData childWithAttribute:@"name" value:@"column2"] childNamed:@"Value"] value];
                errand.dueDate = [SupportFunctions convertXMLDateTimeStringToDate:dueDate];
                NSString *text = [[[dictData childWithAttribute:@"name" value:@"column3"] childNamed:@"Value"] value];
                errand.text = text;
                NSString *status = [[[dictData childWithAttribute:@"name" value:@"column4"] childNamed:@"Value"] value];
                errand.status = [NSNumber numberWithInt:[status intValue]];
                NSString *authorId = [[[dictData childWithAttribute:@"name" value:@"column7"] childNamed:@"Value"] value];
                errand.authorId = authorId;           
                NSString *authorName = [[[dictData childWithAttribute:@"name" value:@"column8"] childNamed:@"Value"] value];
                errand.authorName = authorName;
                NSString *number = [[[dictData childWithAttribute:@"name" value:@"column9"] childNamed:@"Value"] value];
                errand.number = number;
                NSString *report = [[[dictData childWithAttribute:@"name" value:@"column10"] childNamed:@"Value"] value];
                errand.report = report;
                NSString *parentId = [[[dictData childWithAttribute:@"name" value:@"column12"] childNamed:@"Value"] value];
                errand.parentId = parentId;
                
                NSString *errandActions = [[[dictData childWithAttribute:@"name" value:@"column11"] childNamed:@"Value"] value];
                if (errandActions != nil) {
                    NSArray *items = [errandActions componentsSeparatedByString:@";"];
                    int sortIndex = 1;
                    for (NSString *item in items) {
                        NSArray *itemData = [item componentsSeparatedByString:@","];
                        if ([itemData count] == 2) {
                            DocErrandAction *action = [docEntity createDocErrandAction];
                            action.id = [itemData objectAtIndex:0];
                            action.type = [itemData objectAtIndex:0];
                            action.name = [itemData objectAtIndex:1];
                            action.systemSortIndex = [NSNumber numberWithInt:sortIndex];
                            action.errand = errand;
                            sortIndex++;
                        }
                    }
                }
                
                NSString *executorInfoList = [[[dictData childWithAttribute:@"name" value:@"column5"] childNamed:@"Value"] value];
                NSString *executorNameList = [[[dictData childWithAttribute:@"name" value:@"column1"] childNamed:@"Value"] value];
                if (executorInfoList != nil) {
                    NSArray *executorInfos = [executorInfoList componentsSeparatedByString:@";"];
                    NSArray *executorNames = [executorNameList componentsSeparatedByString:@";"];
                    if ([executorInfos count] == [executorNames count]) {
                        for (int i = 0; [executorInfos count] > i; i++) {
                            DocErrandExecutor *executor = [docEntity createDocErrandExecutor];
                            NSArray *executorInfo = [[executorInfos objectAtIndex:i] componentsSeparatedByString:@"="];
                            executor.executorId = [executorInfo objectAtIndex:0];
                            if ([executorInfo count] == 2) {
                                BOOL isMajorExecutor = [[executorInfo objectAtIndex:1] boolValue];
                                executor.isMajorExecutor = [NSNumber numberWithBool:isMajorExecutor];
                            }
                            executor.executorName = [executorNames objectAtIndex:i];
                            executor.systemSortIndex = [NSNumber numberWithInt:(i+1)];
                            executor.errand = errand;
                        }
                    }
                }
            
                errand.doc = doc;
                break;
            }
        }        
    }
}

- (void)sortErrandsForDoc:(Doc *)doc {
    NSArray *sorted = [docEntity sortErrands:[doc.errands allObjects]];
    for (int i = 0; i < [sorted count]; i++) {
        DocErrand *errand = [sorted objectAtIndex:i];
        errand.systemSortIndex = [NSNumber numberWithInt:i];
    }
}

- (void)addRequisitesToDocEntity:(Doc *)doc fromRequisitesSectionInRecord:(SMXMLElement *)record {      
    SMXMLElement *requisitesSection = [record descendantWithPath:@"Requisites"];
    NSArray *requisites = [requisitesSection childrenNamed:@"DataObjects"];
    int sortIndex = 1;
    for (SMXMLElement *requisite in requisites) { 
        SMXMLElement *data = [requisite childNamed:@"Properties"];         
        
        DocRequisite *docRequisite = [docEntity createDocRequisite];
        NSString *requisiteName = [[[data childWithAttribute:@"name" value:@"name"] childNamed:@"Value"] value];
        docRequisite.name = requisiteName;
        NSString *requisiteValue = [[[data childWithAttribute:@"name" value:@"value"] childNamed:@"Value"] value];
        docRequisite.value = requisiteValue;
        docRequisite.doc = doc;
        
        docRequisite.systemSortIndex = [NSNumber numberWithInt:sortIndex];
        sortIndex ++;
    }
}

- (void)addEndorsementsToDocEntity:(Doc *)doc fromEndorsementSectionInRecord:(SMXMLElement *)record { 
    SMXMLElement *dictionariesSection = [record descendantWithPath:@"Dictionaries"];
    NSArray *dictionaries = [dictionariesSection childrenNamed:@"DataObjects"];
    
    SMXMLElement *endorsementSection = [record descendantWithPath:@"Agreement.Properties"];
    NSArray *groups = [endorsementSection childrenNamed:@"Properties"];
    int groupSortIndex = 1;
    for (SMXMLElement *group in groups) { 
        NSArray *endorsements = [group childrenNamed:@"Values"];
        
        if ([endorsements count] > 0) {
            DocEndorsementGroup *endorsementGroup = [docEntity createDocEndorsementGroup];
            NSString *endorsementName = [group attributeNamed:@"name"];
            NSArray *endorsementNameParts = [endorsementName componentsSeparatedByString:constSeparatorSymbol];
            endorsementGroup.id = ([endorsementNameParts count] == 2) ? [endorsementNameParts objectAtIndex:0] : endorsementName;             
            endorsementGroup.name = ([endorsementNameParts count] == 2) ? [endorsementNameParts objectAtIndex:1] : endorsementName;
            endorsementGroup.doc = doc;
            endorsementGroup.systemSortIndex = [NSNumber numberWithInt:groupSortIndex];
            groupSortIndex ++;
            
            int sortIndex = 1;
            for (SMXMLElement *endorsement in endorsements) { 
                NSString *endorsementId = [endorsement value];
                for (SMXMLElement *dictionary in dictionaries) { 
                    SMXMLElement *dictData = [dictionary childNamed:@"Properties"]; 
                    NSString *dictId = [[[dictData childWithAttribute:@"name" value:@"column0"] childNamed:@"Value"] value];
                    if ([endorsementId isEqualToString:dictId]) {
                        DocEndorsement *endorsement = [docEntity createDocEndorsement];
                       
                        endorsement.id = dictId;
                        NSString *endorsementPersonName = [[[dictData childWithAttribute:@"name" value:@"column1"] childNamed:@"Value"] value];
                        endorsement.personName = endorsementPersonName;
                        NSString *endorsementDate = [[[dictData childWithAttribute:@"name" value:@"column2"] childNamed:@"Value"] value];
                        endorsement.endorsementDate = [SupportFunctions convertXMLDateTimeStringToDate:endorsementDate];
                        NSString *endorsementPersonPosition = [[[dictData childWithAttribute:@"name" value:@"column3"] childNamed:@"Value"] value];
                        endorsement.personPosition = endorsementPersonPosition;
                        NSString *endorsementPersonId = [[[dictData childWithAttribute:@"name" value:@"column4"] childNamed:@"Value"] value];
                        endorsement.personId = endorsementPersonId;
                        NSString *endorsementStatus = [[[dictData childWithAttribute:@"name" value:@"column5"] childNamed:@"Value"] value];
                        endorsement.status = endorsementStatus;
                        NSString *endorsementDecision = [[[dictData childWithAttribute:@"name" value:@"column6"] childNamed:@"Value"] value];
                        endorsement.decision = endorsementDecision;
                        NSString *endorsementComment = [[[dictData childWithAttribute:@"name" value:@"column7"] childNamed:@"Value"] value];
                        endorsement.comment = endorsementComment;                
                        endorsement.doc = doc;
                        endorsement.group = endorsementGroup;
                        
                        endorsement.systemSortIndex = [NSNumber numberWithInt:sortIndex];
                        sortIndex ++;
                        break;
                    }
                }        
            }
        }
    }
}

- (void)addNoticesToDocEntity:(Doc *)doc fromAcquaintanceSectionInRecord:(SMXMLElement *)record {
    SMXMLElement *acquaintanceSection = [record descendantWithPath:@"Acquaintance"];
    NSArray *notices = [acquaintanceSection childrenNamed:@"DataObjects"];
    int sortIndex = 1;
    for (SMXMLElement *notice in notices) { 
        SMXMLElement *data = [notice childNamed:@"Properties"];
        
        DocNotice *docNotice = [docEntity createDocNotice];
        NSString *noticeId = [[[data childWithAttribute:@"name" value:@"id"] childNamed:@"Value"] value];
        docNotice.id = noticeId;
        NSString *fromPersonId = [[[data childWithAttribute:@"name" value:@"from_person_id"] childNamed:@"Value"] value];
        docNotice.fromPersonId = fromPersonId;
        NSString *fromPersonName = [[[data childWithAttribute:@"name" value:@"from_person_name"] childNamed:@"Value"] value];
        docNotice.fromPersonName = fromPersonName;
        NSString *toPersonId = [[[data childWithAttribute:@"name" value:@"to_person_id"] childNamed:@"Value"] value];
        docNotice.toPersonId = toPersonId;
        NSString *toPersonName = [[[data childWithAttribute:@"name" value:@"to_person_name"] childNamed:@"Value"] value];
        docNotice.toPersonName = toPersonName;        
        NSString *comment = [[[data childWithAttribute:@"name" value:@"comment"] childNamed:@"Value"] value];
        docNotice.comment = comment;
        NSString *sendDate = [[[data childWithAttribute:@"name" value:@"send_date"] childNamed:@"Value"] value];
        docNotice.sendDate = [SupportFunctions convertXMLDateTimeStringToDate:sendDate];
        NSString *status = [[[data childWithAttribute:@"name" value:@"status"] childNamed:@"Value"] value];
        docNotice.status = [NSNumber numberWithInt:[status intValue]]; //0 - in progress, 1 - viewed
        docNotice.systemSortIndex = [NSNumber numberWithInt:sortIndex];
        docNotice.doc = doc;
        sortIndex++;
    }   
}

- (void)dealloc {
    [taskEntity release];
    [docEntity release];
    [super dealloc];
}

@end
