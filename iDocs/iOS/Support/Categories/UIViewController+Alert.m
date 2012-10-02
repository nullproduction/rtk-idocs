    //
//  UIViewController+Alert.m
//  yeehay
//
//  Created by mark2 on 11/21/10.
//  Copyright 2010 HFS. All rights reserved.
//

#import "UIViewController+Alert.h"


@implementation UIViewController(Alert)

- (void)showAlertWithMessage:(NSString *)message andTitle:(NSString *)titleText {
	UIAlertView *alertView = [UIAlertView new];
	alertView.delegate = self;
	alertView.title =  titleText;
	alertView.message = message;
	[alertView addButtonWithTitle:NSLocalizedString(@"OkButtonTitle", nil)];
	[alertView show];
	[alertView release];	
}

- (void)reportClientError:(NSString *)message {
	[self showAlertWithMessage:message andTitle:NSLocalizedString(@"ClientErrorAlertTitle", nil)];
}

- (void)reportServerError:(NSString *)message {
	[self showAlertWithMessage:message andTitle:NSLocalizedString(@"WSErrorAlertTitle", nil)];
}


@end
