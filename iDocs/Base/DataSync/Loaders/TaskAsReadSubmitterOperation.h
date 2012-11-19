//
//  TaskAsReadSubmitterOperation.h
//  iDoc
//
//  Created by Olga Geets on 15.11.12.
//  Copyright (c) 2012 KORUS Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TaskAsReadSubmitter.h"

@interface TaskAsReadSubmitterOperation : NSOperation {
	NSThread * parentThread;
    NSObject<BaseLoaderDelegate> *delegate;
    
    BOOL executing;
    BOOL finished;
}

- (id)initWithLoaderDelegate:(NSObject<BaseLoaderDelegate> *)newDelegate;

@end
