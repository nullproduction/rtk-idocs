//
//  iPadAppSettingsPanelViewController.m
//  iDoc
//
//  Created by rednekis on 10-12-17.
//  Copyright 2010 KORUS Consulting. All rights reserved.
//

#import "iPadAppSettingsPanelViewController.h"
#import "Constants.h"
#import "iPadThemeBuildHelper.h"


@implementation iPadAppSettingsPanelViewController

@synthesize appSettingsViewController, navController;

#pragma mark custom methods - panel visual init
- (id)initWithFrame:(CGRect)frame {
	NSLog(@"iPadAppSettingsPanelViewController initWithFrame");	
	if ((self = [super initWithNibName:nil bundle:nil])) {
		iPadHeaderBodyFooterLayoutView *container = [[iPadHeaderBodyFooterLayoutView alloc] init];
		container.showFooter = NO;
		container.frame = frame;

		CGRect settingsViewFrame = container.bodyPanel.bounds;
        iPadAppSettingsViewController *settingsController = [[iPadAppSettingsViewController alloc] initAppSettingsDelegate:self];
        self.appSettingsViewController = settingsController;
        [settingsController release];
        appSettingsViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:appSettingsViewController];
        self.navController = navigationController;
        [navigationController release];
        navController.view.frame = settingsViewFrame;
        navController.delegate = appSettingsViewController;
		navController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        navController.navigationBarHidden = YES;
		[container.bodyPanel addSubview:navController.view];
    
        UIColor *buttonColor = [iPadThemeBuildHelper commonButtonFontColor2];
        UIColor *shadowColor = [iPadThemeBuildHelper commonShadowColor2];         
        
		UIButton *doneButton = [container prepareHeaderRightButtonWithCaption:@"DoneButtonTitle" 
                                                                  captionColor:buttonColor 
                                                                 captionShadow:shadowColor
                                                                    imageOrNil:nil];
		[doneButton addTarget:self action:@selector(closePanel) forControlEvents:UIControlEventTouchUpInside];
		[container.headerPanel addSubview:doneButton];
		
		backButton = [container prepareHeaderLeftButtonWithCaption:@"BackButtonTitle" 
                                                      captionColor:buttonColor 
                                                     captionShadow:shadowColor
                                                        imageOrNil:nil];
		[backButton addTarget:self action:@selector(navigateBack) forControlEvents:UIControlEventTouchUpInside];
        backButton.hidden = YES;
		[container.headerPanel addSubview:backButton];
        
        UIColor *titleColor = [iPadThemeBuildHelper commonHeaderFontColor2]; 
        HFSUILabel *settingsTitle = [container prepareHeaderCenterTitleWithCaption:NSLocalizedString(@"SettingsTitle", nil) 
                                                                      captionColor:titleColor
                                                                     captionShadow:shadowColor];
        settingsTitle.font = [UIFont boldSystemFontOfSize:constXXLargeFontSize];
        [container.headerPanel addSubview:settingsTitle];
		self.view = container;
		[container release];        
	}
	return self;
}


#pragma mark custom methods - panel behavior
- (void)setDelegate:(id<iPadAppSettingsPanelViewControllerDelegate>)newDelegate {
	delegate = newDelegate;
}

- (void)showBackButton {
    backButton.hidden = NO;
}

- (void)navigateBack {
    backButton.hidden = YES;
    [navController popViewControllerAnimated:YES];
}

- (void)closePanel {
    if ([appSettingsViewController checkIfAllRequiredFieldsAreFilled] 
       && delegate != nil 
       &&[delegate respondsToSelector:@selector(appSettingsPanelCloseButtonPressed)]) {
        [appSettingsViewController synchronizeSettings];
		[delegate appSettingsPanelCloseButtonPressed];
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
}

- (void)dealloc {
	self.appSettingsViewController = nil;    
    self.navController = nil;
    [super dealloc];
}


@end
