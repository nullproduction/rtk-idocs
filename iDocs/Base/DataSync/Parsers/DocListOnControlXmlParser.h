//
//  DocListOnControlXmlParser.h
//  iDoc
//
//  Created by Konstantin Krupovich on 8/18/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import "BaseXmlParser.h"

@class ClientSettingsDataEntity;
@class TaskDataEntity;
@class TaskGroup;
@class DocDataEntity;

@interface DocListOnControlXmlParser : BaseXmlParser {

    ClientSettingsDataEntity *clientSettingsEntity;    
    TaskDataEntity *taskEntity;
    DocDataEntity *docEntity;
}

- (NSString *)parseAndInsertDocListData:(NSData *)data;

@end
