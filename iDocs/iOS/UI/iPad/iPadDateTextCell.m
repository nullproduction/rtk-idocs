//
//  iPadDateTextCell.m
//  iDoc
//
//  Created by Dmitry Likhachev on 2/22/09.
//  Copyright 2009 KORUS Consulting. All rights reserved.
//

#import "iPadDateTextCell.h"
#import "Constants.h"
#import "iPadThemeBuildHelper.h"

@implementation iPadDateTextCell

- (id)initWithStyle:(UITableViewCellStyle)UITableViewCellStyle reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier])) {
		self.accessoryType = UITableViewCellAccessoryNone;
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 5, 
															   140.0f, 
															   self.contentView.bounds.size.height - 10.0f)];
		titleLabel.textColor = [iPadThemeBuildHelper titleForValueFontColor];
		titleLabel.font = [UIFont systemFontOfSize:constLargeFontSize];
		titleLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight;			
		titleLabel.backgroundColor = [UIColor clearColor];	
		[self.contentView addSubview:titleLabel];		
		
		dateTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(200.0f, 5, 
																  self.contentView.bounds.size.width - 240.0f, 
																  self.contentView.bounds.size.height - 10.0f)];
		dateTextLabel.textColor = [iPadThemeBuildHelper commonTextFontColor1];
		dateTextLabel.textAlignment = UITextAlignmentRight;
		dateTextLabel.font = [UIFont boldSystemFontOfSize:constLargeFontSize];
		dateTextLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;			
		dateTextLabel.backgroundColor = [UIColor clearColor];	
		[self.contentView addSubview:dateTextLabel];
    }
    return self;
}

- (void)setValue:(NSString *)value {
	dateTextLabel.text = value;
}

- (void)setTitle:(NSString *)title {
	titleLabel.text = title;
}

- (NSString *)value {
	return dateTextLabel.text;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (void)layoutSubviews{
	[super layoutSubviews];
//	dateTextLabel.frame = self.bounds;
}

- (void)dealloc {
	[dateTextLabel release];
	[titleLabel release];

    [super dealloc];
}

@end
