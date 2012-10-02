//
//  BaseWSLoader.h
//  iDoc
//
//  Created by rednekis on 5/9/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseLoader.h"
#import "WebServiceProxy.h"
#import "WebServiceRequests.h"

@interface BaseWSLoader : BaseLoader <WebServiceProxyDelegate> {  
	WebServiceProxy *wsProxy;
}

- (NSString *)startDataDownloading:(NSDictionary *)requestData;
- (void)webServiceProxyConnection:(NSString *)connectionId finishedDownloadingWithData:(NSMutableData *)data orError:(NSError *)error;
@end
