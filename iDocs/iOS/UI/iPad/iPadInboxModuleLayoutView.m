//
//  iPadInboxModuleLayoutView.m
//  iDoc
//
//  Created by mark2 on 12/19/10.
//  Copyright 2010 KORUS Consulting. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "iPadInboxModuleLayoutView.h"
#import "Constants.h"
#import "SupportFunctions.h"
#import "iPadThemeBuildHelper.h"
#import "iPadInboxModuleViewController.h"

#import "iPadPanelHeaderBarBackgroundView.h"

@interface iPadInboxModuleLayoutView (PrivateMethods)
- (void)slideItemsListByOffset:(float)offset;
- (void)toggleLeftSliderImage;
@end


@implementation iPadInboxModuleLayoutView

@synthesize leftSlidingPanel, leftSliderFilter, leftSliderBody, leftSliderFooter, leftSliderButton, leftTopToolbarButtonsPanel, 
			showInboxListPopoverButton, showInboxListPopoverButtonTitle, navigateHomeButton, inboxModuleHeaderTitle,
			rightTopToolbarButtonsPanel, actionsPopoverButton, upButton, downButton, actionsPanel,
            syncButton, toolsButton,
            syncButtonHint, toolsButtonHint,
            syncButtonValue, toolsButtonValue;

