//
//  AttachmentPushParser.h
//  iDoc
//
//  Created by rednekis on 5/9/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import <libxml/tree.h>

@interface AttachmentBase64Loader : NSObject {
@private
    NSString *fileName;
    NSString *testDataXMLPath;
    NSAutoreleasePool *downloadAndParsePool;
    NSString *loadingError;    
    
    // connection and write resources
    NSURLConnection *connection;
    NSMutableData *responseData;
    NSOutputStream *stream;
    
    // reference to the libxml parser context
    xmlParserCtxtPtr context;    
    // overall state of the parser, used to exit the run loop.
    BOOL downloadInProcess;
    // the following state variables deal with getting character data from XML elements. 
    BOOL parsingContentsNode;
    BOOL parsingFaultNode;
    BOOL storingCharacters;
    NSMutableData *characterBuffer;
}

@property (nonatomic, retain) NSString *fileName;
@property (nonatomic, retain) NSString *testDataXMLPath;
// the autorelease pool property is assign because autorelease pools cannot be retained.
@property (nonatomic, assign) NSAutoreleasePool *downloadAndParsePool;
@property (nonatomic, retain) NSString *loadingError;
@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic, retain) NSMutableData *responseData;
@property (nonatomic, assign) NSOutputStream *stream;
@property BOOL downloadInProcess;
@property BOOL parsingContentsNode;
@property BOOL parsingFaultNode;
@property BOOL storingCharacters;
@property (nonatomic, retain) NSMutableData *characterBuffer;



- (NSString *)downloadAndParseXMLWithRequest:(NSDictionary *)requestData andSaveWithFileName:(NSString *)name;
- (NSString *)parseAndSaveXML:(NSData *)data withFileName:(NSString *)name;
@end
