//
//  DocDataEntity.m
//  iDoc
//
//  Created by rednekis on 5/8/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import "DocDataEntity.h"
#import "NSManagedObjectContext+CustomFetch.h"
#import "Constants.h"
#import "Task.h"
#import "DocErrand.h"
#import "NSManagedObject+Clone.h"


#pragma mark Errand sorting

NSInteger sortDocErrandsByErrandNumber(id errand1, id errand2, void *context);

NSInteger sortDocErrandsByErrandNumber(id errand1, id errand2, void *context) {
    //fixed errand number format: main | main.sub1 | main.sub1.sub2 | ... : (1, 1.1, 1.2.5)
    
    NSString *errand1Number = ((DocErrand *)errand1).number;
    NSString *errand2Number = ((DocErrand *)errand2).number;
    
    //move errands without number to the bottom:   
    NSString *maxErrandNumber = @"1000";    
    errand1Number = ([errand1Number floatValue] == 0.0f) ? maxErrandNumber : errand1Number;    
    errand2Number = ([errand2Number floatValue] == 0.0f) ? maxErrandNumber : errand2Number; 
    
    //split errand number into main and sub number
    NSArray *errand1NumberParts = [errand1Number componentsSeparatedByString:constErrandNumberSeparatorSymbol];    
    NSArray *errand2NumberParts = [errand2Number componentsSeparatedByString:constErrandNumberSeparatorSymbol];
    
    //count errand number levels
    NSUInteger const errand1Levels = [errand1NumberParts count];
    NSUInteger const errand2Levels = [errand2NumberParts count]; 
    
    //compare errand number by levels
    NSUInteger minLevels = (errand1Levels <= errand2Levels) ? errand1Levels : errand2Levels;
    NSUInteger level = 0;
    NSInteger sorting = NSOrderedSame;
    while (level < minLevels) {
        int errand1NumberPart = (level < errand1Levels) ? [[errand1NumberParts objectAtIndex:level] intValue] : -1;
        int errand2NumberPart = (level < errand2Levels) ? [[errand2NumberParts objectAtIndex:level] intValue] : -1;
        
        if (errand1NumberPart < errand2NumberPart) {
            sorting = NSOrderedAscending;
            break;
        }
        else if (errand1NumberPart > errand2NumberPart) {
            sorting = NSOrderedDescending;
            break;
        }
        else {
            if (level == (minLevels - 1)) {
                sorting = (minLevels == errand1Levels) ? NSOrderedAscending : NSOrderedDescending;
                break;
            }
        }
        level++;
    }
    return sorting;
}



@implementation DocDataEntity

- (id)initWithContext:(NSManagedObjectContext *)newContext {
	if ((self = [super init])) {
		context = newContext;
	}
	return self;
}

#pragma mark doc
- (Doc *)createDoc {
	return (Doc *)[NSEntityDescription insertNewObjectForEntityForName:constDocEntity inManagedObjectContext:context];
}

- (NSArray *)selectAllDocs {
    NSArray *items = [context executeFetchRequestWithPredicate:nil andEntityName:constDocEntity andSortDescriptors:nil];
    return items;
}

- (NSArray *)selectDocsLinkedOnlyWithRegularTasks {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"NONE tasks.type = %@ AND ANY tasks.type = %@", 
                              [NSNumber numberWithInt:ORDTaskTypeOnControl],
                              [NSNumber numberWithInt:ORDTaskTypeRegular]];
    NSArray *items = [context executeFetchRequestWithPredicate:predicate andEntityName:constDocEntity andSortDescriptors:nil];
    return items;
}

- (NSArray *)selectDocsLinkedOnlyWithOnControlTasks {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"NONE tasks.type = %@ AND ANY tasks.type = %@", 
                                                            [NSNumber numberWithInt:ORDTaskTypeRegular],
                                                            [NSNumber numberWithInt:ORDTaskTypeOnControl]];
    NSArray *items = [context executeFetchRequestWithPredicate:predicate andEntityName:constDocEntity andSortDescriptors:nil];
    return items;
}

- (NSArray *)selectDocsToLoad {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"systemSyncStatus = %@", constSyncStatusToLoad];
    NSArray *items = [context executeFetchRequestWithPredicate:predicate andEntityName:constDocEntity andSortDescriptors:nil];
    return items;
}

