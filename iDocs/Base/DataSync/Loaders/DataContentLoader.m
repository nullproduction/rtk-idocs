//
//  DataContentLoader.m
//  iDoc
//
//  Created by Michael Syasko on 6/17/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//


#import "DataContentLoader.h"
#import "DebugUtils.h"
#import "CoreDataProxy.h"
#import "SystemDataEntity.h"
#import "ClientSettingsDataEntity.h"
#import "ServerOperationQueueEntity.h"
#import "DataSyncEventHandler.h"
#import "DashboardItem.h"
#import "SupportFunctions.h"
#import "UserDefaults.h"

@interface DataContentLoader(PrivateMethods)
- (void)loadFiles:(NSMutableArray *)filesArray;
- (void)loadDirectories:(NSMutableArray *)directoriesArray;
- (void)resultForRequest:(FMWebDAVRequest *)finishedRequest; //sync
- (void)finishedDataLoading;
- (void)logEventWithCode:(DataSyncEventCode)eventCode 
                  status:(DataSyncEventStatus)status 
                 message:(NSString *)msg 
             usingPrefix:(NSString *)prefix;
@end

@implementation DataContentLoader

@synthesize syncContext, localFolder, remoteFolder, webDavLogin, webDavPassword, syncModule, errors;

//инициализация для загрузки папки
- (id)initForLoadingFolderWithDelegate:(id<BaseLoaderDelegate>)newDelegate 
                           localFolder:(NSString *)lFolder 
                          remoteFolder:(NSString *)rFolder 
                            andContext:(NSManagedObjectContext *)context
                        forSyncModule:(DataSyncModule)module {
    if ((self = [super init])) {
        loaderDelegate = newDelegate;
        self.syncModule = module;
        self.syncContext = context;
        parser = [[DataContentXmlParser alloc] init];
        self.localFolder = lFolder;
        self.remoteFolder = rFolder;
        
        SystemDataEntity *systemEntity = [[SystemDataEntity alloc] initWithContext:syncContext];
        UserInfo *user = [systemEntity userInfo];
        self.webDavLogin = ([user.webDavLogin length] > 0) ? user.webDavLogin : constEmptyStringValue;
        NSString *password = [UserDefaults stringSettingByKey:constWebDavServerPassword];
        self.webDavPassword = (password != nil) ? password : constEmptyStringValue;
        user.webDavToken = [NSString stringWithFormat: @"%@_%.0f", @"token", [NSDate timeIntervalSinceReferenceDate] * 1000.0];	
        [systemEntity release];
    }
    return self;
}

//инициализация для начала синхронизации папки
- (id)initForSyncWithDelegate:(id<BaseLoaderDelegate>)newDelegate 
                   andContext:(NSManagedObjectContext *)context
                forSyncModule:(DataSyncModule)module {
    if ((self = [super init])) {
        loaderDelegate = newDelegate;
        self.syncContext = context;
        self.syncModule = module;
    }
    return self;
}

