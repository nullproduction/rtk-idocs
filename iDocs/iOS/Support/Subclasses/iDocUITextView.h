//
//  HFSUITextView.h
//  iDoc
//
//  Created by mark2 on 12/25/10.
//  Copyright 2010 KORUS Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iPadPanelBodyBackgroundView.h"

@interface iDocUITextView : UIView {
	iPadPanelBodyBackgroundView *backgroundTiledView;
	UITextView *textEditView;
}

@property (retain, getter=getText,setter=setText:) NSString *text;
@property (assign, getter=getDelegate, setter=setDelegate:) id<UITextViewDelegate>delegate;

@end
