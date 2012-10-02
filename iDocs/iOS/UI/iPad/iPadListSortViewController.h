//
//  iPadInboxListSortViewController.h
//  iDoc
//
//  Created by mark2 on 6/12/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "iPadInboxListSortCell.h"
#import "Constants.h"

@protocol iPadInboxListSortViewControllerDelegate <NSObject>
- (void)didSelectSortOptionWithIndex:(int)index;
- (NSArray *)getSortOptions;
@end

@interface iPadListSortViewController : UITableViewController {
    NSArray *sortOptions;
    int selectedItem;
    id<iPadInboxListSortViewControllerDelegate> delegate;
}
- (void)setSelectedItem:(int)newSelectedItem;
- (id)initWithSortOptionsDelegate:(id<iPadInboxListSortViewControllerDelegate>)newDelegate;

@end
