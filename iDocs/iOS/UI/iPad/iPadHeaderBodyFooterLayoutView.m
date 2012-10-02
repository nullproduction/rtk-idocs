//
//  iPadHeaderBodyFooterLayoutView.m
//  iDoc
//
//  Created by mark2 on 12/24/10.
//  Copyright 2010 KORUS Consulting. All rights reserved.
//

#import "iPadHeaderBodyFooterLayoutView.h"
#import "Constants.h"
#import "iPadThemeBuildHelper.h"

typedef enum {
	HFSLeft,
	HFSCenter,
	HFSRight,
	HFSTop,
	HFSBottom
} HFSAlignControl;

@interface iPadHeaderBodyFooterLayoutView(PrivateMethods)
- (HFSUIButton *)preparePanelButtonWithCaption:(NSString *)caption andColor:(UIColor *)color imageOrNil:(NSString *)imageName position:(HFSAlignControl)leftCenterRight panel:(HFSAlignControl)headerFooter;
@end


@implementation iPadHeaderBodyFooterLayoutView

@synthesize headerPanel, bodyPanel, footerPanel, showHeader, showFooter;

- (id)init {
	if ((self = [super init])) {
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		showHeader = YES;
		showFooter = YES;
		
		bodyBack = [[iPadPanelBodyBackgroundView alloc] initWithPrefix:@"modal_popup_background" suffix:@"_body" tileSize:60.0f];
        [self addSubview:bodyBack];

		headerPanel = [[UIView alloc] init];
		headerPanel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
		[self addSubview:headerPanel];
		
		bodyPanel = [[UIView alloc] init];
		bodyPanel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[self addSubview:bodyPanel];
		
		footerPanel = [[UIView alloc] init];
		footerPanel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
		[self addSubview:footerPanel];
		
	}
	return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	float headerHeight = showHeader ? 63.0f : 0.0f;
	float footerHeight = showFooter ? 71.0f : 0.0f;
	float marginSize = 15.0f;
	
	headerPanel.frame = CGRectMake(0.0f, 0.0f, self.bounds.size.width, headerHeight);
	
	CGRect bodyFrame = CGRectMake(marginSize, headerHeight, self.bounds.size.width - marginSize * 2, self.bounds.size.height - marginSize - headerHeight - footerHeight);
	bodyBack.frame = bodyFrame;
	bodyPanel.frame = CGRectInset(bodyFrame, 5.0f, 5.0f);
	
	footerPanel.frame = CGRectMake(0.0f, headerHeight + bodyFrame.size.height, self.bounds.size.width, footerHeight);
}

- (HFSUIButton *)preparePanelButtonWithCaption:(NSString *)caption 
                                  captionColor:(UIColor *)color 
                                 captionShadow:(UIColor *)shadow 
                                    imageOrNil:(NSString *)imageName 
                                      position:(HFSAlignControl)leftCenterRight 
                                         panel:(HFSAlignControl)headerFooter {
	CGRect panelBounds = (headerFooter == HFSTop ? headerPanel.bounds : footerPanel.bounds);
    imageName = [iPadThemeBuildHelper nameForImage:(imageName == nil ? @"modal_popup_button.png" : imageName)];
	HFSUIButton *newButton = [HFSUIButton prepareButtonWithBackImage:imageName 
                                                             caption:caption 
                                                        captionColor:color
                                                  captionShadowColor:shadow
                                                                icon:nil];
    newButton.buttonTitle.textAlignment = UITextAlignmentCenter;
	newButton.buttonTitle.font = [UIFont boldSystemFontOfSize:constLargeFontSize];
	newButton.frame = (leftCenterRight == HFSLeft ? CGRectMake(10, (headerFooter == HFSTop ? 10 : 15), 150, 45) :
					   leftCenterRight == HFSCenter ? CGRectMake(panelBounds.size.width/2-75, 15, 150, 45) :
					   CGRectMake(panelBounds.size.width-10-150, (headerFooter == HFSTop ? 10 : 15), 150, 45));
	newButton.autoresizingMask = (leftCenterRight == HFSLeft ? UIViewAutoresizingFlexibleRightMargin : 
								  leftCenterRight == HFSCenter ? UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin :
								  UIViewAutoresizingFlexibleLeftMargin);
	return newButton;
}

- (HFSUIButton *)prepareHeaderLeftButtonWithCaption:(NSString *)caption 
                                       captionColor:(UIColor *)color 
                                      captionShadow:(UIColor *)shadow 
                                         imageOrNil:(NSString *)imageName {
	return [self preparePanelButtonWithCaption:caption captionColor:color captionShadow:shadow imageOrNil:imageName position:HFSLeft panel:HFSTop];
}

- (HFSUIButton *)prepareHeaderRightButtonWithCaption:(NSString *)caption 
                                        captionColor:(UIColor *)color 
                                       captionShadow:(UIColor *)shadow 
                                          imageOrNil:(NSString *)imageName {
	return [self preparePanelButtonWithCaption:caption captionColor:color captionShadow:shadow imageOrNil:imageName position:HFSRight panel:HFSTop];
}

- (HFSUIButton *)prepareFooterLeftButtonWithCaption:(NSString *)caption 
                                       captionColor:(UIColor *)color 
                                      captionShadow:(UIColor *)shadow 
                                         imageOrNil:(NSString *)imageName {
	return [self preparePanelButtonWithCaption:caption captionColor:color captionShadow:shadow imageOrNil:imageName position:HFSLeft panel:HFSBottom];
}

- (HFSUIButton *)prepareFooterCenterButtonWithCaption:(NSString *)caption 
                                         captionColor:(UIColor *)color 
                                        captionShadow:(UIColor *)shadow 
                                           imageOrNil:(NSString *)imageName {
	return [self preparePanelButtonWithCaption:caption captionColor:color captionShadow:shadow imageOrNil:imageName position:HFSCenter panel:HFSBottom];
}

- (HFSUIButton *)prepareFooterRightButtonWithCaption:(NSString *)caption 
                                        captionColor:(UIColor *)color 
                                       captionShadow:(UIColor *)shadow 
                                          imageOrNil:(NSString *)imageName {
	return [self preparePanelButtonWithCaption:caption captionColor:color captionShadow:shadow imageOrNil:imageName position:HFSRight panel:HFSBottom];
}

- (UIButton *)prepareHeaderCloseButton {
	UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
	closeButton.frame = CGRectMake(headerPanel.frame.size.width - 60.0f, 0.0f, 60.0f, 60.0f);
	closeButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
	return closeButton;
}

- (HFSUILabel *)prepareHeaderCenterTitleWithCaption:(NSString *)caption 
                                       captionColor:(UIColor *)color 
                                      captionShadow:(UIColor *)shadow {
	HFSUILabel *newLabel = [HFSUILabel labelWithFrame: CGRectMake(headerPanel.bounds.origin.x + 170, 
                                                                  headerPanel.bounds.origin.y, 
                                                                  headerPanel.bounds.size.width - 170*2, 
                                                                  headerPanel.bounds.size.height)
                                              forText:caption
                                            withColor:color
                                           andShadow:shadow];
	newLabel.textAlignment = UITextAlignmentCenter;
	newLabel.font = [UIFont boldSystemFontOfSize:constLargeFontSize];
	newLabel.tag = constHeaderCenterTitleWithCaption;	
	return newLabel;
}

- (void)dealloc {
	[bodyBack release];
	[headerPanel release];
	[bodyPanel release];
	[footerPanel release];
	
    [super dealloc];
}


@end
