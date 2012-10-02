//
//  iPadPopupLayoutView.h
//  iDoc
//
//  Created by mark2 on 12/23/10.
//  Copyright 2010 KORUS Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFSUILabel.h"
#import "iPadPanelBodyBackgroundView.h"
#import "iPadPopupLayoutViewProtocol.h"

@interface iPadPopupLayoutView : BaseLayoutView <iPadPopupLayoutViewDelegate> {
	iPadPanelBodyBackgroundView *modalPanelBack;
	HFSUILabel *modalPopupTitle;
	UIView *containerView;
    UIView *auxContainerView;
    UIView *auxContentView;
    
    BOOL needsAuxViewLayout;
}

@property (nonatomic, retain) HFSUILabel *modalPopupTitle;
@property (nonatomic, retain) UIView *containerView;

- (void)putContent:(UIView *)contentView;
- (void)cleanup;

@end
