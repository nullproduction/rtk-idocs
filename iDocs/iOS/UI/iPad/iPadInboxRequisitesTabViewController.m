//
//  iPadInboxRequisitesTabViewController.m
//  iDoc
//
//  Created by rednekis on 10-12-19.
//  Copyright 2010 KORUS Consulting. All rights reserved.
//

#import "iPadInboxRequisitesTabViewController.h"
#import "iPadAttachmentViewController.h"
#import "iPadInboxRequisitesTabLayoutView.h"
#import "Constants.h"
#import "SupportFunctions.h"
#import "iPadThemeBuildHelper.h"
#import "DocRequisite.h"
#import "DocAttachment.h"


@implementation iPadInboxRequisitesTabViewController

#pragma mark custom methods - init
- (id)initWithPlaceholderPanel:(UIView *)placeholderPanel {
	NSLog(@"iPadInboxRequisitesTab init");	
	if ((self = [super initWithNibName:nil bundle:nil])) {
		
		iPadInboxRequisitesTabLayoutView *container = [[iPadInboxRequisitesTabLayoutView alloc] init];
		container.frame = placeholderPanel.bounds;
		self.view = container;
		
		executorName = container.executorName;
		taskDocDescription = container.taskDocDescription;		
		
        requisitesTableSectionHeight = 40.0f;
        
		requisitesTableView = [[UITableView alloc] initWithFrame:container.requisitesTablePlaceholder.bounds style:UITableViewStylePlain];
		requisitesTableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
		requisitesTableView.backgroundColor = [UIColor clearColor];
		requisitesTableView.rowHeight = constInboxTabCellHeight;
		requisitesTableView.scrollEnabled = YES;
		requisitesTableView.dataSource = self;		
		requisitesTableView.delegate = self;
		
		[container.requisitesTablePlaceholder addSubview:requisitesTableView];
		[placeholderPanel addSubview:container];
		[container release]; 
	}
	return self;
}

#pragma mark custom methods - load data
- (void)loadTabDataWithExecutorName:(NSString *)name 
                     docDescription:(NSString *)description 
                         requisites:(NSArray *)newRequisites 
                     andAttachments:(NSArray *)newAttachments {
	NSLog(@"iPadInboxRequisitesTab loadTabDataWithExecutorName");
	executorName.text = name;
    taskDocDescription.text = description;
    if ([newRequisites count] > 0) {
        requisites = [newRequisites copy]; 
        hasRequisites = YES;
    }
    else {
        hasRequisites = NO;        
    }
    if( attachments != nil ) {
        [attachments release];
    }
	attachments = [newAttachments copy];
    iPadInboxRequisitesTabLayoutView *container = (iPadInboxRequisitesTabLayoutView *)self.view;
    [container setNeedsLayout];

	[requisitesTableView reloadData];
}

#pragma mark custom methods - panel behavior
- (void)setDelegate:(id<iPadInboxRequisitesTabViewControllerDelegate>)newDelegate {
	delegate = newDelegate;
}

#pragma mark custom methods - delegate implementation
- (void)showAttachmentWithFileName:(NSString *)attachmentFileName andName:(NSString *)attachmentName {
	NSLog(@"iPadInboxRequisitesTab showAttachmentWithFileName:%@ andName:%@", attachmentFileName, attachmentName);	
	if (delegate != nil && [delegate respondsToSelector:@selector(showAttachmentWithFileName:andName:)]) {
		[delegate showAttachmentWithFileName:attachmentFileName andName:attachmentName];
	}
}

