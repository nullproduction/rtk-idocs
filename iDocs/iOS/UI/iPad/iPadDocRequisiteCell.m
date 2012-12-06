//
//  iPadDocRequisiteCell.m
//  iDoc
//
//  Created by Dmitry Likhachev on 2/22/09.
//  Copyright 2009 KORUS Consulting. All rights reserved.
//

#import "iPadDocRequisiteCell.h"
#import "Constants.h"
#import "iPadThemeBuildHelper.h"

@implementation iPadDocRequisiteCell

- (id)initWithStyle:(UITableViewCellStyle)UITableViewCellStyle reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier])) {		
		self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
        
		requisiteName = [[UILabel alloc] initWithFrame:CGRectMake(18.0f, 5.0f, 225.0f, self.contentView.bounds.size.height - 10.0f)];
		requisiteName.opaque = YES;
		requisiteName.enabled = YES;
		requisiteName.textColor = [iPadThemeBuildHelper commonTextFontColor1];		
		requisiteName.font = [UIFont systemFontOfSize:constMediumFontSize];
		requisiteName.textAlignment = UITextAlignmentLeft;
		requisiteName.backgroundColor = [UIColor clearColor];
		requisiteName.autoresizingMask = UIViewAutoresizingNone;			
		[[self contentView] addSubview:requisiteName];
		
		requisiteValue = [[UILabel alloc] initWithFrame:CGRectMake(235.0f, 5.0f, self.contentView.bounds.size.width - 122.0f, self.contentView.bounds.size.height-10.0f)];
		requisiteValue.opaque = YES;
		requisiteValue.enabled = YES;
		requisiteValue.textColor = [iPadThemeBuildHelper commonTextFontColor1];		
		requisiteValue.font = [UIFont systemFontOfSize:constMediumFontSize];
		requisiteValue.textAlignment = UITextAlignmentLeft;
		requisiteValue.backgroundColor = [UIColor clearColor];
		requisiteValue.autoresizingMask = UIViewAutoresizingFlexibleWidth;			
		[[self contentView] addSubview:requisiteValue];
    }
    return self;
}

- (void)setRequisiteName:(NSString *)name {
    requisiteName.text = (name != nil) ? name : constEmptyStringValue;;
}

- (void)setRequisiteValue:(NSString *)value {
    requisiteValue.text = (value != nil) ? value : constEmptyStringValue;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)dealloc {
	[requisiteName release];	
	[requisiteValue release];
    
    [super dealloc];
}

@end

