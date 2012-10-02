//
//  iPadListItemCell.m
//  iDoc
//
//  Created by Dmitry Likhachev on 2/22/09.
//  Copyright 2009 KORUS Consulting. All rights reserved.
//

#import "iPadListItemCell.h"
#import "Constants.h"
#import "iPadThemeBuildHelper.h"

@implementation iPadListItemCell

- (id)initWithStyle:(UITableViewCellStyle)UITableViewCellStyle reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier])) {
		self.accessoryType = UITableViewCellAccessoryNone;
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		self.backgroundColor = [UIColor clearColor];
		self.opaque = NO;
		
		cellIdLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 0.0f, 0.0f)];
		cellIdLabel.hidden = YES;
		[[self contentView] addSubview:cellIdLabel];
		
		valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 20.0f, 300.0f, 20.0f)];
		valueLabel.hidden = YES;
		valueLabel.opaque = YES;
		valueLabel.enabled = YES;
		valueLabel.font = [UIFont systemFontOfSize:constLargeFontSize];
		valueLabel.textColor = [iPadThemeBuildHelper commonTextFontColor1];        
		valueLabel.textAlignment = UITextAlignmentLeft;
		valueLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;			
		valueLabel.backgroundColor = [UIColor clearColor];		
		[[self contentView] addSubview:valueLabel];
    }
    return self;
}

- (void)setCellId:(NSString *)cellId {
	cellIdLabel.hidden = YES;
	cellIdLabel.text = cellId;	
}

- (void)setValue:(NSString *)value {
	valueLabel.hidden = NO;
	valueLabel.text = value;	
}

- (NSString *)value {
	return valueLabel.text;
}
 
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)dealloc {
	[cellIdLabel release];	
	[valueLabel release];
    [super dealloc];
}


@end
