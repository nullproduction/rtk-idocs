//
//  iPadInboxModuleLayoutView.m
//  iDoc
//
//  Created by mark2 on 12/19/10.
//  Copyright 2010 KORUS Consulting. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "iPadDocModuleLayoutView.h"
#import "Constants.h"
#import "SupportFunctions.h"
#import "iPadThemeBuildHelper.h"
#import "iPadDocModuleViewController.h"

@interface iPadDocModuleLayoutView (PrivateMethods)
- (void)slideItemsListByOffset:(float)offset;
- (void)toggleLeftSliderImage;
@end

@implementation iPadDocModuleLayoutView

@synthesize leftSlidingPanel, leftSliderFilter, leftSliderBody, leftSliderFooter, leftSliderButton, leftTopToolbarButtonsPanel, 
			leftSliderButtonImage, showDocListPopoverButton, showDocListPopoverButtonTitle, navigateHomeButton, docModuleHeaderTitle,
			rightTopToolbarButtonsPanel, actionsPopoverButton, upButton, downButton, syncButton, toolsButton,
            syncButtonHint, toolsButtonHint, syncButtonValue, toolsButtonValue;

- (id)init {
	if ((self = [super init])) {
		docListPanelSlidedOff = NO;
		slidingInProgress = NO;
		
        //left top toolbar
        UIView *tmpView = [[UIView alloc] init];
		self.leftTopToolbarButtonsPanel = tmpView;
        [tmpView release];

		self.docModuleHeaderTitle = [HFSUILabel labelWithFrame:CGRectZero 
                                                       forText:nil 
                                                     withColor:[iPadThemeBuildHelper commonHeaderFontColor1] 
                                                     andShadow:nil];
		docModuleHeaderTitle.font = [UIFont boldSystemFontOfSize:constLargeFontSize];
		docModuleHeaderTitle.autoresizingMask = UIViewAutoresizingNone;
		[leftTopToolbarButtonsPanel addSubview:docModuleHeaderTitle];
		
		self.showDocListPopoverButton = [HFSUIButton prepareButtonWithBackImage:[iPadThemeBuildHelper nameForImage:@"show_list_button.png"] 
                                                                     caption:constEmptyStringValue
                                                                captionColor:[iPadThemeBuildHelper commonButtonFontColor2]
                                                          captionShadowColor:[iPadThemeBuildHelper commonShadowColor2]
                                                                        icon:nil];
		showDocListPopoverButton.buttonTitle.font = [UIFont boldSystemFontOfSize:constMediumFontSize];
        showDocListPopoverButton.buttonTitle.textAlignment = UITextAlignmentCenter;        
		self.showDocListPopoverButtonTitle = showDocListPopoverButton.buttonTitle;
		[leftTopToolbarButtonsPanel addSubview:showDocListPopoverButton];
		
		self.navigateHomeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *iconHome = [UIImage imageNamed:[iPadThemeBuildHelper nameForImage:@"icon_home.png"]];
		[navigateHomeButton setImage:iconHome forState:UIControlStateNormal];
		[leftTopToolbarButtonsPanel addSubview:navigateHomeButton];	
        
		[self addSubview:leftTopToolbarButtonsPanel];
		
        //right right toolbar
        tmpView = [[UIView alloc] init];
        self.rightTopToolbarButtonsPanel = tmpView;
        [tmpView release];
        
        self.actionsPopoverButton = [HFSUIButton prepareButtonWithBackImageForNormalState:[iPadThemeBuildHelper nameForImage:@"add_btn_normal.png"] 
                                                                backImageForSelectedState:[iPadThemeBuildHelper nameForImage:@"add_btn_selected.png"]];
        
        self.upButton = [HFSUIButton prepareButtonWithBackImageForNormalState:[iPadThemeBuildHelper nameForImage:@"up_btn_normal.png"] 
                                                    backImageForSelectedState:[iPadThemeBuildHelper nameForImage:@"up_btn_selected.png"]]; 
        self.downButton = [HFSUIButton prepareButtonWithBackImageForNormalState:[iPadThemeBuildHelper nameForImage:@"down_btn_normal.png"] 
                                                      backImageForSelectedState:[iPadThemeBuildHelper nameForImage:@"down_btn_selected.png"]]; 
        
        [self.rightTopToolbarButtonsPanel addSubview:self.actionsPopoverButton];
        [rightTopToolbarButtonsPanel addSubview:upButton];
        [rightTopToolbarButtonsPanel addSubview:downButton];
        
        [self addSubview:rightTopToolbarButtonsPanel];
		
        //left slider
        tmpView = [[UIView alloc] init];
		self.leftSlidingPanel = tmpView;
        [tmpView release];
		UIImageView *sliderBack = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[iPadThemeBuildHelper nameForImage:@"left_slider_back.png"]]];
		sliderBack.contentMode = UIViewContentModeTopLeft;
		
        tmpView = [[UIView alloc] init];
		self.leftSliderFilter = tmpView;
        [tmpView release];
		UIImageView *sliderFilterBack = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[iPadThemeBuildHelper nameForImage:@"filter_form_back.png"]]];
		sliderFilterBack.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		sliderFilterBack.frame = leftSliderFilter.bounds;
		sliderFilterBack.contentMode = UIViewContentModeCenter;
		
        tmpView = [[UIView alloc] init];
		self.leftSliderBody = tmpView;
        [tmpView release];
		self.leftSliderBody.layer.cornerRadius = constCornerRadius;
		self.leftSliderBody.clipsToBounds = YES;
        
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
        self.syncButtonValue = [HFSUILabel labelWithFrame:CGRectZero forText:constEmptyStringValue 
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
                
        [leftSliderFooter addSubview:syncButton];
        [leftSliderFooter addSubview:toolsButton];
        
        [leftSliderFooter addSubview:syncButtonHint];
        [leftSliderFooter addSubview:syncButtonValue];
        [leftSliderFooter addSubview:toolsButtonHint];
        [leftSliderFooter addSubview:toolsButtonValue];
		
        //кнопка свернуть-развернуть левую панель
        tmpView = [[UIView alloc] init];
		self.leftSliderButton = tmpView;
        [tmpView release];
		
        UIImage *image = [UIImage imageNamed:[iPadThemeBuildHelper nameForImage:@"left_slider_collapser.png"]];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
		self.leftSliderButtonImage = imageView;
        [imageView release];
		leftSliderButtonImage.contentMode = UIViewContentModeCenter;
		

        //сборка левой панели:
		[leftSlidingPanel addSubview:sliderBack];
		[leftSliderFilter addSubview:sliderFilterBack];
		
		[leftSlidingPanel addSubview:leftSliderFilter];
		[leftSlidingPanel addSubview:leftSliderBody];
		[leftSlidingPanel addSubview:leftSliderFooter];
		[leftSlidingPanel addSubview:leftSliderButton];
		[leftSlidingPanel addSubview:leftSliderButtonImage];
        
		[self addSubview:leftSlidingPanel];		        		
        
		[sliderBack release];
		[sliderFilterBack release];        
	}
	return self;
}

