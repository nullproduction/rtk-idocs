//
//  iPadErrandActionListViewControllerDelegate.h
//  iDoc
//
//  Created by mark2 on 4/5/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol iPadErrandActionListViewControllerDelegate<NSObject>
- (void)didSelectErrandActionAtIndexPath:(NSIndexPath *)indexPath;
- (NSArray *)getErrandActionsList;
@end

@interface iPadErrandActionListViewController : UITableViewController {
    id<iPadErrandActionListViewControllerDelegate>actionsDelegate;
    NSArray *actions;
}

- (void)setActionsDelegate:(id<iPadErrandActionListViewControllerDelegate>)newDelegate;
@end
