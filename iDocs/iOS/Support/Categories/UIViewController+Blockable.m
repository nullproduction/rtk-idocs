//
//  BlockableViewController.m
//  iDoc
//
//  Created by mark2 on 8/19/10.
//  Copyright 2010 HFS. All rights reserved.
//

#import "UIViewController+Blockable.h"
#import <QuartzCore/QuartzCore.h>
#import "Constants.h"
#import "iPadThemeBuildHelper.h"

UIView *HFS_BLOCKER_VIEW;
UIView *HFS_PROGRESSBAR_VIEW;
BOOL HFS_ISBLOCKED_FLAG;
long long HFS_PROGRESSBAR_STOPPER;

@interface UIViewController(PrivateMethods)
- (UIView *)pickCurrentTopView;
@end

@implementation UIViewController(Blockable)

- (UIView *)pickCurrentTopView {
	UIWindow *activeAppWindow = [UIApplication sharedApplication].keyWindow;
	UIView *topView = ((UINavigationController *)activeAppWindow.rootViewController).topViewController.view;
	return topView != nil ? topView : activeAppWindow;
}

- (void)block {

	if (HFS_ISBLOCKED_FLAG) return;
	
	HFS_PROGRESSBAR_STOPPER = 0;
	
	UIView *topView = [self pickCurrentTopView];
	
	//init activityIndicatorView
	HFS_BLOCKER_VIEW = [[UIView alloc] initWithFrame:topView.frame];
	HFS_BLOCKER_VIEW.opaque = NO;
	HFS_BLOCKER_VIEW.userInteractionEnabled = YES;
	HFS_BLOCKER_VIEW.clipsToBounds = YES;
	HFS_BLOCKER_VIEW.backgroundColor = [iPadThemeBuildHelper activityIndicatorBackColor];
	HFS_BLOCKER_VIEW.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	HFS_BLOCKER_VIEW.tag = constActivityIndicatorView;
	
	UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] 
								initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	activityIndicator.frame = CGRectMake(topView.frame.size.width/2-18.0f,
										 topView.frame.size.height/2-18.0f,
										 37.0f, 37.0f);
	activityIndicator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
	[activityIndicator startAnimating];
	
	[HFS_BLOCKER_VIEW addSubview:activityIndicator];
	[activityIndicator release];
    
	[topView addSubview:HFS_BLOCKER_VIEW];

	HFS_ISBLOCKED_FLAG = YES;
	
	[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.001]];	
}

- (void)unblock {
	[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.001]];	
	
	if (!HFS_ISBLOCKED_FLAG) return;

	[HFS_BLOCKER_VIEW removeFromSuperview];
	HFS_BLOCKER_VIEW = nil;
	
	if (HFS_PROGRESSBAR_VIEW != nil) {
		[HFS_PROGRESSBAR_VIEW removeFromSuperview];
		HFS_PROGRESSBAR_VIEW = nil;
	}
	
	HFS_ISBLOCKED_FLAG = NO;
}

- (void)setProgressMessage:(NSString *)message {
	if (!HFS_ISBLOCKED_FLAG) return;

	HFS_PROGRESSBAR_STOPPER++;
	BOOL debug = NO;
	NSTimeInterval delay = debug ? 1 : 0.001;
	if (debug || HFS_PROGRESSBAR_STOPPER == 1 || HFS_PROGRESSBAR_STOPPER%77 == 0) {
		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:delay]];	
	}

	if (HFS_PROGRESSBAR_VIEW == nil) {
		HFS_PROGRESSBAR_VIEW = 
            [[[UIView alloc] initWithFrame:CGRectMake(HFS_BLOCKER_VIEW.bounds.size.width/2-150.0f, HFS_BLOCKER_VIEW.bounds.size.height/2-150.0f, 300.0f, 240.0f)] autorelease];
		HFS_PROGRESSBAR_VIEW.tag = constProgressBarView;
		HFS_PROGRESSBAR_VIEW.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		[HFS_BLOCKER_VIEW addSubview:HFS_PROGRESSBAR_VIEW];
		
		CGRect top, bottom;
		CGRectDivide(HFS_PROGRESSBAR_VIEW.bounds, &top, &bottom, 180.0f, CGRectMinYEdge);
		
		UILabel *percentLabel = [[UILabel alloc] initWithFrame:bottom];
		percentLabel.textAlignment = UITextAlignmentCenter;
		percentLabel.font = [UIFont systemFontOfSize:constMediumFontSize];
		percentLabel.backgroundColor = [iPadThemeBuildHelper progressBarBackColor];
		percentLabel.textColor = [iPadThemeBuildHelper commonTextFontColor1];
		percentLabel.layer.cornerRadius = 5.0f;
        percentLabel.text = message;
		[HFS_PROGRESSBAR_VIEW addSubview:percentLabel];
        [percentLabel release];
	}
    else {
        UILabel *percentLabel = [[HFS_PROGRESSBAR_VIEW subviews] objectAtIndex:0];
        percentLabel.text = message;
    }
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:.001]];
}

@end
