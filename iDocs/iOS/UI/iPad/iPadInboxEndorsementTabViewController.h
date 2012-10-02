//
//  iPadInboxExecutionTabViewController.h
//  iDoc
//
//  Created by rednekis on 10-12-19.
//  Copyright 2010 KORUS Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iPadBaseViewController.h"
#import "iPadDocEndorsementCell.h"
#import "iPadInboxEndorsementTabLayoutView.h"
#import "HFSUILabel.h"


@interface iPadInboxEndorsementTabViewController : iPadBaseViewController <UITableViewDelegate, UITableViewDataSource> {
	UITableView *endorsementTableView;
	float endorsementTableSectionHeight;
	iPadInboxEndorsementTabLayoutView *container;
	
	NSArray *endorsementGroups;
	NSString *currentErrandId;	
}

- (id)initWithPlaceholderPanel:(UIView *)placeholderPanel;
- (void)loadTabData:(NSArray *)newEndorsementGroups;
@end
