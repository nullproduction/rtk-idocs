//
//  BaseLoaderDelegate.h
//  iDoc
//
//  Created by mark2 on 1/29/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

@protocol BaseLoaderDelegate <NSObject>
@optional
- (BOOL)isAbortSyncRequested;
- (void)actionsSubmitFinished;
@end