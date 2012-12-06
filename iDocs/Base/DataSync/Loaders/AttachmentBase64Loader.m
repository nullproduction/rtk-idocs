//
//  AttachmentBase64Loader.m
//  iDoc
//
//  Created by rednekis on 5/9/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import "AttachmentBase64Loader.h"
#import <libxml/tree.h>
#import "SupportFunctions.h"
#import "Constants.h"
#import "NSData+Additions.h"
#import "DebugUtils.h"

// function prototypes for SAX callbacks
static void startElementSAX(void *ctx, const xmlChar *localname, const xmlChar *prefix, const xmlChar *URI, int nb_namespaces, const xmlChar **namespaces, int nb_attributes, int nb_defaulted, const xmlChar **attributes);
static void	endElementSAX(void *ctx, const xmlChar *localname, const xmlChar *prefix, const xmlChar *URI);
static void	charactersFoundSAX(void * ctx, const xmlChar * ch, int len);
static void errorEncounteredSAX(void * ctx, const char * msg, ...);

// forward reference. The structure is defined in full at the end of the file.
static xmlSAXHandler simpleSAXHandlerStruct;


@implementation AttachmentBase64Loader

@synthesize fileName, testDataXMLPath, downloadAndParsePool, loadingError, downloadInProcess, connection, responseData, stream, parsingContentsNode, parsingFaultNode, storingCharacters, characterBuffer;

- (NSString *)downloadAndParseXMLWithRequest:(NSDictionary *)requestData andSaveWithFileName:(NSString *)name {
    NSLog(@"AttachmentBase64Loader downloadAndParseXMLWithRequest andSaveWithFileName:%@ started", name); 
    // init resources
    self.loadingError = nil;
    
    self.downloadAndParsePool = [[NSAutoreleasePool alloc] init];
    downloadInProcess = YES;
    self.fileName = name;
    self.responseData = [NSMutableData data];
    self.characterBuffer = [NSMutableData data];
    // this creates a context for "push" parsing in which chunks of data that are not "well balanced" can be passed
    // to the context for streaming parsing. The handler structure defined above will be used for all the parsing. 
    // The second argument, self, will be passed as user data to each of the SAX handlers. The last three arguments
    // are left blank to avoid creating a tree in memory.
    context = xmlCreatePushParserCtxt(&simpleSAXHandlerStruct, self, NULL, 0, NULL);
    
	NSURL *wsUrl = [NSURL URLWithString:[requestData valueForKey:keyRequestUrl]];
	NSString *requestSoapMessage = [requestData valueForKey:keyRequestMessage];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:wsUrl];
	[request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    float timeout = [(NSNumber *)[requestData objectForKey:keyRequestTimeout] floatValue];
	[request setTimeoutInterval:timeout];
	[request setHTTPMethod:@"POST"];
	[request setValue:@"\"process\"" forHTTPHeaderField:@"SOAPAction"];
	[request setValue:@"text/xml; charset=UTF-8" forHTTPHeaderField:@"Content-type"];
	[request setHTTPBody:[requestSoapMessage dataUsingEncoding:NSUTF8StringEncoding]];
#if TARGET_IPHONE_SIMULATOR
    [DebugUtils debugData:[requestSoapMessage dataUsingEncoding:NSUTF8StringEncoding] toFile:@"request.txt"];
#endif
    
    // create the connection with the request and start loading the data	
	connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [SupportFunctions setNetworkActivityIndicatorVisible:YES];
    if (connection != nil) {
        while (downloadInProcess == YES) {
            [[NSRunLoop currentRunLoop] runUntilDate:[[NSDate date] dateByAddingTimeInterval:0.1]];
        } 
    }
    [SupportFunctions setNetworkActivityIndicatorVisible:NO];
    
    // release resources used only in this thread
    xmlFreeParserCtxt(context);
    self.responseData = nil;
    self.characterBuffer = nil;
    self.connection = nil;
    downloadInProcess = NO;
    [downloadAndParsePool release];
    self.downloadAndParsePool = nil;
    
    //delete local file if there was error while downloading
    if (loadingError != nil) {
        NSError *error = nil;
        NSString *filePath = [SupportFunctions createPathForAttachment:fileName];
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
        if (error != nil) {  
            NSLog(@"AttachmentBase64Loader delete junk file error:%@", [error localizedDescription]); 
        }
    }
    NSLog(@"AttachmentBase64Loader downloadAndParseXMLWithRequest andSaveWithFileName:%@ finished", name); 
    return loadingError;
}

