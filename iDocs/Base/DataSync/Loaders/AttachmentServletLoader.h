//
//  AttachmentServletLoader.h
//  iDoc
//
//  Created by rednekis on 5/9/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import <libxml/tree.h>

@interface AttachmentServletLoader : NSObject {
@private
    NSAutoreleasePool *downloadPool;
    BOOL downloadInProcess;
    NSURLConnection *conn;
    NSOutputStream *stream;
    NSString *filePath;
    NSString *loadingError;
}

// the autorelease pool property is assign because autorelease pools cannot be retained.
@property (nonatomic, assign) NSAutoreleasePool *downloadPool;
@property () BOOL downloadInProcess;
@property (nonatomic, assign) NSURLConnection *conn;
@property (nonatomic, assign) NSOutputStream *stream;
@property (nonatomic, retain) NSString *filePath;
@property (nonatomic, retain) NSString *loadingError;


- (NSString *)downloadFileWithRequest:(NSDictionary *)requestData andSaveWithFileName:(NSString *)fileName;

@end
