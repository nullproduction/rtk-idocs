//
//  iPhoneTaskInfoCell.m
//  iDoc
//
//  Created by Dmitry Likhachev on 2/22/09.
//  Copyright 2009 KORUS Consulting. All rights reserved.
//

#import "iPadTaskInfoCell.h"
#import "Constants.h"
#import "iPadThemeBuildHelper.h"
#import <QuartzCore/QuartzCore.h>

#define addTokenIcon [iPadThemeBuildHelper nameForImage:@"accessory_disclosure_arrow.png"]

@implementation iPadTaskInfoCell

- (id)initWithStyle:(UITableViewCellStyle)UITableViewCellStyle reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier])) {
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		
		self.backgroundColor = [UIColor clearColor];
		taskIdLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 0.0f, 0.0f)];
		taskIdLabel.hidden = YES;
		[[self contentView] addSubview:taskIdLabel];
        
        CGRect taskNewIconFrame = CGRectMake(2.0f, 16.0f, 12.0f, 12.0f);
		taskNewIcon = [[UIImageView alloc] initWithFrame:taskNewIconFrame];
        taskNewIcon.image = [UIImage imageNamed:[iPadThemeBuildHelper nameForImage:@"icon_new_item.png"]]; 
		taskNewIcon.autoresizingMask = UIViewAutoresizingNone;
 		[[self contentView] addSubview:taskNewIcon];
        
		docTypeNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 15.0f, 145.0f, 15.0f)];
		docTypeNameLabel.hidden = NO;
		docTypeNameLabel.opaque = YES;
		docTypeNameLabel.enabled = YES;
		docTypeNameLabel.textAlignment = UITextAlignmentLeft;
		docTypeNameLabel.textColor = [iPadThemeBuildHelper itemInListHeaderFontColor];
		docTypeNameLabel.font = [UIFont boldSystemFontOfSize:constMediumFontSize];
		docTypeNameLabel.autoresizingMask = UIViewAutoresizingNone;
		docTypeNameLabel.backgroundColor = [UIColor clearColor];
		[[self contentView] addSubview:docTypeNameLabel];

		taskStageDueDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(160.0f, 15.0f, 95.0f, 15.0f)];
		taskStageDueDateLabel.hidden = NO;
		taskStageDueDateLabel.opaque = YES;
		taskStageDueDateLabel.enabled = YES;
		taskStageDueDateLabel.textAlignment = UITextAlignmentLeft;
		taskStageDueDateLabel.textColor = [iPadThemeBuildHelper commonTextFontColor1];
		taskStageDueDateLabel.font = [UIFont systemFontOfSize:constMediumFontSize];
		taskStageDueDateLabel.autoresizingMask = UIViewAutoresizingNone;
		taskStageDueDateLabel.backgroundColor = [UIColor clearColor];
		[[self contentView] addSubview:taskStageDueDateLabel];		
			
		UIView *divider = [[UIView alloc] initWithFrame:CGRectMake(16.0f, 41.0f, 
                                                                   self.contentView.bounds.size.width-25, 
                                                                   1.0f)];
		divider.backgroundColor = [iPadThemeBuildHelper commonSeparatorColorSemitransparent];
        divider.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		[self.contentView addSubview:divider];
		[divider release];
		
		docDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 54.0f, 215.0f, 50.0f)];
		docDescLabel.hidden = NO;
		docDescLabel.opaque = YES;
		docDescLabel.enabled = YES;
		docDescLabel.numberOfLines = 3;
		docDescLabel.lineBreakMode = UILineBreakModeTailTruncation;
		docDescLabel.textAlignment = UITextAlignmentLeft;
		docDescLabel.textColor = [iPadThemeBuildHelper commonTextFontColor1];		
		docDescLabel.font = [UIFont systemFontOfSize:constMediumFontSize];
		docDescLabel.autoresizingMask = UIViewAutoresizingNone;
		docDescLabel.backgroundColor = [UIColor clearColor];
		[[self contentView] addSubview:docDescLabel];
		
		CGRect taskGroupIconFrame = CGRectMake(225.0f, 60.0f, 32.0f, 32.0f);
		taskProcessedStatusIcon = [[UIImageView alloc] initWithFrame:taskGroupIconFrame];
		taskProcessedStatusIcon.autoresizingMask = UIViewAutoresizingNone;
        taskProcessedStatusIcon.image = [UIImage imageNamed:[iPadThemeBuildHelper nameForImage:@"ok_icon.png"]];
        taskProcessedStatusIcon.hidden = YES;
		[[self contentView] addSubview:taskProcessedStatusIcon];
        
        UIView *separatorView = [[UIView alloc] 
                                 initWithFrame:CGRectMake(self.contentView.frame.origin.x, 
                                                          self.contentView.frame.origin.y, 
                                                          self.contentView.bounds.size.width, 
                                                          1)];
        separatorView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        separatorView.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:separatorView];
        [separatorView release];
        
        selectionBack = [[HFSGradientView alloc] initWithFrame:self.bounds];
        selectionBack.hidden = YES;
        [self addSubview:selectionBack];
        [self sendSubviewToBack:selectionBack];
        selectionBack.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        
    }
    return self;
}

- (void)setTaskProcessed:(BOOL)processed {
    taskProcessedStatusIcon.hidden = !processed;
    [[self contentView] setNeedsLayout];
}

- (void)setTaskId:(NSString *)taskId {
	taskIdLabel.hidden = YES;
	taskIdLabel.text = taskId;		
}

- (void)setTaskViewed:(BOOL)isViewed {
    taskNewIcon.hidden = isViewed;
}

- (void)setDocTypeName:(NSString *)docTypeName {
    docTypeNameLabel.text = docTypeName;
}

- (void)setTaskStageDueDate:(NSString *)taskStageDueDate withColor:(UIColor *)color {
	taskStageDueDateLabel.text = taskStageDueDate;
    if (color != nil) taskStageDueDateLabel.textColor = color;
}

- (void)setDocDesc:(NSString *)docDesc {
	docDescLabel.text = docDesc;
}

- (void)setTaskProcessedStatusIcon:(NSString *)imageName {
	taskProcessedStatusIcon.image = (imageName != nil) ? [UIImage imageNamed:imageName] : nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    selectionBack.hidden = !selected;    
}

- (void)dealloc {	
    [selectionBack release];
	[taskIdLabel release];
    [taskNewIcon release];
	[docTypeNameLabel release];
	[taskStageDueDateLabel release];	
	[docDescLabel release];
	[taskProcessedStatusIcon release];	
    [super dealloc];
}


@end
