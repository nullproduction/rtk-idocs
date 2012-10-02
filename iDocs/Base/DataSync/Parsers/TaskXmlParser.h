//
//  TaskXmlParser.h
//  iDoc
//
//  Created by katrin on 14.04.11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import "BaseXmlParser.h"

@class ClientSettingsDataEntity;
@class TaskDataEntity;
@class TaskGroup;
@class DocDataEntity;

@interface TaskXmlParser : BaseXmlParser {
    ClientSettingsDataEntity *clientSettingsEntity;    
    TaskDataEntity *taskEntity;
    DocDataEntity *docEntity;
}

- (NSString *)parseAndInsertTaskData:(NSData *)data forTaskBlock:(NSString *)block;
- (NSString *)parseAndInsertTaskData:(NSData *)data forTaskId:(NSString *)taskId;

@end
