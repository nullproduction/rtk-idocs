//
//  iPadResolutionPanelViewController.m
//  iDoc
//
//  Created by Olga Geets on 18.10.12.
//  Copyright (c) 2012 KORUS Consulting. All rights reserved.
//

#import "iPadResolutionPanelViewController.h"


@implementation iPadResolutionPanelViewController

@synthesize container, navController, resolutionViewController;

#pragma mark custom methods - panel visual init
- (id)initWithFrame:(CGRect)frame {
	NSLog(@"iPadResolutionPanel initWithFrame");
	if ((self = [super initWithNibName:nil bundle:nil])) {
		self.view.frame = frame;
		self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        if (self.resolutionViewController != nil) {
            self.resolutionViewController = nil;
        }
        iPadResolutionViewController *controller = [[iPadResolutionViewController alloc] initWithFrame:self.view.bounds];
        self.resolutionViewController = controller;
        [controller release];
        
        self.container = (iPadHeaderBodyFooterLayoutView *)resolutionViewController.view;
        
        if (self.navController != nil) {
            self.navController = nil;
        }
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:resolutionViewController];
        self.navController = navigationController;
        [navigationController release];
        navController.view.frame = self.view.bounds;
        navController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        navController.navigationBarHidden = YES;
        [self.view addSubview:navController.view];
	}
	return self;
}

#pragma mark custom methods - panel behavior

- (void)setTitleForPopupPanelHeader:(NSString *)newTitle {
	if (container != nil && [container isMemberOfClass:iPadHeaderBodyFooterLayoutView.class]) {
		[[container.headerPanel viewWithTag:constHeaderCenterTitleWithCaption] removeFromSuperview];
        UIColor *titleColor = [iPadThemeBuildHelper commonHeaderFontColor2];
        UIColor *shadowColor = [iPadThemeBuildHelper commonShadowColor2];
        [container.headerPanel addSubview:[container prepareHeaderCenterTitleWithCaption:NSLocalizedString(newTitle, nil)
                                                                            captionColor:titleColor
                                                                           captionShadow:shadowColor]];
	}    
}

#pragma mark other methods
- (void)didReceiveMemoryWarning {
	NSLog(@"iPadResolutionPanel didReceiveMemoryWarning");
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)dealloc {
    self.container = nil;
	self.resolutionViewController = nil;
	self.navController = nil;
    [super dealloc];
}


@end
