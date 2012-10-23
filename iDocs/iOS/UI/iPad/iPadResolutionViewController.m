////  iPadErrandReportViewController.m//  iDoc////  Created by Dmitry Likhachev on 02/08/10.//  Copyright 2009 KORUS Consulting. All rights reserved.//#import "iPadResolutionViewController.h"#import "iPadHeaderBodyFooterLayoutView.h"#import "iDocAppDelegate.h"#import "iPadThemeBuildHelper.h"#import "HFSUIButton.h"@implementation iPadResolutionViewController#pragma mark custom methods - init- (id)initWithFrame:(CGRect)frame {	NSLog(@"iPadResolution initWithFrame");		if ((self = [super initWithNibName:nil bundle:nil])) {		iPadHeaderBodyFooterLayoutView *container = [[iPadHeaderBodyFooterLayoutView alloc] init];		container.showFooter = NO;		container.frame = frame;				CGRect reportTextViewFrame = container.bodyPanel.bounds;		resolutionTextView = [[UITextView alloc] initWithFrame:reportTextViewFrame];		resolutionTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;		resolutionTextView.editable = YES;		resolutionTextView.scrollEnabled = YES;		resolutionTextView.enablesReturnKeyAutomatically = YES;		resolutionTextView.textAlignment = UITextAlignmentLeft;				resolutionTextView.font = [UIFont systemFontOfSize:constMediumFontSize];		resolutionTextView.returnKeyType = UIReturnKeyDefault;		resolutionTextView.autocorrectionType = UITextAutocorrectionTypeDefault;		resolutionTextView.autocapitalizationType = UITextAutocapitalizationTypeNone;		resolutionTextView.keyboardType = UIKeyboardTypeDefault;        resolutionTextView.keyboardAppearance = UIKeyboardAppearanceDefault;		resolutionTextView.backgroundColor = [UIColor clearColor];				[container.bodyPanel addSubview:resolutionTextView];                UIColor *buttonColor = [iPadThemeBuildHelper commonButtonFontColor2];        UIColor *shadowColor = [iPadThemeBuildHelper commonShadowColor2];        		submitResolutionButton = [container prepareHeaderRightButtonWithCaption:@"SubmitResolutionButtonTitle"                                                                     captionColor:buttonColor                                                                   captionShadow:shadowColor                                                                     imageOrNil:nil];		[submitResolutionButton addTarget:self action:@selector(submitResolutionButtonPressed) forControlEvents:UIControlEventTouchUpInside];		[container.headerPanel addSubview:submitResolutionButton];				UIButton *closeButton = [container prepareHeaderLeftButtonWithCaption:@"CancelButtonTitle"                                                                  captionColor:buttonColor                                                                 captionShadow:shadowColor                                                                   imageOrNil:nil];		[closeButton addTarget:self action:@selector(resolutionViewCloseButtonPressed) forControlEvents:UIControlEventTouchUpInside];		[container.headerPanel addSubview:closeButton];                container.showBottomBarPanel = YES;                countLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 200.0f, container.bottomBarPanel.bounds.size.height)];		countLabel.hidden = NO;		countLabel.opaque = YES;		countLabel.enabled = YES;		countLabel.font = [UIFont systemFontOfSize:constLargeFontSize];		countLabel.textColor = buttonColor;		countLabel.textAlignment = UITextAlignmentLeft;		countLabel.backgroundColor = [UIColor clearColor];		countLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight;		[container.bottomBarPanel addSubview:countLabel];        countAddedReports = 0;        		chooseFileButton = [container prepareHeaderRightButtonWithCaption:@"FileButtonTitle"                                                                   captionColor:buttonColor                                                                  captionShadow:shadowColor                                                                     imageOrNil:nil];        CGRect rect = chooseFileButton.frame;        rect.size.width += 20;        rect.origin.y -= 5;        chooseFileButton.frame = rect;                [chooseFileButton addTarget:self action:@selector(selectReportButtonPressed) forControlEvents:UIControlEventTouchUpInside];        [container.bottomBarPanel addSubview:chooseFileButton];        self.view = container;		[container release];        //        addedIdReports = [NSString stringWithFormat:@"%@", constEmptyStringValue];        reports = [[NSMutableArray alloc] initWithCapacity:0];        countAddedReports = 0;	}	return self;}#pragma mark custom methods - load data- (void)showResolutionForTaskServerAction:(ActionToSync *)newAction {	NSLog(@"iPadResolution showResolutionForServerAction");	action = newAction;	resolutionTextView.text = constEmptyStringValue;    [resolutionTextView becomeFirstResponder];}#pragma mark custom methods - panel behavior- (void)setDelegate:(id<iPadResolutionViewControllerDelegate>)newDelegate {	delegate = newDelegate;}- (void)resolutionViewCloseButtonPressed {	NSLog(@"iPadResolution resolutionViewCloseButtonPressed");	if (delegate != nil && [delegate respondsToSelector:@selector(resolutionViewCloseButtonPressed)]) {		[delegate resolutionViewCloseButtonPressed];        countAddedReports = 0;//        addedIdReports = constEmptyStringValue;	}}- (void)selectReportButtonPressed {	NSLog(@"iPadResolution selectReportButtonPressed");    [resolutionTextView resignFirstResponder];	if (delegate != nil && [delegate respondsToSelector:@selector(selectReportButtonPressed)]) {		[delegate selectReportButtonPressed];	}}- (void)showButtonReports:(BOOL)haveRecord {    if( !haveRecord ) {        iPadHeaderBodyFooterLayoutView *container = (iPadHeaderBodyFooterLayoutView *)self.view;        container.showBottomBarPanel = NO;        container.bottomBarPanel.hidden = YES;        [container layoutSubviews];                self.view = container;        [self.view layoutSubviews];    }}- (void)showReportsList:(NSMutableArray*)_reports {	NSLog(@"iPadResolution showReportsList");    if( nil == listReportsController ) {        listReportsController = [[iPadResolutionReportsListViewController alloc] initWithFrame:self.view.frame andReports:_reports];        [listReportsController setDelegate:self];//        NSLog(@"frame %@",NSStringFromCGRect(self.view.frame));        [listReportsController setTitle:NSLocalizedString(@"ReportsListTitle", nil)];    }        [self.navigationController pushViewController:listReportsController animated:YES];}- (void)submitResolutionButtonPressed {	NSLog(@"iPadResolution submitResolutionButtonPressed");	    if (resolutionTextView.text != nil && ![resolutionTextView.text isEqualToString:constEmptyStringValue]) {            if (delegate != nil && [delegate respondsToSelector:@selector(submitActionWithResolutionToServer:)]) {            NSString *addedIdReports = constEmptyStringValue;            if( ![reports count] ) {                action.attachments = nil;            }            else {                for( NSString* repId in reports ) {                    addedIdReports = [addedIdReports isEqualToString:constEmptyStringValue] ? [addedIdReports stringByAppendingString:[NSString stringWithFormat:@"%@", repId]] : [addedIdReports stringByAppendingString:[NSString stringWithFormat:@";%@", repId]];                }//                NSLog(@"addedIdReports %@", addedIdReports);                action.attachments = addedIdReports;            }                        action.actionResolution = resolutionTextView.text;                        NSLog(@"action %@", action.actionResolution);            [delegate submitActionWithResolutionToServer:action];        }    }	else {		NSString *errorMessage = [NSString stringWithFormat:@"%@ %@",                                   NSLocalizedString(@"RequiredFieldsNotFilledMessage", nil),                                  NSLocalizedString(@"RequiredFieldResolutionText", nil)];				[self reportClientError:errorMessage];	}}- (void)addReportsText:(NSString *)text andIdAttach:(NSArray *)attach {//    NSLog(@"addReportsText delegate: text %@ idsAttach %@", text, [attach description]);    resolutionTextView.text = [resolutionTextView.text isEqualToString:constEmptyStringValue] ? [resolutionTextView.text stringByAppendingString:[NSString stringWithFormat:@"%@", text]] : [resolutionTextView.text stringByAppendingString:[NSString stringWithFormat:@"\n%@", text]];        if( [attach count] ) {        countAddedReports += [attach count];        if( nil != reports ) {            [reports release];        }        reports = (NSMutableArray *)[attach retain];    }        countLabel.text = [NSString stringWithFormat:@"Добавлено вложений: %i", countAddedReports];}- (void)setTitleForPopupPanelHeader:(NSString *)newTitle {	iPadHeaderBodyFooterLayoutView *container = (iPadHeaderBodyFooterLayoutView *)self.view;	[[container.headerPanel viewWithTag:constHeaderCenterTitleWithCaption] removeFromSuperview];    UIColor *titleColor = [iPadThemeBuildHelper commonHeaderFontColor2];    UIColor *shadowColor = [iPadThemeBuildHelper commonShadowColor2];     	[container.headerPanel addSubview:[container prepareHeaderCenterTitleWithCaption:NSLocalizedString(newTitle, nil)                                                                         captionColor:titleColor                                                                    captionShadow:shadowColor]];}#pragma mark other methods- (void)didReceiveMemoryWarning {	NSLog(@"iPadResolution didReceiveMemoryWarning");		    [super didReceiveMemoryWarning];}- (void)dealloc {	[resolutionTextView release];    [listReportsController release];    [reports release];        [super dealloc];}@end