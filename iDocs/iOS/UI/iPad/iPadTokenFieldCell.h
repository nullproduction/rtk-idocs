//
//  iPadTokenFieldCell.h
//  iDoc
//
//  Created by mark2 on 7/27/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iPadTitleValueCell.h"
#import "TITokenFieldView.h"

@interface iPadTokenFieldCell : UITableViewCell {
	UILabel *titleLabel;
	UILabel *valueLabel;
    TITokenFieldView *tokenField;
}

@property (nonatomic, readonly) TITokenFieldView *tokenField;

- (void)setTitle:(NSString *)title;
- (void)setTokenViewDelegate:(id<TITokenFieldViewDelegate>)newDelegate;
- (void)addValue:(NSString *)value withValueId:(NSString *)valueId forAccessType:(int)accessType;

@end
