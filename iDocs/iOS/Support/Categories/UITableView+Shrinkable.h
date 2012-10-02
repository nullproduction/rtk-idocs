//
//  UIViewController+Shrinkable.h
//  yeehay
//
//  Created by mark2 on 9/13/10.
//  Copyright 2010 HFS. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UITableView(Shrinkable)

- (void)resizeForHeight:(float)resizeHeight;
- (void)scrollToActiveField:(id)activeField;
- (NSIndexPath *)getScrollPosition:(id)field;

@end
