//
//  iPadTitleValueCell.h
//  iDoc
//
//  Created by Dmitry Likhachev on 02/09/10.
//  Copyright 2010 KORUS Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFSUITableViewCell.h"

@interface iPadTitleValueCell: HFSUITableViewCell {	
	UILabel *titleLabel;
	UILabel *valueLabel;
	UILabel *viewLabel;
}

- (void)setTitle:(NSString *)title;
- (void)initValueView:(NSString *)view withValue:(NSString *)value forAccessType:(int)accessType;
@end


