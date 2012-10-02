//
//  HFSUITableViewCell.h
//  iDoc
//
//  Created by rednekis on 10-12-24.
//  Copyright 2010 KORUS Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFSUIButton.h"

@interface HFSUITableViewCell : UITableViewCell {	
	HFSUIButton *disclosureIndicatorButton;
	HFSUIButton *accessoryCheckmarkButton;
	BOOL isAccessoryCheckmarkChecked;
}

- (void)setBackgroundStyleForRow:(int)row;
- (void)setAccessoryCheckmarkChecked:(BOOL)isChecked;
- (BOOL)isAccessoryCheckmarkChecked;
- (void)enableAccessoryCheckmark:(BOOL)enable;
- (void)prepareAccessoryDisclosureIndicator;
- (void)setAccessoryViewFrame;
@end
