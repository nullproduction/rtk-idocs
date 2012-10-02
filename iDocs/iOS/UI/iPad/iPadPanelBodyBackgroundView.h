//
//  iPadPanelBodyBackgroundView.h.h
//  iDoc
//
//  Created by mark2 on 12/22/10.
//  Copyright 2010 KORUS Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseLayoutView.h"

@interface iPadPanelBodyBackgroundView : BaseLayoutView {
	
	NSString *prefix;
	NSString *suffix;
	float tileSize;
	
	//corners
	UIImageView *tlc;
	UIImageView *trc;
	UIImageView *brc;
	UIImageView *blc;
	//edges
	UIView *l;
	UIView *r;
	UIView *t;
	UIView *b;
	//body
	UIView *body;
}

@property (nonatomic, retain) NSString *prefix;
@property (nonatomic, retain) NSString *suffix;
@property () float tileSize;

- (id)initWithPrefix:(NSString *)newPrefix suffix:(NSString *)newSuffix tileSize:(float)newTileSize;

@end
