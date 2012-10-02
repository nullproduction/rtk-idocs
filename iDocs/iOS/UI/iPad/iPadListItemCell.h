//
//  iPadListItemCell.h
//  iDoc
//
//  Created by Dmitry Likhachev on 2/22/09.
//  Copyright 2009 KORUS Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iPadListItemCell: UITableViewCell {
	UILabel *cellIdLabel;	
	UILabel *valueLabel;
}

- (void)setCellId:(NSString *)cellId;
- (void)setValue:(NSString *)value;
- (NSString *)value;

@end
