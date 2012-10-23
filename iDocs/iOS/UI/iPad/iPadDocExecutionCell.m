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
#import <QuartzCore/QuartzCore.h>

@implementation OpenTreeButton

@synthesize rowPath;

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self)
    {
        [self setImage:[UIImage imageNamed:@"plus.png"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"minus.png"] forState:UIControlStateSelected];
        self.hidden = YES;
        self.enabled = NO;
        self.autoresizingMask = UIViewAutoresizingNone;
        [self setShowsTouchWhenHighlighted:YES];
    }
    
    return self;
}

- (void) dealloc
{
    [rowPath release];
    [super dealloc];
}

@end

@interface iPadDocExecutionCell ()
- (void)filesButtonSelect;
@end

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
		//[[self contentView] addSubview:errandStatusImage];
        
        errandOpenTreeButton = [[OpenTreeButton alloc] initWithFrame:CGRectZero];
        [[self contentView] addSubview:errandOpenTreeButton];
        
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
        
        errandAttachmentFiles = [[UIButton alloc] initWithFrame:CGRectZero];
        errandAttachmentFiles.backgroundColor = [UIColor clearColor];
        errandAttachmentFiles.autoresizingMask = UIViewAutoresizingNone;
		errandAttachmentFiles.contentMode = UIViewContentModeCenter;
        errandAttachmentFiles.hidden = YES;
        [[self contentView] addSubview:errandAttachmentFiles];
    }
    
    return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	self.backgroundView.frame = CGRectInset(self.backgroundView.frame, 20.0f, 0.0f);
	
	NSArray *cellFrames = [iPadDocExecutionCell prepareCellFrames:self.bounds];
	
    errandOpenTreeButton.frame = [[cellFrames objectAtIndex:0] CGRectValue];
	//errandStatusImage.frame = [[cellFrames objectAtIndex:0] CGRectValue];
	errandNumberLabel.frame = [[cellFrames objectAtIndex:1] CGRectValue];
	errandAuthorLabel.frame = [[cellFrames objectAtIndex:2] CGRectValue];
    errandMajorExecutorImage.frame = [[cellFrames objectAtIndex:3] CGRectValue];
	errandExecutorLabel.frame = [[cellFrames objectAtIndex:4] CGRectValue];
	errandTextLabel.frame = [[cellFrames objectAtIndex:5] CGRectValue];
	errandDueDateLabel.frame = [[cellFrames objectAtIndex:6] CGRectValue];
    
    errandAttachmentFiles.frame = [[cellFrames objectAtIndex:7] CGRectValue];

}

