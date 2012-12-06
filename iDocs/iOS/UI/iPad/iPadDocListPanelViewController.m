//
//  iPadDocListPanelViewController.m
//  iDoc
//
//  Created by rednekis on 10-12-15.
//  Copyright 2010 KORUS Consulting. All rights reserved.
//

#import "iPadDocListPanelViewController.h"
#import "iPadHeaderBodyFooterLayoutView.h"
#import "SupportFunctions.h"
#import "iPadThemeBuildHelper.h"
#import "iPadDocViewCell.h"
#import "iPadDocListTableViewController.h"
#import "iPadInboxAttachmentsTabLayoutView.h"

#define HFS_FileAttributesDictionaryFileName @"fileName"
#define HFS_FileAttributesDictionaryFileExtension @"fileExtension"
#define HFS_FileAttributesDictionaryFileIcon @"fileIcon"
#define HFS_FileAttributesDictionaryFilePath @"filePath"

@implementation iPadDocListPanelViewController

@synthesize containerController, sortField, ascending, searchString, docListTableViewController;

- (UIColor *)backgroundColor {
    return [UIColor colorWithPatternImage:[UIImage imageNamed:[iPadThemeBuildHelper nameForImage:@"modal_popup_background_body_panel.png"]]];
}

#pragma mark custom methods - visual init of panel
- (id)initWithBodyView:(UIView *)bodyView filterView:(UIView *)filterView buttonView:(UIView *)buttonView andDelegate:(id<iPadDocListPanelViewControllerDelegate>) newDelegate {
	NSLog(@"iPadDocListPanel initWithFrame");		
	if ((self = [super initWithNibName:nil bundle:nil])) {
        delegate = newDelegate;
        
        coreDataProxy = [[CoreDataProxy alloc] init];
        systemEntity = [[SystemDataEntity alloc] initWithContext:coreDataProxy.workContext];
        user = [systemEntity userInfo];

        containerController = [[UIViewController alloc] initWithNibName:nil bundle:nil];
        containerController.view.frame = bodyView.bounds;
        containerController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [bodyView addSubview:containerController.view];

        iPadDocListTableViewController *listTableViewController = [[iPadDocListTableViewController alloc] initWithDelegate:self];
        listTableViewController.view.frame = bodyView.bounds;
        listTableViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        navController = [[UINavigationController alloc] initWithRootViewController:listTableViewController];
        self.docListTableViewController = listTableViewController;
        [listTableViewController release];
        navController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        navController.view.frame = containerController.view.bounds;
        navController.navigationBar.hidden = YES;
        navController.delegate = self;
        
		[containerController.view addSubview:navController.view];

		UIButton *slidePanelButton = [UIButton buttonWithType:UIButtonTypeCustom];
		slidePanelButton.frame = buttonView.bounds;
		slidePanelButton.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
		[slidePanelButton addTarget:self action:@selector(slideDocListPanelButtonPressed) forControlEvents:UIControlEventTouchUpInside];
		[buttonView addSubview:slidePanelButton];

		UITextField *filterTextField = [[UITextField alloc] initWithFrame:CGRectMake(30.0f, 17.0f, 235.0f, 20.0f)];
		filterTextField.font = [UIFont systemFontOfSize:constMediumFontSize];
		filterTextField.placeholder = NSLocalizedString(@"FilterPlaceHolderTitle", nil);
		filterTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		filterTextField.returnKeyType = UIReturnKeyDone;		
		filterTextField.delegate = self;
		[filterView addSubview:filterTextField];
		[filterTextField release];
						
        self.searchString = constEmptyStringValue;
        self.ascending = NO;
	}
    
	return self;	
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark UINavigationControllerDelegate methods
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    self.docListTableViewController = (iPadDocListTableViewController *)viewController;
    [docListTableViewController loadItemsFilteredBySearchText:self.searchString 
                                                    sortField:self.sortField 
                                                    ascending:self.ascending];
    [docListTableViewController performInitialSelection];
}

