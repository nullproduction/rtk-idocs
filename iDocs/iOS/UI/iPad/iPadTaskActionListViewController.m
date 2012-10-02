//
//  iPadTaskActionListViewController.m
//  iDoc
//
//  Created by mark2 on 4/5/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import "iPadTaskActionListViewController.h"
#import "HFSUIButton.h"
#import "Constants.h"
#import "iPadThemeBuildHelper.h"
#import "TaskAction.h"

#define constSectionHeight 35.0f

@interface iPadTaskActionListViewController(PrivateMethods)
- (UIColor *)backgroundColor;
@end

@implementation iPadTaskActionListViewController

#pragma mark common methods
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [self backgroundColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = NO;
    self.tableView.rowHeight = constListItemCellHeight;
    actions = [[actionsDelegate getActionsList] copy];
}

- (UIColor *)backgroundColor {
    return [UIColor colorWithPatternImage:[UIImage imageNamed:[iPadThemeBuildHelper nameForImage:@"modal_popup_background_body_panel.png"]]];
}

- (void)setActionsDelegate:(id<iPadTaskActionListViewControllerDelegate>)newDelegate{
    actionsDelegate = newDelegate;
}

- (void)actionButtonPressed:(id)sender {
    if (actionsDelegate != nil && [actionsDelegate respondsToSelector:@selector(didSelectActionAtIndexPath:)]) {
        [actionsDelegate didSelectActionAtIndexPath:[NSIndexPath indexPathForRow:((UIButton *)sender).tag inSection:0]];
    }
}


#pragma mark table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //показывать только дополнительные функции
    return [actions count] - 2;
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
        UIButton *actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        NSString *buttonImageName = @"action_list_button.png";
        buttonImageName = [iPadThemeBuildHelper nameForImage:buttonImageName];
        [actionButton setBackgroundImage:[UIImage imageNamed:buttonImageName] forState:UIControlStateNormal];
        
        TaskAction *action = (TaskAction *)[actions objectAtIndex:(indexPath.row + 2)];
        [actionButton setTitle:action.name forState:UIControlStateNormal];
        [actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [actionButton setTitleShadowColor:[UIColor grayColor] forState:UIControlStateNormal];
        actionButton.tag = (indexPath.row + 2);
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