- (void)toggleLeftSliderImage {
	if (docListPanelSlidedOff) {
		[leftSliderButtonImage setImage:[UIImage imageNamed:[iPadThemeBuildHelper nameForImage:@"left_slider_expander.png"]]];
	}
	else {
		[leftSliderButtonImage setImage:[UIImage imageNamed:[iPadThemeBuildHelper nameForImage:@"left_slider_collapser.png"]]];
	}

}

- (void)layoutSubviews {
	leftTopToolbarButtonsPanel.frame = CGRectMake(0.0f, 0.0f, 475.0f, 59.0f);	
	navigateHomeButton.frame = CGRectMake(0.0f, 0.0f, 59.0f, 59.0f);
	docModuleHeaderTitle.frame = CGRectMake(65.0f, 14.0f, 700.0f, 31.0f);
	showDocListPopoverButton.frame = CGRectMake(65.0f, 10.0f, 218.0f, 38.0f);
    	
	if ([self isInPortraitOrientation]) {
		docModuleHeaderTitle.hidden = YES;
		showDocListPopoverButton.hidden = NO;
	}
	else {
		docModuleHeaderTitle.hidden = NO;
		showDocListPopoverButton.hidden = YES;		
	}
    
    rightTopToolbarButtonsPanel.frame = CGRectMake(self.bounds.size.width - 177.0f, 0.0f, 182.0f, 58.0f);
    
    self.actionsPopoverButton.frame = CGRectMake(0.0f, 9.0f, 59.0f, 40.0f);
    self.upButton.frame = CGRectMake(69.0f, 9.0f, 50.0f, 40.0f);
    self.downButton.frame = CGRectMake(119.0f, 9.0f, 48.0f, 40.0f);
    
    float initialOffsetX = 0.0f;
	if ([self isInPortraitOrientation]) {/* portrait */
		initialOffsetX = -constTaskListPanelWidthLandscapeNormal; /* hidden */
	} else if (docListPanelSlidedOff) {
		initialOffsetX = -(constTaskListPanelWidthLandscapeNormal - constTaskListPanelWidthLandscapeSlidedOff);
	}
    
	CGRect initialFrame = [self contentPanelInitialFrame];
	if(!slidingInProgress){/* layout allready done in animation cycle */		
		CGRect leftSliderBounds = CGRectMake(0,0, constTaskListPanelWidthLandscapeNormal, initialFrame.size.height);
		CGRect leftFrame, rightFrame, filterFrame, bodyFrame, footerFrame;
		
        CGRectDivide(leftSliderBounds, &leftFrame,&rightFrame, leftSliderBounds.size.width - constTaskListPanelWidthLandscapeSlidedOff, CGRectMinXEdge);
		
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
    contentBodyPanel.frame = CGRectInset(self.contentPanel.bounds, 10.0f, 10.0f); /*add 10px margin around body content*/
}

- (void)slideLeftPanel {
	slidingInProgress = YES;
	float slideOffset = 
        ((docListPanelSlidedOff) ? 1 : -1) * (constTaskListPanelWidthLandscapeNormal - constTaskListPanelWidthLandscapeSlidedOff);    
	[self slideItemsListByOffset:slideOffset];
	docListPanelSlidedOff = !docListPanelSlidedOff;
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
	
	CGRect taskPanelFrame = self.contentPanel.frame;
	taskPanelFrame.origin.x = taskPanelFrame.origin.x + offset;
	taskPanelFrame.size.width = taskPanelFrame.size.width - offset;
	self.contentPanel.frame = taskPanelFrame;
    [UIView commitAnimations];	
}

- (void)dealloc {
    self.docModuleHeaderTitle = nil;
    self.showDocListPopoverButton = nil;
    self.showDocListPopoverButtonTitle = nil;
    self.navigateHomeButton = nil;
    self.actionsPopoverButton = nil;
    self.upButton = nil;
    self.downButton = nil;
    
    self.actionsPopoverButton = nil;
    self.syncButton = nil;
    self.syncButtonHint = nil;
    self.syncButtonValue = nil;

    self.toolsButton = nil;
    self.toolsButtonHint = nil;
    self.toolsButtonValue = nil;    
    
	self.leftTopToolbarButtonsPanel = nil;
 	self.rightTopToolbarButtonsPanel = nil;   
	self.leftSliderFilter = nil; 
    self.leftSliderFooter = nil; 
	self.leftSliderBody = nil; 
	self.leftSliderButton = nil; 
	self.leftSliderButtonImage = nil; 
	self.leftSlidingPanel = nil; 
    
    [super dealloc];
}

@end
