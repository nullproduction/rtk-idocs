//
//  DictionariesChunkLoader.m
//  iDoc
//
//  Created by rednekis on 5/9/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import "DictionariesChunkLoader.h"
#import <libxml/tree.h>
#import "SupportFunctions.h"
#import "Constants.h"
#import "NSData+Additions.h"
#import "DebugUtils.h"
#import "WebServiceRequests.h"
#import "ORDSyncManager.h"
#import "UserDefaults.h"

// function prototypes for SAX callbacks
static void startElementSAX(void *ctx, const xmlChar *localname, const xmlChar *prefix, const xmlChar *URI, int nb_namespaces, const xmlChar **namespaces, int nb_attributes, int nb_defaulted, const xmlChar **attributes);
static void	endElementSAX(void *ctx, const xmlChar *localname, const xmlChar *prefix, const xmlChar *URI);
static void	charactersFoundSAX(void * ctx, const xmlChar * ch, int len);
static void errorEncounteredSAX(void * ctx, const char * msg, ...);

// forward reference. The structure is defined in full at the end of the file.
static xmlSAXHandler simpleSAXHandlerStruct;

@interface DictionariesChunkLoader(PrivateMethods)
- (void)startLoad;
- (void)cleanupLocalData;
- (void)reportError:(NSString *)errorMessage;
- (void)addValueToField;
- (void)appendCharacters:(const char *)charactersFound length:(NSInteger)length;
- (void)insertDictionariesData:(NSDictionary *)data;
@end


@implementation DictionariesChunkLoader

@synthesize downloadAndParsePool; 
@synthesize conn; 
@synthesize responseData; 
@synthesize recordData; 
@synthesize parsingFieldName; 
@synthesize storingCharacters; 
@synthesize characterBuffer;
@synthesize employeeEntity;
@synthesize employeeGroupEntity;
@synthesize resolutionTemplateEntity;

- (id)initWithLoaderDelegate:(id<BaseLoaderDelegate>)newDelegate 
                  andContext:(NSManagedObjectContext *)context 
               forSyncModule:(DataSyncModule)module {
    if ((self = [super initWithLoaderDelegate:newDelegate andContext:context])) {
        self.syncModule = module;
	}
	return self;
}

- (NSString *)returnPathForMockXml:(NSString *)connId {
    return constTestDicDataFile;
}

- (NSArray *)loadSyncData {
    NSLog(@"DictionariesLoader loadSyncData");
    [self logEventWithCode:DSEventCodeLoaderStarted status:DSEventStatusUnknown message:nil usingPrefix:nil];
    
    NSMutableArray *emptyArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.errors = emptyArray;
    [emptyArray release];
    
    if ([UserDefaults boolSettingByKey:constSyncDictionaries] == YES) {
        [self startLoad];
    }
    
    [self logEventWithCode:DSEventCodeLoaderFinished status:DSEventStatusUnknown message:nil usingPrefix:nil];
    return [NSArray arrayWithArray:errors];
}

