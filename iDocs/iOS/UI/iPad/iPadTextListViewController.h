//
//  iPadTextListViewController.h
//  iDoc
//
//  Created by Arthur Semenyutin on 7/23/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol iPadTextListViewControllerDelegate <NSObject>
- (void)didSelectText:(NSString *)text;
@end

@interface iPadTextListViewController : UITableViewController <UISearchBarDelegate> {
    NSArray * textList;
	NSMutableArray * filteredTextList;
    id<iPadTextListViewControllerDelegate> delegate;
    CGFloat contentWidth;
}

- (id)initWithTextList:(NSArray *)list andDelegate:(id<iPadTextListViewControllerDelegate>)newDelegate usingSearchBar:(BOOL)hasSearch;
- (id)initWithTextList:(NSArray *)list andDelegate:(id<iPadTextListViewControllerDelegate>)newDelegate;

@end
