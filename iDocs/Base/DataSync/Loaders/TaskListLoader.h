//
//  TaskListLoader.h
//  iDoc
//
//  Created by rednekis on 5/9/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseWSLoader.h"
#import "ClientSettingsDataEntity.h"
#import "TaskXmlParser.h"

@interface TaskListLoader : BaseWSLoader {
    NSMutableDictionary *requests;
    int requestsCount;
    ClientSettingsDataEntity *settingsEntity;
    TaskXmlParser *parser;
}

- (id)initWithLoaderDelegate:(id<BaseLoaderDelegate>)newDelegate 
                  andContext:(NSManagedObjectContext *)context 
               forSyncModule:(DataSyncModule)module;
@end
