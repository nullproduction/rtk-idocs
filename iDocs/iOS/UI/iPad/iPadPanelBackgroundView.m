//
//  iPadPanelBackgroundView.m
//  iDoc
//
//  Created by mark2 on 12/22/10.
//  Copyright 2010 KORUS Consulting. All rights reserved.
//

#import "iPadPanelBackgroundView.h"
#import "iPadThemeBuildHelper.h"


@implementation iPadPanelBackgroundView


- (id)init {
    if ((self = [super init])) {
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		//corners
		tlc = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[iPadThemeBuildHelper nameForImage:@"panel_back_tlc.png"]]];
		tlc.contentMode = UIViewContentModeTopLeft;
		tlc.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		
		trc = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[iPadThemeBuildHelper nameForImage:@"panel_back_trc.png"]]];
		trc.contentMode = UIViewContentModeTopRight;
		trc.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		
		blc = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[iPadThemeBuildHelper nameForImage:@"panel_back_blc.png"]]];
		blc.contentMode = UIViewContentModeBottomLeft;
		blc.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		
		brc = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[iPadThemeBuildHelper nameForImage:@"panel_back_brc.png"]]];
		brc.contentMode = UIViewContentModeBottomRight;
		brc.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		
		//edges
		l = [self newViewWithTiledBackground:[iPadThemeBuildHelper nameForImage:@"panel_back_l.png"]];
		l.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin;
		r = [self newViewWithTiledBackground:[iPadThemeBuildHelper nameForImage:@"panel_back_r.png"]];
		r.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin;
		t = [self newViewWithTiledBackground:[iPadThemeBuildHelper nameForImage:@"panel_back_t.png"]];
		t.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
		b = [self newViewWithTiledBackground:[iPadThemeBuildHelper nameForImage:@"panel_back_b.png"]];
		b.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
		
		//body
		body = [self newViewWithTiledBackground:[iPadThemeBuildHelper nameForImage:@"panel_back_body.png"]];
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
    return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	body.frame = CGRectInset(self.bounds, 10, 10);
	tlc.frame = self.bounds;
	trc.frame = self.bounds;
	blc.frame = self.bounds;
	brc.frame = self.bounds;
	l.frame = CGRectMake(0, 30, 31, self.bounds.size.height-30-27);
	r.frame = CGRectMake(self.bounds.size.width-39, 41, 39, self.bounds.size.height-41-32);
	t.frame = CGRectMake(31, 0, self.bounds.size.width-31-39, 41);
	b.frame = CGRectMake(32, self.bounds.size.height-43, self.bounds.size.width-32-30, 43);
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