- (Doc *)selectDocById:(NSString *)docId {	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id = %@", docId];
    NSArray *items = [context executeFetchRequestWithPredicate:predicate andEntityName:constDocEntity andSortDescriptors:nil];
	return ([items count] == 1) ? (Doc *)[items objectAtIndex:0] : nil;	
}

- (void)deleteAllDocs {
    NSArray *items = [context executeFetchRequestWithPredicate:nil andEntityName:constDocEntity andSortDescriptors:nil];
    for (NSManagedObject *item in items) {
        [context deleteObject:[context objectWithID:[item objectID]]];
    }
}

- (void)deleteDocsLinkedOnlyWithRegularTasks {
    NSArray *items = [self selectDocsLinkedOnlyWithRegularTasks];
    for (NSManagedObject *item in items) {
        [context deleteObject:[context objectWithID:[item objectID]]];
    }
}

- (void)deleteDocsLinkedOnlyWithOnControlTasks {
    NSArray *items = [self selectDocsLinkedOnlyWithOnControlTasks];
    for (NSManagedObject *item in items) {
        [context deleteObject:[context objectWithID:[item objectID]]];
    }
}

- (NSArray *)selectDocsForRemoval {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"systemSyncStatus = %@", constSyncStatusToDelete];
    NSArray *items = [context executeFetchRequestWithPredicate:predicate andEntityName:constDocEntity andSortDescriptors:nil];
    return items;
}

- (void)deleteDocsForRemoval {
    for (NSManagedObject *item in [self selectDocsForRemoval]) {
        [context deleteObject:[context objectWithID:[item objectID]]];
    }
}

- (NSArray *)selectDocsForRemovalLinkedWithOnControlTasks {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"systemSyncStatus = %@ AND ANY tasks.type = %@", 
                              constSyncStatusToDelete, 
                              [NSNumber numberWithInt:ORDTaskTypeOnControl]];
    NSArray *items = [context executeFetchRequestWithPredicate:predicate andEntityName:constDocEntity andSortDescriptors:nil];
    return items;
}
             
- (NSArray *)selectDocsForRemovalLinkedWithRegularTasks {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"systemSyncStatus = %@ AND ANY tasks.type = %@", 
                              constSyncStatusToDelete, 
                              [NSNumber numberWithInt:ORDTaskTypeRegular]];
    NSArray *items = [context executeFetchRequestWithPredicate:predicate andEntityName:constDocEntity andSortDescriptors:nil];
    return items;
}

- (void)depreciateWorkingDocsWithRegularTasks {	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"systemSyncStatus = %@ AND ANY tasks.type = %@", 
                                                            constSyncStatusWorking,
                                                            [NSNumber numberWithInt:ORDTaskTypeRegular]];
    NSArray *items = [context executeFetchRequestWithPredicate:predicate andEntityName:constDocEntity andSortDescriptors:nil];
	for(Doc *item in items) {
		item.systemSyncStatus = constSyncStatusToDelete;
	}		
}

- (void)depreciateWorkingDocsWithOnControlTasks {	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"systemSyncStatus = %@ AND ANY tasks.type = %@", 
                              constSyncStatusWorking,
                              [NSNumber numberWithInt:ORDTaskTypeOnControl]];
    NSArray *items = [context executeFetchRequestWithPredicate:predicate andEntityName:constDocEntity andSortDescriptors:nil];
	for(Doc *item in items) {
		item.systemSyncStatus = constSyncStatusToDelete;
	}		
}

- (void)deleteDocWithId:(NSString *)docId {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id = %@", docId];
    NSArray *items = [context executeFetchRequestWithPredicate:predicate andEntityName:constDocEntity andSortDescriptors:nil];
    for (Doc *item in items) {
        [context deleteObject:[context objectWithID:[item objectID]]];
    }    
}

- (void)unlinkRegularTasksFromDocWithId:(NSString *)docId {
    Doc *doc = [self selectDocById:docId];
    Task *onControlTask = nil;
    if (doc != nil) {
        for(Task *task in doc.tasks) {
            if([task.type intValue] ==  ORDTaskTypeOnControl) {
                onControlTask = task;
                break;
            }
        }
        doc.tasks = nil;
        if (onControlTask != nil)
            [doc addTasksObject:onControlTask];
    }
}

