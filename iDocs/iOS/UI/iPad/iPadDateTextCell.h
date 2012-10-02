//
//  iPadDateTextCell.h
//  iDoc
//
//  Created by Dmitry Likhachev on 2/22/09.
//  Copyright 2009 KORUS Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFSUITableViewCell.h"

@interface iPadDateTextCell: HFSUITableViewCell {
	UILabel *dateTextLabel;
	UILabel *titleLabel;
}

- (void)setTitle:(NSString *)title;
- (void)setValue:(NSString *)value;
- (NSString *)value;

@end
