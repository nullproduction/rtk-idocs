//
//  iPadPanelHeaderBarBackgroundView.m
//  iDoc
//
//  Created by mark2 on 12/22/10.
//  Copyright 2010 KORUS Consulting. All rights reserved.
//

#import "iPadPanelHeaderBarBackgroundView.h"
#import "iPadThemeBuildHelper.h"

@implementation iPadPanelHeaderBarBackgroundView

@synthesize sideTileWidth;

- (id)initWithImages:(NSArray *)imageNames {
    if ((self = [super init])) {
		sideTileWidth = 41.0f;
		
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		
        NSString *imageName = [iPadThemeBuildHelper nameForImage:[imageNames objectAtIndex:0]];
        l = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
		l.contentMode = UIViewContentModeBottomLeft;
		l.autoresizingMask = UIViewAutoresizingNone;
		
        imageName = [iPadThemeBuildHelper nameForImage:[imageNames objectAtIndex:1]];        
		body = [self newViewWithTiledBackground:imageName];
		body.autoresizingMask = UIViewAutoresizingNone;
        
        imageName = [iPadThemeBuildHelper nameForImage:[imageNames objectAtIndex:2]];
		r = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
		r.contentMode = UIViewContentModeBottomRight;
		r.autoresizingMask = UIViewAutoresizingNone;
				
		[self addSubview:l];
		[self addSubview:r];
		[self addSubview:body];
    }
    return self;
}
- (id)initWithImagePrefix:(NSString *)prefix {
    return [self initWithImages:[NSArray arrayWithObjects:
                                 [NSString stringWithFormat:@"%@_01.png", prefix], 
                                 [NSString stringWithFormat:@"%@_02.png", prefix], 
                                 [NSString stringWithFormat:@"%@_03.png", prefix], 
                                 nil]];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	l.frame = self.bounds;
	r.frame = self.bounds;
	body.frame = CGRectInset(self.bounds, sideTileWidth, 0);
	
}
- (void)dealloc {
	[l release];
	[r release];
	[body release];
    [super dealloc];
}


@end