- (BOOL)isOnControlTaskLinkedToDocWithId:(NSString *)docId {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription  entityForName:constDocEntity inManagedObjectContext:context];
    [request setEntity:entity];
    [request setPredicate:[NSPredicate predicateWithFormat:@"id = %@ and ANY tasks.type = %@", 
                                                            docId, 
                                                            [NSNumber numberWithInt:ORDTaskTypeOnControl]]];
    
    NSError *error = nil;
    NSInteger records = [context countForFetchRequest:request error:&error];
    [request release];
    return  (records > 0) ? YES : NO;    
}



#pragma mark doc attachments
- (DocAttachment *)createDocAttachment {
	return (DocAttachment *)[NSEntityDescription insertNewObjectForEntityForName:constDocAttachmentEntity inManagedObjectContext:context];
}

- (NSArray *)selectAllAttachments {
    NSArray *items = [context executeFetchRequestWithPredicate:nil andEntityName:constDocAttachmentEntity andSortDescriptors:nil];
    return items;
}

- (NSArray *)selectAttachmentsToLoad {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"systemLoaded == NO"];
    NSArray *items = [context executeFetchRequestWithPredicate:predicate andEntityName:constDocAttachmentEntity andSortDescriptors:nil];
    return items;
}

- (NSArray *)selectAttachmentsToDelete {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"doc.systemSyncStatus = %@", constSyncStatusToDelete];
    NSArray *items = [context executeFetchRequestWithPredicate:predicate andEntityName:constDocAttachmentEntity andSortDescriptors:nil];
    return items;
}

- (NSArray *)selectAttachmentsForDocWithId:(NSString *)docId {	
    NSSortDescriptor *sortBySortIndex =[NSSortDescriptor sortDescriptorWithKey:@"systemSortIndex" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortBySortIndex, nil];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"doc.id = %@", docId];
    NSArray *items = [context executeFetchRequestWithPredicate:predicate andEntityName:constDocAttachmentEntity andSortDescriptors:sortDescriptors];
	[sortDescriptors release];
    return items;	
}

- (DocAttachment *)selectAttachmentWithId:(NSString *)attachmentId inDocWithId:(NSString *)docId {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"doc.id = %@ AND id = %@", docId, attachmentId];
    NSArray *items = [context executeFetchRequestWithPredicate:predicate andEntityName:constDocAttachmentEntity andSortDescriptors:nil];
	return ([items count] == 1) ? (DocAttachment *)[items objectAtIndex:0] : nil;    
}

- (void)deleteAttachmentsForDocWithId:(NSString *)docId {	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"doc.id = %@", docId];
    NSArray *items = [context executeFetchRequestWithPredicate:predicate andEntityName:constDocAttachmentEntity andSortDescriptors:nil];
    for (NSManagedObject *item in items) {
        [context deleteObject:[context objectWithID:[item objectID]]];
    }	
}

#pragma mark report attachments

- (ReportAttachment *) createReportAttachment
{
    return (ReportAttachment *)[NSEntityDescription insertNewObjectForEntityForName:constReportAttachmentEntity inManagedObjectContext:context];
}

- (NSDictionary*) selectErrandAttachmentsWithDocId:(NSString *)docId
{
    NSMutableDictionary *attachmentDictionary = [[NSMutableDictionary alloc] init];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"doc.id = %@",docId];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"systemSortIndex" ascending:YES];
    NSArray *items = [context executeFetchRequestWithPredicate:predicate
                                                 andEntityName:constDocErrandEntity
                                            andSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    for (DocErrand *currentErrand in items)
    {
        [attachmentDictionary setObject:[self selectAttachmentsWithErrandId:currentErrand.id] forKey:currentErrand.id];
    }
    
    return [NSDictionary dictionaryWithDictionary:attachmentDictionary];
}

- (NSArray*) selectAttachmentsWithErrandId:(NSString*)errandId
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"errand.id = %@ AND id != nil",errandId];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    NSArray *items = [context executeFetchRequestWithPredicate:predicate
                                                 andEntityName:constReportAttachmentEntity
                                            andSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
	return items;
}

