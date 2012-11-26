//
//  iPadDateSelectCell.m
//  iDoc
//
//  Created by Dmitry Likhachev on 2/22/09.
//  Copyright 2009 KORUS Consulting. All rights reserved.
//

#import "iPadDateSelectCell.h"
#import "Constants.h"
#import "iPadThemeBuildHelper.h"

#define disclosureIndicatorIcon [iPadThemeBuildHelper nameForImage:@"accessory_disclosure_arrow.png"]

@implementation iPadDateSelectCell

- (id)initWithStyle:(UITableViewCellStyle)UITableViewCellStyle reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier])) {		
		self.selectionStyle = UITableViewCellSelectionStyleNone;	
		
		titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(18.0f, 5.0f, 100.0f, self.contentView.bounds.size.height-10.0f)];
		titleLabel.hidden = YES;
		titleLabel.opaque = YES;
		titleLabel.enabled = YES;
		titleLabel.font = [UIFont systemFontOfSize:constMediumFontSize];
		titleLabel.textColor = [iPadThemeBuildHelper titleForValueFontColor];
		titleLabel.textAlignment = UITextAlignmentLeft;
		titleLabel.backgroundColor = [UIColor clearColor];
		titleLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight;			
		[[self contentView] addSubview:titleLabel];
		
		valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(122.0f, 5.0f, self.contentView.bounds.size.width - 122.0f, self.contentView.bounds.size.height-10.0f)];
		valueLabel.hidden = YES;
		valueLabel.opaque = YES;
		valueLabel.enabled = YES;
		valueLabel.numberOfLines = 1;
		valueLabel.font = [UIFont systemFontOfSize:constMediumFontSize];
		valueLabel.textColor = [iPadThemeBuildHelper commonTextFontColor1];		
		valueLabel.textAlignment = UITextAlignmentLeft;
		valueLabel.backgroundColor = [UIColor clearColor];
		valueLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;			
		[[self contentView] addSubview:valueLabel];
    }
    return self;
}

- (void)setValue:(NSString *)value withAccessType:(int)accessType {
	valueLabel.text = value;		
    valueLabel.hidden = NO;
    if (accessType >= constAccessTypeViewWithLinks) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else {			
        self.accessoryType = UITableViewCellAccessoryNone;
    }
}

- (void)prepareAccessoryDisclosureIndicator {
	disclosureIndicatorButton = [HFSUIButton prepareButtonWithIconForNormalState:disclosureIndicatorIcon 
                                                            iconForSelectedState:disclosureIndicatorIcon 
                                                                         caption:nil
                                                                    captionColor:nil
                                                              captionShadowColor:nil];
    disclosureIndicatorButton.contentMode = UIViewContentModeCenter;
	disclosureIndicatorButton.backgroundColor = [iPadThemeBuildHelper commonHeaderBackColor];
	disclosureIndicatorButton.frame = CGRectInset(CGRectMake(0.0f, 
                                                             0.0f, 
                                                             disclosureIndicatorButton.buttonIconView.bounds.size.width + 7.0f, 
                                                             self.bounds.size.height), 
                                                  0.0f, 1.0f);
	[disclosureIndicatorButton addTarget:self action:@selector(accessoryDisclosureIndicatorTapped:withEvent:) forControlEvents:UIControlEventTouchUpInside];
	
	self.accessoryView = disclosureIndicatorButton;
	self.accessoryView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;	
}

- (void)setAccessoryViewFrame {
    if (self.accessoryView == nil) 
        return;
    self.accessoryView.frame = CGRectMake(self.frame.size.width - self.accessoryView.frame.size.width - 18.0f, 
                                          0.0f, 
                                          self.accessoryView.frame.size.width, 
                                          self.frame.size.height);
}

- (void)setTitle:(NSString *)title {
	titleLabel.hidden = NO;
	titleLabel.text = title;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)dealloc {	
	[titleLabel release];
	[valueLabel release];
    
    [super dealloc];
}

@end

