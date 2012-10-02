//
//  iPadDocActionListViewController.h
//  iDoc
//
//  Created by msyasko on 28/6/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>

@class iPadDocActionListViewController;
@protocol iPadDocActionListViewControllerDelegate <NSObject>
@optional
- (void)didSelectActionWithId:(int)actionId;
- (NSArray *)getActionsList;
@end

@interface iPadDocActionListViewController : UITableViewController {    
    id<iPadDocActionListViewControllerDelegate> actionsDelegate;
    NSMutableArray *actions;  
}

- (void)setActionsDelegate:(id<iPadDocActionListViewControllerDelegate>)newDelegate;
@end
