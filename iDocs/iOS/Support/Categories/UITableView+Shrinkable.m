    //
//  UIViewController+Shrinkable.m
//  yeehay
//
//  Created by mark2 on 9/13/10.
//  Copyright 2010 HFS. All rights reserved.
//

#import "UITableView+Shrinkable.h"


@implementation UITableView(Shrinkable)
- (void)resizeForHeight:(float)resizeHeight{
	CGRect viewFrame = self.frame;
    viewFrame.size.height += resizeHeight;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3f];
    
    [self setFrame:viewFrame];
    
    [UIView commitAnimations];
}

- (NSIndexPath *)getScrollPosition:(id)field{
	id activeCell = field;
	int rc = 0;
	while (![activeCell isKindOfClass:[UITableViewCell class]] && rc++ <10) {
		activeCell = [activeCell superview];
	}
	if (rc < 10) {
		return [self indexPathForCell:(UITableViewCell *)activeCell];
	}
	return nil;
}

- (void)scrollToActiveField:(id)activeField {
	if (activeField == nil) return;
	
	NSIndexPath *indexToScroll = [self getScrollPosition:activeField];
	
	if (indexToScroll == nil) return;
	
	[self scrollToRowAtIndexPath:indexToScroll atScrollPosition:UITableViewScrollPositionBottom animated:YES];	
}
@end
