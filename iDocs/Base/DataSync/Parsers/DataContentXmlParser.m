//
//  DataContentXmlParser.m
//  iDoc
//
//  Created by Michael Syasko on 6/17/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import "DataContentXmlParser.h"
#import "SMXMLDocument+RPC.h"
#import "SupportFunctions.h"

@implementation DataContentXmlParser

@synthesize directories = dirsArray, files = filesArray, currFolder;

- (NSDate *)convertWebDavCreationDateTimeStringToDate:(NSString *)dateString {
    return [formatter dateFromString:dateString];
}

- (NSDate *)convertWebDavModificationDateTimeStringToDate:(NSString *)dateString {
    return [SupportFunctions dateFromRFC1123:dateString];
}

- (BOOL)parseContent:(NSData *)data forPath:(NSString *)path error:(NSError **)parseError {
    formatter = [[ISO8601DateFormatter alloc] init];
    dirsArray = [[NSMutableArray alloc] init];
    filesArray = [[NSMutableArray alloc] init];
    NSError *error = nil;
    SMXMLDocument *document = [SMXMLDocument documentWithData:data RPCError:&error];
    if (error) {
        NSLog(@"DataContentXmlParser parseContent error:%@", [error localizedDescription]);
        if (parseError)
            *parseError = error;
        return NO;
    }
    
    SMXMLElement *contentsPacket = document.root;
        
    for (SMXMLElement *node in [contentsPacket childrenNamed:@"response"]) {
        SMXMLElement *resourceType = [node descendantWithPath:@"propstat.prop.resourcetype"];
        NSString *resourcePath = [[node childNamed:@"href"] value];
        SMXMLElement *propData = [node descendantWithPath:@"propstat.prop"];
        
        // если есть доступ к данному объекту, то добавляем его в список
        if (propData != nil) {  
            NSString *resourceCreationString = [[propData childNamed:@"creationdate"] value];
            NSDate *resourceCreationDate = [self convertWebDavCreationDateTimeStringToDate:resourceCreationString];
            NSString *resourceModificationString = [[propData childNamed:@"getlastmodified"] value];
            NSDate *resourceModificationDate = [self convertWebDavModificationDateTimeStringToDate:resourceModificationString];
            NSString *resourceName = [[propData childNamed:@"displayname"] value];
            
            if ([resourceType childNamed:@"collection"]) {
                if (![resourcePath isEqualToString:path] && ([[[propData childNamed:@"ishidden"] value] intValue] == 0)) {
                    [dirsArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                          resourcePath, HFS_FilePath,
                                          resourceName, HFS_FileName,
                                          resourceCreationDate, NSFileCreationDate,
                                          resourceModificationDate, NSFileModificationDate, nil]];
                }
            } 
            else {
                if ([[[propData childNamed:@"ishidden"] value] intValue] == 0) {
                    [filesArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                          resourcePath, HFS_FilePath,
                                          resourceName, HFS_FileName,
                                          resourceCreationDate, NSFileCreationDate,
                                          resourceModificationDate, NSFileModificationDate, nil]];
                }        
            }
        }
    }
    return YES;
}

- (void)dealloc {
    [formatter release];
    [dirsArray release];
    [currFolder release];
    [filesArray release];
    [super dealloc];
}

@end
