//
//  iPadBaseLayoutView.h
//  iDoc
//
//  Created by mark2 on 12/21/10.
//  Copyright 2010 KORUS Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseLayoutView.h"
#import "iPadPanelBackgroundView.h"
#import "iPadPanelBodyBackgroundView.h"
#import "iPadPanelHeaderBarBackgroundView.h"

#import "iPadPopupLayoutView.h"

@interface iPadBaseLayoutView : BaseLayoutView {
	iPadPanelBackgroundView *contentPanelBack;
	iPadPanelBodyBackgroundView *contentPanelBodyBack;
	iPadPanelHeaderBarBackgroundView *masterTitleBackgroundView;
	
	iPadPopupLayoutView *popupPanel;
	
	UIView *contentPanel;/* container for contentBody and trayButtons */
	UIView *contentBodyPanel;/* see above */
	UIView *trayButtonsPanel;/* see above */
	
	UIView *modalPopupVeil;
	UIButton *modalPopupVeilCloseButton;
	UIView *modalPopupContainer;	
	
	CGSize modalPanelSize;
}

@property (nonatomic, retain) UIView *contentPanel;/* container for contentBody and trayButtons */
@property (nonatomic, retain) UIView *contentBodyPanel;/* see above */
@property (nonatomic, retain) UIView *trayButtonsPanel;/* see above */

@property (nonatomic, retain) UIView *modalPopupVeil;
@property (nonatomic, retain) UIButton *modalPopupVeilCloseButton;
@property (nonatomic, retain) UIView *modalPopupContainer;

@property (nonatomic, retain) iPadPopupLayoutView *popupPanel;
@property () CGSize modalPanelSize;

- (CGRect)contentPanelInitialFrame;
- (void)toggleModalPanelOnOFF:(BOOL)onOff;

@end
