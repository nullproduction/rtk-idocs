//
//  UIViewController+Alert.h
//  yeehay
//
//  Created by mark2 on 11/21/10.
//  Copyright 2010 HFS. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIViewController(Alert)

- (void)showAlertWithMessage:(NSString *)message andTitle:(NSString *)titleText;
- (void)reportServerError:(NSString *)message;
- (void)reportClientError:(NSString *)message;

@end
