//
//  iPadResolutionReportsListViewController.m
//  iDoc
//
//  Created by Olga Geets on 17.10.12.
//  Copyright (c) 2012 KORUS Consulting. All rights reserved.
//

#import "iPadResolutionReportsListViewController.h"
#import "CoreDataProxy.h"
#import "iPadThemeBuildHelper.h"
#import "iPadReportInfoCell.h"
#import "iPadHeaderBodyFooterLayoutView.h"

@implementation iPadResolutionReportsListViewController

@synthesize reports;

- (UIColor *)backgroundColor {
    return [UIColor colorWithPatternImage:[UIImage imageNamed:[iPadThemeBuildHelper nameForImage:@"modal_popup_background_body_panel.png"]]];
}

- (id)initWithFrame:(CGRect)frame andReports:(NSMutableArray *)_reports {
    NSLog(@"ResolutionReportsList initWithFrame");
	if ((self = [super initWithNibName:nil bundle:nil])) {
        checkArray = [[NSMutableArray alloc] initWithCapacity:0];
        attachArray = [[NSMutableArray alloc] initWithCapacity:0];
        for (int i = 0; i < _reports.count; ++i) {
            [checkArray addObject:[NSNumber numberWithBool:NO]];
            [attachArray addObject:[NSNumber numberWithBool:NO]];
        }
        self.navigationController.navigationBar.hidden = YES;
		CGRect resolutionReportsTableFrame;
        iPadHeaderBodyFooterLayoutView *container = nil;
        container = [[iPadHeaderBodyFooterLayoutView alloc] init];
        container.showFooter = NO;
        container.frame = frame;
        
        resolutionReportsTableFrame = CGRectMake(0.0f, 0.0f, container.bodyPanel.frame.size.width, container.bodyPanel.frame.size.height - 50.0f);
                    
        UIColor *buttonColor = [iPadThemeBuildHelper commonButtonFontColor2];
        UIColor *shadowColor = [iPadThemeBuildHelper commonShadowColor2];
        
        UIButton *backButton = [container prepareHeaderLeftButtonWithCaption:NSLocalizedString(@"BackButtonTitle",nil)
                                                                captionColor:buttonColor
                                                               captionShadow:shadowColor
                                                                  imageOrNil:nil];
        [backButton addTarget:self action:@selector(navigateBack) forControlEvents:UIControlEventTouchUpInside];
        [container.headerPanel addSubview:backButton];
                
        UIButton *addButton = [container prepareHeaderRightButtonWithCaption:NSLocalizedString(@"AddButtonTitle",nil)
                                                                captionColor:buttonColor
                                                               captionShadow:shadowColor
                                                                  imageOrNil:nil];
        [addButton addTarget:self action:@selector(navigateAddAndBack) forControlEvents:UIControlEventTouchUpInside];
        [container.headerPanel addSubview:addButton];
        
		reportsListTable = [[UITableView alloc] initWithFrame:resolutionReportsTableFrame style:UITableViewStylePlain];
		reportsListTable.backgroundColor = [UIColor clearColor];
        reportsListTable.scrollEnabled = YES;
		reportsListTable.opaque = NO;
		reportsListTable.rowHeight = constListItemCellHeight;
		reportsListTable.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		reportsListTable.delegate = self;
		reportsListTable.dataSource = self;
        
        [container.bodyPanel addSubview:reportsListTable];
                
        self.view = container;
        [container release];
        
        reports = [[NSMutableDictionary alloc] initWithCapacity:0];
//        NSLog(@"_reports %@", _reports);
        for( ReportAttachment* report in _reports ) {
            NSString* idReport = report.reportId;
            if( nil != [reports objectForKey:idReport] ) {
                NSMutableArray* arrayReport = [reports objectForKey:idReport];
                [arrayReport addObject:report];
            }
            else {
                NSMutableArray* arrayReport = [[NSMutableArray alloc] initWithCapacity:0];
                [arrayReport addObject:report];
                [reports setValue:arrayReport forKey:idReport];
            }
        }
        
//        NSLog(@"reportsDict %@", [reports description]);
        
        selectedReports = [[NSMutableArray alloc] initWithCapacity:0];
        
        [reportsListTable reloadData];
	}
	return self;
}


#pragma mark custom methods - view behavior

- (void)navigateBack {
	NSLog(@"ResolutionReportsList navigateBack");
	[self.navigationController popViewControllerAnimated:YES];

    [selectedReports removeAllObjects];
    
    [self setUncheckedAll];
    
    [reportsListTable reloadData];
}

