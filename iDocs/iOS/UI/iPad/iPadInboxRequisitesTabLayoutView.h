//
//  iPadInboxRequisitesTabLayoutView.h
//  iDoc
//
//  Created by mark2 on 12/21/10.
//  Copyright 2010 KORUS Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseLayoutView.h"
#import "HFSUILabel.h"

@interface iPadInboxRequisitesTabLayoutView : BaseLayoutView {

	UIImageView *executorFieldIcon;
	HFSUILabel *executorFieldLabel;
	HFSUILabel *executorName;
	UIView *separator;
	HFSUILabel *taskDocDescription;	
	UIView *requisitesTablePlaceholder;

}

@property(nonatomic,retain) UIImageView *executorFieldIcon;
@property(nonatomic,retain) HFSUILabel *executorFieldLabel;
@property(nonatomic,retain) HFSUILabel *executorName;
@property(nonatomic,retain) HFSUILabel *taskDocDescription;
@property(nonatomic,retain) UIView *requisitesTablePlaceholder;
@end
