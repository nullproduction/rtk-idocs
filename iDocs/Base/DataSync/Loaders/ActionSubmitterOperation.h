//
//  ActionSubmitterOperation.h
//  iDoc
//
//  Created by mmakankov on 14.02.12.
//  Copyright (c) 2012 KORUS Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ActionsSubmitter.h"

//Используется для непосредственной отправки действий
@interface ActionSubmitterOperation : NSOperation {
	NSThread * parentThread;
    NSObject<BaseLoaderDelegate> *delegate;
    
    BOOL executing;
    BOOL finished;
}

- (id)initWithLoaderDelegate:(NSObject<BaseLoaderDelegate> *)newDelegate;

@end
