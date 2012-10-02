//
//  HFSUIButton.m
//  iDoc
//
//  Created by mark2 on 12/21/10.
//  Copyright 2010 KORUS Consulting. All rights reserved.
//

#import "HFSUIButton.h"

@interface HFSUIButton(PrivateMethods)

- (void)assignIconForNormalState:(NSString *)buttonNormalIcon 
            iconForSelectedState:(NSString *)buttonSelectedIcon 
                         caption:(NSString *)buttonCaption
                    captionColor:(UIColor *)color
              captionShadowColor:(UIColor *)shadow;
- (void)assignBackgroundImageForNormalState:(NSString *)buttonNormalBack 
             backgrounImageForSelectedState:(NSString *)buttonSelectedBack 
                                    caption:(NSString *)buttonCaption 
                               captionColor:(UIColor *)color
                         captionShadowColor:(UIColor *)shadow
                                       icon:(NSString *)buttonIcon;

@end

@implementation HFSUIButton

@synthesize buttonId, buttonTitle, buttonIconView, normalStateIconImage, selectedStateIconImage, leftMargin, buttonTitleOffset, selectorData;

- (BOOL)isSelected {
	return buttonSelected;
}

- (void)setSelected:(BOOL)yesNo {
	[super setSelected:yesNo];
	buttonSelected = yesNo;
	if (self.normalStateIconImage != nil && self.selectedStateIconImage != nil) {
		[self.buttonIconView setImage:((buttonSelected == YES) ? self.selectedStateIconImage : self.normalStateIconImage)];
	}
}

+ (HFSUIButton *)buttonWithType:(UIButtonType)buttonType {
	HFSUIButton *newButton = [super buttonWithType:buttonType];
	newButton.leftMargin = 5.0f;
    newButton.buttonTitleOffset = 5.0f;
	return newButton;
}

+ (HFSUIButton *)prepareButtonWithIconForNormalState:(NSString *)normalIcon 
                                iconForSelectedState:(NSString *)selectedIcon 
                                             caption:(NSString *)caption
                                        captionColor:(UIColor *)color
                                  captionShadowColor:(UIColor *)shadow {
	HFSUIButton *newButton = [HFSUIButton buttonWithType:UIButtonTypeCustom];
	[newButton assignIconForNormalState:normalIcon 
                   iconForSelectedState:selectedIcon 
                                caption:caption
                           captionColor:color
                     captionShadowColor:shadow];
	return newButton;
}

+ (HFSUIButton *)prepareButtonWithBackImage:(NSString *)backImage
                                    caption:(NSString *)caption 
                               captionColor:(UIColor *)color
                         captionShadowColor:(UIColor *)shadow 
                                       icon:(NSString *)icon {
	HFSUIButton *newButton = [HFSUIButton buttonWithType:UIButtonTypeCustom];
	[newButton assignBackgroundImageForNormalState:backImage
                    backgrounImageForSelectedState:backImage 
                                           caption:caption
                                      captionColor:color
                                captionShadowColor:shadow
                                              icon:icon];
	return newButton;
}

+ (HFSUIButton *)prepareButtonWithBackImage:(NSString *)backImage {
	HFSUIButton *newButton = [HFSUIButton buttonWithType:UIButtonTypeCustom];
	[newButton assignBackgroundImageForNormalState:backImage
                    backgrounImageForSelectedState:backImage 
                                           caption:nil
                                      captionColor:nil
                                captionShadowColor:nil
                                              icon:nil];
	return newButton;
}


+ (HFSUIButton *)prepareButtonWithBackImageForNormalState:(NSString *)normalBack 
                                backImageForSelectedState:(NSString *)selectedBack 
                                                  caption:(NSString *)caption 
                                             captionColor:(UIColor *)color
                                       captionShadowColor:(UIColor *)shadow
                                                     icon:(NSString *)icon {
	HFSUIButton *newButton = [HFSUIButton buttonWithType:UIButtonTypeCustom];
	[newButton assignBackgroundImageForNormalState:normalBack 
                    backgrounImageForSelectedState:selectedBack 
                                           caption:caption
                                      captionColor:color
                                captionShadowColor:shadow
                                              icon:icon];
	return newButton;
}

