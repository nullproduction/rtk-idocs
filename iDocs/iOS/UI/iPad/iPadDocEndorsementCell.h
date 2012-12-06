//
//  iPadTaskEndorsementCell.h
//  iDoc
//
//  Created by Dmitry Likhachev on 1/31/10.
//  Copyright 2009 KORUS Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFSUITableViewCell.h"

@interface iPadDocEndorsementCell: HFSUITableViewCell {
	UIImageView *statusImage;
}

+ (NSArray *)prepareCellFrames:(CGRect)rowFrame;

- (void)setStatusImage:(NSString *)imageName;

@property (nonatomic,retain) UILabel *positionLabel;
@property (nonatomic,retain) UILabel *personLabel;
@property (nonatomic,retain) UILabel *decisionLabel;
@property (nonatomic,retain) UILabel *dateLabel;
@property (nonatomic,retain) UILabel *commentLabel;

@end
