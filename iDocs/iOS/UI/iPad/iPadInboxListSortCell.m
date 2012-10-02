//
//  iPadInboxListSortCell.m
//  iDoc
//
//  Created by mark2 on 6/12/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import "iPadInboxListSortCell.h"
#import "Constants.h"
#import "iPadThemeBuildHelper.h"

@implementation iPadInboxListSortCell

- (id)initWithReuseIdentifier:(NSString *)identifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    if (self) {
        // Initialization code
        self.textLabel.font = [UIFont systemFontOfSize:constMediumFontSize];
        self.textLabel.textColor = [iPadThemeBuildHelper commonTextFontColor4];
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    if (selected) {
        UIImageView *checkMark = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[iPadThemeBuildHelper nameForImage:@"green_checkbox_even_icon.png"]]];
        self.accessoryView = checkMark;
        [checkMark release];
    }
    else {
        self.accessoryView = nil;
    }
    // Configure the view for the selected state
}

- (void)dealloc
{
    [super dealloc];
}

@end