//запуск синхронизации
- (NSArray *)loadSyncData {
    [self logEventWithCode:DSEventCodeLoaderStarted status:DSEventStatusUnknown message:nil usingPrefix:nil];
    
    NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.errors = tmpArray;
    [tmpArray release];
    
    NSString *localRootFolder = [SupportFunctions getWebDavRootFolderPath];
    NSString *remoteRootFolder = [UserDefaults stringSettingByKey:constWebDavServerUrl];
    
    ClientSettingsDataEntity *settingsEntity = [[ClientSettingsDataEntity alloc] initWithContext:[[CoreDataProxy sharedProxy] workContext]];
    NSArray *webDavSyncFolders = [settingsEntity selectAllWebDavDashboardItems];
    for (DashboardItem *webDavSyncFolder in webDavSyncFolders) {
        if ([loaderDelegate isAbortSyncRequested] == YES) 
            break;
        
        NSString *webDavSyncFolderName = [SupportFunctions createWebDavFolderNameForDashboardItem:webDavSyncFolder.id];
        NSLog(@"DataContentLoader loadSyncData for webdav folder %@", webDavSyncFolderName);
        
        NSString *localSyncFolderPath = [localRootFolder stringByAppendingPathComponent:webDavSyncFolderName];
        NSString *remoteSyncFolderURL = [remoteRootFolder stringByAppendingString:webDavSyncFolderName];
        NSString *remoteSyncFolderURLEscaped = 
            [remoteSyncFolderURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        DataContentLoader *syncFolderLoader = [[DataContentLoader alloc] initForLoadingFolderWithDelegate:loaderDelegate 
                                                                                              localFolder:localSyncFolderPath 
                                                                                             remoteFolder:remoteSyncFolderURLEscaped
                                                                                               andContext:syncContext
                                                                                            forSyncModule:self.syncModule];
        [errors addObjectsFromArray:[syncFolderLoader startLoad]];
        [syncFolderLoader release];
    }
    
    [settingsEntity release];
    [self logEventWithCode:DSEventCodeLoaderFinished status:DSEventStatusUnknown message:nil usingPrefix:nil];
    
    return [NSArray arrayWithArray:errors];
}

//запуск загрузки каталогов
- (NSArray *)startLoad {
    NSLog(@"DataContentLoader startLoad");
    NSLog(@"remoteFolder = %@", self.remoteFolder);
    NSLog(@"localFolder = %@", self.localFolder);
      
    requestInProcess = YES;
    NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.errors = tmpArray;
    [tmpArray release];
    
    NSError *error = nil;
    BOOL localFolderExists = [[NSFileManager defaultManager] fileExistsAtPath:self.localFolder];
    if (localFolderExists == NO) { 
        [[NSFileManager defaultManager] createDirectoryAtPath:self.localFolder withIntermediateDirectories:YES attributes:nil error:&error];
        if (error != nil) {
            NSLog(@"DataContentLoader create folder error description: %@ \n", [error localizedDescription]);
            [self logEventWithCode:DSEventCodeLoaderSubevent 
                            status:DSEventStatusWarning 
                           message:[NSString stringWithFormat:@"%@ - %@", [error localizedDescription], [error localizedFailureReason]]
                       usingPrefix:NSLocalizedString(@"WebDavSyncSaveFailedMessage", nil)];
        }
        else {
            localFolderExists = YES; 
        }
    }
   
    if (localFolderExists == YES) {
        NSURL *newUrl = [NSURL URLWithString:self.remoteFolder];
		if (webDavRequest) [webDavRequest release];
        webDavRequest = [[FMWebDAVRequest requestToURL:newUrl 
											  delegate:[self retain] 
										   endSelector:@selector(resultForRequest:) 
										   contextInfo:nil] retain];
        [SupportFunctions setNetworkActivityIndicatorVisible:YES];
        [webDavRequest fetchDirectoryListing]; 
        
        while (requestInProcess == YES) {
            [[NSRunLoop currentRunLoop] runUntilDate:[[NSDate date] dateByAddingTimeInterval:0.1]];
        } 
    }
    else {
        requestInProcess = NO;
    }
    
    return [NSArray arrayWithArray:errors];
}

- (void)resultForRequest:(FMWebDAVRequest *)finishedRequest {
    [SupportFunctions setNetworkActivityIndicatorVisible:NO];
    if (finishedRequest.error == nil) {
        [DebugUtils debugData:finishedRequest.responseData toFile:@"webDavResponse.xml"];
        NSError *error = nil;
        parser.currFolder = self.localFolder;
        [parser parseContent:finishedRequest.responseData forPath:self.remoteFolder error:&error];
        if (error == nil) {
            [self loadFiles:parser.files];
            [self loadDirectories:parser.directories];
        }
        else {
            NSLog(@"DataContentLoader parsing error:%@", [error localizedDescription]);
            [self logEventWithCode:DSEventCodeLoaderSubevent 
                            status:DSEventStatusWarning 
                            message:[NSString stringWithFormat:@"%@ %@", self.localFolder, [error localizedDescription]]
                        usingPrefix:NSLocalizedString(@"WebDavSyncParseFailedMessage", nil)];                   
        }
        requestInProcess = NO;
    }
}

- (void)request:(FMWebDAVRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"DataContentLoader request didFailWithError:%@", [error localizedDescription]); 
    [self logEventWithCode:DSEventCodeLoaderSubevent 
                    status:DSEventStatusWarning 
                   message:[NSString stringWithFormat:@"%@ %@", 
                            [self.remoteFolder stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                            [error localizedDescription]]
               usingPrefix:NSLocalizedString(@"WebDavSyncWSFailedMessage", nil)]; 
    [request.connection cancel];
    requestInProcess = NO;
    [SupportFunctions setNetworkActivityIndicatorVisible:NO];
}

- (void)request:(FMWebDAVRequest *)request hadStatusCodeErrorWithResponse:(NSHTTPURLResponse *)httpResponse {
    NSLog(@"DataContentLoader request hadStatusCodeErrorWithResponse:%i", httpResponse.statusCode); 
    [self logEventWithCode:DSEventCodeLoaderSubevent 
                    status:DSEventStatusWarning 
                   message:[NSString stringWithFormat:@"%@ %@", 
                            [self.remoteFolder stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                            [NSHTTPURLResponse localizedStringForStatusCode:httpResponse.statusCode]]
               usingPrefix:NSLocalizedString(@"WebDavSyncWSFailedMessage", nil)]; 
    [request.connection cancel];
    requestInProcess = NO;
    [SupportFunctions setNetworkActivityIndicatorVisible:NO];
}

- (void)request:(FMWebDAVRequest *)request didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {            
    if([challenge previousFailureCount] < 10) {
        NSURLCredential *creds = [NSURLCredential credentialWithUser:self.webDavLogin 
                                                            password:self.webDavPassword 
                                                         persistence:NSURLCredentialPersistenceForSession];
        
        [[challenge sender] useCredential:creds forAuthenticationChallenge:challenge];
    }
    else {
        [request.connection cancel];
        NSLog(@"DataContentLoader login failed"); 
        NSString *message = 
            [NSString stringWithFormat:@"%@: %@, %@", NSLocalizedString(@"LoginFailedMessage", nil), self.webDavLogin, self.webDavPassword];
        [self logEventWithCode:DSEventCodeLoaderSubevent 
                        status:DSEventStatusError 
                       message:message
                   usingPrefix:nil];                   
        
        SystemDataEntity *systemEntity = [[SystemDataEntity alloc] initWithContext:[[CoreDataProxy sharedProxy] workContext]];
        UserInfo *user = [systemEntity userInfo];
        user.webDavToken = nil;	
        [systemEntity release];
        
        requestInProcess = NO;
    }
}

- (void)loadFiles:(NSMutableArray *)filesArray {
    NSLog(@"DataContentLoader loadFiles: %i", [filesArray count]);
    
    NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.localFolder error:nil];
    NSMutableArray *localFiles = [NSMutableArray arrayWithArray:contents];
    
    //удаление директорий из списка файлов
    for (NSString *contentName in contents) {
        NSString *contentPath = [self.localFolder stringByAppendingPathComponent:contentName];
        NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:contentPath error:nil];
        if ([attributes objectForKey:NSFileType] == NSFileTypeDirectory) {
            [localFiles removeObject:contentName];
        }
    }
    
    //анализ файлов на необходимость загрузки
    for (NSDictionary *fileInfo in filesArray) {
        NSString *remoteFileName = [fileInfo objectForKey:HFS_FileName];
        NSString *remoteFileURL = [fileInfo objectForKey:HFS_FilePath];
        NSString *localFilePath = [self.localFolder stringByAppendingPathComponent:remoteFileName];
        NSLog(@"remote file %@ check", [remoteFileURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
        
        BOOL needFileDownload = NO;
        BOOL localFileExists = [[NSFileManager defaultManager] fileExistsAtPath:localFilePath];
        if (localFileExists == YES) {
            NSDate *remoteFileModificationDate = [fileInfo valueForKey:NSFileModificationDate];
            NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:localFilePath error:nil]; 
            NSDate *localFileModificationDate = [attributes valueForKey:NSFileModificationDate];
            if ([SupportFunctions date:remoteFileModificationDate equalToDate:localFileModificationDate] == NO) {
                [[NSFileManager defaultManager] removeItemAtPath:localFilePath error:nil];
                needFileDownload = YES;
            }
        }
        else {
            needFileDownload = YES; 
        }
        
        if (needFileDownload == YES) {
            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:remoteFileURL]];
            NSURLResponse *response = nil;
            NSError *error = nil;
            
            [SupportFunctions setNetworkActivityIndicatorVisible:YES];
            NSData *fileData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
            [SupportFunctions setNetworkActivityIndicatorVisible:NO];
            
            if (error != nil) {
                if (localFileExists && error.code == 401) {
                    NSLog(@"DataContentLoader server file access error:%@. Local file deleted:%@", [error localizedDescription], localFilePath);
                  [[NSFileManager defaultManager] removeItemAtPath:localFilePath error:nil];  
                }
                NSLog(@"DataContentLoader file downloading error:%@", [error localizedDescription]);
                [self logEventWithCode:DSEventCodeLoaderSubevent 
                                status:DSEventStatusWarning 
                               message:[NSString stringWithFormat:@"%@ %@", remoteFileName, [error localizedDescription]]
                           usingPrefix:NSLocalizedString(@"WebDavSyncWSFailedMessage", nil)];                
            }
            else {
                [fileData writeToFile:localFilePath atomically:YES];
                NSDictionary *fileAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                [fileInfo valueForKey:NSFileCreationDate], NSFileCreationDate,
                                                [fileInfo valueForKey:NSFileModificationDate], NSFileModificationDate,
                                            nil];
                [[NSFileManager defaultManager] setAttributes:fileAttributes ofItemAtPath:localFilePath error:nil];
                NSLog(@"file downloaded and saved as local");
            }
        }
        else {
            NSLog(@"local file exists");
        }
        for (NSString *contentName in contents) {
            if ([remoteFileName localizedCaseInsensitiveCompare:contentName] == NSOrderedSame) {
                [localFiles removeObject:contentName];
                break;
            }
        }
    }

    //удаление локальных файлов удаленных ранее на сервере
    for (NSString *fileName in localFiles) {
        NSString *filePath = [self.localFolder stringByAppendingPathComponent:fileName];
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        NSLog(@"local file %@ deleted", fileName);
    }
}

