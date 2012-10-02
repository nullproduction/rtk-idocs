//
//  iPadHeaderBodyFooterLayoutView.h
//  iDoc
//
//  Created by mark2 on 12/24/10.
//  Copyright 2010 KORUS Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iPadPanelBodyBackgroundView.h"
#import "BaseLayoutView.h"

@interface iPadHeaderBodyFooterLayoutView: BaseLayoutView {
	iPadPanelBodyBackgroundView *bodyBack;
	UIView *headerPanel;
	UIView *bodyPanel;
	UIView *footerPanel;

	BOOL showHeader;	
	BOOL showFooter;
}

@property (nonatomic, retain) UIView *headerPanel;
@property (nonatomic, retain) UIView *bodyPanel;
@property (nonatomic, retain) UIView *footerPanel;

@property () BOOL showHeader;
@property () BOOL showFooter;

- (id)init;
- (HFSUIButton *)prepareHeaderLeftButtonWithCaption:(NSString *)caption 
                                       captionColor:(UIColor *)color 
                                      captionShadow:(UIColor *)shadow 
                                         imageOrNil:(NSString *)imageName;
- (HFSUIButton *)prepareHeaderRightButtonWithCaption:(NSString *)caption 
                                        captionColor:(UIColor *)color 
                                       captionShadow:(UIColor *)shadow 
                                          imageOrNil:(NSString *)imageName;
- (HFSUIButton *)prepareFooterCenterButtonWithCaption:(NSString *)caption 
                                         captionColor:(UIColor *)color 
                                        captionShadow:(UIColor *)shadow 
                                           imageOrNil:(NSString *)imageName;
- (HFSUIButton *)prepareFooterLeftButtonWithCaption:(NSString *)caption 
                                       captionColor:(UIColor *)color 
                                      captionShadow:(UIColor *)shadow 
                                         imageOrNil:(NSString *)imageName;
- (HFSUIButton *)prepareFooterRightButtonWithCaption:(NSString *)caption 
                                        captionColor:(UIColor *)color 
                                       captionShadow:(UIColor *)shadow 
                                          imageOrNil:(NSString *)imageName;
- (HFSUILabel *)prepareHeaderCenterTitleWithCaption:(NSString *)caption 
                                       captionColor:(UIColor *)color 
                                   captionShadow:(UIColor *)shadow;
- (UIButton *)prepareHeaderCloseButton;


@end
