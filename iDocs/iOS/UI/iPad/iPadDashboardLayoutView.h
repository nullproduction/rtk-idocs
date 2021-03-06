//
//  iPadDashboardLayoutView.h
//  iDoc
//
//  Created by mark2 on 12/17/10.
//  Copyright 2010 KORUS Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iPadBaseLayoutView.h"
#import "HFSUILabel.h"

@interface iPadDashboardLayoutView : iPadBaseLayoutView <UIScrollViewDelegate> {
	UIImageView *companyLogoIcon;
	HFSUILabel *appTitleLabel;
	HFSUILabel *userTitleLabel;
    
    UIScrollView *contentScrollView;

    NSInteger currentPage;
}

@property(nonatomic, retain) HFSUILabel *userNameLabel;
@property(nonatomic, retain) UIImageView *userIcon;
@property(nonatomic, retain) HFSUIButton *backButton;
@property(nonatomic, retain) HFSUIButton *syncButton;
@property(nonatomic, retain) HFSUIButton *settingsButton;
@property(nonatomic, retain) HFSUILabel *syncButtonHint;
@property(nonatomic, retain) HFSUILabel *syncButtonValue;
@property(nonatomic, retain) UIPageControl *dashboardPager;

- (id)init;
- (void)clearContentPanel;
- (void)addContentPanel:(UIView *)contentPanelView;
- (void)setCurrentPage:(int)pageNum;
- (void) returnToEOffice;

@end
