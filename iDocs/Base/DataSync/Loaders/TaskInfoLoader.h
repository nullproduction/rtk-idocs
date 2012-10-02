//
//  TaskInfoLoader.h
//  iDoc
//
//  Created by mark2 on 6/10/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseWSLoader.h"
#import "TaskXmlParser.h"
#import "TaskDataEntity.h"

@interface TaskInfoLoader : BaseWSLoader {
    NSMutableDictionary *requests;
    NSInteger requestsCount;
    TaskXmlParser *parser;
    TaskDataEntity *taskEntity;
}

- (id)initWithLoaderDelegate:(id<BaseLoaderDelegate>)newDelegate andContext:(NSManagedObjectContext *)context forSyncModule:(DataSyncModule)module;
@end
