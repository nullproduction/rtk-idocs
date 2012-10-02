//
//  iPadTextViewCell.h
//  iDoc
//
//  Created by Dmitry Likhachev on 2/22/09.
//  Copyright 2009 KORUS Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFSUITableViewCell.h"

@interface iPadTextViewCell: HFSUITableViewCell {
	UILabel *titleLabel;	
	UILabel *valueLabel;
}

- (void)setTitle:(NSString *)title;
- (void)setValue:(NSString *)value forAccessType:(int)accessType;

@end
