//
//  DataContentLoader.h
//  iDoc
//
//  Created by Michael Syasko on 6/17/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "FMWebDAVRequest.h"
#import "DataContentXmlParser.h"
#import "BaseLoaderDelegate.h"
#import <CoreData/CoreData.h>

@interface DataContentLoader : NSObject {
    id<BaseLoaderDelegate> loaderDelegate;
    
    FMWebDAVRequest *webDavRequest;
    NSString *webDavLogin;
    NSString *webDavPassword;
    
    DataContentXmlParser *parser;
    NSString *localFolder;
    NSString *remoteFolder;
    
    NSManagedObjectContext *syncContext;
    
    int syncModule;
    BOOL requestInProcess;
    
    NSMutableArray *errors;
}

@property (nonatomic, retain) NSManagedObjectContext *syncContext;
@property (nonatomic, retain) NSString *localFolder;
@property (nonatomic, retain) NSString *remoteFolder;
@property (nonatomic, retain) NSString *webDavLogin;
@property (nonatomic, retain) NSString *webDavPassword;
@property (nonatomic, retain) NSMutableArray *errors;
@property () int syncModule;

- (id)initForSyncWithDelegate:(id<BaseLoaderDelegate>)newDelegate 
                   andContext:(NSManagedObjectContext *)context
                forSyncModule:(DataSyncModule)module;
- (NSArray *)loadSyncData;
- (id)initForLoadingFolderWithDelegate:(id<BaseLoaderDelegate>)newDelegate 
                           localFolder:(NSString *)lFolder 
                          remoteFolder:(NSString *)rFolder 
                            andContext:(NSManagedObjectContext *)context
                         forSyncModule:(DataSyncModule)module;
- (NSArray *)startLoad;
+ (void)notifyAboutSkippedStep;

@end