- (void)startLoad {
    NSLog(@"DictionariesLoader startLoad");
//    [self cleanupLocalData];

    self.downloadAndParsePool = [[NSAutoreleasePool alloc] init];
    requestInProcess = YES;
    
    self.responseData = [NSMutableData data];
    self.characterBuffer = [NSMutableData data];
    self.recordData = [NSMutableDictionary dictionaryWithCapacity:0];
    EmployeeListDataEntity *tmpEmployeeListEntity = [[EmployeeListDataEntity alloc] initWithContext:syncContext];
    self.employeeEntity = tmpEmployeeListEntity;
    [tmpEmployeeListEntity release];
    truncateEmployees = YES;
    EmployeeGroupDataEntity *tmpEmployeeGroupEntity = [[EmployeeGroupDataEntity alloc] initWithContext:syncContext];
    self.employeeGroupEntity = tmpEmployeeGroupEntity;
    [tmpEmployeeGroupEntity release];
    truncateEmployeeGroups = YES;
    ResolutionTemplateDataEntity *tmpResolutionTemplateEntity = [[ResolutionTemplateDataEntity alloc] initWithContext:syncContext];
    self.resolutionTemplateEntity = tmpResolutionTemplateEntity;
    [tmpResolutionTemplateEntity release];
    truncateResolutionTemplates = YES;
    
    // this creates a context for "push" parsing in which chunks of data that are not "well balanced" can be passed
    // to the context for streaming parsing. The handler structure defined above will be used for all the parsing. 
    // The second argument, self, will be passed as user data to each of the SAX handlers. The last three arguments
    // are left blank to avoid creating a tree in memory.
    parserContext = xmlCreatePushParserCtxt(&simpleSAXHandlerStruct, self, NULL, 0, NULL);
    
	if (useTestData == NO) {
		NSDictionary *requestData = [WebServiceRequests createDictionariesSyncRequestForUser:[systemEntity userInfo]];
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
        conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        //prepare test xml
        if (prepareTestData == YES) {
            NSString *connId = [NSString stringWithFormat:@"%0d", [conn hash]];
            [self.mockXMLPaths setValue:[self returnPathForMockXml:connId] forKey:connId];
        }

        [SupportFunctions setNetworkActivityIndicatorVisible:YES];
        if (conn != nil) {
            while (requestInProcess == YES) {
                if ([loaderDelegate isAbortSyncRequested] == YES) {
                    [conn cancel];
                    requestInProcess = NO;
                }
                [[NSRunLoop currentRunLoop] runUntilDate:[[NSDate date] dateByAddingTimeInterval:0.1]];
            }

        }
        [SupportFunctions setNetworkActivityIndicatorVisible:NO];
        
	}
    else {
        NSString *connId = @"test_conn";
        NSString *testDataXMLPath = [self returnPathForMockXml:connId];
        NSLog(@"Dictionaries Data XML Path: %@", testDataXMLPath);
        NSMutableData *data = 
            [NSMutableData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:testDataXMLPath ofType:nil]];
        xmlParseChunk(parserContext, (const char *)[data bytes], (int)[data length], 1);
	}
    
    NSError *error = nil;
    [syncContext save:&error];
    if (error != nil) {
        NSLog(@"Error saving context in DictionariesChunkLoader: %@", [error description]);
    }
    
    // release resources used only in this thread
    xmlFreeParserCtxt(parserContext);
    self.parsingFieldName = nil;
    self.employeeEntity = nil;
    self.employeeGroupEntity = nil;
    self.resolutionTemplateEntity = nil;
    self.recordData = nil;
    self.responseData = nil;
    self.characterBuffer = nil;
    self.conn = nil;
    requestInProcess = NO;
    [downloadAndParsePool release];
    self.downloadAndParsePool = nil;
    
    NSLog(@"DictionariesLoader finish loading");
}

- (void)cleanupLocalData {
    NSLog(@"DictionariesChunkLoader cleanupLocalData");
    ORDSyncManager *manager = [[ORDSyncManager alloc] initForCleanupWithContext:syncContext];
    [manager cleanupORDDictionariesData];
    [manager release];
}

#pragma mark NSURLConnection delegate methods
// disable caching so that each time we run this app we are starting with a clean slate. You may not want to do this in your application.
- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    return nil;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"Start response parsing");
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"DictionariesChunkLoader ws failed:%@", [error localizedDescription]);
    [self logEventWithCode:DSEventCodeLoaderSubevent 
                    status:DSEventStatusError 
                   message:[error localizedDescription]
               usingPrefix:NSLocalizedString(@"DicSyncWSFailedMessage", nil)];
    requestInProcess = NO;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // end parsing and saving data
    xmlParseChunk(parserContext, NULL, 0, 1);
#if TARGET_IPHONE_SIMULATOR
    [DebugUtils debugData:responseData toFile:@"response.txt"];
    if (prepareTestData == YES) {
        NSString *connId = [NSString stringWithFormat:@"%0d", [connection hash]];
        [SupportFunctions createMockOutputFile:[self.mockXMLPaths valueForKey:connId] withData:responseData]; 
    }
#endif
    
    NSLog(@"End response parsing");
    requestInProcess = NO; 
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // parse chunk data   
    xmlParseChunk(parserContext, (const char *)[data bytes], (int)[data length], 0);
#if TARGET_IPHONE_SIMULATOR
    [responseData appendData:data];
#endif
}