- (NSString *)parseAndSaveXML:(NSData *)data withFileName:(NSString *)name {
    NSLog(@"AttachmentBase64Loader parseAndSaveXML withFileName:%@ started", name); 
    self.loadingError = nil;
    
    self.downloadAndParsePool = [[NSAutoreleasePool alloc] init];
    downloadInProcess = NO;
    self.responseData = nil;
    self.connection = nil;
    self.characterBuffer = [NSMutableData data];
    self.fileName = name;
    
    NSString *filePath = [SupportFunctions createPathForAttachment:fileName];
    stream = [[NSOutputStream alloc] initToFileAtPath:filePath append:YES]; 
    [stream open];
    
    context = xmlCreatePushParserCtxt(&simpleSAXHandlerStruct, self, NULL, 0, NULL);
    xmlParseChunk(context, (const char *)[data bytes], (int)[data length], 1);
    xmlFreeParserCtxt(context);
    
    [stream close];
    [stream release];
    self.stream = nil;
    
    self.characterBuffer = nil;
    [downloadAndParsePool release];
    self.downloadAndParsePool = nil;
    
    //delete local file if there was error while downloading
    if (loadingError != nil) {
        NSError *error = nil;
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
        if (error != nil) {  
            NSLog(@"AttachmentBase64Loader delete junk file error:%@", [error localizedDescription]); 
        }
    }
    
    NSLog(@"AttachmentBase64Loader parseAndSaveXML withFileName:%@ finished", name);
    return loadingError;
}


#pragma mark NSURLConnection Delegate methods
// disable caching so that each time we run this app we are starting with a clean slate. You may not want to do this in your application.
- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    return nil;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // open stream
    NSString *filePath = [SupportFunctions createPathForAttachment:fileName];
    stream = [[NSOutputStream alloc] initToFileAtPath:filePath append:YES];
    [stream open];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"AttachmentBase64Loader ws failed:%@", [error localizedDescription]);
    // close stream
    self.loadingError = [error localizedDescription];
    [stream close];
    [stream release];
    self.stream = nil;
    downloadInProcess = NO;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // end parsing and saving data
    xmlParseChunk(context, NULL, 0, 1);
#if TARGET_IPHONE_SIMULATOR
    [DebugUtils debugData:responseData toFile:@"response.txt"];
    if ([testDataXMLPath length] > 0)
        [SupportFunctions createMockOutputFile:testDataXMLPath withData:responseData];
#endif
    [stream close];
    [stream release];
    self.stream = nil;
    downloadInProcess = NO; 
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // parse chunk data
    xmlParseChunk(context, (const char *)[data bytes], (int)[data length], 0);
#if TARGET_IPHONE_SIMULATOR
    [responseData appendData:data];
#endif
}


#pragma mark Parsing support methods
- (void)saveDataToFile {
    // save data to file
    NSString *base64Chars = 
        [[NSString alloc] initWithBytes:[characterBuffer bytes] length:[characterBuffer length] encoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBase64EncodedString:base64Chars];
    [base64Chars release];
    
    NSString *str = (NSString *)data;
    NSUInteger left = [str length];
    NSUInteger nwr = 0;
    do {
        nwr = [stream write:[data bytes] maxLength:left];
        if (-1 == nwr) break;
        left -= nwr;
    } while (left > 0);
    if (left) {
        NSLog(@"stream error: %@", [stream streamError]);
        self.loadingError = [[stream streamError] localizedDescription];
    }   
}

- (void)reportError { 
    // report error
    NSString *faultString = 
        [[NSString alloc] initWithBytes:[characterBuffer bytes] length:[characterBuffer length] encoding:NSUTF8StringEncoding];
    NSLog(@"AttachmentBase64Loader fault error: %@", faultString);
    self.loadingError = faultString;
    [faultString release];
#if TARGET_IPHONE_SIMULATOR
    [DebugUtils debugData:characterBuffer toFile:@"fault.txt"];
#endif    
}

- (void)appendCharacters:(const char *)charactersFound length:(NSInteger)length {
    // save chunk data to buffer
    [characterBuffer appendBytes:charactersFound length:length];
}

- (void)dealloc {
    if( self.fileName != nil ) {
        self.fileName = nil;
    }
    if( self.testDataXMLPath != nil ) {
        self.testDataXMLPath = nil;
    }

    if( self.loadingError != nil ) {
        self.loadingError = nil;
    }

    if( self.connection != nil ) {
        self.connection = nil;
    }

    if( self.responseData != nil ) {
        self.responseData = nil;
    }

    if( self.characterBuffer != nil ) {
        self.characterBuffer = nil;
    }
    
    [super dealloc];
}

@end


#pragma mark SAX Parsing Callbacks
// the following constants are the XML element names and their string lengths for parsing comparison.
// the lengths include the null terminator, to ensure exact matches.
static const char *kName_Contents = "Contents";
static const NSUInteger kLength_Contents = 9;
static const char *kName_Value = "Value";
static const NSUInteger kLength_Value = 6;

static const char *kName_Fault = "Fault";
static const NSUInteger kLength_Fault = 6;
static const char *kName_FaultString = "faultstring";
static const NSUInteger kLength_FaultString = 12;

