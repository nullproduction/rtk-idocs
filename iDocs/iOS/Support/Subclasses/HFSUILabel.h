//
//  YeehayUILabel.h
//  yeehay
//
//  Created by mark2 on 9/12/10.
//  Copyright 2010 HFS. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HFSUILabel : UILabel {	
	UIColor *withTextColor;
	UIColor *withShadowColor;
	float withShadowOffset;
}

+ (id)labelWithFrame:(CGRect)lFrame 
             forText:(NSString *)tValue 
          withColor:(UIColor *)wColor 
           andShadow:(UIColor *)wShadow;

+ (id)labelWithFrame:(CGRect)lFrame 
             forText:(NSString *)tValue  
           withColor:(UIColor *)wColor 
           andShadow:(UIColor *)wShadow 
            fontSize:(int)fontSize;

+ (id)roundLabelWithFrame:(CGRect)lFrame 
                  forText:(NSString *)tValue 
                withColor:(UIColor *)wColor 
                backColor:(UIColor *)backColor;
@end