#pragma mark parsing support methods
- (void)reportError:(NSString *)errorMessage { 
    NSLog(@"DictionariesChunkLoader parse error: %@", errorMessage);
    [self cleanupLocalData];
    [self logEventWithCode:DSEventCodeLoaderSubevent 
                    status:DSEventStatusError 
                   message:errorMessage
               usingPrefix:NSLocalizedString(@"DicSyncParseFailedMessage", nil)]; 
#if TARGET_IPHONE_SIMULATOR
    [DebugUtils debugData:characterBuffer toFile:@"fault.txt"];
#endif    
}

- (void)addValueToField { 
    NSString *fieldValue = 
        [[NSString alloc] initWithBytes:[characterBuffer bytes] length:[characterBuffer length] encoding:NSUTF8StringEncoding];
    [self.recordData setObject:fieldValue forKey:self.parsingFieldName];
    [fieldValue release];   
}

- (void)appendCharacters:(const char *)charactersFound length:(NSInteger)length {
    // save chunk data to buffer
    [characterBuffer appendBytes:charactersFound length:length];
}

#pragma mark core data methods
- (void)insertDictionariesData:(NSDictionary *)dataItem {
    
	NSString *dictType = [dataItem valueForKey:@"dictionaryType"];
    NSString *actionType = [dataItem valueForKey:@"actionType"];
    
	id<DictionaryDataItemEntityDelegate> dataEntity = nil;
	
	if ([dictType isEqualToString:constDicItemTypeSystemInfo]) {        
        //если не используем тестовые данные - установить новую дату для синхронизации
        NSString *lastUpdatedDate = (useTestData == NO) ? [dataItem valueForKey:@"nameElement"] : constEmptyStringValue;
        [UserDefaults saveValue:lastUpdatedDate forSetting:constDictionariesLastUpdatedDate];
        
        UserInfo *user = [systemEntity userInfo];
		user.id = [dataItem valueForKey:@"current_org_id"];
		user.fio = [dataItem valueForKey:@"current_user_fio"];
        user.organization = [dataItem valueForKey:@"current_user_organization"];
        user.subdivision = [dataItem valueForKey:@"current_user_subdivision"];
        user.position = [dataItem valueForKey:@"current_user_position"];
	}
    else {
        if ([dictType isEqualToString:constDicItemTypeEmployee]) {
           dataEntity = employeeEntity;
            if (truncateEmployees == YES && ([actionType isEqualToString:constDicItemActionTypeFullRefresh] || useTestData == YES)) {
                [dataEntity deleteAll];
                truncateEmployees = NO;
            }
        }
        else if ([dictType isEqualToString:constDicItemTypeEmployeeGroup]) {
            dataEntity = employeeGroupEntity;
            if (truncateEmployeeGroups == YES && ([actionType isEqualToString:constDicItemActionTypeFullRefresh] || useTestData == YES)) {
                [dataEntity deleteAll];
                truncateEmployeeGroups = NO;
            } 
        }
        else if ([dictType isEqualToString:constDicItemTypeResolutionTemplate]) {
            dataEntity = resolutionTemplateEntity;
            if (truncateResolutionTemplates == YES && ([actionType isEqualToString:constDicItemActionTypeFullRefresh] || useTestData == YES)) {
                [dataEntity deleteAll];
                truncateResolutionTemplates = NO;
            }
        }
        else {
            return;
        }
        
        if ([actionType isEqualToString:constDicItemActionTypeFullRefresh]) {
            [dataEntity createItemWithData:dataItem];
        }
        else if ([actionType isEqualToString:constDicItemActionTypeNew]) {
            [dataEntity createItemWithData:dataItem];
        }
        else if ([actionType isEqualToString:constDicItemActionTypeDelete]) {
            NSString *itemId = [dataItem valueForKey:@"idElement"];
            if ([itemId length] > 0)
                [dataEntity deleteItemWithId:itemId];
        }
        else if ([actionType isEqualToString:constDicItemActionTypeChange]) {
            [dataEntity updateItemWithData:dataItem];
        }
    }
}
@end


#pragma mark SAX Parsing Callbacks
// the following constants are the XML element names and their string lengths for parsing comparison.
// the lengths include the null terminator, to ensure exact matches.
static const char *kName_DataObjects = "DataObjects";
static const NSUInteger kLength_DataObjects = 12;

