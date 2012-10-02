//
//  iPadTokenFieldCell.m
//  iDoc
//
//  Created by mark2 on 7/27/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import "iPadTokenFieldCell.h"
#import "Constants.h"
#import "iPadThemeBuildHelper.h"

@implementation iPadTokenFieldCell

@synthesize tokenField;

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

        CGRect titleFrame, tokenFieldFrame;
        CGRectDivide(CGRectOffset(CGRectInset(self.contentView.bounds, 18.0f/2, 5.0f), 18.0f/2, 0), &titleFrame, &tokenFieldFrame, 100, CGRectMinXEdge);
        tokenField = [[TITokenFieldView alloc] initWithFrame:tokenFieldFrame 
                                                   titleText:constEmptyStringValue 
                                                  titleColor:[iPadThemeBuildHelper titleForValueFontColor] 
                                                   titleFont:[UIFont systemFontOfSize:constMediumFontSize]];
        [self.contentView addSubview:tokenField];
    }
    return self;
}

- (void)setTokenViewDelegate:(id<TITokenFieldViewDelegate>)newDelegate {
    [tokenField setDelegate:newDelegate];
}

- (void)addValue:(NSString *)value withValueId:(NSString *)valueId forAccessType:(int)accessType {
    self.accessoryType = UITableViewCellAccessoryNone;                       
    if (accessType >= constAccessTypeViewWithLinks) {
        [tokenField.tokenField addToken:value tokenId:valueId];
        [tokenField resignFirstResponder];
        tokenField.hidden = NO;
        valueLabel.hidden = YES;
        titleLabel.autoresizingMask = UIViewAutoresizingNone;          
    }
    else {		
        valueLabel.text = ([valueLabel.text length] == 0) ? value : [NSString stringWithFormat:@"%@, %@", valueLabel.text, value];
        tokenField.hidden = YES;
        valueLabel.hidden = NO;
        titleLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    }		
}

- (void)setTitle:(NSString *)title {
	titleLabel.hidden = NO;
	titleLabel.text = title;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect titleFrame, tokenFieldFrame;
    CGRectDivide(CGRectOffset(CGRectInset(self.contentView.bounds, 18.0f/2, 5.0f), 18.0f/2, 0), &titleFrame, &tokenFieldFrame, 100, CGRectMinXEdge);
    tokenFieldFrame = CGRectOffset(CGRectInset(tokenFieldFrame, 10, 0), -10, 0);//освобождаем место для кнопки справа
    titleFrame.size.height = 43;//фиксируем высоту заголовка
    titleLabel.frame = titleFrame;
    tokenField.frame = tokenFieldFrame;
}

- (void)dealloc {
    [valueLabel release];
    [titleLabel release];
    [tokenField release];
    [super dealloc];
}

@end
