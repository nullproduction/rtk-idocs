//
//  DictionariesChunkLoader.h
//  iDoc
//
//  Created by rednekis on 5/9/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import <libxml/tree.h>
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseLoader.h"
#import "EmployeeListDataEntity.h"
#import "EmployeeGroupDataEntity.h"
#import "ResolutionTemplateDataEntity.h"

@interface DictionariesChunkLoader : BaseLoader {
@private
    NSAutoreleasePool *downloadAndParsePool;  
    
    // connection and write resources
    NSURLConnection *conn;
    NSMutableData *responseData;
    
    // dictionary record
    NSMutableDictionary *recordData;
    NSString *parsingFieldName;
    
    // reference to the libxml parser context
    xmlParserCtxtPtr parserContext;    
    // the following state variables deal with getting character data from XML elements. 
    BOOL storingCharacters;
    NSMutableData *characterBuffer;
    
    // core data
	EmployeeListDataEntity *employeeEntity;
    BOOL truncateEmployees;
    EmployeeGroupDataEntity *employeeGroupEntity;
    BOOL truncateEmployeeGroups;
    ResolutionTemplateDataEntity *resolutionTemplateEntity;
    BOOL truncateResolutionTemplates;
}

// the autorelease pool property is assign because autorelease pools cannot be retained.
@property (nonatomic, assign) NSAutoreleasePool *downloadAndParsePool;
@property (nonatomic, retain) NSURLConnection *conn;
@property (nonatomic, retain) NSMutableData *responseData;
@property BOOL storingCharacters;
@property (nonatomic, retain) NSMutableData *characterBuffer;
@property (nonatomic, retain) NSMutableDictionary *recordData;
@property (nonatomic, retain) NSString *parsingFieldName;
@property (nonatomic, retain) EmployeeListDataEntity *employeeEntity;
@property (nonatomic, retain) EmployeeGroupDataEntity *employeeGroupEntity;
@property (nonatomic, retain) ResolutionTemplateDataEntity *resolutionTemplateEntity;

- (id)initWithLoaderDelegate:(id<BaseLoaderDelegate>)newDelegate 
                  andContext:(NSManagedObjectContext *)context 
               forSyncModule:(DataSyncModule)module;

@end
