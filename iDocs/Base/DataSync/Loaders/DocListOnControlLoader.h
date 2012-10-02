//
//  DocListOnControlLoader.h
//  iDoc
//
//  Created by Konstantin Krupovich on 8/17/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseWSLoader.h"
#import "ClientSettingsDataEntity.h"
#import "DocListOnControlXmlParser.h"

@interface DocListOnControlLoader : BaseWSLoader {
    ClientSettingsDataEntity *settingsEntity;
    DocListOnControlXmlParser *parser;
}

- (id)initWithLoaderDelegate:(id<BaseLoaderDelegate>)newDelegate 
                  andContext:(NSManagedObjectContext *)context 
               forSyncModule:(DataSyncModule)module;

@end
