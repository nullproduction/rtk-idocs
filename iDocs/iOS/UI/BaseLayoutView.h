//
//  BaseLayoutView.h
//  iDoc
//
//  Created by mark2 on 12/15/10.
//  Copyright 2010 KORUS Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFSUIButton.h"

@interface BaseLayoutView : UIView {
	//keyboard tracing
	float shrinkHeight;
	float offsetHeight;
	BOOL keyboardTracingInProcess;
}

- (UIView *)newViewWithTiledBackground:(NSString *)tileName;
- (BOOL)isInPortraitOrientation;

- (BOOL)traceKeyboard;
- (CGRect)tracedFrame;
- (void)processKeyboardShow;
- (void)processKeyboardHide;

@end