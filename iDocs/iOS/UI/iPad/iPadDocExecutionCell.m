//
//  iPadTaskExecutionCell.m
//  iDoc
//
//  Created by Dmitry Likhachev on 1/31/10.
//  Copyright 2009 KORUS Consulting. All rights reserved.
//

#import "iPadDocExecutionCell.h"
#import "Constants.h"
#import "iPadThemeBuildHelper.h"
#import "CoreDataProxy.h"
#import "ClientSettingsDataEntity.h"
@implementation iPadDocExecutionCell

- (id)initWithStyle:(UITableViewCellStyle)UITableViewCellStyle reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier])) {
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		self.accessoryType = UITableViewCellAccessoryNone;
		self.backgroundColor = [UIColor clearColor];
			
		errandIdLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		[[self contentView] addSubview:errandIdLabel];
		
		errandStatusImage = [[UIImageView alloc] initWithFrame:CGRectZero];
		errandStatusImage.contentMode = UIViewContentModeCenter;
		errandStatusImage.backgroundColor = [UIColor clearColor];
		errandStatusImage.autoresizingMask = UIViewAutoresizingNone;		
		[[self contentView] addSubview:errandStatusImage];
        
		errandNumberLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		errandNumberLabel.textColor = [iPadThemeBuildHelper commonTextFontColor1];		
		errandNumberLabel.font = [UIFont systemFontOfSize:constMediumFontSize];
		errandNumberLabel.backgroundColor = [UIColor clearColor];
		errandNumberLabel.autoresizingMask = UIViewAutoresizingNone;			
		[[self contentView] addSubview:errandNumberLabel];
		
		errandAuthorLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		errandAuthorLabel.textColor = [iPadThemeBuildHelper commonTextFontColor1];		
		errandAuthorLabel.font = [UIFont systemFontOfSize:constMediumFontSize];
		errandAuthorLabel.backgroundColor = [UIColor clearColor];
		errandAuthorLabel.autoresizingMask = UIViewAutoresizingNone;			
		[[self contentView] addSubview:errandAuthorLabel];

		errandMajorExecutorImage = [[UIImageView alloc] initWithFrame:CGRectZero];
		errandMajorExecutorImage.contentMode = UIViewContentModeCenter;
		errandMajorExecutorImage.backgroundColor = [UIColor clearColor];
		errandMajorExecutorImage.autoresizingMask = UIViewAutoresizingNone;		
		[[self contentView] addSubview:errandMajorExecutorImage];
        
		errandExecutorLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		errandExecutorLabel.textColor = [iPadThemeBuildHelper commonTextFontColor1];		
		errandExecutorLabel.font = [UIFont systemFontOfSize:constMediumFontSize];
		errandExecutorLabel.backgroundColor = [UIColor clearColor];
		errandExecutorLabel.autoresizingMask = UIViewAutoresizingNone;	
		errandExecutorLabel.lineBreakMode = UILineBreakModeWordWrap;
		[[self contentView] addSubview:errandExecutorLabel];
		
		errandTextLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		errandTextLabel.textColor = [iPadThemeBuildHelper commonTextFontColor1];		
		errandTextLabel.font = [UIFont systemFontOfSize:constMediumFontSize];
		errandTextLabel.backgroundColor = [UIColor clearColor];
		errandTextLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;		
		[[self contentView] addSubview:errandTextLabel];	
		
		errandDueDateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		errandDueDateLabel.textColor = [iPadThemeBuildHelper commonTextFontColor1];		
		errandDueDateLabel.font = [UIFont systemFontOfSize:constMediumFontSize];
		errandDueDateLabel.backgroundColor = [UIColor clearColor];
		errandDueDateLabel.autoresizingMask = UIViewAutoresizingNone;			
		[[self contentView] addSubview:errandDueDateLabel];			
    }
    return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	self.backgroundView.frame = CGRectInset(self.backgroundView.frame, 20.0f, 0.0f);
	
	NSArray *cellFrames = [iPadDocExecutionCell prepareCellFrames:self.bounds];
	
	errandStatusImage.frame = [[cellFrames objectAtIndex:0] CGRectValue];
	errandNumberLabel.frame = [[cellFrames objectAtIndex:1] CGRectValue];
	errandAuthorLabel.frame = [[cellFrames objectAtIndex:2] CGRectValue];
    errandMajorExecutorImage.frame = [[cellFrames objectAtIndex:3] CGRectValue];
	errandExecutorLabel.frame = [[cellFrames objectAtIndex:4] CGRectValue];
	errandTextLabel.frame = [[cellFrames objectAtIndex:5] CGRectValue];
	errandDueDateLabel.frame = [[cellFrames objectAtIndex:6] CGRectValue];
}

