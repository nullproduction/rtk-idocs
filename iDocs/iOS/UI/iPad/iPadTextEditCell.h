//
//  iPadTextEditCell.h
//  iDoc
//
//  Created by Dmitry Likhachev on 2/22/09.
//  Copyright 2009 KORUS Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iDocUITextView.h"
#import "HFSUILabel.h"

@interface iPadTextEditCell: UITableViewCell {
	HFSUILabel *titleLabel;
	iDocUITextView *dataTextView;
	UILabel *valueLabel;
	int currentAccessType;

}
- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;
- (void)setDelegate:(id<UITextViewDelegate>)newDelegate;
- (void)initValueView:(NSString *)value forAccessType:(int)accessType;
- (void)setTitle:(NSString *)title;
- (void)setValue:(NSString *)value;
- (NSString *)value;


@end
