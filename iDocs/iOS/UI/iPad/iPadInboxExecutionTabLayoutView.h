//
//  iPadInboxExecutionTabLayoutView.h
//  iDoc
//
//  Created by mark2 on 12/21/10.
//  Copyright 2010 KORUS Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseLayoutView.h"
#import "HFSUILabel.h"

@interface iPadInboxExecutionTabLayoutView : BaseLayoutView {
	UIView *tableFilterPlaceholder;
	UIView *tableHeaderPlaceholder;
	UIView *headerBottomBorder;
	HFSUILabel *tableHeader0;
	HFSUILabel *tableHeader1;
	HFSUILabel *tableHeader2;
	HFSUILabel *tableHeader3;
	HFSUILabel *tableHeader4;
	HFSUILabel *tableHeader5;
	HFSUILabel *tableHeader6;
	HFSUILabel *tableHeader7;
	
	UIView *tablePlaceholder;
	HFSUIButton *tableFilterButton;
}

@property(nonatomic, retain) UIView *tableHeaderPlaceholder;
@property(nonatomic, retain) UIView *tablePlaceholder;
@property(nonatomic, retain) HFSUIButton *tableFilterButton;

@end
