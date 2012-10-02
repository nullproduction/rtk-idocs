//
//  iPadBaseViewController.m
//  iDoc
//
//  Created by mark2 on 12/17/10.
//  Copyright 2010 KORUS Consulting. All rights reserved.
//

#import "iPadBaseViewController.h"
#import "Constants.h"
#import "iPadThemeBuildHelper.h"

@implementation iPadBaseViewController

- (UIColor *)backgroundColor {
    return [UIColor clearColor]; //[UIColor colorWithPatternImage:[UIImage imageNamed:[iPadThemeBuildHelper nameForImage:@"background_tile.png"]]];
}

#pragma mark UIViewController methods
- (void)viewWillAppear:(BOOL)animated {
	self.navigationController.navigationBarHidden = YES;	
	self.view.backgroundColor = [self backgroundColor];
	[super viewWillAppear:animated];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return YES;
}


#pragma mark operations behavior
- (void)onOperationStart {
	[self block];
	self.navigationController.navigationItem.leftBarButtonItem.enabled = NO;
	self.navigationController.navigationItem.rightBarButtonItem.enabled = NO;		
}

- (void)onOperationEnd:(NSError *)error {
	[self unblock];
	if (error != nil) {
		[self reportClientError:[error localizedDescription]];
	} else {
		self.navigationController.navigationItem.leftBarButtonItem.enabled = YES;
		self.navigationController.navigationItem.rightBarButtonItem.enabled = YES;		
	}
}

#pragma mark other methods
- (void)didReceiveMemoryWarning {
	NSLog(@"iPadBaseViewController didReceiveMemoryWarning");		
    // Releases the iPadSearchFilter if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc. that aren't in use.
}

- (void)dealloc {
    [super dealloc];
}


@end
