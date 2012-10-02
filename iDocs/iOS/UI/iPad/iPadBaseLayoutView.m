//
//  iPadBaseBackgroundView.m
//  iDoc
//
//  Created by mark2 on 12/21/10.
//  Copyright 2010 KORUS Consulting. All rights reserved.
//

#import "iPadBaseLayoutView.h"
#import "Constants.h"
#import "iPadPanelBodyBackgroundView.h"
#import "iPadThemeBuildHelper.h"
#import <QuartzCore/QuartzCore.h>

@interface iPadBaseLayoutView(PrivateMethods)
- (void)layoutPopupPanel;
@end

@implementation iPadBaseLayoutView

@synthesize contentPanel, contentBodyPanel, trayButtonsPanel, modalPopupVeil, modalPopupVeilCloseButton, modalPopupContainer,
			popupPanel, modalPanelSize;

- (id)init {
	if ((self = [super init])) {
		modalPanelSize = CGSizeMake(600.0f, 600.0f);
		
		masterTitleBackgroundView = [[iPadPanelHeaderBarBackgroundView alloc] initWithImagePrefix:@"master_title_background"];
		masterTitleBackgroundView.sideTileWidth = 100.0f;
				
		contentPanelBack = [[iPadPanelBackgroundView alloc] init];
		contentPanelBodyBack = [[iPadPanelBodyBackgroundView alloc] init];
				
        UIView *tmpView = [[UIView alloc] init];
		self.contentPanel = tmpView;
        [tmpView release]; 
		contentPanel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		
        tmpView = [[UIView alloc] init];
		self.contentBodyPanel = tmpView;
        [tmpView release];
		contentBodyPanel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		
        tmpView = [[UIView alloc] init];
		self.trayButtonsPanel = tmpView;
        [tmpView release];
		trayButtonsPanel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;

		[contentBodyPanel addSubview:contentPanelBodyBack];

		[contentPanel addSubview:contentPanelBack];
		[contentPanel addSubview:contentBodyPanel];
		[contentPanel addSubview:trayButtonsPanel];
		
		[self addSubview:masterTitleBackgroundView];
		
		[self addSubview:contentPanel];
		
        tmpView = [[UIView alloc] init];
		self.modalPopupVeil = tmpView;
        [tmpView release];
		modalPopupVeil.backgroundColor = [iPadThemeBuildHelper commonPopupVeilColor];
		modalPopupVeil.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

		self.modalPopupVeilCloseButton = [UIButton buttonWithType:UIButtonTypeCustom];
		modalPopupVeilCloseButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		modalPopupVeilCloseButton.frame = modalPopupVeil.bounds;
		[modalPopupVeil addSubview:modalPopupVeilCloseButton];
		
        tmpView = [[UIView alloc] init];
		self.modalPopupContainer = tmpView;
        [tmpView release];
		modalPopupContainer.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;

        iPadPopupLayoutView *popupLayoutView = [[iPadPopupLayoutView alloc] init];
		self.popupPanel = popupLayoutView;
        [popupLayoutView release];
		[modalPopupContainer addSubview:popupPanel];
				
		[modalPopupVeil addSubview:modalPopupContainer];
		[self addSubview:modalPopupVeil];
		
		modalPopupVeil.hidden = YES;
		[self sendSubviewToBack:modalPopupVeil];		
    }
    return self;
}

- (void)toggleModalPanelOnOFF:(BOOL)onOff {
	popupPanel.containerView.frame = CGRectMake(0, 0, modalPanelSize.width, modalPanelSize.height);
	if (onOff == YES) {
		[self bringSubviewToFront:modalPopupVeil];
		modalPopupVeil.hidden = NO;
	}
	else {
		[popupPanel cleanup];
		[self sendSubviewToBack:modalPopupVeil];
		modalPopupVeil.hidden = YES;
	}
}

- (CGRect)contentPanelInitialFrame {
	return CGRectOffset(CGRectInset(self.bounds, 5.0f, 33.0f), 0.0f, 33.0f);/* inset shrinks view both from top and bottom. half of heeded offset. left offset by Offset func */
}

- (void)layoutContentPanel {
	contentPanel.frame = [self contentPanelInitialFrame];
}

- (void)layoutContentBodyPanel {
    float trayHeight = 51.0f;
    /*add 10px margin around body content*/
    contentBodyPanel.frame = 
        CGRectOffset(CGRectInset(contentPanel.bounds, 10.0f, 10.0f + trayHeight/2), 0.0f, -trayHeight/2);
}

- (void)layoutPopupPanel {
	NSLog(@"iPadBaseLayoutView layoutPopupPanel");	
	CGRect modalPopupContainerFrame = CGRectMake(self.bounds.size.width/2-modalPanelSize.width/2, self.bounds.size.height/2-modalPanelSize.height/2, modalPanelSize.width, modalPanelSize.height);
	modalPopupContainer.frame = CGRectMake(modalPopupContainerFrame.origin.x, modalPopupContainerFrame.origin.y+offsetHeight, modalPopupContainerFrame.size.width, modalPopupContainerFrame.size.height+shrinkHeight);
}

- (void)layoutSubviews {
	NSLog(@"iPadBaseLayoutView layoutSubviews");
	[super layoutSubviews];
	
	modalPopupVeil.frame = self.bounds;
	modalPopupVeilCloseButton.frame = modalPopupVeil.bounds;
	
	masterTitleBackgroundView.frame = CGRectMake(0, 0, self.bounds.size.width, 58.0f);
	
	[self layoutPopupPanel];
	[self layoutContentPanel];
	[self layoutContentBodyPanel];

	contentPanelBack.frame = contentPanel.bounds;
	contentPanelBodyBack.frame = contentBodyPanel.bounds;

	for (UIView *subview in contentBodyPanel.subviews) {
		[subview layoutSubviews];
	}
}

#pragma mark keyboard tracing methods:
- (BOOL)traceKeyboard {
	return YES;
}

- (CGRect)tracedFrame {
	return modalPopupContainer.frame;
}

#pragma mark system methods:
- (void)dealloc {
	[masterTitleBackgroundView release];
	[contentPanelBack release];
	[contentPanelBodyBack release];
    
	self.contentPanel = nil; 	
	self.contentBodyPanel = nil; 	
	self.trayButtonsPanel = nil; 
    
	self.modalPopupVeil = nil; 
	self.modalPopupContainer = nil;
    self.modalPopupVeilCloseButton = nil;
	self.popupPanel = nil; 

    [super dealloc];
}


@end
