//
//  UIWebView+Block.m
//  iDoc
//
//  Created by Michael Syasko on 7/6/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import "UIWebView+Block.h"
#import <QuartzCore/QuartzCore.h>
#import "Constants.h"
#import "iPadThemeBuildHelper.h"

UIView *HFS_BLOCKER_VIEW;
BOOL HFS_ISBLOCKED_FLAG;
long long HFS_PROGRESSBAR_STOPPER;

@implementation UIWebView (Block)
- (UIView *)pickCurrentTopView {
    return self.superview;
}

- (void)block {
    
	if (HFS_ISBLOCKED_FLAG) return;
	
	HFS_PROGRESSBAR_STOPPER = 0;
	
	UIView *topView = [self pickCurrentTopView];
	
	HFS_BLOCKER_VIEW = [[UIView alloc] initWithFrame:self.frame];//CGRectMake(0.0f, 0.0f, 320.0f, 416.0f)];
	HFS_BLOCKER_VIEW.opaque = NO;
	HFS_BLOCKER_VIEW.userInteractionEnabled = YES;
	HFS_BLOCKER_VIEW.clipsToBounds = YES;
	HFS_BLOCKER_VIEW.backgroundColor = [iPadThemeBuildHelper activityIndicatorBackColor];
	HFS_BLOCKER_VIEW.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	HFS_BLOCKER_VIEW.tag = constActivityIndicatorView;
    HFS_BLOCKER_VIEW.layer.cornerRadius = 5.0f;
	
	UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] 
                                                  initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	activityIndicator.frame = CGRectMake(self.bounds.size.width/2-18.0f,
										 self.bounds.size.height/2-18.0f,
										 37.0f, 37.0f);//(141.0f, 192.0f, 37.0f, 37.0f);
	activityIndicator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
	[activityIndicator startAnimating];
	
	[HFS_BLOCKER_VIEW addSubview:activityIndicator];
	[activityIndicator release];
	[topView addSubview:HFS_BLOCKER_VIEW];
    
	HFS_ISBLOCKED_FLAG = YES;
	
	[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.001]];	
}

- (void)unlock {
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.001]];	

    if (!HFS_ISBLOCKED_FLAG) return;

    [HFS_BLOCKER_VIEW removeFromSuperview];
    HFS_BLOCKER_VIEW = nil;

    HFS_ISBLOCKED_FLAG = NO;
}

@end
