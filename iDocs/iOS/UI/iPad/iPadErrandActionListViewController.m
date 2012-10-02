//
//  iPadErrandActionListViewController.m
//  iDoc
//
//  Created by mark2 on 4/5/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import "iPadErrandActionListViewController.h"
#import "Constants.h"
#import "iPadThemeBuildHelper.h"
#import "DocErrandAction.h"


@interface iPadErrandActionListViewController(PrivateMethods)
- (UIColor *)backgroundColor;
@end

@implementation iPadErrandActionListViewController

#pragma mark common methods
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [self backgroundColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = NO;
    self.tableView.rowHeight = constListItemCellHeight;
    actions = [[actionsDelegate getErrandActionsList] copy];
}

- (UIColor *)backgroundColor {
    return [UIColor colorWithPatternImage:[UIImage imageNamed:[iPadThemeBuildHelper nameForImage:@"modal_popup_background_body_panel.png"]]];
}

- (void)setActionsDelegate:(id<iPadErrandActionListViewControllerDelegate>)newDelegate {
    actionsDelegate = newDelegate;
}

- (void)actionButtonPressed:(id)sender {
    if (actionsDelegate != nil && [actionsDelegate respondsToSelector:@selector(didSelectErrandActionAtIndexPath:)]) {
        [actionsDelegate didSelectErrandActionAtIndexPath:[NSIndexPath indexPathForRow:((UIButton *)sender).tag inSection:0]];
    }
}


#pragma mark table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [actions count];
}
                                                        
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        UIButton *actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        NSString *buttonImageName = @"action_list_button.png";
        buttonImageName = [iPadThemeBuildHelper nameForImage:buttonImageName];
        [actionButton setBackgroundImage:[UIImage imageNamed:buttonImageName] forState:UIControlStateNormal];
        
        DocErrandAction *action = [actions objectAtIndex:indexPath.row];
        [actionButton setTitle:action.name forState:UIControlStateNormal];
        [actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [actionButton setTitleShadowColor:[UIColor grayColor] forState:UIControlStateNormal];
        actionButton.tag = indexPath.row;
        [actionButton addTarget:self action:@selector(actionButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        actionButton.frame = CGRectInset(cell.bounds, 5.0f, 1.0f);
        actionButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [cell addSubview:actionButton];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
        
    return cell;
}

- (void)dealloc {
    [actions release];
    [super dealloc];
}


@end
