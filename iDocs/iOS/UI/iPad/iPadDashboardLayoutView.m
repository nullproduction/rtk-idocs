//
//  iPadDashboardLayoutView.m
//  iDoc
//
//  Created by mark2 on 12/17/10.
//  Copyright 2010 KORUS Consulting. All rights reserved.
//

#import "iPadDashboardLayoutView.h"
#import "Constants.h"
#import "SupportFunctions.h"
#import "iPadThemeBuildHelper.h"
#import "ClientSettingsDataEntity.h"
#import "CoreDataProxy.h"

#import <QuartzCore/QuartzCore.h>

@implementation iPadDashboardLayoutView
@synthesize userNameLabel;
@synthesize userIcon;
@synthesize backButton;
@synthesize syncButton;
@synthesize syncButtonHint;
@synthesize syncButtonValue;
@synthesize settingsButton;
@synthesize dashboardPager;

- (id)init {
	NSLog(@"iPadDashboardLayoutView init");
	if ((self = [super init])) {
        currentPage = 0;
        
        NSString *applicationTitle = [SupportFunctions addQuatationMarksToString:NSLocalizedString(@"ApplicationTitle", nil)];
          
		appTitleLabel = [HFSUILabel labelWithFrame:CGRectZero 
                                           forText:applicationTitle
                                         withColor:[iPadThemeBuildHelper infoTextFontColor1]
                                         andShadow:[iPadThemeBuildHelper commonShadowColor1]
                                          fontSize:constXLargeFontSize];
        appTitleLabel.autoresizingMask = UIViewAutoresizingNone;
		[self addSubview:appTitleLabel];
             
        UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[iPadThemeBuildHelper nameForImage:@"icon_user.png"]]];
		self.userIcon = icon;
        [icon release];
        self.userIcon.contentMode = UIViewContentModeCenter;
		self.userIcon.autoresizingMask = UIViewAutoresizingNone;
		[self addSubview:self.userIcon];
        
		NSString *userTitle = [NSString stringWithFormat:@"%@:", NSLocalizedString(@"UserTitle", nil)];
		userTitleLabel = [HFSUILabel labelWithFrame:CGRectZero 
                                            forText:userTitle
                                          withColor:[iPadThemeBuildHelper commonTextFontColor5]
                                          andShadow:nil
                                           fontSize:constSmallFontSize];
        userTitleLabel.autoresizingMask = UIViewAutoresizingNone;
		[self addSubview:userTitleLabel];
		
		self.userNameLabel = [HFSUILabel labelWithFrame:CGRectZero 
                                                forText:nil
                                              withColor:[iPadThemeBuildHelper commonTextFontColor5]
                                              andShadow:nil
                                               fontSize:constSmallFontSize];
        self.userNameLabel.autoresizingMask = UIViewAutoresizingNone;
		[self addSubview:self.userNameLabel];

        companyLogoIcon = [[UIImageView alloc] init];
        companyLogoIcon.autoresizingMask = UIViewAutoresizingNone;
        [self addSubview:companyLogoIcon];
        
        //add home button for eoffice
        
        HFSUIButton *eofficeHome = [HFSUIButton prepareButtonWithBackImage:[iPadThemeBuildHelper nameForImage:@"icon_home.png"] 
                                                                   caption:nil 
                                                              captionColor:nil
                                                        captionShadowColor:nil
                                                                      icon:nil];
        [eofficeHome setFrame:CGRectMake(10.0f, 12.0f, 41.0f, 42.0f)];
        [eofficeHome addTarget:self action:@selector(returnToEOffice) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:eofficeHome];
        
        
        self.backButton = [HFSUIButton prepareButtonWithBackImage:[iPadThemeBuildHelper nameForImage:@"icon_home.png"] 
                                                          caption:nil 
                                                     captionColor:nil
                                               captionShadowColor:nil
                                                             icon:nil];
        self.backButton.hidden = YES;
        [self addSubview:self.backButton];
        
        self.syncButton = [HFSUIButton prepareButtonWithBackImageForNormalState:[iPadThemeBuildHelper nameForImage:@"sync_button.png"] 
                                                      backImageForSelectedState:[iPadThemeBuildHelper nameForImage:@"sync_button.png"]]; 
        self.syncButton.hidden = YES;
        [self addSubview:self.syncButton];

        self.syncButtonHint = [HFSUILabel labelWithFrame:CGRectZero
                                                 forText:NSLocalizedString(@"SyncButtonHint", nil)
                                               withColor:[iPadThemeBuildHelper commonTextFontColor5]
                                               andShadow:nil
                                                fontSize:constSmallFontSize];
        self.syncButtonHint.autoresizingMask = UIViewAutoresizingNone;
        self.syncButtonHint.hidden = YES;
        [self addSubview:self.syncButtonHint];
 
        self.syncButtonValue = [HFSUILabel labelWithFrame:CGRectZero
                                                  forText:constEmptyStringValue
                                                withColor:[iPadThemeBuildHelper commonTextFontColor5]
                                                andShadow:nil
                                                 fontSize:constSmallFontSize];
        self.syncButtonValue.autoresizingMask = UIViewAutoresizingNone;
        self.syncButtonValue.hidden = YES;
        [self addSubview:self.syncButtonValue];
        
        self.settingsButton = [HFSUIButton prepareButtonWithBackImageForNormalState:[iPadThemeBuildHelper nameForImage:@"tools_btn.png"] 
                                                      backImageForSelectedState:[iPadThemeBuildHelper nameForImage:@"tools_btn.png"]]; 
        self.settingsButton.hidden = YES;
        [self addSubview:self.settingsButton];

        contentScrollView = [[UIScrollView alloc] initWithFrame:contentBodyPanel.bounds];
        contentScrollView.showsHorizontalScrollIndicator = NO;
        contentScrollView.showsVerticalScrollIndicator = NO;
        contentScrollView.pagingEnabled = YES;
        contentScrollView.delegate = self;
        [contentBodyPanel addSubview:contentScrollView];
        
        UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:contentPanelBack.bounds];
        self.dashboardPager = pageControl;
        [pageControl release];
        self.dashboardPager.userInteractionEnabled = NO;
        [contentPanelBack addSubview:self.dashboardPager];
	}
	return self;
}

