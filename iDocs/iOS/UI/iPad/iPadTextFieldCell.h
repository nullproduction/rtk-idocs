//
//  iPadTextFieldCell.h
//  iDoc
//
//  Created by mark2 on 7/5/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iPadPanelBodyBackgroundView.h"

@interface iPadTextFieldCell : UITableViewCell {
    UITextField *valueEditField;
    iPadPanelBodyBackgroundView *backgroundTiledView;
}

@property (nonatomic, retain) NSString *placeholderText;
@property (nonatomic, retain) NSString *valueText;
@property (nonatomic, retain) id<UITextFieldDelegate>delegate;
@property () int valueTag;

@end
