//
//  DataContentXmlParser.h
//  iDoc
//
//  Created by Michael Syasko on 6/17/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ISO8601DateFormatter.h"

#define HFS_FilePath @"filePath"
#define HFS_FileName @"fileName"

@interface DataContentXmlParser : NSObject {
    NSMutableArray *dirsArray;
    NSMutableArray *filesArray;
    ISO8601DateFormatter *formatter;
    NSString *currFolder;
}

@property(nonatomic, readonly) NSMutableArray *directories;
@property(nonatomic, readonly) NSMutableArray *files;
@property(nonatomic, retain) NSString *currFolder;

- (BOOL)parseContent:(NSData *)data forPath:(NSString *)path error:(NSError **)parseError;
@end