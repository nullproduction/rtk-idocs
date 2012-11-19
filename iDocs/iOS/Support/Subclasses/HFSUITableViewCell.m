//
//  iDocUITableViewCell.m
//  iDoc
//
//  Created by rednekis on 10-12-24.
//  Copyright 2010 KORUS Consulting. All rights reserved.
//

#import "HFSUITableViewCell.h"
#import "iPadThemeBuildHelper.h"

#define disclosureIndicatorIcon [iPadThemeBuildHelper nameForImage:@"accessory_disclosure_arrow.png"]
#define accessoryUncheckedCheckmarkIcon [iPadThemeBuildHelper nameForImage:@"icon_mark_check_4.png"]
#define accessoryCheckedCheckmarkIcon [iPadThemeBuildHelper nameForImage:@"icon_mark_green_check.png"]
#define evenStyleBackground [iPadThemeBuildHelper nameForImage:@"odd_tablerow_background.png"]

@interface HFSUITableViewCell(PrivateMethods)
- (void) accessoryDisclosureIndicatorTapped:(UIControl *)button withEvent:(UIEvent *)event;
- (void) accessoryCheckmarkTapped:(UIControl *)button withEvent:(UIEvent *)event;
@end

@implementation HFSUITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {		
	}
    return self;
}

- (void)prepareAccessoryDisclosureIndicator {
	disclosureIndicatorButton = [HFSUIButton prepareButtonWithIconForNormalState:disclosureIndicatorIcon 
                                                            iconForSelectedState:disclosureIndicatorIcon 
                                                                         caption:nil
                                                                    captionColor:nil
                                                              captionShadowColor:nil];
	disclosureIndicatorButton.leftMargin = 0.0f;
	disclosureIndicatorButton.backgroundColor = [iPadThemeBuildHelper commonHeaderBackColor];
	disclosureIndicatorButton.frame = CGRectInset(CGRectMake(0.0f, 0.0f, disclosureIndicatorButton.buttonIconView.bounds.size.width, self.bounds.size.height), 0.0f, 1.0f);
	[disclosureIndicatorButton addTarget:self action:@selector(accessoryDisclosureIndicatorTapped:withEvent:) forControlEvents:UIControlEventTouchUpInside];
	
	self.accessoryView = disclosureIndicatorButton;
	self.accessoryView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;	
}

- (void)setAccessoryViewFrame {
    if (self.accessoryView == nil) return;
    
	float accessoryViewOffset = (self.accessoryType == UITableViewCellAccessoryCheckmark ? -10.0f : 0.0f);
	self.accessoryView.frame = CGRectMake(self.frame.size.width-self.accessoryView.frame.size.width+accessoryViewOffset, 0, self.accessoryView.frame.size.width, self.frame.size.height);
}

- (void)setAccessoryType:(UITableViewCellAccessoryType)accessoryType {
	[super setAccessoryType:accessoryType];
	
	if (accessoryType == UITableViewCellAccessoryDisclosureIndicator) {
		[self prepareAccessoryDisclosureIndicator];
	}
	else if (accessoryType == UITableViewCellAccessoryCheckmark) {
		accessoryCheckmarkButton = [HFSUIButton prepareButtonWithIconForNormalState:accessoryUncheckedCheckmarkIcon 
                                                               iconForSelectedState:accessoryCheckedCheckmarkIcon 
                                                                            caption:nil
                                                                       captionColor:nil
                                                                 captionShadowColor:nil];
		accessoryCheckmarkButton.leftMargin = 0.0f;
		accessoryCheckmarkButton.frame = CGRectMake(0.0f, 0.0f, accessoryCheckmarkButton.buttonIconView.bounds.size.width, self.bounds.size.height);
		
		[accessoryCheckmarkButton addTarget:self action:@selector(accessoryCheckmarkTapped:withEvent:) forControlEvents:UIControlEventTouchUpInside];

		self.accessoryView = accessoryCheckmarkButton;
	}
	else { 
		self.accessoryView = nil;
	}
}

#pragma mark AccessoryDisclosureIndicator methods
//call UITableView delegate accessoryButtonTappedForRowWithIndexPath method
- (void) accessoryDisclosureIndicatorTapped:(UIControl *)button withEvent:(UIEvent *)event {
	UITableView *table = (UITableView *)self.superview;
    NSIndexPath *indexPath = [table indexPathForRowAtPoint:[[[event touchesForView:button] anyObject] locationInView:table]];
    if (indexPath != nil && table.delegate != nil && [table.delegate respondsToSelector:@selector(tableView:accessoryButtonTappedForRowWithIndexPath:)])
		[table.delegate tableView:table accessoryButtonTappedForRowWithIndexPath:indexPath];

}

-(void)layoutSubviews {
	[super layoutSubviews];
	[self setAccessoryViewFrame];
}

#pragma mark accessoryCheckmark methods
//call UITableView delegate accessoryButtonTappedForRowWithIndexPath method
- (void) accessoryCheckmarkTapped:(UIControl *)button withEvent:(UIEvent *)event {
	[self setAccessoryCheckmarkChecked:!isAccessoryCheckmarkChecked];
	
	UITableView *table = (UITableView *)self.superview;
    NSIndexPath *indexPath = [table indexPathForRowAtPoint:[[[event touchesForView:button] anyObject] locationInView:table]];
    if (indexPath != nil && table.delegate != nil && [table.delegate respondsToSelector:@selector(tableView:accessoryButtonTappedForRowWithIndexPath:)])
		[table.delegate tableView:table accessoryButtonTappedForRowWithIndexPath:indexPath];
}

- (void)setAccessoryCheckmarkChecked:(BOOL)isChecked {
	[accessoryCheckmarkButton setSelected:isChecked];
	isAccessoryCheckmarkChecked = isChecked;
}

- (BOOL)isAccessoryCheckmarkChecked {
	return isAccessoryCheckmarkChecked;
}

- (void)enableAccessoryCheckmark:(BOOL)enable {
	accessoryCheckmarkButton.enabled = enable;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark even style background methods
- (void)setBackgroundStyleForRow:(int)row	{
	if (row%2 == 0) {
		UIImageView *evenBackImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:evenStyleBackground]];
		evenBackImage.contentMode = UIViewContentModeScaleToFill;
		self.backgroundView = evenBackImage;
		self.backgroundView.userInteractionEnabled = NO;
		[evenBackImage release];
	} 
	else {
		self.backgroundColor = [UIColor clearColor];
	}				
}

- (void)dealloc {
    [super dealloc];
}

@end
