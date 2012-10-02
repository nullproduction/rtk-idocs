//
//  iPadDocViewCell.h
//  iDoc
//
//  Created by Michael Syasko on 6/14/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFSUITableViewCell.h"
#import "HFSGradientView.h"

@interface iPadDocViewCell : UITableViewCell {	
	UILabel *fileName;
	UILabel *timeValue;
    UILabel *sizeValue;
    BOOL isSelected;
    HFSGradientView *selectionBack;
}

- (void)setFileName:(NSString *)fName;
- (void)setTimeValue:(NSString *)tValue;
- (void)setSizeValue:(NSString *)sValue;

@end


