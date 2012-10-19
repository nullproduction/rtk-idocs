//
//  iPadReportInfoCell.h
//  iDoc
//
//  Created by Olga Geets on 17.10.12.
//  Copyright (c) 2012 KORUS Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iPadThemeBuildHelper.h"
#import "Constants.h"
#import "HFSGradientView.h"
#import "iPadPanelBodyBackgroundView.h"
#import "HFSUITableViewCell.h"


@interface iPadReportInfoCell : HFSUITableViewCell {
    UILabel *nameReport;
    UIImageView* checkReport;
    UIImageView* attachment;
}

- (void)setNameReport:(NSString *)name;
- (void)setChecked:(BOOL)check;
- (void)setAttachment:(BOOL)attach;
- (BOOL)isChecked;

@end
