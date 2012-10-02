//
//  Doc.h
//  iDoc
//
//  Created by rednekis on 5/11/11.
//  Copyright (c) 2011 KORUS Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DocAttachment, DocEndorsement, DocEndorsementGroup, DocErrand, DocRequisite, DocNotice, Task;

@interface Doc : NSManagedObject {
@private
}
@property (nonatomic, retain) NSDate * regDate;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * ownerId;
@property (nonatomic, retain) NSString * ownerName;
@property (nonatomic, retain) NSString * regNumber;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * systemSyncStatus;
@property (nonatomic, retain) NSDate * systemUpdateDate;
@property (nonatomic, retain) NSString * typeName;
@property (nonatomic, retain) NSSet* endorsementGroups;
@property (nonatomic, retain) NSSet* errands;
@property (nonatomic, retain) NSSet* tasks;
@property (nonatomic, retain) NSSet* requisites;
@property (nonatomic, retain) NSSet* attachments;
@property (nonatomic, retain) NSSet* endorsements;
@property (nonatomic, retain) NSSet* notices;

- (void)addEndorsementGroupsObject:(DocEndorsementGroup *)value;
- (void)removeEndorsementGroupsObject:(DocEndorsementGroup *)value;
- (void)addEndorsementGroups:(NSSet *)value;
- (void)removeEndorsementGroups:(NSSet *)value;
- (void)addErrandsObject:(DocErrand *)value;
- (void)removeErrandsObject:(DocErrand *)value;
- (void)addErrands:(NSSet *)value;
- (void)removeErrands:(NSSet *)value;
- (void)addTasksObject:(Task *)value;
- (void)removeTasksObject:(Task *)value;
- (void)addTasks:(NSSet *)value;
- (void)removeTasks:(NSSet *)value;
- (void)addRequisitesObject:(DocRequisite *)value;
- (void)removeRequisitesObject:(DocRequisite *)value;
- (void)addRequisites:(NSSet *)value;
- (void)removeRequisites:(NSSet *)value;
- (void)addAttachmentsObject:(DocAttachment *)value;
- (void)removeAttachmentsObject:(DocAttachment *)value;
- (void)addAttachments:(NSSet *)value;
- (void)removeAttachments:(NSSet *)value;
- (void)addEndorsementsObject:(DocEndorsement *)value;
- (void)removeEndorsementsObject:(DocEndorsement *)value;
- (void)addEndorsements:(NSSet *)value;
- (void)removeEndorsements:(NSSet *)value;
- (void)addNoticesObject:(DocNotice *)value;
- (void)removeNoticesObject:(DocNotice *)value;
- (void)addNotices:(NSSet *)value;
- (void)removeNotices:(NSSet *)value;

@end