- (void) returnToEOffice
{
    NSURL *ourURL = [NSURL URLWithString:@"eoffice://"];
    
    if  ([[UIApplication sharedApplication] canOpenURL:ourURL]) 
    {
        [[UIApplication sharedApplication] openURL:ourURL];
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Приложение не найдено!" message:@"Вызываемое вами приложение не найдено на усройстве." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)clearContentPanel {
    for (UIView *subview in contentScrollView.subviews) {
        [subview removeFromSuperview];
    }
}

- (void)addContentPanel:(UIView *)contentPanelView {
    contentPanelView.hidden = YES;
    [contentScrollView addSubview:contentPanelView];
    [contentPanel bringSubviewToFront:contentBodyPanel];
}

- (void)setCurrentPage:(int)pageNum {
    currentPage = (pageNum >=0 ? pageNum : 0);
}

- (void)layoutSubviews {
	NSLog(@"iPadDashboardLayoutView layoutSubviews");
	[super layoutSubviews];
	
	CGRect appTitleLabelFrame;
	CGRect userIconFrame;
	CGRect userTitleLabelFrame;
	CGRect userNameLabelFrame;
    CGRect companyLogoIconFrame;    
    CGRect backButtonFrame;
    CGRect syncButtonFrame;
    CGRect syncHintFrame;
    CGRect syncValueFrame;
    CGRect settingsButtonFrame;
    
    contentScrollView.frame = contentBodyPanel.bounds;
    float offset = 0.0f;
    int subviewsCount = [contentScrollView.subviews count];
    
    for (UIView *subview in contentScrollView.subviews) {
        subview.frame = CGRectOffset(contentBodyPanel.bounds, offset, 0);
        subview.hidden = NO;
        offset+=contentBodyPanel.bounds.size.width; 
        
    }
    contentScrollView.contentSize = CGSizeMake(offset, contentBodyPanel.bounds.size.height);
    
    if (subviewsCount > 1) {
        self.dashboardPager.hidden = NO;
        self.dashboardPager.frame = CGRectInset(CGRectMake(0, contentPanelBack.bounds.size.height-80, contentPanelBack.bounds.size.width, 80), 250, 5);
        self.dashboardPager.numberOfPages = subviewsCount;
    } 
    else {
        self.dashboardPager.hidden = YES;
    }

    ClientSettingsDataEntity *settingsEntity = [[ClientSettingsDataEntity alloc] initWithContext:[[CoreDataProxy sharedProxy] workContext]];
    if ([self isInPortraitOrientation]) {
        companyLogoIcon.image = [UIImage imageNamed:[iPadThemeBuildHelper nameForImage:[settingsEntity logoIcon]]];		
        companyLogoIconFrame = CGRectMake(10.0f, 12.0f, 41.0f, 42.0f);		
    }
    else {
        companyLogoIcon.image = [UIImage imageNamed:[iPadThemeBuildHelper nameForImage:[settingsEntity logoIconWithName]]];		
        companyLogoIconFrame = CGRectMake(10.0f, 12.0f, 189.0f, 42.0f);		
    }
    companyLogoIcon.frame = companyLogoIconFrame;
    [settingsEntity release];    
    
    CGSize size = [appTitleLabel.text sizeWithFont:[UIFont boldSystemFontOfSize:constXLargeFontSize]];
    appTitleLabelFrame = CGRectMake(CGRectGetMidX(self.frame) - size.width/2, 15.0f, size.width, size.height);
    appTitleLabel.frame = appTitleLabelFrame;
      
    backButtonFrame = CGRectMake(10.0f, 12.0f, 41.0f, 42.0f);
    self.backButton.frame = backButtonFrame;
    
    settingsButtonFrame = CGRectMake(12.0f, self.frame.size.height - 49.0f, 41.0f, 42.0f);
    self.settingsButton.frame = settingsButtonFrame;

    syncButtonFrame = CGRectMake(56.0f, self.frame.size.height - 49.0f, 41.0f, 42.0f);
    self.syncButton.frame = syncButtonFrame;
    syncHintFrame = CGRectMake(100.0f, self.frame.size.height - 47.0f, 157.0f, 21.0f);
    self.syncButtonHint.frame = syncHintFrame;
    syncValueFrame = CGRectMake(100.0f, self.frame.size.height - 30.0f, 157.0f, 21.0f);
    self.syncButtonValue.frame = syncValueFrame;
    
	userIconFrame = CGRectMake(self.frame.size.width - 197.0f, self.frame.size.height - 47.0f, 27.0f, 36.0f);
    self.userIcon.frame = userIconFrame;
    userTitleLabelFrame = CGRectMake(self.frame.size.width - 160.0f, self.frame.size.height - 47.0f, 157.0f, 21.0f);
    userTitleLabel.frame = userTitleLabelFrame;        
    userNameLabelFrame = CGRectMake(self.frame.size.width - 160.0f, self.frame.size.height - 30.0f, 157.0f, 21.0f);
    self.userNameLabel.frame = userNameLabelFrame;
            
    [contentScrollView setContentOffset:CGPointMake((contentBodyPanel.bounds.size.width * currentPage), 0.0f) animated:NO];  
}

#pragma mark UIScrollViewDelegate methods:
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.dashboardPager.frame.size.width;
    int page = floor((contentScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.dashboardPager.currentPage = page;
}

- (void)dealloc {    
    [companyLogoIcon release];
    [contentScrollView release];
 
    self.userNameLabel = nil;
	self.userIcon = nil;
    self.backButton = nil;
    self.syncButton = nil;
    self.settingsButton = nil;
    self.syncButtonHint = nil;
    self.syncButtonValue = nil;
    self.dashboardPager = nil;

    [super dealloc];
}


@end