static const char *kName_Properties = "Properties";
static const NSUInteger kLength_Properties = 11;
static const char *kAttr_Name_Name = "name";
static const NSUInteger kAttr_Length_Name = 5;

static const char *kName_FaultString = "faultstring";
static const NSUInteger kLength_FaultString = 12;

// this callback is invoked when the parser finds the beginning of a node in the XML.
static void startElementSAX(void *ctx, const xmlChar *localname, const xmlChar *prefix, const xmlChar *URI, 
                            int nb_namespaces, const xmlChar **namespaces, int nb_attributes, int nb_defaulted, const xmlChar **attributes) {
    DictionariesChunkLoader *loader = (DictionariesChunkLoader *)ctx;
 
    // the second parameter to strncmp is the name of the element, which we known from the XML schema of the feed.
    // the third parameter to strncmp is the number of characters in the element name, plus 1 for the null terminator.
    if (!strncmp((const char *)localname, kName_FaultString, kLength_FaultString)) { //error
        loader.storingCharacters = YES;
        [loader.characterBuffer setLength:0];
    }  
    else if (!strncmp((const char *)localname, kName_DataObjects, kLength_DataObjects)) { //dictionary record
        [loader.recordData removeAllObjects];
    }
    else if (!strncmp((const char *)localname, kName_Properties, kLength_Properties)) { //dictionary values
        for (int i = 0; i < nb_attributes * 5; i += 5) {
            const char *attr = (const char *)attributes[i]; 
            if (!strncmp((const char *)attr, kAttr_Name_Name, kAttr_Length_Name)) {
                const char *begin = (const char *)attributes[i + 3];
                const char *end = (const char *)attributes[i + 4];
                ptrdiff_t vlen = end - begin;
                char val[vlen + 1];
                strncpy(val, begin, vlen);
                val[vlen] = '\0';
                //NSLog(@"attribute name value: %s", val);
                loader.parsingFieldName = [NSString stringWithCString:val encoding:NSUTF8StringEncoding];
                [loader.characterBuffer setLength:0];
                loader.storingCharacters = YES;
            }
        }
    }
}

// this callback is invoked when the parse reaches the end of a node.
static void	endElementSAX(void *ctx, const xmlChar *localname, const xmlChar *prefix, const xmlChar *URI) { 
    DictionariesChunkLoader *loader = (DictionariesChunkLoader *)ctx;
    
    if (!strncmp((const char *)localname, kName_FaultString, kLength_FaultString)) {  //error
        NSString *faultString = [[NSString alloc] initWithBytes:[loader.characterBuffer bytes] 
                                                         length:[loader.characterBuffer length] 
                                                       encoding:NSUTF8StringEncoding];
        [loader reportError:faultString];
        [faultString release];
        loader.storingCharacters = NO;
    }
    else if (!strncmp((const char *)localname, kName_DataObjects, kLength_DataObjects)) { //dictionary record
        //save data
        [loader insertDictionariesData:[NSDictionary dictionaryWithDictionary:loader.recordData]];
    }
    else if (!strncmp((const char *)localname, kName_Properties, kLength_Properties)) { //dictionary values
        [loader addValueToField];
        loader.storingCharacters = NO;
    }    
}

// this callback is invoked when the parser encounters character data inside a node. 
static void	charactersFoundSAX(void *ctx, const xmlChar *ch, int len) {
    DictionariesChunkLoader *loader = (DictionariesChunkLoader *)ctx;
    // a state variable, "storingCharacters", is set when nodes of interest begin and end. 
    // this determines whether character data is handled or ignored. 
    if (loader.storingCharacters == YES) {
        [loader appendCharacters:(const char *)ch length:len];
    }
}

static void errorEncounteredSAX(void *ctx, const char *msg, ...) {
    // Handle errors as appropriate for your application.
    DictionariesChunkLoader *loader = (DictionariesChunkLoader *)ctx;
    NSLog(@"DictionariesChunkLoader error during sax parsing:%@", [NSString stringWithCString:msg encoding:NSUTF8StringEncoding]);
    [loader reportError:[NSString stringWithCString:msg encoding:NSUTF8StringEncoding]];
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