- (void)navigateAddAndBack {
	NSLog(@"ResolutionReportsList navigateAddAndBack");
    [self.navigationController popViewControllerAnimated:YES];
//    NSLog(@" selectedReports %i", [selectedReports count]);
    
    if (delegate != nil && [delegate respondsToSelector:@selector(addReportsText:andIdAttach:)]) {
        NSString* text = constEmptyStringValue;
        NSMutableArray* idsAttach = [[NSMutableArray alloc] initWithCapacity:0];
        for( int i = 0; i < [selectedReports count]; ++i ) {
            NSMutableArray* dict = [reports objectForKey:[selectedReports objectAtIndex:i]];
            ReportAttachment* report = (ReportAttachment *)[dict objectAtIndex:0];
            text = [text isEqualToString:constEmptyStringValue] ? [text stringByAppendingString:[NSString stringWithFormat:@"%@", report.reportText]] : [text stringByAppendingString:[NSString stringWithFormat:@"\n%@", report.reportText]];
            for( int i = 0; i < [dict count]; ++i ) {
                ReportAttachment* _report = (ReportAttachment *)[dict objectAtIndex:i];
                if( _report.id ) {
                    [idsAttach addObject:_report.id];
                }
            }
        }
//        NSLog(@"text %@ idsAttach %@", text, [idsAttach description]);
        [delegate addReportsText:text andIdAttach:idsAttach];
    }
   
    for(NSString* idReport in selectedReports) {
        [reports removeObjectForKey:idReport];
    }
    
//    NSLog(@"navigateAddAndBack reports %@", reports);

    [selectedReports removeAllObjects];
    
    [self setUncheckedAll];
    
    [reportsListTable reloadData];
}

- (void)setTitle:(NSString *)newTitle {
	iPadHeaderBodyFooterLayoutView *container = (iPadHeaderBodyFooterLayoutView *)self.view;
	[[container.headerPanel viewWithTag:constHeaderCenterTitleWithCaption] removeFromSuperview];
    UIColor *titleColor = [iPadThemeBuildHelper commonHeaderFontColor2];
    UIColor *shadowColor = [iPadThemeBuildHelper commonShadowColor2];
	[container.headerPanel addSubview:[container prepareHeaderCenterTitleWithCaption:NSLocalizedString(newTitle, nil)
                                                                        captionColor:titleColor
                                                                       captionShadow:shadowColor]];
}

- (void)setDelegate:(id<iPadResolutionReportsListViewControllerDelegate>)newDelegate {
	delegate = newDelegate;
}

- (void) setUncheckedAll {
    [checkArray removeAllObjects];
    [attachArray removeAllObjects];
    for (int i = 0; i < [[reports allKeys] count]; ++i) {
        [checkArray addObject:[NSNumber numberWithBool:NO]];
        [attachArray addObject:[NSNumber numberWithBool:NO]];
    }
}

#pragma mark UIViewController methods
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.contentSizeForViewInPopover = self.view.frame.size;
}


#pragma mark UITableViewDataSource and UITableViewDelegate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.reports allKeys] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"ReportInfoCell";

    iPadReportInfoCell *cell = (iPadReportInfoCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil) {
		cell = [[[iPadReportInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
	}
    
    NSString* keyReport = [[self.reports allKeys] objectAtIndex:indexPath.row];
    NSMutableArray* dict = [reports objectForKey:keyReport];
    ReportAttachment* report = (ReportAttachment *)[dict objectAtIndex:0];
    NSString* attach = constEmptyStringValue;
    for( int i = 0; i < [dict count]; ++i ) {
        ReportAttachment* _report = (ReportAttachment *)[dict objectAtIndex:i];
        if( _report.id ) {
        attach = [attach isEqualToString:constEmptyStringValue] ?  [attach stringByAppendingString:[NSString stringWithFormat:@"%@", _report.name]] : [attach stringByAppendingString:[NSString stringWithFormat:@", %@", _report.name]];
        }
    }
    DocErrandExecutor* executor = [[report.errand.executors allObjects] objectAtIndex:0];
    [cell setChecked:[[checkArray objectAtIndex:indexPath.row] boolValue]];
    
    if( ![attach isEqualToString:constEmptyStringValue] ) {
        [cell setAttachment:YES];
        [cell setNameReport:[NSString stringWithFormat:@"%@ \n %@ (вложения: %@)", executor.executorName, report.reportText, attach]];
    }
    else {
        [cell setAttachment:NO];
        [cell setNameReport:[NSString stringWithFormat:@"%@ \n %@", executor.executorName, report.reportText]];
    }
 
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSLog(@"iPadReportsList didSelectRowAtIndexPath indexPath.row: %i", indexPath.row);

    iPadReportInfoCell* cell = (iPadReportInfoCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell setChecked:![cell isChecked]];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    [checkArray replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:[cell isChecked]]];
    if( [cell isChecked] ) {
        [selectedReports addObject:[[self.reports allKeys] objectAtIndex:indexPath.row]];
    }
    else {
        [selectedReports removeObject:[[self.reports allKeys] objectAtIndex:indexPath.row]];
    }
}

- (void)dealloc {
    [self.reports removeAllObjects];
    self.reports = nil;
    
    [super dealloc];
}

@end
