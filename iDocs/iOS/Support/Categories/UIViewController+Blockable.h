//
//  BlockableViewController.h
//  yeehay
//
//  Created by mark2 on 8/19/10.
//  Copyright 2010 HFS. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIViewController (Blockable) 

- (void)block;
- (void)unblock;
- (void)setProgressMessage:(NSString *)message;

@end
