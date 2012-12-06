//
//  AttachmentServletLoader.m
//  iDoc
//
//  Created by rednekis on 5/9/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import "AttachmentServletLoader.h"
#import "SupportFunctions.h"
#import "Constants.h"

@implementation AttachmentServletLoader

@synthesize downloadPool, downloadInProcess, loadingError, stream, filePath, conn;

- (NSString *)downloadFileWithRequest:(NSDictionary *)requestData andSaveWithFileName:(NSString *)fileName {
    NSLog(@"AttachmentServletLoader downloadFileWithRequest andSaveWithFileName:%@ started", fileName); 
    // init
    self.loadingError = nil;
    
    self.downloadPool = [[NSAutoreleasePool alloc] init];
    self.filePath = [[SupportFunctions getORDFolderPath] stringByAppendingPathComponent:fileName];
    downloadInProcess = YES;

    NSString *servletUrl = [requestData valueForKey:keyRequestUrl];
	NSString *requestMessage = [requestData valueForKey:keyRequestMessage];
	NSURL *requestUrl = [NSURL URLWithString:[servletUrl stringByAppendingString:requestMessage]];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestUrl];
	[request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    float timeout = [(NSNumber *)[requestData objectForKey:keyRequestTimeout] floatValue];
	[request setTimeoutInterval:timeout];
	[request setHTTPMethod:@"GET"];

    // delete local file if exists before starting downloading new one
    NSError *error = nil;
    BOOL localFileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    if (localFileExists == YES) {
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
    }
    
    // download file
    if (error != nil) {  
        self.loadingError = [error localizedDescription];
        NSLog(@"AttachmentServletLoader delete local attachment error:%@", loadingError); 
    }
    else {
        [SupportFunctions setNetworkActivityIndicatorVisible:YES];
        conn = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
        while (downloadInProcess == YES) {
            [[NSRunLoop currentRunLoop] runUntilDate:[[NSDate date] dateByAddingTimeInterval:0.1]];
        } 
        [SupportFunctions setNetworkActivityIndicatorVisible:NO];        
    }
    
    self.conn = nil;
    downloadInProcess = NO;
    [downloadPool release];
    self.downloadPool = nil;

    // delete local file if there was error while downloading
    if (loadingError != nil) {
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
        if (error != nil) {  
            NSLog(@"AttachmentServletLoader delete junk file error:%@", [error localizedDescription]); 
        }
    }
    
    NSLog(@"AttachmentServletLoader downloadFileWithRequest andSaveWithFileName:%@ finished", fileName);
    return loadingError;
}

- (void)dealloc {
	self.filePath = nil;
    if( self.loadingError != nil ) {
        self.loadingError = nil;
    }
    
	[super dealloc];
}

#pragma mark NSURLConnection Delegate methods
// disable caching so that each time we run this app we are starting with a clean slate. You may not want to do this in your application.
- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    return nil;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {	
    // create stream
    stream = [[NSOutputStream alloc] initToFileAtPath:filePath append:YES]; 
    [stream open];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // write into stream
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

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	NSLog(@"AttachmentServletLoader connectionDidFinishLoading");
    // close stream and connection
    [stream close];
	[stream release];
    self.stream = nil;
    [conn release];
    downloadInProcess = NO;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {	
	NSLog(@"AttachmentServletLoader connectionDidFailWithError:%@", [error localizedDescription]);
    //close stream and connection
    self.loadingError = [error localizedDescription];
    [stream close];
	[stream release];
    self.stream = nil;
    [conn release];
    downloadInProcess = NO;
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {	
	NSLog(@"AttachmentServletLoader didReceiveAuthenticationChallenge for connection");
}


@end


