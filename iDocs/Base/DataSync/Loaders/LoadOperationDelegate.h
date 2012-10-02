//
//  LoadOperationDelegate.h
//  iDoc
//
//  Created by rednekis on 05/10/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

@protocol LoadOperationDelegate <NSObject>
- (void)reportOperationError:(NSArray *)errorInfo;
- (void)operationFinished;
@optional
- (void)mergeOperationContextChangesWithMainContext:(NSNotification *)notification;
@end