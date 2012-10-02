//
//  iPadServerOperationMonitorCell.m
//  Medi_Pad
//
//  Created by katrin on 11.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "iPadServerOperationMonitorCell.h"
#import "Constants.h"
#import "HFSUILabel.h"
#import "iPadThemeBuildHelper.h"

@implementation iPadServerOperationMonitorCell
@synthesize statusIcon, activityIndicator;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier])) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.contentView.backgroundColor = [UIColor whiteColor];        
        self.clipsToBounds = YES;
        
        self.textLabel.font = [UIFont systemFontOfSize:constLargeFontSize];
        self.textLabel.textColor = [iPadThemeBuildHelper commonTextFontColor2];
        
        UIImageView *tmpImageView = [[UIImageView alloc] init];
        self.statusIcon = tmpImageView;
        [tmpImageView release];
        statusIcon.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        statusIcon.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:statusIcon];
        
        activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activityIndicator.contentMode = UIViewContentModeCenter;
        activityIndicator.hidesWhenStopped = YES;
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"5.0")) {
            activityIndicator.color = [iPadThemeBuildHelper activityIndicatorColor];
        }
        [self.contentView addSubview:activityIndicator];
        
    }
    return self;
}

- (void)layoutSubviews { 
    [super layoutSubviews];
    
    CGRect statusIconFrame, labelFrame;
    
    CGRectDivide(self.contentView.bounds, &statusIconFrame, &labelFrame, 60.0f, CGRectMinXEdge);
    
    self.textLabel.frame = CGRectOffset(CGRectInset(labelFrame, 4.0f, 0.0f), 4.0f, 0.0f);
    statusIcon.frame = statusIconFrame;
    activityIndicator.frame = statusIconFrame;
}


- (void)dealloc {
    self.activityIndicator = nil;
    self.statusIcon = nil;
    [super dealloc];
}

@end
