//
//  iPadSwitchCell.m
//  iDoc
//
//  Created by mark2 on 2/3/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import "iPadSwitchCell.h"
#import "Constants.h"
#import "iPadThemeBuildHelper.h"

@implementation iPadSwitchCell

@synthesize titleLabel;

- (id)initWithStyle:(UITableViewCellStyle)UITableViewCellStyle reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier])) {
		self.accessoryType = UITableViewCellAccessoryNone;
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		UILabel* titleLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(40, 5,
                                                             140.0f,
                                                             self.contentView.bounds.size.height - 10.0f)];

        self.titleLabel = titleLabel_;
		[titleLabel_ release];
        self.titleLabel.textColor = [iPadThemeBuildHelper titleForValueFontColor];
		self.titleLabel.font = [UIFont systemFontOfSize:constLargeFontSize];
		self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight;
		self.titleLabel.backgroundColor = [UIColor clearColor];
		[self.contentView addSubview:self.titleLabel];
		
		
		onOffSwitch = [[UISwitch alloc] init];
		[self.contentView addSubview:onOffSwitch];
	}
	return self;
}		

- (void)setDelegate:(id<iPadSwitchCellDelegate>)newDelegate {
	delegate = newDelegate;
	[onOffSwitch addTarget:self action:@selector(switcherWasSwitched) forControlEvents:UIControlEventValueChanged];
}

- (void)switcherWasSwitched {
	if (delegate != nil) {
		[delegate switchedTo:[onOffSwitch isOn]];
	}
}

- (void)setTitle:(NSString *)title {
	self.titleLabel.text = title;
}

- (void)setValue:(BOOL)value {
	[onOffSwitch setOn:value];
}

- (BOOL)value {
	return [onOffSwitch isOn];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	CGRect switchFrame = CGRectMake(200.0f, 5, 
									self.contentView.bounds.size.width - 240.0f, 
									self.contentView.bounds.size.height - 10.0f);
	onOffSwitch.frame = CGRectMake(switchFrame.origin.x + switchFrame.size.width-onOffSwitch.bounds.size.width, 
								   switchFrame.origin.y + switchFrame.size.height/2-onOffSwitch.bounds.size.height/2, 
								   onOffSwitch.bounds.size.width, 
								   onOffSwitch.bounds.size.height);
	
}

- (void)dealloc {
	self.titleLabel = nil;
	[onOffSwitch release];
    
//    [self setDelegate:nil];
    
    [super dealloc];
}


@end
