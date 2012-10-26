//
//  iPadResolutionReportsListViewController.h
//  iDoc
//
//  Created by Olga Geets on 17.10.12.
//  Copyright (c) 2012 KORUS Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iPadBaseViewController.h"
#import "DocErrand.h"
#import "ReportAttachment.h"
#import "DocErrandExecutor.h"
#import "DocDataEntity.h"


@protocol iPadResolutionReportsListViewControllerDelegate <NSObject>
@optional
- (void)addReportsText:(NSString *)text andIdAttach:(NSArray *)attach andReport:(NSArray *)_reports;
@end

@interface iPadResolutionReportsListViewController : iPadBaseViewController <UITableViewDelegate, UITableViewDataSource> {
    UITableView* reportsListTable;
    NSMutableDictionary* reports;
    NSMutableArray* selectedReports;
    id<iPadResolutionReportsListViewControllerDelegate> delegate;
    NSMutableArray* checkArray;
    NSMutableArray* attachArray;
}

@property (nonatomic, retain) NSMutableDictionary* reports;

- (id)initWithFrame:(CGRect)frame;
- (void)setTitle:(NSString *)newTitle;
- (void)setDelegate:(id<iPadResolutionReportsListViewControllerDelegate>)newDelegate;
- (void)setUncheckedAll;
- (void)setListReports:(NSMutableArray *)_reports;

@end
