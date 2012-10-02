//
//  iPadInboxListPanelViewController.m
//  iDoc
//
//  Created by rednekis on 10-12-15.
//  Copyright 2010 KORUS Consulting. All rights reserved.
//

#import "iPadInboxListPanelViewController.h"
#import "iPadHeaderBodyFooterLayoutView.h"
#import "SupportFunctions.h"
#import "iPadThemeBuildHelper.h"
#import "CoreDataProxy.h"

@implementation iPadInboxListPanelViewController

@synthesize sortFields, inboxListTableViewController, itemsGroupId;

- (UIColor *)backgroundColor {
    return [UIColor colorWithPatternImage:[UIImage imageNamed:[iPadThemeBuildHelper nameForImage:@"modal_popup_background_body_panel.png"]]];
}

#pragma mark custom methods - visual init of panel
- (id)initWithBodyView:(UIView *)bodyView filterView:(UIView *)filterView buttonView:(UIView *)buttonView andDelegate:(id<iPadInboxListPanelViewControllerDelegate>)newDelegate {
    NSLog(@"iPadInboxList initWithFrame");		
	if ((self = [super initWithNibName:nil bundle:nil])) {
		//left panel table
        delegate = newDelegate;
        
        iPadInboxListTableViewController *tmpController = [[iPadInboxListTableViewController alloc] initWithPanelDelegate:self];
        self.inboxListTableViewController = tmpController;
        [tmpController release];
        inboxListTableViewController.view.frame = bodyView.bounds;
		[bodyView addSubview:inboxListTableViewController.view];

		UIButton *slidePanelButton = [UIButton buttonWithType:UIButtonTypeCustom];
		slidePanelButton.frame = buttonView.bounds;
		slidePanelButton.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
		[slidePanelButton addTarget:self action:@selector(slideInboxListPanelButtonPressed) forControlEvents:UIControlEventTouchUpInside];
		[buttonView addSubview:slidePanelButton];

		UITextField *filterTextField = [[UITextField alloc] initWithFrame:CGRectMake(30.0f, 17.0f, 235.0f, 20.0f)];
		filterTextField.font = [UIFont systemFontOfSize:constMediumFontSize];
		filterTextField.placeholder = NSLocalizedString(@"FilterPlaceHolderTitle", nil);
		filterTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		filterTextField.returnKeyType = UIReturnKeyDone;		
		filterTextField.delegate = self;
		[filterView addSubview:filterTextField];
		[filterTextField release];
	}
	return self;	
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark custom methods - load module data
- (void)loadDataForDashboardItemId:(NSString *)itemId {
	NSLog(@"iPadInboxList loadDataForDashboardItem: %@", itemId);	
	self.itemsGroupId = itemId;
    [inboxListTableViewController loadItemsFilteredBySearchText:constEmptyStringValue 
                                                   itemsGroupId:itemsGroupId 
                                                     sortFields:self.sortFields];

    if (delegate != nil && [delegate respondsToSelector:@selector(formatItemHeader:)]) {
		[delegate formatItemHeader:[inboxListTableViewController numberOfLoadedItems]];
	}

    [inboxListTableViewController selectItemInRow:0];
}

#pragma mark custom methods - panel behavior
- (void)slideInboxListPanelButtonPressed {
	NSLog(@"iPadInboxList slidePanelButtonPressed");	
	if(delegate != nil && [delegate respondsToSelector:@selector(slideInboxListPanelButtonPressed)]) {
		[delegate slideInboxListPanelButtonPressed];
	}
}

- (BOOL)selectNextItem {
	NSLog(@"iPadInboxList selectNextItem"); 
    int selectedRow = [[inboxListTableViewController indexPathForSelectedRow] row];
    int nextRow = selectedRow + 1;
    if (nextRow < [inboxListTableViewController numberOfLoadedItems])
        [inboxListTableViewController selectItemInRow:nextRow];
    
    BOOL hasFollowingRow = (nextRow >= [inboxListTableViewController numberOfLoadedItems]) ? NO : YES;
    return hasFollowingRow;
}

- (BOOL)selectPreviousItem {
	NSLog(@"iPadInboxList selectNextItem"); 
    int selectedRow = [[inboxListTableViewController indexPathForSelectedRow] row];
    int previuosRow = selectedRow - 1;
    if (previuosRow >= 0)
        [inboxListTableViewController selectItemInRow:previuosRow];
    
    BOOL hasFollowingRow = (previuosRow <= 0) ? NO : YES;
    return hasFollowingRow;
}

#pragma mark - passthrowgh methods
- (void) setSelectedItemProcessed {
    [inboxListTableViewController setSelectedItemProcessed];
}

- (void)didSelectItem:(Task *)item {
    [delegate didSelectItem:item];
}

- (void)selectItemInRow:(int)row {
    [inboxListTableViewController selectItemInRow:row];
}
- (void)removeSelectedItem {
    [inboxListTableViewController removeSelectedItem];
}
- (void)removeItemList {
    [inboxListTableViewController removeItemList];
}
- (int)numberOfLoadedItems {
    return [inboxListTableViewController numberOfLoadedItems];
}
#pragma mark -

#pragma mark UITextFieldDelegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	NSString *searchString = textField.text;	
    [inboxListTableViewController loadItemsFilteredBySearchText:searchString 
                                                   itemsGroupId:itemsGroupId 
                                                     sortFields:self.sortFields];	
	[textField resignFirstResponder];
	return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	NSString *searchString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    [inboxListTableViewController loadItemsFilteredBySearchText:searchString 
                                                   itemsGroupId:itemsGroupId 
                                                      sortFields:self.sortFields];
	return YES;
}

#pragma mark other methods
- (void)didReceiveMemoryWarning {
	NSLog(@"iPadInboxList didReceiveMemoryWarning");
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
    self.inboxListTableViewController = nil;
    self.sortFields = nil;
    self.itemsGroupId = nil;
    [super dealloc];
}

@end
