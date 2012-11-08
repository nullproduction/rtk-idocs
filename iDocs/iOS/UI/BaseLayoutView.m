//
//  BaseLayoutView.m
//  iDoc
//
//  Created by mark2 on 12/15/10.
//  Copyright 2010 KORUS Consulting. All rights reserved.
//

#import "BaseLayoutView.h"
#import "Constants.h"
#import "iPadThemeBuildHelper.h"

@interface BaseLayoutView (PrivateMethods)
- (CGRect)convertRect:(CGRect)rect;
@end

@implementation BaseLayoutView

- (id)init {
	if ((self = [super init])) {
		offsetHeight = 0;
		shrinkHeight = 0;
		if ([self traceKeyboard]) {
			[[NSNotificationCenter defaultCenter] addObserver:self 
                                                     selector:@selector(keyboardWillShow:) 
                                                         name:UIKeyboardWillShowNotification 
                                                       object:nil];
			[[NSNotificationCenter defaultCenter] addObserver:self 
                                                     selector:@selector(keyboardDidHide:) 
                                                         name:UIKeyboardDidHideNotification 
                                                       object:nil];
		}
	}	
	return self;
}

#pragma mark helper functions
- (UIView *)newViewWithTiledBackground:(NSString *)tileName {
	UIView *newView = [[UIView alloc] init];
	newView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:tileName]];
	[newView setOpaque:NO];
	return newView;
}

- (BOOL)isInPortraitOrientation {
	BOOL deviceIsPad = (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPhone);
	float comparedWidth = (deviceIsPad) ? 800.0f : 400.0f; //greater than regular portrait width of ipad | iphone
	return (self.frame.size.width < comparedWidth) ? YES : NO;
}

#pragma mark keyboard trace methods
- (CGRect)convertRect:(CGRect)rect { 
	/*  when keyboard show notification fired, it's notification info contains window-based frames 
	 *  wich are in window coordinates and not aware of screen orientation. 
	 *  this method mostly used with this case handling
	 */
    UIWindow *window = [self isKindOfClass:[UIWindow class]] ? (UIWindow *) self : [self window];
    return [self convertRect:[window convertRect:rect fromWindow:nil] fromView:nil];
}

- (void)keyboardWillShow:(NSNotification *)note {
	NSLog(@"keyboardWillShow");
	offsetHeight = 0;
	shrinkHeight = 0;
    CGRect keyboardEndFrame, frameToTrace, keyboardCollision;
	[[[note userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
	
	keyboardEndFrame = [self convertRect:keyboardEndFrame];
	frameToTrace = [self tracedFrame];
	keyboardCollision = CGRectIntersection(frameToTrace, keyboardEndFrame);
	
	if(!CGRectIsNull(keyboardCollision)) {
		offsetHeight = -keyboardCollision.size.height;
		shrinkHeight = frameToTrace.origin.y-keyboardCollision.size.height;
		if (shrinkHeight < 0.0f) { /* view needs to be shrinked after move */
			offsetHeight = -frameToTrace.origin.y + 10;
			shrinkHeight = shrinkHeight - 10;
		} 
		else{
			shrinkHeight = 0;
		}
		[self processKeyboardShow];
	}
}

- (void)keyboardDidHide:(NSNotification*)note {
	NSLog(@"keyboardDidHide");
	offsetHeight = 0;
	shrinkHeight = 0;
	[self processKeyboardHide];
}

- (BOOL)traceKeyboard { /* override point to turn on|off keyboard show|hide notification handling */
	return NO;
}

- (CGRect)tracedFrame { /* override point to get frame to be traced after keyboard */
	return CGRectZero;
}

- (void)processKeyboardShow { /* override point to handle keyboard show event: endFrame is keyboard's frame to accomodate to */
	[self setNeedsLayout];
}

- (void)processKeyboardHide { /* override point to handle keyboard hide event */
	[self setNeedsLayout];
}

#pragma mark system methods
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    [super dealloc];
}
@end
