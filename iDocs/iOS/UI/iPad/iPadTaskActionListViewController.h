//
//  iPadTaskActionListViewController.h
//  iDoc
//
//  Created by mark2 on 4/5/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol iPadTaskActionListViewControllerDelegate<NSObject>
- (void)didSelectActionAtIndexPath:(NSIndexPath *)indexPath;
- (NSArray *)getActionsList;
@end

@interface iPadTaskActionListViewController : UITableViewController {
    id<iPadTaskActionListViewControllerDelegate>actionsDelegate;
    NSArray *actions;
}

- (void)setActionsDelegate:(id<iPadTaskActionListViewControllerDelegate>)newDelegate;
@end
