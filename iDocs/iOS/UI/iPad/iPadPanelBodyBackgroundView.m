//
//  iPadPanelBodyBackgroundView.h.m
//  iDoc
//
//  Created by mark2 on 12/22/10.
//  Copyright 2010 KORUS Consulting. All rights reserved.
//

#import "iPadPanelBodyBackgroundView.h"
#import "Constants.h"
#import "iPadThemeBuildHelper.h"

@interface iPadPanelBodyBackgroundView (PrivateMethods)
- (void)commonInit;
@end


@implementation iPadPanelBodyBackgroundView

@synthesize prefix, suffix, tileSize;

- (id)initWithPrefix:(NSString *)newPrefix suffix:(NSString *)newSuffix tileSize:(float)newTileSize {
    if ((self = [super init])) {
		prefix = newPrefix;
		suffix = newSuffix;
		tileSize = newTileSize;
	
		[self commonInit];	
	}
	return self;
}

- (id)init {
    if ((self = [super init])) {
		prefix = @"panel_back";
		suffix = @"_body";
		tileSize = 50.0f;
		
		[self commonInit];
    }
    return self;
}

- (void)commonInit {
	self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.backgroundColor = [UIColor clearColor];
	self.opaque = NO;
	
    //corners
    NSString *imageName = [iPadThemeBuildHelper nameForImage:[NSString stringWithFormat:@"%@_tlc%@.png", prefix, suffix]];
	tlc = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
	tlc.contentMode = UIViewContentModeTopLeft;
	tlc.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	
    imageName = [iPadThemeBuildHelper nameForImage:[NSString stringWithFormat:@"%@_trc%@.png", prefix, suffix]];
	trc = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
	trc.contentMode = UIViewContentModeTopRight;
	trc.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	
    imageName = [iPadThemeBuildHelper nameForImage:[NSString stringWithFormat:@"%@_blc%@.png", prefix, suffix]];    
	blc = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
	blc.contentMode = UIViewContentModeBottomLeft;
	blc.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	
    imageName = [iPadThemeBuildHelper nameForImage:[NSString stringWithFormat:@"%@_brc%@.png", prefix, suffix]];    
	brc = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
	brc.contentMode = UIViewContentModeBottomRight;
	brc.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	
	//edges
    imageName = [iPadThemeBuildHelper nameForImage:[NSString stringWithFormat:@"%@_l%@.png", prefix, suffix]];
	l = [self newViewWithTiledBackground:imageName];
	l.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin;
    imageName = [iPadThemeBuildHelper nameForImage:[NSString stringWithFormat:@"%@_r%@.png", prefix, suffix]];
	r = [self newViewWithTiledBackground:imageName];
	r.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin;
    imageName = [iPadThemeBuildHelper nameForImage:[NSString stringWithFormat:@"%@_t%@.png", prefix, suffix]];
	t = [self newViewWithTiledBackground:imageName];
	t.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    imageName = [iPadThemeBuildHelper nameForImage:[NSString stringWithFormat:@"%@_b%@.png", prefix, suffix]];
	b = [self newViewWithTiledBackground:imageName];
	b.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
	
	//body
    imageName = [iPadThemeBuildHelper nameForImage:[NSString stringWithFormat:@"%@_body%@.png", prefix, suffix]];
	body = [self newViewWithTiledBackground:imageName];
	body.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	
	[self addSubview:body];//back with some offset
	[self addSubview:tlc];
	[self addSubview:trc];
	[self addSubview:blc];
	[self addSubview:brc];
	[self addSubview:l];
	[self addSubview:r];
	[self addSubview:t];
	[self addSubview:b];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	body.frame = CGRectInset(self.bounds, tileSize, tileSize);
	tlc.frame = self.bounds;
	trc.frame = self.bounds;
	blc.frame = self.bounds;
	brc.frame = self.bounds;
	l.frame = CGRectMake(0.0f, tileSize, tileSize, self.bounds.size.height - tileSize - tileSize);
	r.frame = CGRectMake(self.bounds.size.width - tileSize, tileSize, tileSize, self.bounds.size.height - tileSize - tileSize);
	t.frame = CGRectMake(tileSize, 0.0f, self.bounds.size.width - tileSize - tileSize, tileSize);
	b.frame = CGRectMake(tileSize, self.bounds.size.height - tileSize, self.bounds.size.width - tileSize - tileSize, tileSize);
	
}

- (void)dealloc {
	//corners
	[tlc release];
	[trc release];
	[brc release];
	[blc release];
	//edges
	[l release];
	[r release];
	[t release];
	[b release];
	//body
	[body release];
	
	
    [super dealloc];
}


@end
