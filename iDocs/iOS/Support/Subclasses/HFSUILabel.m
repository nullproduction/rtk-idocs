//
//  YeehayUILabel.m
//  yeehay
//
//  Created by mark2 on 9/12/10.
//  Copyright 2010 HFS. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "HFSUILabel.h"
#import "Constants.h"

@interface HFSUILabel(PrivateMethods)
- (id)initWithFrame:(CGRect)frame;
@end

@implementation HFSUILabel

- (id)initWithFrame:(CGRect)frame {
	if((self=[super initWithFrame:frame])){
        self.autoresizingMask = UIViewAutoresizingNone;
        self.backgroundColor = [UIColor clearColor];	
        self.textColor = [UIColor blackColor];
        self.font = [UIFont boldSystemFontOfSize:constMediumFontSize];
	}
	return self;
}

+ (id)labelWithFrame:(CGRect)lFrame 
             forText:(NSString *)tValue  
           withColor:(UIColor *)wColor 
           andShadow:(UIColor *)wShadow {
    return [self labelWithFrame:lFrame forText:tValue withColor:wColor andShadow:wShadow fontSize:constMediumFontSize];
}

+ (id)labelWithFrame:(CGRect)lFrame 
             forText:(NSString *)tValue  
           withColor:(UIColor *)wColor 
           andShadow:(UIColor *)wShadow 
            fontSize:(int)fontSize{
	HFSUILabel *newLabel = [[[HFSUILabel alloc] initWithFrame:lFrame] autorelease];
	newLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    newLabel.font = [UIFont boldSystemFontOfSize:fontSize];
	if (wShadow != nil) {
		newLabel.shadowColor = wShadow;
		newLabel.shadowOffset = CGSizeMake(0, -1);	
	}
	if (wColor != nil){
		newLabel.textColor = wColor;
	}
	newLabel.text = tValue;
	return newLabel;
}

+ (id)roundLabelWithFrame:(CGRect)lFrame 
                  forText:(NSString *)tValue 
                withColor:(UIColor *)wColor 
                backColor:(UIColor *)backColor {
	HFSUILabel *newLabel = [self labelWithFrame:lFrame forText:tValue withColor:wColor andShadow:nil];
	newLabel.layer.cornerRadius = 4.0f;
	newLabel.backgroundColor = backColor;
	return newLabel;
}

@end
