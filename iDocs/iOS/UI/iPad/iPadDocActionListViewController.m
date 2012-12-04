//
//  iPadDocActionListViewController.m
//  iDoc
//
//  Created by msyasko on 28/6/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import "iPadDocActionListViewController.h"
#import "HFSUIButton.h"
#import "Constants.h"
#import "iPadThemeBuildHelper.h"
#import <MessageUI/MFMailComposeViewController.h>


@interface iPadDocActionListViewController(PrivateMethods)
- (UIColor *)backgroundColor;
- (void)displayMailComposerSheet;
@end

@implementation iPadDocActionListViewController

#pragma mark general methods
- (void)viewDidLoad {
    [super viewDidLoad];
    actions = [[actionsDelegate getActionsList] copy];
    self.tableView.backgroundColor = [self backgroundColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = NO;
    self.tableView.rowHeight = constListItemCellHeight;
}

- (void)setActionsDelegate:(id<iPadDocActionListViewControllerDelegate>)newDelegate{
    actionsDelegate = newDelegate;
}

- (UIColor *)backgroundColor {
    return [UIColor colorWithPatternImage:[UIImage imageNamed:[iPadThemeBuildHelper nameForImage:@"modal_popup_background_body_panel.png"]]];
}

- (void)actionButtonPressed:(id)sender {
    NSLog(@"iPadDocActionListViewController actionButtonPressed");
    if (actionsDelegate != nil && [actionsDelegate respondsToSelector:@selector(didSelectActionWithId:)]) {
        [actionsDelegate didSelectActionWithId:((UIButton *)sender).tag];
    }
}

#pragma mark table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [actions count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger) section {
    UIView *sectionView = [[[UIView alloc] init] autorelease];
	UILabel *sectionHeader = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 0.0f, 200.0f, constSectionHeight)];
    sectionHeader.text = [NSString stringWithFormat:@"%@:", NSLocalizedString(@"AdditionalFunctionsTitle", nil)]; 
    sectionHeader.font = [UIFont boldSystemFontOfSize:constMediumFontSize];
    sectionHeader.textColor = [iPadThemeBuildHelper commonButtonFontColor1];
    sectionHeader.backgroundColor = [self backgroundColor];
    [sectionView addSubview:sectionHeader];
    [sectionHeader release];
    return sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return constSectionHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        NSDictionary *action = [actions objectAtIndex:indexPath.row];
        UIButton *actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        NSString *buttonImageName = @"action_list_button.png";
        buttonImageName = [iPadThemeBuildHelper nameForImage:buttonImageName];
        [actionButton setBackgroundImage:[UIImage imageNamed:buttonImageName] forState:UIControlStateNormal];
                
        [actionButton setTitle:[action valueForKey:@"name"] forState:UIControlStateNormal];
        [actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        actionButton.titleLabel.font = [UIFont systemFontOfSize:constMediumFontSize];
        [actionButton setTitleShadowColor:[UIColor grayColor] forState:UIControlStateNormal];
        actionButton.tag = [[action valueForKey:@"id"] intValue];
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
    
//    [self setActionsDelegate:nil];
    
    [super dealloc];
}


@end