- (id)init {
	if ((self = [super init])) {
		inboxListPanelSlidedOff = NO;
		slidingInProgress = NO;
		
        //left top toolbar
        UIView *tmpView = [[UIView alloc] init];
		self.leftTopToolbarButtonsPanel = tmpView;
        [tmpView release];

		self.inboxModuleHeaderTitle = [HFSUILabel labelWithFrame:CGRectZero 
                                                         forText:nil 
                                                       withColor:[iPadThemeBuildHelper commonHeaderFontColor1] 
                                                       andShadow:nil];
		inboxModuleHeaderTitle.font = [UIFont boldSystemFontOfSize:constLargeFontSize];
		inboxModuleHeaderTitle.autoresizingMask = UIViewAutoresizingNone;
        inboxModuleHeaderTitle.lineBreakMode = UILineBreakModeWordWrap;
        inboxModuleHeaderTitle.numberOfLines = 2;
		[self.leftTopToolbarButtonsPanel addSubview:inboxModuleHeaderTitle];
		
		self.showInboxListPopoverButton = [HFSUIButton prepareButtonWithBackImage:[iPadThemeBuildHelper nameForImage:@"show_list_button.png"] 
                                                                     caption:@""
                                                                captionColor:[iPadThemeBuildHelper commonButtonFontColor2]
                                                          captionShadowColor:[iPadThemeBuildHelper commonShadowColor2]
                                                                        icon:nil];
		
        self.showInboxListPopoverButton.buttonTitle.font = [UIFont boldSystemFontOfSize:constMediumFontSize];
        self.showInboxListPopoverButton.buttonTitle.textAlignment = UITextAlignmentCenter;        
		self.showInboxListPopoverButtonTitle = showInboxListPopoverButton.buttonTitle;
		[self.leftTopToolbarButtonsPanel addSubview:self.showInboxListPopoverButton];
		
		self.navigateHomeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *iconHome = [UIImage imageNamed:[iPadThemeBuildHelper nameForImage:@"icon_home.png"]];
		[self.navigateHomeButton setImage:iconHome forState:UIControlStateNormal];
		[self.leftTopToolbarButtonsPanel addSubview:self.navigateHomeButton];	
        
		[self addSubview:self.leftTopToolbarButtonsPanel];
		
        //right right toolbar
        tmpView = [[UIView alloc] init];
        self.rightTopToolbarButtonsPanel = tmpView;
        [tmpView release];
        
		self.actionsPopoverButton = 
            [HFSUIButton prepareButtonWithBackImageForNormalState:[iPadThemeBuildHelper nameForImage:@"add_btn_normal.png"] 
                                        backImageForSelectedState:[iPadThemeBuildHelper nameForImage:@"add_btn_selected.png"]];
        
        self.upButton = [HFSUIButton prepareButtonWithBackImageForNormalState:[iPadThemeBuildHelper nameForImage:@"up_btn_normal.png"] 
                                               backImageForSelectedState:[iPadThemeBuildHelper nameForImage:@"up_btn_selected.png"]]; 
        self.downButton = [HFSUIButton prepareButtonWithBackImageForNormalState:[iPadThemeBuildHelper nameForImage:@"down_btn_normal.png"] 
                                                 backImageForSelectedState:[iPadThemeBuildHelper nameForImage:@"down_btn_selected.png"]]; 
        
        iPadInboxModuleActionButtonsLayoutView *tmpActionPanel = [[iPadInboxModuleActionButtonsLayoutView alloc] init];
        self.actionsPanel = tmpActionPanel;
        [tmpActionPanel release];
        
        [self.rightTopToolbarButtonsPanel addSubview:self.actionsPopoverButton];
        [self.rightTopToolbarButtonsPanel addSubview:self.upButton];
        [self.rightTopToolbarButtonsPanel addSubview:self.downButton];
        [self.rightTopToolbarButtonsPanel addSubview:self.actionsPanel];
        
        [self addSubview:self.rightTopToolbarButtonsPanel];
		
        //left slider
        tmpView = [[UIView alloc] init];
		self.leftSlidingPanel = tmpView;
        [tmpView release];
		UIImageView *sliderBack = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[iPadThemeBuildHelper nameForImage:@"left_slider_back.png"]]];
		sliderBack.contentMode = UIViewContentModeTopLeft;
		
        tmpView = [[UIView alloc] init];
		self.leftSliderFilter = tmpView;
        [tmpView release];
		UIImageView *sliderFilterBack = 
            [[UIImageView alloc] initWithImage:[UIImage imageNamed:[iPadThemeBuildHelper nameForImage:@"filter_form_back.png"]]];
		sliderFilterBack.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		sliderFilterBack.frame = leftSliderFilter.bounds;
		sliderFilterBack.contentMode = UIViewContentModeCenter;
		
        tmpView = [[UIView alloc] init];
		self.leftSliderBody = tmpView;
        [tmpView release];
		leftSliderBody.layer.cornerRadius = constCornerRadius;
		leftSliderBody.clipsToBounds = YES;
        
        //панель под списком документов - кнопки синхронизации и сортировки
        tmpView = [[UIView alloc] init];
        self.leftSliderFooter = tmpView;
        [tmpView release];
        
        self.syncButton = [HFSUIButton prepareButtonWithBackImageForNormalState:[iPadThemeBuildHelper nameForImage:@"sync_button.png"] 
                                                    backImageForSelectedState:[iPadThemeBuildHelper nameForImage:@"sync_button.png"]]; 

        self.syncButtonHint = [HFSUILabel labelWithFrame:CGRectZero 
                                                 forText:NSLocalizedString(@"SyncButtonHint", nil) 
                                               withColor:[iPadThemeBuildHelper commonTextFontColor4] 
                                               andShadow:nil 
                                                fontSize:constSmallFontSize];
        self.syncButtonValue = [HFSUILabel labelWithFrame:CGRectZero 
                                                  forText:constEmptyStringValue 
                                                withColor:[iPadThemeBuildHelper commonTextFontColor4] 
                                                andShadow:nil 
                                                 fontSize:constSmallFontSize];

        self.toolsButton = [HFSUIButton prepareButtonWithBackImageForNormalState:[iPadThemeBuildHelper nameForImage:@"tools_btn.png"] 
                                                      backImageForSelectedState:[iPadThemeBuildHelper nameForImage:@"tools_btn.png"]]; 
        
        self.toolsButtonHint = [HFSUILabel labelWithFrame:CGRectZero 
                                                  forText:NSLocalizedString(@"ToolsButtonHint",nil) 
                                                withColor:[iPadThemeBuildHelper commonTextFontColor4] 
                                                andShadow:nil 
                                                 fontSize:constSmallFontSize];
        self.toolsButtonValue = [HFSUILabel labelWithFrame:CGRectZero 
                                                   forText:constEmptyStringValue 
                                                 withColor:[iPadThemeBuildHelper commonTextFontColor4] 
                                                 andShadow:nil 
                                                  fontSize:constSmallFontSize];
                
        [self.leftSliderFooter addSubview:self.syncButton];
        [self.leftSliderFooter addSubview:self.toolsButton];
        
        [self.leftSliderFooter addSubview:self.syncButtonHint];
        [self.leftSliderFooter addSubview:self.syncButtonValue];
        [self.leftSliderFooter addSubview:self.toolsButtonHint];
        [self.leftSliderFooter addSubview:self.toolsButtonValue];
		
        //кнопка свернуть-развернуть левую панель
        tmpView = [[UIView alloc] init];
		self.leftSliderButton = tmpView;
        [tmpView release];
		
        UIImage *image = [UIImage imageNamed:[iPadThemeBuildHelper nameForImage:@"left_slider_collapser.png"]];
		leftSliderButtonImage = [[UIImageView alloc] initWithImage:image];
		leftSliderButtonImage.contentMode = UIViewContentModeCenter;
		

        //сборка левой панели:
		[self.leftSlidingPanel addSubview:sliderBack];
		[self.leftSliderFilter addSubview:sliderFilterBack];
		
		[self.leftSlidingPanel addSubview:self.leftSliderFilter];
		[self.leftSlidingPanel addSubview:self.leftSliderBody];
		[self.leftSlidingPanel addSubview:self.leftSliderFooter];
		[self.leftSlidingPanel addSubview:self.leftSliderButton];
		[self.leftSlidingPanel addSubview:leftSliderButtonImage];
        
		[self addSubview:leftSlidingPanel];		        		
        
		[sliderBack release];
		[sliderFilterBack release];     
        
        iPadPanelHeaderBarBackgroundView *buttonsBack = [[iPadPanelHeaderBarBackgroundView alloc] initWithImagePrefix:@"buttons_back"];
        buttonsBack.sideTileWidth = 26.0f;
        buttonsBack.frame = trayButtonsPanel.bounds;
        [trayButtonsPanel addSubview:buttonsBack];
        [buttonsBack release];
	}
	return self;
}

