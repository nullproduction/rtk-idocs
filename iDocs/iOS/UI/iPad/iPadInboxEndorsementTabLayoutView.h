//
//  iPadInboxEndorsementTabLayoutView.h
//  iDoc
//
//  Created by mark2 on 12/21/10.
//  Copyright 2010 KORUS Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseLayoutView.h"

@interface iPadInboxEndorsementTabLayoutView : BaseLayoutView {
	UIView *tableHeaderPlaceholder;
	UIView *tablePlaceholder;
	UIView *headerBottomBorder;	
	HFSUILabel *tableHeader1;
	HFSUILabel *tableHeader2;
	HFSUILabel *tableHeader3;
	HFSUILabel *tableHeader4;
	HFSUILabel *tableHeader5;
	HFSUILabel *tableHeader6;	
}

@property(nonatomic, retain) UIView *tableHeaderPlaceholder;
@property(nonatomic, retain) UIView *tablePlaceholder;

@end
