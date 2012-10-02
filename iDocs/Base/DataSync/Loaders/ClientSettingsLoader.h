//
//  ClientSettingsLoader.h
//  iDoc
//
//  Created by rednekis on 5/9/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseWSLoader.h"
#import "ClientSettingsXmlParser.h"
#import "DocDataEntity.h"
#import "TaskDataEntity.h"
#import "ClientSettingsDataEntity.h"

@interface ClientSettingsLoader : BaseWSLoader {
	ClientSettingsXmlParser *parser;
    NSString *serverCheckSum;
    bool checksumRequest;
}

@property (nonatomic, retain) NSString *serverCheckSum;

- (id)initWithLoaderDelegate:(id<BaseLoaderDelegate>)newDelegate 
                  andContext:(NSManagedObjectContext *)context 
               forSyncModule:(DataSyncModule)module;
@end
