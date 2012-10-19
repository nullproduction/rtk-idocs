//
//  iPadResolutionPanelViewController.h
//  iDoc
//
//  Created by Olga Geets on 18.10.12.
//  Copyright (c) 2012 KORUS Consulting. All rights reserved.
//

#import "iPadBaseViewController.h"
#import "iPadResolutionViewController.h"
#import "iPadHeaderBodyFooterLayoutView.h"

@protocol iPadPopupLayoutViewDelegate;

@interface iPadResolutionPanelViewController : iPadBaseViewController {
    iPadHeaderBodyFooterLayoutView* container;
	UINavigationController* navController;
	iPadResolutionViewController* resolutionViewController;
}

@property (nonatomic, retain) iPadHeaderBodyFooterLayoutView *container;
@property (nonatomic, retain) UINavigationController *navController;
@property (nonatomic, retain) iPadResolutionViewController* resolutionViewController;

- (id)initWithFrame:(CGRect)frame;
- (void)setTitleForPopupPanelHeader:(NSString *)newTitle;

@end