#pragma mark custom methods - load module data
- (void)loadDataForDashboardItemId:(NSString *)itemId {
	NSLog(@"iPadDocListPanel loadDataForDashboardItem:%@", itemId);
    NSString *path = [SupportFunctions createWebDavFolderPathForDashboardItem:itemId];
    docListTableViewController.currentPath = path;
    [self filterAndSortData];
}

- (void)filterAndSortData {
    [docListTableViewController loadItemsFilteredBySearchText:self.searchString 
                                                    sortField:self.sortField 
                                                    ascending:self.ascending];
    [docListTableViewController performInitialSelection];
}

#pragma mark custom methods - panel behavior
- (void)slideDocListPanelButtonPressed {
	NSLog(@"iPadDocListPanel slidePanelButtonPressed");	
	if(delegate != nil && [delegate respondsToSelector:@selector(slideDocListPanelButtonPressed)]) {
		[delegate slideDocListPanelButtonPressed];
	}
}

- (void)didSelectItem:(NSDictionary *)item {
    [delegate didSelectItem:item];
}

- (BOOL)prevItemAvailable {
    if ([docListTableViewController numberOfLoadedItems] > 0) {
        int selectedRow = [[docListTableViewController indexPathForSelectedRow] row];
        return (selectedRow > 0);        
    }
    else return NO;
}

- (BOOL)nextItemAvailable {
    if ([docListTableViewController numberOfLoadedItems]>0) {
        int selectedRow = [[docListTableViewController indexPathForSelectedRow] row];
        return [docListTableViewController hasFollowingRow:selectedRow];
    }
    else return NO;
}

- (void)selectNextItem {
	NSLog(@"iPadDocListPanel selectNextItem"); 
    int selectedRow = [[docListTableViewController indexPathForSelectedRow] row];
    while (selectedRow < [docListTableViewController numberOfLoadedItems]) {
        selectedRow++;
        if ([docListTableViewController isItemViewable:selectedRow]){
            [docListTableViewController selectItemInRow:selectedRow];
            break;
        }
    }
}

- (void)selectPreviousItem {
	NSLog(@"iPadDocListPanel selectPreviousItem"); 
    int selectedRow = [[docListTableViewController indexPathForSelectedRow] row];
    while (selectedRow > 0) {
        selectedRow--;
        if ([docListTableViewController isItemViewable:selectedRow]){
            [docListTableViewController selectItemInRow:selectedRow];
            break;
        }
    }
}

- (BOOL)isSelectedItemViewable {
	NSLog(@"iPadDocListPanel isSelectedItemViewable"); 
    int selectedRow = [[docListTableViewController indexPathForSelectedRow] row];  
    return [docListTableViewController isItemViewable:selectedRow];
}


#pragma mark - passthrough methods
- (void)selectItemInRow:(int)row {
    [docListTableViewController selectItemInRow:row];
    
}

- (void)removeItemList {
    [docListTableViewController removeItemList];
}

- (int)numberOfLoadedItems {
    return [docListTableViewController numberOfLoadedItems];
}


#pragma mark UITextFieldDelegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	self.searchString = textField.text;	
	[docListTableViewController loadItemsFilteredBySearchText:self.searchString 
                                                    sortField:self.sortField 
                                                    ascending:self.ascending];	
	[textField resignFirstResponder];
	return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	self.searchString = [textField.text stringByReplacingCharactersInRange:range withString:string];
	[docListTableViewController loadItemsFilteredBySearchText:self.searchString 
                                                    sortField:self.sortField
                                                    ascending:self.ascending];
	return YES;
}

- (CGSize)contentSizeForViewInPopover {
    return CGSizeMake(200.0f, 600.0f);
}

#pragma mark other methods
- (void)didReceiveMemoryWarning {
	NSLog(@"iPadDocListPanel didReceiveMemoryWarning");
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [navController release];
    [coreDataProxy release];
    [systemEntity release];
    
    self.containerController = nil;
    self.docListTableViewController = nil;
    self.sortField = nil;
    self.searchString = nil;
    
    [super dealloc];
}

@end
