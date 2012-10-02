//
//  HFSGradientView.m
//  iDoc
//
//  Created by mark2 on 6/19/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import "HFSGradientView.h"


@implementation HFSGradientView
- (void)drawRect:(CGRect)rect 
{
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    CGGradientRef glossGradient;
    CGColorSpaceRef rgbColorspace;
    size_t num_locations = 4;
    CGFloat locations[4] = { 0.0, 0.1, 0.9, 1.0 };
    CGFloat components[16] = { 
        1.0, 1.0, 1.0, 0,  // Start color
        1.0, 1.0, 1.0, 1,  // Mid color
        1.0, 1.0, 1.0, 1,  // Mid color
        1.0, 1.0, 1.0, 0 }; // End color
    
    rgbColorspace = CGColorSpaceCreateDeviceRGB();
    glossGradient = CGGradientCreateWithColorComponents(rgbColorspace, components, locations, num_locations);
    
    CGRect currentBounds = self.bounds;
    CGPoint startpoint = CGPointMake(CGRectGetMinX(currentBounds), CGRectGetMidY(currentBounds));
    CGPoint endpoint = CGPointMake(CGRectGetMaxX(currentBounds), CGRectGetMidY(currentBounds));
    CGContextDrawLinearGradient(currentContext, glossGradient, startpoint, endpoint, 0);
    
    CGGradientRelease(glossGradient);
    CGColorSpaceRelease(rgbColorspace); 
}

- (BOOL)isOpaque {
    return NO;
}

- (UIColor *)backgroundColor {
    return [UIColor clearColor];
}

- (UIViewAutoresizing)autoresizingMask {
    return UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

@end