- (void)toggleLeftSliderImage {
	if (inboxListPanelSlidedOff) {
		[leftSliderButtonImage setImage:[UIImage imageNamed:[iPadThemeBuildHelper nameForImage:@"left_slider_expander.png"]]];
	}
	else {
		[leftSliderButtonImage setImage:[UIImage imageNamed:[iPadThemeBuildHelper nameForImage:@"left_slider_collapser.png"]]];
	}

}

- (void)layoutSubviews {
	if ([self isInPortraitOrientation]) {
        self.leftTopToolbarButtonsPanel.frame = CGRectMake(0.0f, 0.0f, 285.0f, 59.0f);
		self.inboxModuleHeaderTitle.hidden = YES;
		self.showInboxListPopoverButton.hidden = NO;
	}
	else {
        self.leftTopToolbarButtonsPanel.frame = CGRectMake(0.0f, 0.0f, 571.0f, 59.0f);
		self.inboxModuleHeaderTitle.hidden = NO;
		self.showInboxListPopoverButton.hidden = YES;		
	}
	self.navigateHomeButton.frame = CGRectMake(0.0f, 0.0f, 59.0f, 59.0f);
	self.inboxModuleHeaderTitle.frame = CGRectMake(65.0f, 14.0f, 506.0f, 31.0f);
	self.showInboxListPopoverButton.frame = CGRectMake(65.0f, 10.0f, 218.0f, 38.0f);
    
    self.rightTopToolbarButtonsPanel.frame = CGRectMake(self.bounds.size.width - 449.0f, 0.0f, 451.0f, 58.0f);
    self.actionsPanel.frame = CGRectMake(9.0f, 0.0f, 269.0f, 58.0f);
	self.actionsPopoverButton.frame = CGRectMake(279.0f, 9.0f, 59.0f, 40.0f);
    self.upButton.frame = CGRectMake(341.0f, 9.0f, 50.0f, 40.0f);
    self.downButton.frame = CGRectMake(391.0f, 9.0f, 48.0f, 40.0f);
    
    float initialOffsetX = 0.0f;
	if ([self isInPortraitOrientation]) {/* portrait */
		initialOffsetX = -constTaskListPanelWidthLandscapeNormal; /*hidden*/
	} else if (inboxListPanelSlidedOff) {
		initialOffsetX = -(constTaskListPanelWidthLandscapeNormal - constTaskListPanelWidthLandscapeSlidedOff);
	}
    
	CGRect initialFrame = [self contentPanelInitialFrame];
	if(!slidingInProgress){/* layout allready done in animation cycle */		
		CGRect leftSliderBounds = CGRectMake(0,0, constTaskListPanelWidthLandscapeNormal, initialFrame.size.height);
		CGRect leftFrame, rightFrame, filterFrame, bodyFrame, footerFrame;
		
        CGRectDivide(leftSliderBounds, &leftFrame, &rightFrame, leftSliderBounds.size.width - constTaskListPanelWidthLandscapeSlidedOff, CGRectMinXEdge);
		
		leftFrame.origin.y = rightFrame.origin.y = 0;
		leftFrame = CGRectOffset(CGRectInset(leftFrame, 10, 0), 5, 0);
			
		CGRectDivide(leftFrame, &filterFrame, &bodyFrame, 51, CGRectMinYEdge);
        
        bodyFrame = CGRectInset(bodyFrame, 3, 0);
		CGRectDivide(bodyFrame, &footerFrame, &bodyFrame, 36, CGRectMaxYEdge);
        
		leftSlidingPanel.frame = CGRectOffset(leftSliderBounds,initialOffsetX, initialFrame.origin.y-10);
		leftSliderBody.frame = bodyFrame;
        leftSliderFooter.frame = CGRectInset(footerFrame, 0, -2);
        
        CGRect syncButtonFrame, syncHintFrame, syncValueFrame, toolsButtonFrame, toolsHintFrame, toolsValueFrame;
        
        CGRectDivide(leftSliderFooter.bounds, &syncButtonFrame, &toolsButtonFrame, leftSliderBody.bounds.size.width/2, CGRectMinXEdge);

        CGRectDivide(syncButtonFrame, &syncButtonFrame, &syncHintFrame, 40.0f, CGRectMinXEdge);
        syncHintFrame = CGRectInset(syncHintFrame, 0, 6);
        CGRectDivide(syncHintFrame, &syncHintFrame, &syncValueFrame, syncHintFrame.size.height/2, CGRectMinYEdge);
        
        CGRectDivide(toolsButtonFrame, &toolsButtonFrame, &toolsHintFrame, 40.0f, CGRectMinXEdge);
        toolsHintFrame = CGRectInset(toolsHintFrame, 0, 6);
        CGRectDivide(toolsHintFrame, &toolsHintFrame, &toolsValueFrame, toolsHintFrame.size.height/2, CGRectMinYEdge);
        
        syncButton.frame = CGRectOffset(syncButtonFrame, 0, 3);
        syncButtonHint.frame = CGRectOffset(syncHintFrame, 0, 3);
        syncButtonValue.frame = CGRectOffset(syncValueFrame, 0, 3);

        toolsButton.frame = CGRectOffset(toolsButtonFrame, 0, 3);
        toolsButtonHint.frame = CGRectOffset(toolsHintFrame, 0, 3);
        toolsButtonValue.frame = CGRectOffset(toolsValueFrame, 0, 3);

		leftSliderButton.frame = rightFrame;
		leftSliderButtonImage.frame = CGRectOffset(rightFrame, -5, -15);
        
		leftSliderFilter.frame = filterFrame;
		[super layoutSubviews];

        //cжимаем бэкграунд панели для рестайлинга подложки кнопочной панели (закладок) инбокса
        contentPanelBack.frame = CGRectOffset(CGRectInset(contentPanel.bounds, 0, 12), 0, -12);
        
	}
    slidingInProgress = NO;
}

