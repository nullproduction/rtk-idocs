//
//  iPadErrandPanelViewController.m
//  iDoc
//
//  Created by rednekis on 10-12-17.
//  Copyright 2010 KORUS Consulting. All rights reserved.
//

#import "iPadErrandPanelViewController.h"
#import "Constants.h"
#import "iPadThemeBuildHelper.h"

@interface iPadErrandPanelViewController(PrivateMethods)
- (void)loadErrand:(DocErrand *)errandData withTaskAction:(ActionToSync *)actionData orTaskId:(NSString *)taskId usingMode:(int)mode;
@end

@implementation iPadErrandPanelViewController

@synthesize container, errandNavigationController, errandViewController;

#pragma mark custom methods - panel visual init
- (id)initWithFrame:(CGRect)frame {
	NSLog(@"iPadErrandReport initWithFrame");	
	if ((self = [super initWithNibName:nil bundle:nil])) {
		self.view.frame = frame;
		self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	}
	return self;
}
	
#pragma mark custom methods - load data
- (void)setPopupAuxPanel:(id<iPadPopupLayoutViewDelegate>)auxPanel {
    [errandViewController setPopupAuxPanel:auxPanel];
}

- (void)showErrand:(DocErrand *)errandData forTaskWithId:(NSString *)taskId usingMode:(int)mode {
    [self loadErrand:errandData withTaskAction:nil orTaskId:taskId usingMode:mode];
}

- (void)createErrand:(DocErrand *)errandData forTaskAction:(ActionToSync *)actionData {
    [self loadErrand:errandData withTaskAction:actionData orTaskId:nil usingMode:constModeCreate];
}

- (void)loadErrand:(DocErrand *)errandData withTaskAction:(ActionToSync *)actionData orTaskId:(NSString *)taskId usingMode:(int)mode {
	NSLog(@"iPadErrandPanel loadErrand");
    if (self.errandViewController != nil) {
        self.errandViewController = nil;
    }
    iPadErrandViewController *errandController = [[iPadErrandViewController alloc] initWithFrame:self.view.bounds];
    self.errandViewController = errandController;
    [errandController release];
    [errandViewController setDelegate:self];
	[errandViewController prepareDataForErrand:errandData withTaskAction:actionData orTaskId:taskId usingMode:mode];
    
	self.container = (iPadHeaderBodyFooterLayoutView *)errandViewController.view;
    
    if (self.errandNavigationController != nil) {
        self.errandNavigationController = nil;
    }
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:errandViewController];
    self.errandNavigationController = navController;
    [navController release];
    errandNavigationController.view.frame = self.view.bounds;
    errandNavigationController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    errandNavigationController.navigationBarHidden = YES;
    [self.view addSubview:errandNavigationController.view];	
}

#pragma mark custom methods - panel behavior
- (void)setDelegate:(id<iPadErrandPanelViewControllerDelegate>) newDelegate {
	delegate = newDelegate;
}

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

#pragma mark custom methods - delegate implementation methods
- (void)errandViewCloseButtonPressed {
	NSLog(@"iPadErrandPanel errandViewCloseButtonPressed");
	if (delegate != nil && [delegate respondsToSelector:@selector(errandViewCloseButtonPressed)]) {
		[delegate errandViewCloseButtonPressed];
	}	
}

- (void)deleteErrandActionButtonPressed {
	NSLog(@"iPadErrandPanel deleteErrandActionButtonPressed");
	if (delegate != nil && [delegate respondsToSelector:@selector(deleteErrandActionButtonPressed)]) {
		[delegate deleteErrandActionButtonPressed];
	}	
}

- (void)submitErrandCreateActionsToServer:(NSArray *)actions {
	NSLog(@"iPadErrandPanel submitErrandCreateActionsToServer");
	if (delegate != nil && [delegate respondsToSelector:@selector(submitErrandCreateActionsToServer:)]) {
		[delegate submitErrandCreateActionsToServer:actions];
	}	
}

- (void)submitErrandWorkflowActionToServer:(ActionToSync *)action {
	NSLog(@"iPadErrandPanel submitErrandWorkflowActionToServer");
	if (delegate != nil && [delegate respondsToSelector:@selector(submitErrandWorkflowActionToServer:)]) {
		[delegate submitErrandWorkflowActionToServer:action];
	}    
}


#pragma mark other methods
- (void)didReceiveMemoryWarning {
	NSLog(@"iPadErrandPanel didReceiveMemoryWarning");		
    // Releases the iPadSearchFilter if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	self.errandViewController = nil;
	self.errandNavigationController = nil;

    if (self.container != nil)
        self.container = nil;
    
//    [self setDelegate:nil];
    
    [super dealloc];
}


@end