+ (HFSUIButton *)prepareButtonWithBackImageForNormalState:(NSString *)normalBack 
                                backImageForSelectedState:(NSString *)selectedBack {
	HFSUIButton *newButton = [HFSUIButton buttonWithType:UIButtonTypeCustom];
	[newButton assignBackgroundImageForNormalState:normalBack 
                    backgrounImageForSelectedState:selectedBack 
                                           caption:nil
                                      captionColor:nil
                                captionShadowColor:nil
                                              icon:nil];
	return newButton;
}

- (void)assignIconForNormalState:(NSString *)buttonNormalIcon 
            iconForSelectedState:(NSString *)buttonSelectedIcon 
                         caption:(NSString *)buttonCaption 
                    captionColor:(UIColor *)color
              captionShadowColor:(UIColor *)shadow {
	buttonTitle = [HFSUILabel labelWithFrame:CGRectZero forText:NSLocalizedString(buttonCaption, nil) withColor:color andShadow:shadow];
	[self addSubview:self.buttonTitle];
	
	normalStateIconImage = [[UIImage imageNamed:buttonNormalIcon] retain];
	selectedStateIconImage = [[UIImage imageNamed:buttonSelectedIcon] retain];
	
	buttonIconView = [[UIImageView alloc] initWithImage:self.normalStateIconImage];
	self.buttonIconView.contentMode = UIViewContentModeLeft;
	[self addSubview:self.buttonIconView];	
}

- (void)assignBackgroundImageForNormalState:(NSString *)buttonNormalBack 
             backgrounImageForSelectedState:(NSString *)buttonSelectedBack 
                                    caption:(NSString *)buttonCaption 
                               captionColor:(UIColor *)color
                         captionShadowColor:(UIColor *)shadow
                                       icon:(NSString *)buttonIcon {
	self.autoresizingMask = UIViewAutoresizingNone;
	
	[self setImage:[UIImage imageNamed:buttonNormalBack] forState:UIControlStateNormal];
	[self setImage:[UIImage imageNamed:buttonSelectedBack] forState:UIControlStateSelected];
    
	buttonTitle = [HFSUILabel labelWithFrame:CGRectZero forText:NSLocalizedString(buttonCaption, nil) withColor:color andShadow:shadow];
	[self addSubview:buttonTitle];
	
	if (buttonIcon != nil) {
        UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:buttonIcon]];
		self.buttonIconView = iconView;
        [iconView release];
		self.buttonIconView.contentMode = UIViewContentModeLeft;
		[self addSubview:self.buttonIconView];
	}
    
}

- (void)layoutSubviews {
	[super layoutSubviews];
	CGRect buttonIconViewFrame = self.buttonIconView.frame;
	buttonIconViewFrame.origin.x = self.leftMargin;
	buttonIconViewFrame.origin.y = (self.frame.size.height - buttonIconViewFrame.size.height)/2;
	self.buttonIconView.frame = buttonIconViewFrame;
	
	self.buttonTitle.frame = (self.buttonIconView != nil ? 
						 CGRectOffset(CGRectInset(self.bounds, (self.buttonIconView.frame.size.width + self.leftMargin + self.buttonTitleOffset)/2, 0.0f), (self.buttonIconView.frame.size.width + self.leftMargin + self.buttonTitleOffset)/2, 0.0f) :
						 self.bounds);
}

- (void)dealloc {
    if (normalStateIconImage != nil)
        [normalStateIconImage release];
    
    if (selectedStateIconImage != nil)
        [selectedStateIconImage release];
    
    if (selectorData != nil)
        [selectorData release];
    
    if (buttonIconView != nil)
        [buttonIconView release];
    
    [super dealloc];
}

@end
