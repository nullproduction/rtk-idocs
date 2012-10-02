//
//  BaseWSLoader.m
//  iDoc
//
//  Created by rednekis on 5/9/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import "BaseWSLoader.h"
#import "UserDefaults.h"
#import "LoginXmlParser.h"
#import "SupportFunctions.h"
#import "DataSyncEventHandler.h"

@implementation BaseWSLoader

- (id)initWithLoaderDelegate:(id<BaseLoaderDelegate>)newDelegate andContext:(NSManagedObjectContext *)context {	
    if ((self = [super initWithLoaderDelegate:newDelegate andContext:context])) {
        wsProxy = [[WebServiceProxy alloc] init];
		[wsProxy setDelegate:self];
	}
	return self;
}

- (NSString *)startDataDownloading:(NSDictionary *)requestData {
    NSLog(@"BaseLoader startDataDownloading");   
	return [wsProxy getServerDataForRequest:requestData];
}

- (void)webServiceProxyConnection:(NSString *)connectionId finishedDownloadingWithData:(NSMutableData *)data orError:(NSError *)error {
    NSLog(@"BaseLoader requestFinished");
    if (prepareTestData == YES && error == nil && connectionId != nil)
        [SupportFunctions createMockOutputFile:[self.mockXMLPaths valueForKey:connectionId] withData:data];       
}


- (void)dealloc {
	[wsProxy release];
	[super dealloc];
}

@end