+ (NSArray *)prepareCellFrames:(CGRect)rowFrame {
	CGRect c0Frame, c1Frame, c2Frame, c3Frame, c4Frame, c5Frame, c6Frame, c7Frame;
    
    ClientSettingsDataEntity *settingsEntity = [[ClientSettingsDataEntity alloc] initWithContext:[[CoreDataProxy sharedProxy] workContext]];
    if ([settingsEntity showMajorExecutorErrandSign] == NO) {
        CGRectDivide(rowFrame, &c0Frame, &c1Frame, 70.0f, CGRectMinXEdge);
        CGRectDivide(c1Frame, &c1Frame, &c2Frame, 50.0f, CGRectMinXEdge);
        CGRectDivide(c2Frame, &c2Frame, &c3Frame, 110.0f, CGRectMinXEdge);
        CGRectDivide(c3Frame, &c3Frame, &c4Frame, 0.0f, CGRectMinXEdge);
        CGRectDivide(c4Frame, &c4Frame, &c5Frame, 120.0f, CGRectMinXEdge);
        
        c5Frame = CGRectMake(c5Frame.origin.x, c5Frame.origin.y, 130.0f, c5Frame.size.height);
        c6Frame = CGRectMake(c5Frame.origin.x + c5Frame.size.width, c5Frame.origin.y, 155.0f, c5Frame.size.height);
        
        c7Frame = CGRectMake(c6Frame.origin.x + c6Frame.size.width, c5Frame.origin.y, rowFrame.size.width - c0Frame.size.width - c1Frame.size.width - c2Frame.size.width - c3Frame.size.width - c4Frame.size.width - c5Frame.size.width - c6Frame.size.width, c5Frame.size.height);
	}
    else {
        CGRectDivide(rowFrame, &c0Frame, &c1Frame, 70.0f, CGRectMinXEdge);
        CGRectDivide(c1Frame, &c1Frame, &c2Frame, 50.0f, CGRectMinXEdge);
        CGRectDivide(c2Frame, &c2Frame, &c3Frame, 110.0f, CGRectMinXEdge);
        CGRectDivide(c3Frame, &c3Frame, &c4Frame, 0.0f, CGRectMinXEdge);
        CGRectDivide(c4Frame, &c4Frame, &c5Frame, 120.0f, CGRectMinXEdge);
        
        c5Frame = CGRectMake(c5Frame.origin.x, c5Frame.origin.y, 130.0f, c5Frame.size.height);
        c6Frame = CGRectMake(c5Frame.origin.x + c5Frame.size.width, c5Frame.origin.y, 155.0f, c5Frame.size.height);
        
        c7Frame = CGRectMake(c6Frame.origin.x + c6Frame.size.width, c5Frame.origin.y, rowFrame.size.width - c0Frame.size.width - c1Frame.size.width - c2Frame.size.width - c3Frame.size.width - c4Frame.size.width - c5Frame.size.width - c6Frame.size.width, c5Frame.size.height);
    }
        
    [settingsEntity release];
    
	return [NSArray arrayWithObjects:
			[NSValue valueWithCGRect:CGRectInset(c0Frame, 5.0f, 0.0f)],
			[NSValue valueWithCGRect:CGRectInset(c1Frame, 5.0f, 0.0f)],
			[NSValue valueWithCGRect:CGRectInset(c2Frame, 5.0f, 0.0f)],
			[NSValue valueWithCGRect:CGRectInset(c3Frame, 5.0f, 0.0f)],
			[NSValue valueWithCGRect:CGRectInset(c4Frame, 5.0f, 0.0f)],
			[NSValue valueWithCGRect:CGRectInset(c5Frame, 5.0f, 0.0f)],
			[NSValue valueWithCGRect:CGRectInset(c6Frame, 5.0f, 0.0f)],
            
			[NSValue valueWithCGRect:CGRectInset(c7Frame, 5.0f, 0.0f)],
            nil];
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

- (void)setErrandOpenTreeButtonActive:(BOOL)active
{
    [errandOpenTreeButton setEnabled:active];
    [errandOpenTreeButton setHidden:!active];
}

- (void)setErrandOpenTreeButtonActionWithTarget:(id)target andAction:(SEL)selector
{
    [errandOpenTreeButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
}

- (void)setErrandOpenTreeButtonIndexPath:(NSIndexPath*)indexPath
{
    [errandOpenTreeButton setRowPath:indexPath];
}

- (OpenTreeButton*) getErrandOpenTreeButton
{
    return errandOpenTreeButton;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];	
}


- (void)setDelegate:(id<iPadDocAttachmentCellDelegate>)newDelegate {
	delegate = newDelegate;
}

- (void)setSelection:(id)sender {
	if (delegate != nil && [delegate respondsToSelector:@selector(showAttachmentWithFileName:andName:)]) {
        // TODO:
	}
}

- (void)setErrandAttachmentFiles:(BOOL)hidden {
    UIImage *buttonImage = [UIImage imageNamed:[iPadThemeBuildHelper nameForImage:@"task_attachment_icon.png"]];
    [errandAttachmentFiles addTarget:self action:@selector(showAttachmentButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [errandAttachmentFiles setImage:[buttonImage stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
    errandAttachmentFiles.hidden = hidden;
}

- (CGRect)getAttachmentButtonRect
{
    return errandAttachmentFiles.frame;
}

- (void)filesButtonSelect
{
    if([delegate respondsToSelector:@selector(showFileListWithCell:)])
    {
        [delegate performSelector:@selector(showFileListWithCell:) withObject:self];
    }
}

- (void)showAttachmentButtonPressed {
	NSLog(@"iPadDocExecutionCell showAttachmentButtonPressed");
    
    if ([delegate respondsToSelector:@selector(showFileListWithCell:)])
    {
        [delegate performSelector:@selector(showFileListWithCell:) withObject:self];
    }
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
    [errandOpenTreeButton release];
    
    [errandAttachmentFiles release];
    [super dealloc];
}
@end