- (void)layoutContentPanel {
	float contentPanelOffset = (leftSlidingPanel.frame.origin.x + leftSlidingPanel.frame.size.width);
	CGRect initialFrame = [self contentPanelInitialFrame];
	if ([self isInPortraitOrientation]) {
        contentPanel.frame = CGRectInset(CGRectMake(contentPanelOffset, initialFrame.origin.y, self.frame.size.width - contentPanelOffset, initialFrame.size.height), 5.0f, 0.0f);	
    }
    else {
        contentPanel.frame = CGRectOffset(CGRectInset(CGRectMake(contentPanelOffset, initialFrame.origin.y, self.frame.size.width - contentPanelOffset, initialFrame.size.height), -4.0f, 0.0f), -9.0f, 0.0f);	        
    }
}

- (void)layoutContentBodyPanel {  
    float trayButtonsHeight = 26.0f;
    /*add 10px margin around body content*/
    contentBodyPanel.frame = 
        CGRectOffset(CGRectInset(contentPanel.bounds, 10.0f, 10.0f + trayButtonsHeight/2), 0.0f, -trayButtonsHeight/2);
    
    float trayButtonsPanelWidth = 455.0f + 10.0f; //4 buttons + зазор для подложки
    float trayButtonsPanelHeight = trayButtonsHeight + 7.0f; //button height + зазор для подложки
    float trayButtonsPanelOriginY = CGRectGetMaxY(contentBodyPanel.frame) + 2.0f;
    float trayButtonsPanelOriginX = contentPanel.bounds.size.width/2 - trayButtonsPanelWidth/2 - 2.0f;
	trayButtonsPanel.frame = CGRectMake(trayButtonsPanelOriginX, 
                                        trayButtonsPanelOriginY, 
                                        trayButtonsPanelWidth,
                                        trayButtonsPanelHeight);    
}

