//
//  iPadPanelHeaderBarBackgroundView.h
//  iDoc
//
//  Created by mark2 on 12/22/10.
//  Copyright 2010 KORUS Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseLayoutView.h"

@interface iPadPanelHeaderBarBackgroundView : BaseLayoutView {
	UIImageView *l;
	UIImageView *r;
	UIView *body;
	
	float sideTileWidth;
}

@property () float sideTileWidth;

- (id)initWithImagePrefix:(NSString *)prefix;
- (id)initWithImages:(NSArray *)imageNames;
@end
