//
//  UIImage+Crop.m
//  yeehay
//
//  Created by mark2 on 8/20/10.
//  Copyright 2010 HFS. All rights reserved.
//

#import "UIImage+Crop.h"
#import "UIImage+Resize.h"

@implementation UIImage(Crop)

-(UIImage *)cropWithSide:(float)sideSize{
	UIImage *resized =  [self
						 resizedImageWithContentMode:UIViewContentModeScaleAspectFill
						 bounds:CGSizeMake(sideSize, sideSize)
						 interpolationQuality:kCGInterpolationMedium];
	float sp = (MAX(resized.size.width, resized.size.height)-MIN(resized.size.width,resized.size.height))/2;
	BOOL x = resized.size.width>=resized.size.height;
	UIImage *cropped = [resized croppedImage:CGRectMake(x?sp:0,x?0:sp,
														sideSize,sideSize)];
	return cropped;
}
@end
