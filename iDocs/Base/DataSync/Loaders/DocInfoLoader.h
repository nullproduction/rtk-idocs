//
//  DocInfoLoader.h
//  iDoc
//
//  Created by mark2 on 6/10/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseLoader.h"
#import "DocDataEntity.h"
#import "LoadOperationDelegate.h"

@interface DocInfoLoader : BaseLoader <LoadOperationDelegate> {   
    NSOperationQueue *queue;
    DocDataEntity *docEntity;
}

@property (nonatomic, retain) NSOperationQueue *queue;

- (id)initWithLoaderDelegate:(id<BaseLoaderDelegate>)newDelegate 
                  andContext:(NSManagedObjectContext *)context 
               forSyncModule:(DataSyncModule)module;
@end