- (void)slideLeftPanel {
	slidingInProgress = YES;
	float slideOffset = 
        ((inboxListPanelSlidedOff) ? 1 : -1) * (constTaskListPanelWidthLandscapeNormal - constTaskListPanelWidthLandscapeSlidedOff);    
	[self slideItemsListByOffset:slideOffset];
	inboxListPanelSlidedOff = !inboxListPanelSlidedOff;
	[self toggleLeftSliderImage];
}

- (void)slideItemsListByOffset:(float)offset {
	NSLog(@"slideItemsListByOffset");    
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3f];
	
	CGRect taskListPanelFrame = leftSlidingPanel.frame;
	taskListPanelFrame.origin.x = taskListPanelFrame.origin.x + offset;
	leftSlidingPanel.frame = taskListPanelFrame;
	
	CGRect taskPanelFrame = contentPanel.frame;
	taskPanelFrame.origin.x = taskPanelFrame.origin.x + offset;
	taskPanelFrame.size.width = taskPanelFrame.size.width - offset;
	contentPanel.frame = taskPanelFrame;
    [UIView commitAnimations];	
}

- (void)dealloc {
    [inboxModuleHeaderTitle release];
    [showInboxListPopoverButton release];
    [showInboxListPopoverButtonTitle release];
    [navigateHomeButton release];
    [actionsPopoverButton release];
    [upButton release];
    [downButton release];
    
    [syncButton release];
    [syncButtonHint release];
    [syncButtonValue release];

    [toolsButton release];
    [toolsButtonHint release];
    [toolsButtonValue release];    
    
	[leftTopToolbarButtonsPanel release];
 	[rightTopToolbarButtonsPanel release];   
	[leftSliderFilter release];
    [leftSliderFooter release];
	[leftSliderBody release];
	[leftSliderButton release];
	[leftSliderButtonImage release];
	[leftSlidingPanel release];
    [actionsPanel release];
    
    [super dealloc];
}


@end
