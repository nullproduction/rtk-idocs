//
//  WebServiceProxy.h
//
//  Created by Dmitry Likhachev on 06/15/10.
//  Copyright HFS 2010. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DebugUtils.h"

@class WebServiceProxy;
@protocol WebServiceProxyDelegate <NSObject>
- (void)webServiceProxyConnection:(NSString *)connectionId finishedDownloadingWithData:(NSMutableData *)data orError:(NSError *)error;
@optional
- (void)onRequestNewCredentials:(WebServiceProxy *)proxy;
- (void)setProgressPercentage:(long long)percent;
@end


@interface WebServiceProxy : NSObject {
	NSMutableDictionary *responseData;
	NSMutableDictionary *responseLength;
	id<WebServiceProxyDelegate> delegate;
}

- (void)setDelegate:(id<WebServiceProxyDelegate>)newDelegate;
- (NSString *)getServerDataForRequest:(NSDictionary *)requestData;

@end