#pragma mark doc errands
- (DocErrand *)createDocErrand {
	return (DocErrand *)[NSEntityDescription insertNewObjectForEntityForName:constDocErrandEntity inManagedObjectContext:context];
}

- (NSArray *)selectErrandsForDocWithId:(NSString *)docId {	
	//NSPredicate *predicate = [NSPredicate predicateWithFormat:@"doc.id = %@",docId];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"doc.id = %@ AND parentId = %@",docId,docId];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"systemSortIndex" ascending:YES];
    NSArray *items = [context executeFetchRequestWithPredicate:predicate 
                                                 andEntityName:constDocErrandEntity 
                                            andSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
	return items;	
}

- (NSDictionary *)selectChildErrandsForDocWithId:(NSString *)docId {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"doc.id = %@",docId];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"systemSortIndex" ascending:YES];
    NSArray *items = [context executeFetchRequestWithPredicate:predicate
                                                 andEntityName:constDocErrandEntity
                                            andSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    NSMutableDictionary *dictWithChilds = [[NSMutableDictionary alloc] init];
    
    for (DocErrand *currentErrand in items)
    {
        NSMutableArray *errandsArray = [dictWithChilds objectForKey:currentErrand.parentId];
        
        if(errandsArray != nil)
        {
            [errandsArray addObject:currentErrand];
        }
        else
        {
            errandsArray = [[[NSMutableArray alloc] init] autorelease];
            [errandsArray addObject:currentErrand];
        }
        
        [dictWithChilds setObject:errandsArray forKey:currentErrand.parentId];
    }
    
    NSDictionary *returnDict = [NSDictionary dictionaryWithDictionary:dictWithChilds];
    
    [dictWithChilds release];
    
	return returnDict;
}

- (NSArray *)sortErrands:(NSArray *)errands {
    NSArray *sorted = [errands sortedArrayUsingFunction:sortDocErrandsByErrandNumber context:NULL];
    return sorted;
}

- (DocErrand *)selectErrandWithId:(NSString *)errandId inDocWithId:(NSString *)docId {	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"doc.id = %@ AND id = %@", docId, errandId];
    NSArray *items = [context executeFetchRequestWithPredicate:predicate andEntityName:constDocErrandEntity andSortDescriptors:nil];
    
	return ([items count] == 1) ? (DocErrand *)[items objectAtIndex:0] : nil;	
}

- (void)deleteErrandsForDocWithId:(NSString *)docId {	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"doc.id = %@", docId];
    NSArray *items = [context executeFetchRequestWithPredicate:predicate andEntityName:constDocErrandEntity andSortDescriptors:nil];
    for (NSManagedObject *item in items) {
        [context deleteObject:[context objectWithID:[item objectID]]];
    }
}

- (void)deleteErrandWithId:(NSString *)errandId forDocWithId:(NSString *)docId {	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"doc.id = %@ AND id = %@", docId, errandId];
    NSArray *items = [context executeFetchRequestWithPredicate:predicate andEntityName:constDocErrandEntity andSortDescriptors:nil];
    for (NSManagedObject *item in items) {
        [context deleteObject:[context objectWithID:[item objectID]]];
    }
}

- (void)cancelErrandForDocWithId:(NSString *)docId andErrandWithId:(NSString *)errandId {	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"doc.id = %@ AND id = %@", docId, errandId];
    NSArray *items = [context executeFetchRequestWithPredicate:predicate andEntityName:constDocErrandEntity andSortDescriptors:nil];
	
	if([items count] == 1) {
		DocErrand *item = (DocErrand *)[items objectAtIndex:0];
		item.status = [NSNumber numberWithInt:constErrandStatusRejected];
	}		
}

- (void)setMajorExecutorStateForErrandWithActionToSyncId:(NSString *)actionToSyncId andExecutorId:(NSString *)executorId {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"errand.systemActionToSyncId = %@", actionToSyncId];
    NSArray *items = [context executeFetchRequestWithPredicate:predicate andEntityName:constDocErrandExecutorEntity andSortDescriptors:nil];
    for (DocErrandExecutor *item in items) {
        item.isMajorExecutor = [NSNumber numberWithBool:[item.executorId isEqualToString:executorId]];
    }		
}

