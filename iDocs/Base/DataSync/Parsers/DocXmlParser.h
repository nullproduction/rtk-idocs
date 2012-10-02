//
//  DocXmlParser.h
//  iDoc
//
//  Created by katrin on 14.04.11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import "BaseXmlParser.h"

@class TaskDataEntity;
@class Task;
@class DocDataEntity;

@interface DocXmlParser : BaseXmlParser {
    DocDataEntity *docEntity;
    TaskDataEntity *taskEntity; 
}

- (NSString *)parseAndInsertDocsData:(NSData *)data;

@end
