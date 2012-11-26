////  iPadErrandReportViewController.h//  iDoc////  Created by Dmitry Likhachev on 02/08/10.//  Copyright 2009 KORUS Consulting. All rights reserved.//#import <UIKit/UIKit.h>#import "iPadBaseViewController.h"#import "HFSUIButton.h"#import "ActionToSync.h"#import "iPadResolutionReportsListViewController.h"#import "ReportAttachment.h"@protocol iPadResolutionViewControllerDelegate <NSObject>@optional- (void)resolutionViewCloseButtonPressed;- (void)selectReportButtonPressed;- (void)submitActionWithResolutionToServer:(ActionToSync *)action;@end@interface iPadResolutionViewController: iPadBaseViewController <iPadResolutionReportsListViewControllerDelegate> {	UITextView *resolutionTextView;    UILabel* countLabel;    int countAddedReports;    NSMutableArray* reports;    NSMutableArray* selectedReports;    HFSUIButton* chooseFileButton;	HFSUIButton* submitResolutionButton;			ActionToSync *action;		id<iPadResolutionViewControllerDelegate> delegate;    iPadResolutionReportsListViewController* listReportsController;}- (id)initWithFrame:(CGRect)frame;- (void)setDelegate:(id<iPadResolutionViewControllerDelegate>)newDelegate;- (void)setTitleForPopupPanelHeader:(NSString *)newTitle;- (void)showResolutionForTaskServerAction:(ActionToSync *)newAction;- (void)showButtonReports:(BOOL)haveRecord;- (void)showReportsList:(NSMutableArray*)_reports;@end