- (DocErrand *)cloneDocErrand:(DocErrand *)errand excludingRelations:(NSArray *)excludedRelations { 
    return (DocErrand *)[errand cloneInContext:context excludeEntities:excludedRelations];
}


#pragma mark doc errand executors
- (DocErrandExecutor *)createDocErrandExecutor {
	return (DocErrandExecutor *)[NSEntityDescription insertNewObjectForEntityForName:constDocErrandExecutorEntity 
                                                              inManagedObjectContext:context];
}

- (NSArray *)selectExecutorsForErrandWithId:(NSString *)errandId {	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"errand.id = %@", errandId];
    NSSortDescriptor *sortDescriptor1 = [NSSortDescriptor sortDescriptorWithKey:@"isMajorExecutor" ascending:NO];
    NSSortDescriptor *sortDescriptor2 = [NSSortDescriptor sortDescriptorWithKey:@"systemSortIndex" ascending:YES];
    NSArray *items = [context executeFetchRequestWithPredicate:predicate 
                                                 andEntityName:constDocErrandExecutorEntity 
                                            andSortDescriptors:[NSArray arrayWithObjects:sortDescriptor1, sortDescriptor2, nil]];
	return items;	
}

- (void)deleteErrandExecutorsForErrandWithId:(NSString *)errandId inDocWithId:(NSString *)docId {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"doc.id = %@ AND id = %@", docId, errandId];
    NSArray *items = [context executeFetchRequestWithPredicate:predicate andEntityName:constDocErrandEntity andSortDescriptors:nil];
	if ([items count] == 1) {
		DocErrand *item = (DocErrand *)[items objectAtIndex:0];
		for (NSManagedObject *executor in item.executors) {
            [context deleteObject:[context objectWithID:[executor objectID]]];
        }
	}
}


#pragma mark doc errand actions
- (DocErrandAction *)createDocErrandAction {
	return (DocErrandAction *)[NSEntityDescription insertNewObjectForEntityForName:constDocErrandActionEntity 
                                                              inManagedObjectContext:context];
}

- (NSArray *)selectActionsForErrandWithId:(NSString *)errandId {	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"errand.id = %@", errandId];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"systemSortIndex" ascending:YES];
    NSArray *items = [context executeFetchRequestWithPredicate:predicate 
                                                 andEntityName:constDocErrandActionEntity 
                                            andSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
	return items;	
}

- (void)deleteErrandActionsForErrandWithId:(NSString *)errandId inDocWithId:(NSString *)docId {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"doc.id = %@ AND id = %@", docId, errandId];
    NSArray *items = [context executeFetchRequestWithPredicate:predicate andEntityName:constDocErrandEntity andSortDescriptors:nil];
	if([items count] == 1) {
		DocErrand *item = (DocErrand *)[items objectAtIndex:0];
		for (NSManagedObject *errandAction in item.errandActions) {
            [context deleteObject:[context objectWithID:[errandAction objectID]]];
        }
	}
}


#pragma mark doc endorsement groups
- (DocEndorsementGroup *)createDocEndorsementGroup {
	return (DocEndorsementGroup *)[NSEntityDescription insertNewObjectForEntityForName:constDocEndorsementGroupEntity inManagedObjectContext:context];
}

- (NSArray *)selectEndorsementGroupsForDocWithId:(NSString *)docId {
    NSSortDescriptor *sortBySortIndex = [NSSortDescriptor sortDescriptorWithKey:@"systemSortIndex" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortBySortIndex, nil];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"doc.id = %@", docId];
    NSArray *items = [context executeFetchRequestWithPredicate:predicate andEntityName:constDocEndorsementGroupEntity andSortDescriptors:sortDescriptors];
	[sortDescriptors release];
    return items;	
}

- (void)deleteEndorsementGroupsForDocWithId:(NSString *)docId {	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"doc.id = %@", docId];
    NSArray *items = [context executeFetchRequestWithPredicate:predicate andEntityName:constDocEndorsementGroupEntity andSortDescriptors:nil];
    for (NSManagedObject *item in items) {
        [context deleteObject:[context objectWithID:[item objectID]]];
    }	
}