- (void)loadDirectories:(NSMutableArray *)directoriesArray {
    NSLog(@"DataContentLoader loadDirectories: %i", [directoriesArray count]);
    
    NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.localFolder error:nil];
    NSMutableArray *localDirectories = [NSMutableArray arrayWithArray:contents];
    
    //удаление файлов из списка директорий
    for (NSString *contentName in contents) {
        NSString *contentPath = [self.localFolder stringByAppendingPathComponent:contentName];
        NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:contentPath error:nil];
        if ([attributes objectForKey:NSFileType] != NSFileTypeDirectory) {
            [localDirectories removeObject:contentName];
        }
    }
    
    //анализ файлов на необходимость загрузки
    for (NSDictionary *directoryInfo in directoriesArray) {
        NSString *remoteDirectoryName = [directoryInfo objectForKey:HFS_FileName];
        NSString *remoteDirectoryURL = [directoryInfo objectForKey:HFS_FilePath];
        NSString *localDirectoryPath = [self.localFolder stringByAppendingPathComponent:remoteDirectoryName];
        NSLog(@"remote directory %@ check", remoteDirectoryName);
        
        DataContentLoader *directoryLoader = [[DataContentLoader alloc] initForLoadingFolderWithDelegate:loaderDelegate 
                                                                                            localFolder:localDirectoryPath 
                                                                                            remoteFolder:remoteDirectoryURL
                                                                                              andContext:syncContext
                                                                                        forSyncModule:self.syncModule];
        [directoryLoader startLoad];
        [directoryLoader release];
        NSDictionary *fileAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [directoryInfo valueForKey:NSFileCreationDate],NSFileCreationDate,
                                        [directoryInfo valueForKey:NSFileModificationDate],NSFileModificationDate, nil];
        [[NSFileManager defaultManager] setAttributes:fileAttributes ofItemAtPath:localDirectoryPath error:nil];
        
        for (NSString *contentName in contents) {
            if ([remoteDirectoryName localizedCaseInsensitiveCompare:contentName] == NSOrderedSame) {
                [localDirectories removeObject:contentName];
                break;
            }
        }
        NSLog(@"structure updated");
    }
   
    //удаление несуществующих на сервере директорий
    for (NSString *directoryName in localDirectories) {
        NSString *filePath = [self.localFolder stringByAppendingPathComponent:directoryName];
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        NSLog(@"local directory %@ deleted", directoryName);
    }
}


- (void)logEventWithCode:(DataSyncEventCode)eventCode 
                  status:(DataSyncEventStatus)status 
                 message:(NSString *)msg 
             usingPrefix:(NSString *)prefix {
    if (status == DSEventStatusError) 
        [self.errors addObject:msg];                  
    if (prefix != nil) 
        msg = [NSString stringWithFormat:@"%@: %@", prefix, msg];
    [DataSyncEventHandler notifyForDatasyncEventWithCode:eventCode title:nil status:status message:msg sender:self];
}

+ (void)notifyAboutSkippedStep {
    [DataSyncEventHandler notifyForDatasyncEventWithCode:DSEventCodeLoaderFinished title:nil status:DSEventStatusUnknown message:nil sender:self];
}

- (void)dealloc {
    self.errors = nil;
    self.webDavPassword = nil;
    self.webDavLogin = nil;

    self.localFolder = nil;
    self.remoteFolder = nil;
    
    self.syncContext = nil;
    
    if (webDavRequest != nil)
        [webDavRequest release];
    if (parser != nil)
        [parser release];
    
    [super dealloc];
}

@end
