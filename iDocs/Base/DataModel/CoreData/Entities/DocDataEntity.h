//
//  DocDataEntity.h
//  iDoc
//
//  Created by rednekis on 5/8/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Doc.h"
#import "DocErrandExecutor.h"
#import "DocErrandAction.h"
#import "ReportAttachment.h"

#define constDocEntity @"Doc"
#define constDocAttachmentEntity @"DocAttachment"
#define constDocErrandEntity @"DocErrand"
#define constReportAttachmentEntity @"ReportAttachment"
#define constDocErrandExecutorEntity @"DocErrandExecutor"
#define constDocErrandActionEntity @"DocErrandAction"
#define constDocEndorsementGroupEntity @"DocEndorsementGroup"
#define constDocEndorsementEntity @"DocEndorsement"
#define constDocRequisiteEntity @"DocRequisite"
#define constDocNoticeEntity @"DocNotice"
#define constTaskEntity @"Task"

@interface DocDataEntity : NSObject {
	NSManagedObjectContext *context;     
}

- (id)initWithContext:(NSManagedObjectContext *)newContext;

- (Doc *)createDoc;
- (NSArray *)selectAllDocs;
- (NSArray *)selectDocsLinkedOnlyWithRegularTasks;
- (NSArray *)selectDocsLinkedOnlyWithOnControlTasks;
- (NSArray *)selectDocsToLoad;
- (Doc *)selectDocById:(NSString *)docId;
- (void)deleteAllDocs;
- (void)deleteDocsLinkedOnlyWithRegularTasks;
- (void)deleteDocsLinkedOnlyWithOnControlTasks;
- (NSArray *)selectDocsForRemoval;
- (void)deleteDocsForRemoval;
- (NSArray *)selectDocsForRemovalLinkedWithOnControlTasks;
- (NSArray *)selectDocsForRemovalLinkedWithRegularTasks; 
- (void)depreciateWorkingDocsWithRegularTasks;
- (void)depreciateWorkingDocsWithOnControlTasks;
- (void)deleteDocWithId:(NSString *)docId;
- (void)unlinkRegularTasksFromDocWithId:(NSString *)docId;
- (BOOL)isOnControlTaskLinkedToDocWithId:(NSString *)docId;

- (DocAttachment *)createDocAttachment;
- (NSArray *)selectAllAttachments;
- (NSArray *)selectAttachmentsToLoad;
- (NSArray *)selectAttachmentsToDelete;
- (NSArray *)selectAttachmentsForDocWithId:(NSString *)docId;
- (DocAttachment *)selectAttachmentWithId:(NSString *)attachmentId inDocWithId:(NSString *)docId;
- (void)deleteAttachmentsForDocWithId:(NSString *)docId;

- (ReportAttachment *) createReportAttachment;
- (NSArray *)selectReportAttachmentForErrandWithId:(NSString *)errandId;

- (NSDictionary*) selectErrandAttachmentsWithDocId:(NSString*)docId;
- (NSArray*) selectAttachmentsWithErrandId:(NSString*)errandId;

- (DocErrand *)createDocErrand;
- (NSArray *)selectErrandsForDocWithId:(NSString *)docId;
- (NSDictionary *)selectChildErrandsForDocWithId:(NSString *)docId;
- (NSArray *)sortErrands:(NSArray *)errands;
- (DocErrand *)selectErrandWithId:(NSString *)errandId inDocWithId:(NSString *)docId;
- (void)deleteErrandsForDocWithId:(NSString *)docId;
- (void)deleteErrandWithId:(NSString *)errandId forDocWithId:(NSString *)docId;
- (void)cancelErrandForDocWithId:(NSString *)docId andErrandWithId:(NSString *)errandId;
- (void)setMajorExecutorStateForErrandWithActionToSyncId:(NSString *)actionToSyncId andExecutorId:(NSString *)executorId;
- (DocErrand *)cloneDocErrand:(DocErrand *)errand excludingRelations:(NSArray *)excludedRelations;

- (DocErrandExecutor *)createDocErrandExecutor;
- (NSArray *)selectExecutorsForErrandWithId:(NSString *)errandId;
- (void)deleteErrandExecutorsForErrandWithId:(NSString *)errandId inDocWithId:(NSString *)docId;

- (DocErrandAction *)createDocErrandAction;
- (NSArray *)selectActionsForErrandWithId:(NSString *)errandId;
- (void)deleteErrandActionsForErrandWithId:(NSString *)errandId inDocWithId:(NSString *)docId;

- (DocEndorsementGroup *)createDocEndorsementGroup;
- (NSArray *)selectEndorsementGroupsForDocWithId:(NSString *)docId;
- (void)deleteEndorsementGroupsForDocWithId:(NSString *)docId;

- (DocEndorsement *)createDocEndorsement;
- (NSArray *)selectEndorsementsInGroup:(NSString *)groupId forDocWithId:(NSString *)docI;
- (void)deleteEndorsementsForDocWithId:(NSString *)docId;

- (DocRequisite *)createDocRequisite;
- (NSArray *)selectRequisitesForDocWithId:(NSString *)docId;
- (void)deleteRequisitesForDocWithId:(NSString *)docId;

- (DocNotice *)createDocNotice;
- (NSArray *)selectNoticesForDocWithId:(NSString *)docId;
- (DocNotice *)selectNoticeWithId:(NSString *)noticeId inDocWithId:(NSString *)docId;
- (void)deleteNoticesForDocWithId:(NSString *)docId;
- (void)deleteNoticeForDocWithId:(NSString *)docId andNoticeWithId:(NSString *)noticeId;
@end