+ (NSArray *)prepareCellFrames:(CGRect)rowFrame {
	CGRect c0Frame, c1Frame, c2Frame, c3Frame, c4Frame, c5Frame, c6Frame;
    
    ClientSettingsDataEntity *settingsEntity = [[ClientSettingsDataEntity alloc] initWithContext:[[CoreDataProxy sharedProxy] workContext]];
    if ([settingsEntity showMajorExecutorErrandSign] == NO) {
        CGRectDivide(rowFrame, &c0Frame, &c1Frame, 70.0f, CGRectMinXEdge);
        CGRectDivide(c1Frame, &c1Frame, &c2Frame, 55.0f, CGRectMinXEdge);
        CGRectDivide(c2Frame, &c2Frame, &c3Frame, 111.0f, CGRectMinXEdge);
        CGRectDivide(c3Frame, &c3Frame, &c4Frame, 0.0f, CGRectMinXEdge);
        CGRectDivide(c4Frame, &c4Frame, &c5Frame, 123.0f, CGRectMinXEdge);
	
        c5Frame = CGRectMake(c5Frame.origin.x, c5Frame.origin.y, c5Frame.size.width - 136.0f, c5Frame.size.height);
        c6Frame = CGRectMake(c5Frame.origin.x + c5Frame.size.width, c5Frame.origin.y, 136.0f, c5Frame.size.height);
	} 
    else {
        CGRectDivide(rowFrame, &c0Frame, &c1Frame, 70.0f, CGRectMinXEdge);
        CGRectDivide(c1Frame, &c1Frame, &c2Frame, 55.0f, CGRectMinXEdge);
        CGRectDivide(c2Frame, &c2Frame, &c3Frame, 111.0f, CGRectMinXEdge);
        CGRectDivide(c3Frame, &c3Frame, &c4Frame, 55.0f, CGRectMinXEdge);
        CGRectDivide(c4Frame, &c4Frame, &c5Frame, 123.0f, CGRectMinXEdge);
        
        c5Frame = CGRectMake(c5Frame.origin.x, c5Frame.origin.y, c5Frame.size.width - 136.0f, c5Frame.size.height);
        c6Frame = CGRectMake(c5Frame.origin.x + c5Frame.size.width, c5Frame.origin.y, 136.0f, c5Frame.size.height);        
    }
        
    [settingsEntity release];
    
	return [NSArray arrayWithObjects:
			[NSValue valueWithCGRect:CGRectInset(c0Frame, 5.0f, 0.0f)],
			[NSValue valueWithCGRect:CGRectInset(c1Frame, 5.0f, 0.0f)],
			[NSValue valueWithCGRect:CGRectInset(c2Frame, 5.0f, 0.0f)],
			[NSValue valueWithCGRect:CGRectInset(c3Frame, 5.0f, 0.0f)],
			[NSValue valueWithCGRect:CGRectInset(c4Frame, 5.0f, 0.0f)],
			[NSValue valueWithCGRect:CGRectInset(c5Frame, 5.0f, 0.0f)],
			[NSValue valueWithCGRect:CGRectInset(c6Frame, 5.0f, 0.0f)], nil];
}

- (void)setErrandId:(NSString *)errandId {
	errandIdLabel.text = errandId;
}

- (void)setErrandStatusImage:(NSString *)imageName {
	[errandStatusImage setImage:(imageName != nil) ? [UIImage imageNamed:imageName] : nil];
}

- (void)setErrandMajorExecutorImage:(NSString *)imageName {
	[errandMajorExecutorImage setImage:(imageName != nil) ? [UIImage imageNamed:imageName] : nil];
}

- (void)setErrandNumber:(NSString *)errandNumber {
    errandNumberLabel.text = errandNumber;
}

- (void)setErrandAuthorName:(NSString *)authorName {
    errandAuthorLabel.text = authorName;
}

- (void)setErrandExecutorName:(NSString *)executorName {
    errandExecutorLabel.text = executorName;
}

- (void)setNumberOfLinesForErrandExecutorLabel:(int)numberOfLines {
    errandExecutorLabel.numberOfLines = numberOfLines;
}

- (void)setErrandText:(NSString *)errandText {
    errandTextLabel.text = errandText;
}

- (void)setErrandDueDate:(NSString *)dueDate withColor:(UIColor *)color {
    errandDueDateLabel.text = dueDate;
    errandDueDateLabel.textColor = color;
}

- (void)setCurrentErrandStyle:(Boolean)isCurrentErrand {
	errandNumberLabel.font = 
        (isCurrentErrand) ? [UIFont boldSystemFontOfSize:constMediumFontSize] : [UIFont systemFontOfSize:constMediumFontSize];
	errandAuthorLabel.font = 
        (isCurrentErrand) ? [UIFont boldSystemFontOfSize:constMediumFontSize] : [UIFont systemFontOfSize:constMediumFontSize];
	errandExecutorLabel.font = 
        (isCurrentErrand) ? [UIFont boldSystemFontOfSize:constMediumFontSize] : [UIFont systemFontOfSize:constMediumFontSize];
	errandTextLabel.font = 
        (isCurrentErrand) ? [UIFont boldSystemFontOfSize:constMediumFontSize] : [UIFont systemFontOfSize:constMediumFontSize];
	errandDueDateLabel.font = 
        (isCurrentErrand) ? [UIFont boldSystemFontOfSize:constMediumFontSize] : [UIFont systemFontOfSize:constMediumFontSize];	
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];	
}

- (void)dealloc {	
	[errandIdLabel release];
	[errandStatusImage release];
	[errandNumberLabel release];
    [errandMajorExecutorImage release];
	[errandAuthorLabel release];
	[errandExecutorLabel release];
	[errandTextLabel release];
	[errandDueDateLabel release];
    [super dealloc];
}
@end