//
//  iPadDateSelectCell.h
//  iDoc
//
//  Created by Dmitry Likhachev on 02/09/10.
//  Copyright 2010 KORUS Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFSUITableViewCell.h"

@interface iPadDateSelectCell: HFSUITableViewCell {	
	UILabel *titleLabel;
	UILabel *valueLabel;
}

- (void)setTitle:(NSString *)title;
- (void)setValue:(NSString *)value withAccessType:(int)accessType;
@end


