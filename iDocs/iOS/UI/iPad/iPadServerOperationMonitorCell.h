//
//  iPadServerOperationMonitorCell.h
//  Medi_Pad
//
//  Created by katrin on 11.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface iPadServerOperationMonitorCell : UITableViewCell

@property (nonatomic, retain) UIImageView *statusIcon;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@end
