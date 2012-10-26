//
//  ActionToSync.h
//  iDoc
//
//  Created by rednekis on 5/25/11.
//  Copyright (c) 2011 KORUS Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ActionToSync : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * taskId;
@property (nonatomic, retain) NSString * actionType;
@property (nonatomic, retain) NSString * errandOnControl;
@property (nonatomic, retain) NSString * actionResolution;
@property (nonatomic, retain) NSString * docId;
@property (nonatomic, retain) NSString * actionId;
@property (nonatomic, retain) NSString * errandText;
@property (nonatomic, retain) NSDate * actionDate;
@property (nonatomic, retain) NSString * errandDueDate;
@property (nonatomic, retain) NSString * errandExecutorId;
@property (nonatomic, retain) NSNumber * requestType;
@property (nonatomic, retain) NSString * errandId;
@property (nonatomic, retain) NSNumber * actionIsFinal;
@property (nonatomic, retain) NSString * actionResultText;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * systemSyncStatus;
@property (nonatomic, retain) NSString * systemErrandMajorExecutorId;
@property (nonatomic, retain) NSString * attachments;

@end
