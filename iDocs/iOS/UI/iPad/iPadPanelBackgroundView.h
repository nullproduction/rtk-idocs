//
//  iPadPanelBackgroundView.h
//  iDoc
//
//  Created by mark2 on 12/22/10.
//  Copyright 2010 KORUS Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseLayoutView.h"

@interface iPadPanelBackgroundView : BaseLayoutView {
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

@end
