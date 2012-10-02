//
//  iPadPopupLayoutView.m
//  iDoc
//
//  Created by mark2 on 12/23/10.
//  Copyright 2010 KORUS Consulting. All rights reserved.
//

#import "iPadPopupLayoutView.h"
#import "Constants.h"
#import "iPadThemeBuildHelper.h"
#import <QuartzCore/QuartzCore.h>

#define HFS_EMPL_LIST_VIEW_TAG 876

@implementation iPadPopupLayoutView

@synthesize modalPopupTitle, containerView;

- (id)init {
    if ((self = [super init])) {
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.clipsToBounds = YES;
        
		modalPanelBack = [[iPadPanelBodyBackgroundView alloc] initWithPrefix:@"modal_popup_background" suffix:@"_panel" tileSize:60.0f];
		modalPanelBack.frame = self.bounds;
		[self addSubview:modalPanelBack];
		
		modalPopupTitle = [HFSUILabel labelWithFrame:CGRectZero 
                                             forText:@"" 
                                           withColor:[iPadThemeBuildHelper commonHeaderFontColor2]
                                          andShadow:[iPadThemeBuildHelper commonShadowColor1]];
		modalPopupTitle.font = [UIFont boldSystemFontOfSize:constLargeFontSize];
		modalPopupTitle.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		[self addSubview:modalPopupTitle];
		
		containerView = [[UIView alloc] init];
		containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        auxContainerView = [[UIView alloc] init];
        auxContainerView.layer.cornerRadius = 5.0f;
        auxContainerView.backgroundColor = [UIColor clearColor];
        auxContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        auxContainerView.clipsToBounds = YES;
        
        auxContentView = [[UIView alloc] init];
        auxContentView.backgroundColor = [[iPadThemeBuildHelper commonPlaceholderBackColor] colorWithAlphaComponent:1.0f];
        auxContentView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		
		[self addSubview:containerView];		
        [self addSubview:auxContainerView];
        [auxContainerView addSubview:auxContentView];
        [self sendSubviewToBack:auxContainerView];

        needsAuxViewLayout = YES;//для начальной инициализации вспомогательного (выезжающего снизу) контейнера
    }
    return self;
}

#pragma mark Main Panel methods
- (void)putContent:(UIView *)contentView {
	contentView.frame = containerView.bounds;
	[containerView addSubview:contentView];
}

- (void)cleanup {
	for (UIView *toRemove in containerView.subviews) {
		[toRemove removeFromSuperview];
	}
}

#pragma mark Aux Panel methods:
- (void)showAuxView:(BOOL)yesNo {
    needsAuxViewLayout = NO;//лэйаут уже проведен, теперь обработка вспомогательного контейнера делается по требованию
    CGRect frame = auxContentView.frame;
    if (yesNo) {
        [auxContainerView.superview bringSubviewToFront:auxContainerView];//контейнер - на передний план
        frame.origin.y = 0;//контент внутри контейнера - вверх
        [UIView animateWithDuration:0.7 animations:^{[auxContentView setFrame:frame];}];
    }
    else {
        [auxContainerView.superview sendSubviewToBack:auxContainerView];//контейнер - на задний план
        UIView *subview = [auxContentView viewWithTag:HFS_EMPL_LIST_VIEW_TAG];
        if (subview != nil) {
            [subview removeFromSuperview];
        }        
        frame.origin.y = auxContainerView.bounds.size.height;    
        [auxContentView setFrame:frame];//анимация не нужна
    }    
}

- (void)setAuxViewContent:(UIView *)auxContent {
    auxContent.tag = HFS_EMPL_LIST_VIEW_TAG;
    auxContent.frame = CGRectInset(auxContentView.bounds,10,10);
    [auxContentView addSubview:auxContent];
}

#pragma mark UIView methods:
- (void)layoutSubviews {
	[super layoutSubviews];
	modalPanelBack.frame = self.bounds;
	modalPopupTitle.frame = CGRectMake(15, 0, self.bounds.size.width-30, 60);
	containerView.frame = self.bounds;	
    auxContainerView.frame = CGRectOffset(CGRectInset(self.bounds, 15.5f, 72), -1, 54);
    if (needsAuxViewLayout) {
        auxContentView.frame = CGRectOffset(auxContainerView.bounds,0,auxContainerView.bounds.size.height);//задвигаем за край
    }
    needsAuxViewLayout = YES;
}

- (void)dealloc {
	[modalPanelBack release];
	[containerView release];
    [auxContainerView release];
    [auxContentView release];
    
	[super dealloc];
}


@end
