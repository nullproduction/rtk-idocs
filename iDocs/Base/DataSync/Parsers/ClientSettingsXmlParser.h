//
//  ClientSettingsEntity.h
//  iDoc
//
//  Created by katrin on 14.04.11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import "BaseXmlParser.h"
#import "TaskDataEntity.h"
#import "ClientSettingsDataEntity.h"
#import "TaskActionTemplateDataEntity.h" 

@interface ClientSettingsXmlParser : BaseXmlParser {
    ClientSettingsDataEntity *clientEntity;
    TaskDataEntity *taskEntity;
    TaskActionTemplateDataEntity *taskActionTempalteEntity;
}

- (NSString *)getClientSettingsCheckSumFromData:(NSData *)data error:(NSError **)parseError;
- (NSData *)getClientSettingsDataFromData:(NSData *)data error:(NSError **)parseError;
- (NSString *)parseAndInsertClientSettingsData:(NSData *)data;

@end
