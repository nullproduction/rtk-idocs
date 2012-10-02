//
//  iPadTextListViewController.m
//  iDoc
//
//  Created by Arthur Semenyutin on 7/23/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import "iPadTextListViewController.h"
#import "iPadThemeBuildHelper.h"

@implementation iPadTextListViewController

static const float constMaximumWidth = 300.f;
static const float constMaximumHeight = 500.f;
static const float constSearchBarHeight = 50.f;

- (id)initWithTextList:(NSArray *)list andDelegate:(id<iPadTextListViewControllerDelegate>)newDelegate usingSearchBar:(BOOL)hasSearch {
    self = [super init];
    if (self) {
        delegate = newDelegate;
        textList = list;
		filteredTextList = [textList mutableCopy];
        CGFloat maxItemWidth = 0;
        for (NSString * str in textList) {
            CGSize sz = [str sizeWithFont:[UIFont systemFontOfSize:constMediumFontSize]
                                 forWidth:constMaximumWidth
                            lineBreakMode:UILineBreakModeTailTruncation];            
            maxItemWidth = MAX(maxItemWidth, sz.width);
        }
		contentWidth = maxItemWidth + 40.f;
		
		if (hasSearch) {
			UISearchBar * searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.f, 0.f, contentWidth, constSearchBarHeight)];
			searchBar.showsCancelButton = NO;
			searchBar.tintColor = [iPadThemeBuildHelper commonHeaderBackColor];
			searchBar.delegate = self;
			self.tableView.tableHeaderView = searchBar;
			[searchBar release];			
		}
    }    
    return self;
}

- (id)initWithTextList:(NSArray *)list andDelegate:(id<iPadTextListViewControllerDelegate>)newDelegate {
	return [self initWithTextList:list andDelegate:newDelegate usingSearchBar:NO];
}


#pragma mark - View lifecycle
- (CGSize)contentSizeForViewInPopover {
	CGFloat tableHeight = [self.tableView rectForSection:0].size.height;
	if (self.tableView.tableHeaderView)
		tableHeight += self.tableView.tableHeaderView.bounds.size.height;
	
    return CGSizeMake(contentWidth, MIN(tableHeight, constMaximumHeight));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = 
        [UIColor colorWithPatternImage:[UIImage imageNamed:[iPadThemeBuildHelper nameForImage:@"modal_popup_background_body_subbody.png"]]];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [filteredTextList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"TextListCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.textLabel.font = [UIFont systemFontOfSize:constMediumFontSize];
		cell.textLabel.textColor = [iPadThemeBuildHelper commonTextFontColor1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
        
    cell.textLabel.text = [filteredTextList objectAtIndex:indexPath.row];
    return cell;
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (delegate != nil && [delegate respondsToSelector:@selector(didSelectText:)]) {
        [delegate didSelectText:[filteredTextList objectAtIndex:indexPath.row]];
    }
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSLog(@"iPadTextListViewController searchBar textDidChange: %@",searchText);
	[filteredTextList removeAllObjects];

	if (searchText.length != 0) {		
		for (NSString * item in textList) {
			NSLog(@"%@", item);
			NSRange range = [item rangeOfString:searchText options:NSCaseInsensitiveSearch];
			if (range.location != NSNotFound) {
				[filteredTextList addObject:item];
			}
		}		
	}
	else {
		[filteredTextList addObjectsFromArray:textList];
	}
	
	[self.tableView reloadData];
}

- (void)dealloc {
	[filteredTextList release];
    [super dealloc];
}

@end