#pragma mark UITableViewDelegate and UITableViewDataSource methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    int numberOfSectionsInTableView = (hasRequisites) ? 2 : 1;
    return numberOfSectionsInTableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int numberOfRowsInSection;
    if (section == 0)
        numberOfRowsInSection = (hasRequisites) ? (([attachments count] == 0) ? [requisites count] + 3 : [requisites count]) : [attachments count] + 3;
    else
        numberOfRowsInSection = [attachments count] + 3;
    return numberOfRowsInSection;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return requisitesTableSectionHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	//title subcontainer:
	CGRect sectionHeaderFrame  = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, requisitesTableSectionHeight);
	UIView *sectionHeader = [[[UIView alloc] initWithFrame:sectionHeaderFrame] autorelease];
	sectionHeader.backgroundColor = [iPadThemeBuildHelper commonHeaderBackColor];
	sectionHeader.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	
	//title:
	CGRect sectionHeaderTitleFrame  = CGRectMake(15.0f, 0.0f, 150.0f, 36.0f);
	HFSUILabel *sectionHeaderTitle = 
        [HFSUILabel labelWithFrame:sectionHeaderTitleFrame forText:nil withColor:[iPadThemeBuildHelper commonTableSectionHeaderFontColor] andShadow:nil];
	sectionHeaderTitle.font = [UIFont boldSystemFontOfSize:constLargeFontSize];
	sectionHeaderTitle.textAlignment = UITextAlignmentLeft;
	sectionHeaderTitle.autoresizingMask = UIViewAutoresizingNone;
	[sectionHeader addSubview:sectionHeaderTitle];
	
    sectionHeaderTitle.text = 
        (hasRequisites && section == 0) ? NSLocalizedString(@"RequisitesSectionTableTitle", nil) : NSLocalizedString(@"AttachmentsSectionTableTitle", nil);
	
    return sectionHeader;	
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (hasRequisites && indexPath.section == 0) {
        NSString *cellIdentifier = @"DocRequisitesCell";
        iPadDocRequisiteCell *cell = (iPadDocRequisiteCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[[iPadDocRequisiteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        }
        
        if (indexPath.row < [requisites count]) {
            [cell setBackgroundStyleForRow:indexPath.row]; 
            DocRequisite *requisite = (DocRequisite *)[requisites objectAtIndex:indexPath.row];
            [cell setRequisiteName:requisite.name];
            [cell setRequisiteValue:requisite.value];
        }
        return cell;
    }
    else {
        iPadDocAttachmentCell *cell = nil;
        if (indexPath.row < [attachments count]) {
            NSString *cellIdentifier = @"DocAttachmentCell";
            cell = (iPadDocAttachmentCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[[iPadDocAttachmentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
            }
            [cell addCellIcon];
            [cell setBackgroundStyleForRow:indexPath.row];
    
            DocAttachment *attachment = (DocAttachment *)[attachments objectAtIndex:indexPath.row];
            
            [cell setAttachmentId:attachment.id];
            
            NSString* fileName = attachment.name;
            
            if( 0 == [attachment.systemLoaded intValue] || [attachment.size isEqualToNumber:[NSNumber numberWithInt:0]] ) {
                if( ![attachment.size isEqualToNumber:[NSNumber numberWithInt:0]] )
                    fileName = [fileName stringByAppendingString:[NSString stringWithFormat:@" (%@)", NSLocalizedString(@"AttachmentsNotLoadedMessage", nil)]];
                
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [cell setAvailable:NO];
            }
            else {
                [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
                [cell setAvailable:YES];
            }
            
            [cell setAttachmentFileName:attachment.fileName];
            [cell setAttachmentName:fileName];
            NSString *attachmentSize = [attachment.size stringValue];
            attachmentSize = (attachmentSize != nil) ? [SupportFunctions formatAttachmentContentSize:attachmentSize] : constEmptyStringValue;	
            [cell setAttachmentSize:attachmentSize];
            [cell setDelegate:self];
        }
        else {
            NSString *cellIdentifier = @"SupportCell";
            cell = (iPadDocAttachmentCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[[iPadDocAttachmentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
            }
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSLog(@"iPadTaskRequisitesTab didSelectRowAtIndexPath indexPath.row: %i [attachments count] %i", indexPath.row, [attachments count]);
    if( ([attachments count] > indexPath.row) && (!hasRequisites || indexPath.section != 0) ) {
        DocAttachment *attachment = (DocAttachment *)[attachments objectAtIndex:indexPath.row];
        if( ![attachment.size isEqualToNumber:[NSNumber numberWithInt:0]] && 1 == [attachment.systemLoaded intValue]  ) {
            iPadDocAttachmentCell *taskAttachmentCell = (iPadDocAttachmentCell *) [tableView cellForRowAtIndexPath:indexPath];
            [taskAttachmentCell setSelection:nil];
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
        }        
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	if (scrollView.contentOffset.y <= requisitesTableSectionHeight && scrollView.contentOffset.y >= 0) {
		scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0.0f, 0.0f, 0.0f);
	} 
	else if(scrollView.contentOffset.y >= requisitesTableSectionHeight) {
		scrollView.contentInset = UIEdgeInsetsMake(-requisitesTableSectionHeight, 0.0f, 0.0f, 0.0f);
	}
}

#pragma mark other methods
- (void)didReceiveMemoryWarning {
	NSLog(@"iPadInboxRequisitesTab didReceiveMemoryWarning");		
    // Releases the iPadSearchFilter if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc. that aren't in use.
}

- (void)dealloc {
	[attachments release];
    if (requisites != nil)
        [requisites release];
	[requisitesTableView release];
    
//    [self setDelegate:nil];
    
	[super dealloc];
}
@end
