//
//  iPadInboxExecutionTabViewController.m
//  iDoc
//
//  Created by rednekis on 10-12-19.
//  Copyright 2010 KORUS Consulting. All rights reserved.
//

#import "iPadInboxEndorsementTabViewController.h"
#import "Constants.h"
#import "SupportFunctions.h"
#import "iPadThemeBuildHelper.h"
#import "DocEndorsementGroup.h"
#import "DocEndorsement.h"
#import "DocDataEntity.h"
#import "CoreDataProxy.h"


@interface iPadInboxEndorsementTabViewController(PrivateMethods)
- (int)getEndorsementSectionByTag:(int)newTag;
@end

@implementation iPadInboxEndorsementTabViewController

#pragma mark custom methods - init
- (id)initWithPlaceholderPanel:(UIView *)placeholderPanel {
	NSLog(@"iPadInboxEndorsementTab init");	
	if ((self = [super initWithNibName:nil bundle:nil])) {
		endorsementTableSectionHeight = 40.0f;
		
		container = [[iPadInboxEndorsementTabLayoutView alloc] init];
		container.frame = placeholderPanel.bounds;
		self.view = container;
		
		endorsementTableView = [[UITableView alloc] initWithFrame:container.tablePlaceholder.bounds style:UITableViewStylePlain];
		endorsementTableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
		endorsementTableView.rowHeight = 60;
		endorsementTableView.backgroundColor = [UIColor clearColor];
		endorsementTableView.scrollEnabled = YES;
		endorsementTableView.dataSource = self;		
		endorsementTableView.delegate = self;
		[container.tablePlaceholder addSubview:endorsementTableView];
		
		[placeholderPanel addSubview:container];		
	}
	return self;
}


#pragma mark custom methods - load data
- (void)loadTabData:(NSArray *)newEndorsementGroups {
	NSLog(@"iPadInboxEndorsementTab loadTabData");
    if (endorsementGroups != nil)
        [endorsementGroups release];
    endorsementGroups = [newEndorsementGroups copy];
	[endorsementTableView reloadData];
}

#pragma mark UITableViewDelegate and UITableViewDataSource methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	int numberOfSections = ([endorsementGroups count] > 0) ? [endorsementGroups count] : 1;
    return numberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int numberOfRowsInSection;
    if ([endorsementGroups count] > 0) {
        numberOfRowsInSection = [((DocEndorsementGroup *)[endorsementGroups objectAtIndex:section]).endorsements count];
    }
    else {
        numberOfRowsInSection = 0;
    }
    return numberOfRowsInSection;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return endorsementTableSectionHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	//title subcontainer:
	CGRect sectionHeaderFrame  = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, endorsementTableSectionHeight);
	UIView *sectionHeader = [[[UIView alloc] initWithFrame:sectionHeaderFrame] autorelease];
	sectionHeader.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	
    if ([endorsementGroups count] > 0) {
        sectionHeader.backgroundColor = [iPadThemeBuildHelper commonHeaderBackColor];
        
        //title:
        CGRect sectionHeaderTitleFrame  = CGRectMake(15.0f, 0.0f, 150.0f, 36.0f);
        HFSUILabel *sectionHeaderTitle = [HFSUILabel labelWithFrame:sectionHeaderTitleFrame forText:nil withColor:[iPadThemeBuildHelper commonTableSectionHeaderFontColor] andShadow:nil];
        sectionHeaderTitle.font = [UIFont boldSystemFontOfSize:constLargeFontSize];
        sectionHeaderTitle.textAlignment = UITextAlignmentLeft;
        sectionHeaderTitle.autoresizingMask = UIViewAutoresizingNone;
        [sectionHeader addSubview:sectionHeaderTitle];
	
        NSString *title = ((DocEndorsementGroup *)[endorsementGroups objectAtIndex:section]).name;
        sectionHeaderTitle.text = title;
	}
    return sectionHeader;	
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *cellIdentifier = @"DocEndorsementCell";
	iPadDocEndorsementCell *cell = (iPadDocEndorsementCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil) {
		cell = [[[iPadDocEndorsementCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
	}
	[cell setBackgroundStyleForRow:indexPath.row];
	   
    DocDataEntity *docEntity = [[DocDataEntity alloc] initWithContext:[[CoreDataProxy sharedProxy] workContext]];
    DocEndorsementGroup *endorsementGroup = (DocEndorsementGroup *)[endorsementGroups objectAtIndex:indexPath.section];
    NSString *docId = endorsementGroup.doc.id;
    NSString *endorsementGroupId = endorsementGroup.id;
	NSArray *endorsements = [docEntity selectEndorsementsInGroup:endorsementGroupId forDocWithId:docId];
    [docEntity release];
	DocEndorsement *endorsement = [endorsements objectAtIndex:indexPath.row];
		
    NSString *imageName = nil;
    if ([constEndorsementStatusInProcess isEqualToString:endorsement.status]) {
        imageName = [iPadThemeBuildHelper nameForImage:@"icon_mark_check_2.png"]; 
    }
    else if ([constEndorsementStatusFuture isEqualToString:endorsement.status]) {
        imageName = [iPadThemeBuildHelper nameForImage:@"icon_mark_check_1.png"]; 
    }
    else if ([constEndorsementStatusApproved isEqualToString:endorsement.status]) {
        imageName = [iPadThemeBuildHelper nameForImage:@"icon_mark_check_3.png"]; 
    }
    else if ([constEndorsementStatusRejected isEqualToString:endorsement.status]) {
        imageName = [iPadThemeBuildHelper nameForImage:@"icon_mark_cross_1.png"]; 
    }
    else {
        imageName = nil; 
    }
	[cell setStatusImage:imageName];
	
	cell.positionLabel.text = endorsement.personPosition;
	cell.personLabel.text = endorsement.personName;
	cell.decisionLabel.text = endorsement.decision;
	cell.commentLabel.text = endorsement.comment;
    
    //set endorsement date
    NSDate *date = endorsement.endorsementDate;
    if (date != nil) {
        NSString *dateFormatted = [SupportFunctions convertDateToString:date withFormat:constDateTimeFormat]; 
        cell.dateLabel.text = dateFormatted;		
    }
    else {
        cell.dateLabel.text = constEmptyStringValue;
    }
	return cell;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	if (scrollView.contentOffset.y <= endorsementTableSectionHeight && scrollView.contentOffset.y >= 0) {
		scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0.0f, 0.0f, 0.0f);
	} 
	else if(scrollView.contentOffset.y >= endorsementTableSectionHeight) {
		scrollView.contentInset = UIEdgeInsetsMake(-endorsementTableSectionHeight, 0.0f, 0.0f, 0.0f);
	}
}


#pragma mark other methods
- (void)didReceiveMemoryWarning {
	NSLog(@"iPadInboxEndorsementTab didReceiveMemoryWarning");		
    // Releases the iPadSearchFilter if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc. that aren't in use.
}

- (void)dealloc {
	[endorsementGroups release];
	[endorsementTableView release];
	[container release];
	[super dealloc];
}
@end
