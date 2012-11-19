//
//  TaskAsReadSubmitter.h
//  iDoc
//
//  Created by Olga Geets on 13.11.12.
//  Copyright (c) 2012 KORUS Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseWSLoader.h"
#import "TaskDataEntity.h"
#import "CoreDataProxy.h"
#import "ActionsSubmitResultXMLParser.h"
#import "SupportFunctions.h"

@interface TaskAsReadSubmitter : BaseWSLoader {
    TaskDataEntity* taskEntity;
    ActionsSubmitResultXMLParser *parser;
    NSMutableDictionary *requests;
    NSInteger requestsCount;
}

- (id)initWithLoaderDelegate:(id<BaseLoaderDelegate>)newDelegate
                  andContext:(NSManagedObjectContext *)context
               forSyncModule:(DataSyncModule)module;

@end
