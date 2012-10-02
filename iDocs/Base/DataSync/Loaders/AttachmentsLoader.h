//
//  AttachmentsPushLoader.h
//  iDoc
//
//  Created by rednekis on 5/9/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseLoader.h"
#import "DocDataEntity.h"

@interface AttachmentsLoader : BaseLoader {
    DocDataEntity *docEntity;
}

- (id)initWithLoaderDelegate:(id<BaseLoaderDelegate>)newDelegate 
                  andContext:(NSManagedObjectContext *)context 
               forSyncModule:(DataSyncModule)module;
@end
