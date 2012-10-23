//
//  WebServiceProxy.m
//
//  Created by Dmitry Likhachev on 06/15/10.
//  Copyright HFS 2010. All rights reserved.
//

#import "WebServiceProxy.h"
#import "Constants.h"
#import "SupportFunctions.h"

@implementation WebServiceProxy

//init webServiceProxy
- (id)init {
	if((self = [super init])) {
		responseData = [[NSMutableDictionary alloc] init];
		responseLength = [[NSMutableDictionary alloc] init];
	}
	return self;
}

//init request to server
- (NSString *)getServerDataForRequest:(NSDictionary *)requestData {	
	NSURL *wsUrl = [NSURL URLWithString:[requestData valueForKey:keyRequestUrl]];
    NSLog(@"wsUrl %@", [wsUrl description]);
	NSString *requestSoapMessage = [requestData valueForKey:keyRequestMessage];
    NSLog(@"requestSoapMessage %@", [requestSoapMessage description]);
	
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:wsUrl];
	[request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    float timeout = [(NSNumber *)[requestData objectForKey:keyRequestTimeout] floatValue];
	[request setTimeoutInterval:timeout];
	[request setHTTPMethod:@"POST"];
	[request setValue:@"\"process\"" forHTTPHeaderField:@"SOAPAction"];
	[request setValue:@"text/xml; charset=UTF-8" forHTTPHeaderField:@"Content-type"];
	[request setHTTPBody:[requestSoapMessage dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    [request release];
	[DebugUtils debugData:[requestSoapMessage dataUsingEncoding:NSUTF8StringEncoding] toFile:@"request.txt"];	
	
	NSString *connId = nil;
	if (conn) {
		connId = [NSString stringWithFormat:@"%0d", [conn hash]];		
		NSLog(@"WebServiceProxy getServerDataForRequest create connection:%@", connId);		
		// Create the NSMutableData that will hold the received data
		[SupportFunctions setNetworkActivityIndicatorVisible:YES];
		NSMutableData *connResponseData = [NSMutableData dataWithLength:0];
		[responseData setValue:connResponseData forKey:connId];
		[responseLength setValue:[NSString stringWithFormat:@"%i", 0] forKey:connId];
	} else {
		// inform the user that the download could not be made
	}
	return connId;
}


#pragma mark WebServiceProxy delegate methods
- (void)setDelegate:(id<WebServiceProxyDelegate>)newDelegate {
	delegate = newDelegate;
}

- (void)endDownloadForConnection:(NSString *)connectionId withData:(NSMutableData *)data orError:(NSError *)error {
	[SupportFunctions setNetworkActivityIndicatorVisible:NO];
	if([delegate respondsToSelector:@selector(webServiceProxyConnection:finishedDownloadingWithData:orError:)])
		[delegate webServiceProxyConnection:connectionId finishedDownloadingWithData:data orError:error];
}

- (void)notifyInvalidCredentials {
	if([delegate respondsToSelector:@selector(onRequestNewCredentials:)])
		[delegate onRequestNewCredentials:self];
}


#pragma mark Connection delegate methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {	
	// this method is called when the server has determined that it
	// has enough information to create the NSURLResponse
	// it can be called multiple times, for example in the case of a
	// redirect, so each time we reset the data.
	// receivedData is declared as a method instance elsewhere
	NSString *connId = [NSString stringWithFormat:@"%0d" , [connection hash]];		
	[(NSMutableData *)[responseData objectForKey:connId] setLength:0];
	[responseLength setValue:[NSString stringWithFormat:@"%lli", [response expectedContentLength]] forKey:connId];

}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	// append the new data to the receivedData
	// receivedData is declared as a method instance elsewhere
	NSString *connId = [NSString stringWithFormat:@"%0d" ,[connection hash]];	
	[(NSMutableData *)[responseData objectForKey:connId] appendData:data];
	
	if (delegate != nil && [delegate respondsToSelector:@selector(setProgressPercentage:)]) {
		long long expectedLength = [[responseLength objectForKey:connId] longLongValue];
		long long loadedLength = [(NSMutableData *)[responseData objectForKey:connId] length];
		[delegate setProgressPercentage:(expectedLength == -1 ? loadedLength : floor(expectedLength*100/loadedLength))];
	}
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	NSString *connId = [NSString stringWithFormat:@"%0d" ,[connection hash]];
	[DebugUtils debugData:[responseData objectForKey:connId] toFile:@"response.txt"];
	[self endDownloadForConnection:connId withData:[responseData objectForKey:connId] orError:nil];
    
	[responseData removeObjectForKey:connId];
	[responseLength removeObjectForKey:connId];
	[connection release];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {	
	NSLog(@"WebServiceProxy connectionDidFailWithError:%@", [error localizedDescription]);
	NSString *connId = [NSString stringWithFormat:@"%0d" ,[connection hash]];	
	[responseData removeObjectForKey:connId];
	[responseLength removeObjectForKey:connId];	
	[connection release];
	
	[DebugUtils debugData:[[error localizedDescription] dataUsingEncoding:NSUTF8StringEncoding] toFile:@"response_error.txt"];		
	[self endDownloadForConnection:connId withData:nil orError:error];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
	NSString *connId = [NSString stringWithFormat:@"%0d" ,[connection hash]];	
	NSLog(@"SecurityProxy didReceiveAuthenticationChallenge for connection:%@", connId);
}

- (void)dealloc {
	[responseData release];
	[responseLength release];
	[super dealloc];
}

@end
