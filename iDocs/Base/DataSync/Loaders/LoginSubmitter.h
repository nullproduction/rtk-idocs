//
//  LoginLoader.h
//  iDoc
//
//  Created by rednekis on 8/10/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseWSLoader.h"

@interface LoginSubmitter : BaseWSLoader {
}

- (id)initWithLoaderDelegate:(id<BaseLoaderDelegate>)newDelegate 
                  andContext:(NSManagedObjectContext *)context 
               forSyncModule:(DataSyncModule)module;
@end
