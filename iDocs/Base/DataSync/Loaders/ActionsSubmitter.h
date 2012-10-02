//
//  ActionsSubmitter.h
//  iDoc
//
//  Created by rednekis on 5/9/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseWSLoader.h"
#import "ActionToSyncDataEntity.h"
#import "ActionsSubmitResultXMLParser.h"

@interface ActionsSubmitter : BaseWSLoader {
    ActionToSyncDataEntity *actionsEntity;
    ActionsSubmitResultXMLParser *parser;
    NSMutableArray *actionIds;
}

- (id)initWithLoaderDelegate:(id<BaseLoaderDelegate>)newDelegate 
                  andContext:(NSManagedObjectContext *)context 
               forSyncModule:(DataSyncModule)module;
@end
