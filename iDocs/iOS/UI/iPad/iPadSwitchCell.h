//
//  iPadSwitchCell.h
//  iDoc
//
//  Created by mark2 on 2/3/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFSUITableViewCell.h"

@protocol iPadSwitchCellDelegate<NSObject>

- (void)switchedTo:(BOOL)onOff;

@end

@interface iPadSwitchCell : HFSUITableViewCell {
	UISwitch *onOffSwitch;
	id<iPadSwitchCellDelegate>delegate;
}

@property (nonatomic,retain) UILabel *titleLabel;

- (void)setDelegate:(id<iPadSwitchCellDelegate>)newDelegate;
- (void)setTitle:(NSString *)title;
- (void)setValue:(BOOL)value;
- (BOOL)value;

@end
