//
//  ClientSettingsSyncManager.h
//  iDoc
//
//  Created by mark2 on 7/11/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseSyncManager.h"
#import "ClientSettingsDataEntity.h"
#import "DocDataEntity.h"
#import "DocAttachment.h"
#import "TaskDataEntity.h"

@interface ClientSettingsSyncManager : BaseSyncManager { 
}

- (id)initForCleanupWithContext:(NSManagedObjectContext *)newContext;
- (void)cleanupSync;

@end