#pragma mark doc endorsements
- (DocEndorsement *)createDocEndorsement {
	return (DocEndorsement *)[NSEntityDescription insertNewObjectForEntityForName:constDocEndorsementEntity inManagedObjectContext:context];
}

- (NSArray *)selectEndorsementsInGroup:(NSString *)groupId forDocWithId:(NSString *)docId {	
    NSSortDescriptor *sortBySortIndex = [NSSortDescriptor sortDescriptorWithKey:@"systemSortIndex" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortBySortIndex, nil];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"doc.id = %@ AND group.id = %@", docId, groupId];
    NSArray *items = 
    [context executeFetchRequestWithPredicate:predicate andEntityName:constDocEndorsementEntity andSortDescriptors:sortDescriptors];
	[sortDescriptors release];	
    return items;	
}

- (void)deleteEndorsementsForDocWithId:(NSString *)docId {	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"doc.id = %@", docId];
    NSArray *items = [context executeFetchRequestWithPredicate:predicate andEntityName:constDocEndorsementEntity andSortDescriptors:nil];
    for (NSManagedObject *item in items) {
        [context deleteObject:[context objectWithID:[item objectID]]];
    }	
}


#pragma mark doc requisites
- (DocRequisite *)createDocRequisite {
	return (DocRequisite *)[NSEntityDescription insertNewObjectForEntityForName:constDocRequisiteEntity inManagedObjectContext:context];
}

- (NSArray *)selectRequisitesForDocWithId:(NSString *)docId {
    NSSortDescriptor *sortBySortIndex = [NSSortDescriptor sortDescriptorWithKey:@"systemSortIndex" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortBySortIndex, nil];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"doc.id = %@", docId];
    NSArray *items = [context executeFetchRequestWithPredicate:predicate andEntityName:constDocRequisiteEntity andSortDescriptors:sortDescriptors];
	[sortDescriptors release];
	return items;	
}

- (void)deleteRequisitesForDocWithId:(NSString *)docId {	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"doc.id = %@", docId];
    NSArray *items = [context executeFetchRequestWithPredicate:predicate andEntityName:constDocRequisiteEntity andSortDescriptors:nil];
    for (NSManagedObject *item in items) {
        [context deleteObject:[context objectWithID:[item objectID]]];
    }	
}


#pragma mark doc notices
- (DocNotice *)createDocNotice {
	return (DocNotice *)[NSEntityDescription insertNewObjectForEntityForName:constDocNoticeEntity inManagedObjectContext:context];
}

- (NSArray *)selectNoticesForDocWithId:(NSString *)docId {	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"doc.id = %@", docId];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"systemSortIndex" ascending:YES];
    NSArray *items = [context executeFetchRequestWithPredicate:predicate 
                                                 andEntityName:constDocNoticeEntity 
                                            andSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
	return items;	
}

- (DocNotice *)selectNoticeWithId:(NSString *)noticeId inDocWithId:(NSString *)docId {	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"doc.id = %@ AND id = %@", docId, noticeId];
    NSArray *items = [context executeFetchRequestWithPredicate:predicate andEntityName:constDocNoticeEntity andSortDescriptors:nil];
	return ([items count] == 1) ? (DocNotice *)[items objectAtIndex:0] : nil;	
}

- (void)deleteNoticesForDocWithId:(NSString *)docId {	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"doc.id = %@", docId];
    NSArray *items = [context executeFetchRequestWithPredicate:predicate andEntityName:constDocNoticeEntity andSortDescriptors:nil];
    for (NSManagedObject *item in items) {
        [context deleteObject:[context objectWithID:[item objectID]]];
    }
}

- (void)deleteNoticeForDocWithId:(NSString *)docId andNoticeWithId:(NSString *)noticeId {	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"doc.id = %@ AND id = %@", docId, noticeId];
    NSArray *items = [context executeFetchRequestWithPredicate:predicate andEntityName:constDocNoticeEntity andSortDescriptors:nil];
    for (NSManagedObject *item in items) {
        [context deleteObject:[context objectWithID:[item objectID]]];
    }
}

#pragma mark misc methods
- (void)dealloc {
	[super dealloc];
}
@end
