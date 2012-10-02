//
//  HFSUIButton.h
//  iDoc
//
//  Created by mark2 on 12/21/10.
//  Copyright 2010 KORUS Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFSUILabel.h"
#import "iPadThemeBuildHelper.h"

@interface HFSUIButton : UIButton {
	NSString *buttonId;
	HFSUILabel *buttonTitle;
	UIImageView *buttonIconView;
	BOOL buttonSelected;
	float leftMargin;
    float buttonTitleOffset;
	
	UIImage *normalStateIconImage;
	UIImage *selectedStateIconImage;
	
	NSDictionary *selectorData;
}

@property (nonatomic, retain) NSString *buttonId;
@property (nonatomic, retain) HFSUILabel *buttonTitle;
@property (nonatomic, retain) UIImageView *buttonIconView;
@property (nonatomic, retain) UIImage *normalStateIconImage;
@property (nonatomic, retain) UIImage *selectedStateIconImage;
@property float leftMargin;
@property float buttonTitleOffset;
@property (nonatomic, retain) NSDictionary *selectorData; 

+ (HFSUIButton *)prepareButtonWithBackImageForNormalState:(NSString *)buttonNormalBack 
                                backImageForSelectedState:(NSString *)buttonSelectedBack 
                                                  caption:(NSString *)buttonCaption 
                                             captionColor:(UIColor *)color
                                       captionShadowColor:(UIColor *)shadow
                                                     icon:(NSString *)buttonIcon;
+ (HFSUIButton *)prepareButtonWithBackImageForNormalState:(NSString *)buttonNormalBack 
                                backImageForSelectedState:(NSString *)buttonSelectedBack;

+ (HFSUIButton *)prepareButtonWithIconForNormalState:(NSString *)buttonNormalIcon 
                                iconForSelectedState:(NSString *)buttonSelectedIcon 
                                             caption:(NSString *)buttonCaption
                                        captionColor:(UIColor *)color
                                  captionShadowColor:(UIColor *)shadow;

+ (HFSUIButton *)prepareButtonWithBackImage:(NSString *)buttonBack 
                                    caption:(NSString *)buttonCaption 
                               captionColor:(UIColor *)color
                         captionShadowColor:(UIColor *)shadow
                                       icon:(NSString *)buttonIcon;
+ (HFSUIButton *)prepareButtonWithBackImage:(NSString *)buttonBack;

@end
