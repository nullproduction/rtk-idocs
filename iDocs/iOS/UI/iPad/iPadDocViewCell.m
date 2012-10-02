//
//  iPadDocViewCell.m
//  iDoc
//
//  Created by Michael Syasko on 6/14/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import "iPadDocViewCell.h"
#import "Constants.h"
#import "iPadThemeBuildHelper.h"

@implementation iPadDocViewCell

- (id)initWithStyle:(UITableViewCellStyle)UITableViewCellStyle reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier])) {		
		self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.accessoryType = UITableViewCellAccessoryNone;

        UIView *separatorView = [[UIView alloc] 
                                 initWithFrame:CGRectMake(0,0,self.bounds.size.width,1)];
        separatorView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        separatorView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:separatorView];
        [separatorView release];
        
        selectionBack = [[HFSGradientView alloc] initWithFrame:self.bounds];
        selectionBack.hidden = YES;
        [self addSubview:selectionBack];
        [self sendSubviewToBack:selectionBack];
        selectionBack.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;        
        CGRect nameFrame, sizeFrame, timeFrame;
        nameFrame = CGRectOffset(CGRectInset(self.contentView.bounds,30,0),20,0);

        if (UITableViewCellStyle != UITableViewCellStyleValue1) 
        {   //делим ячейку на три части для не-UITableViewCellStyleValue1
            CGRectDivide(nameFrame, &nameFrame,&sizeFrame,self.contentView.bounds.size.height*2/3,CGRectMinYEdge);
            CGRectDivide(sizeFrame, &sizeFrame,&timeFrame,80, CGRectMinXEdge);
        }

        fileName = [[UILabel alloc] initWithFrame:nameFrame];
		fileName.opaque = YES;
		fileName.enabled = YES;
		fileName.textColor = [iPadThemeBuildHelper commonTextFontColor1];		
		fileName.font = [UIFont systemFontOfSize:constMediumFontSize + 2];
		fileName.textAlignment = UITextAlignmentLeft;
		fileName.backgroundColor = [UIColor clearColor];
		fileName.autoresizingMask = UIViewAutoresizingFlexibleWidth;			
		[[self contentView] addSubview:fileName];
		        
        if (UITableViewCellStyle != UITableViewCellStyleValue1) {
            sizeValue = [[UILabel alloc] initWithFrame:sizeFrame];
            sizeValue.opaque = YES;
            sizeValue.enabled = YES;
            sizeValue.textColor = [[iPadThemeBuildHelper commonTextFontColor1] colorWithAlphaComponent:0.5f];		
            sizeValue.font = [UIFont systemFontOfSize:constMediumFontSize - 2];
            sizeValue.textAlignment = UITextAlignmentLeft;
            sizeValue.backgroundColor = [UIColor clearColor];
            sizeValue.autoresizingMask = UIViewAutoresizingNone;			
            [[self contentView] addSubview:sizeValue];

            timeValue = [[UILabel alloc] initWithFrame:timeFrame];
            timeValue.opaque = YES;
            timeValue.enabled = YES;
            timeValue.textColor = [[iPadThemeBuildHelper commonTextFontColor1] colorWithAlphaComponent:0.5f];		
            timeValue.font = [UIFont systemFontOfSize:constMediumFontSize - 4];
            timeValue.textAlignment = UITextAlignmentRight;
            timeValue.backgroundColor = [UIColor clearColor];
            timeValue.autoresizingMask = UIViewAutoresizingFlexibleWidth;			
            [[self contentView] addSubview:timeValue];
        }
        
    }
    return self;
}
- (void)setFileName:(NSString *)name {
    fileName.text = (name != nil) ? name : constEmptyStringValue;;
}

- (void)setTimeValue:(NSString *)value {
    timeValue.text = (value != nil) ? value : constEmptyStringValue;
}

- (void)setSizeValue:(NSString *)value {
    sizeValue.text = (value != nil) ? value : constEmptyStringValue;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    selectionBack.hidden = !selected;    
}

- (void)dealloc {
	[fileName release];	
	timeValue = nil;
    sizeValue = nil;
    [selectionBack release];
    [super dealloc];
}

@end

