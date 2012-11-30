//
//  iPadInboxListSortViewController.m
//  iDoc
//
//  Created by mark2 on 6/12/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import "iPadListSortViewController.h"
#import "iPadThemeBuildHelper.h"

#define constHeaderHeight 35.0f

@implementation iPadListSortViewController

- (id)initWithSortOptionsDelegate:(id<iPadInboxListSortViewControllerDelegate>)newDelegate {
    self = [super init];
    if (self != nil) {
        delegate = newDelegate;
        sortOptions = [[delegate getSortOptions] copy];
    }
    return self;
}

- (UIColor *)backgroundColor {
    return [UIColor colorWithPatternImage:[UIImage imageNamed:[iPadThemeBuildHelper nameForImage:@"modal_popup_background_body_panel.png"]]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [self backgroundColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = NO;
    self.tableView.rowHeight = constListItemCellHeight - 30;
}

- (CGSize)contentSizeForViewInPopover {
    return CGSizeMake(200, (constListItemCellHeight - 30)*[sortOptions count] + 40);
}

- (void)setSelectedItem:(int)newSelectedItem {
    selectedItem = newSelectedItem;
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:selectedItem
                                                            inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [sortOptions count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger) section {
    UIView *sectionView = [[[UIView alloc] init] autorelease];
	UILabel *sectionHeader = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 0.0f, 200.0f, constHeaderHeight)]; 
    sectionHeader.text = [NSString stringWithFormat:@"%@:", NSLocalizedString(@"SortOrderTitle", nil)]; 
    sectionHeader.font = [UIFont boldSystemFontOfSize:constMediumFontSize];
    sectionHeader.textColor = [iPadThemeBuildHelper commonTextFontColor4];
    sectionHeader.backgroundColor = [self backgroundColor];
    [sectionView addSubview:sectionHeader];
    [sectionHeader release];
    return sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return constHeaderHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    iPadInboxListSortCell *cell = (iPadInboxListSortCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[iPadInboxListSortCell alloc] initWithReuseIdentifier:CellIdentifier] autorelease];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }

    cell.textLabel.text = [[sortOptions objectAtIndex:indexPath.row] valueForKey:@"name"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [delegate didSelectSortOptionWithIndex:indexPath.row];
}

- (void)dealloc {
    [sortOptions release];
    delegate = nil;
    
    [super dealloc];
}


@end