// this callback is invoked when the parser finds the beginning of a node in the XML.
static void startElementSAX(void *ctx, const xmlChar *localname, const xmlChar *prefix, const xmlChar *URI, 
                            int nb_namespaces, const xmlChar **namespaces, int nb_attributes, int nb_defaulted, const xmlChar **attributes) {
    AttachmentBase64Loader *loader = (AttachmentBase64Loader *)ctx;
    [loader.characterBuffer setLength:0];
    
    // the second parameter to strncmp is the name of the element, which we known from the XML schema of the feed.
    // the third parameter to strncmp is the number of characters in the element name, plus 1 for the null terminator.
    if (!strncmp((const char *)localname, kName_Fault, kLength_Fault)) { //error
        loader.parsingFaultNode = YES;
    }   
    else if (!strncmp((const char *)localname, kName_Contents, kLength_Contents)) { //content
        loader.parsingContentsNode = YES;
    }
    else if ((loader.parsingFaultNode == YES && !strncmp((const char *)localname, kName_FaultString, kLength_FaultString)) ||
             (loader.parsingContentsNode == YES && !strncmp((const char *)localname, kName_Value, kLength_Value))) {
        loader.storingCharacters = YES;
    }
}

// this callback is invoked when the parse reaches the end of a node.
static void	endElementSAX(void *ctx, const xmlChar *localname, const xmlChar *prefix, const xmlChar *URI) { 
    AttachmentBase64Loader *loader = (AttachmentBase64Loader *)ctx;
    if (loader.parsingFaultNode == NO && loader.parsingContentsNode == NO) 
        return;
    
    if (!strncmp((const char *)localname, kName_Fault, kLength_Fault)) {  //error
        loader.parsingFaultNode = NO;
    }
    else if (loader.parsingFaultNode == YES && !strncmp((const char *)localname, kName_FaultString, kLength_FaultString)) {
        [loader reportError];
        loader.storingCharacters = NO;
    }
    else if (!strncmp((const char *)localname, kName_Contents, kLength_Contents)) { //content
        loader.parsingContentsNode = NO;
    }
    else if (loader.parsingContentsNode == YES && !strncmp((const char *)localname, kName_Value, kLength_Value)) {
        [loader saveDataToFile];
        loader.storingCharacters = NO;
    }
}


// this callback is invoked when the parser encounters character data inside a node. 
static void	charactersFoundSAX(void *ctx, const xmlChar *ch, int len) {
    AttachmentBase64Loader *loader = (AttachmentBase64Loader *)ctx;
    // a state variable, "storingCharacters", is set when nodes of interest begin and end. 
    // this determines whether character data is handled or ignored. 
    if (loader.storingCharacters == YES) {
        [loader appendCharacters:(const char *)ch length:len];
    }
}

static void errorEncounteredSAX(void *ctx, const char *msg, ...) {
    // Handle errors as appropriate for your application.
    AttachmentBase64Loader *loader = (AttachmentBase64Loader *)ctx;
    NSLog(@"AttachmentBase64Loader error during sax parsing:%@", [NSString stringWithCString:msg encoding:NSUTF8StringEncoding]);
    loader.loadingError = [NSString stringWithCString:msg encoding:NSUTF8StringEncoding];
}

// the handler struct has positions for a large number of callback functions. If NULL is supplied at a given position,
// that callback functionality won't be used. Refer to libxml documentation at http://www.xmlsoft.org for more information
// about the SAX callbacks.
static xmlSAXHandler simpleSAXHandlerStruct = {
    NULL,                       /* internalSubset */
    NULL,                       /* isStandalone   */
    NULL,                       /* hasInternalSubset */
    NULL,                       /* hasExternalSubset */
    NULL,                       /* resolveEntity */
    NULL,                       /* getEntity */
    NULL,                       /* entityDecl */
    NULL,                       /* notationDecl */
    NULL,                       /* attributeDecl */
    NULL,                       /* elementDecl */
    NULL,                       /* unparsedEntityDecl */
    NULL,                       /* setDocumentLocator */
    NULL,                       /* startDocument */
    NULL,                       /* endDocument */
    NULL,                       /* startElement*/
    NULL,                       /* endElement */
    NULL,                       /* reference */
    charactersFoundSAX,         /* characters */
    NULL,                       /* ignorableWhitespace */
    NULL,                       /* processingInstruction */
    NULL,                       /* comment */
    NULL,                       /* warning */
    errorEncounteredSAX,        /* error */
    NULL,                       /* fatalError //: unused error() get all the errors */
    NULL,                       /* getParameterEntity */
    NULL,                       /* cdataBlock */
    NULL,                       /* externalSubset */
    XML_SAX2_MAGIC,             //
    NULL,
    startElementSAX,            /* startElementNs */
    endElementSAX,              /* endElementNs */
    NULL,                       /* serror */
};
