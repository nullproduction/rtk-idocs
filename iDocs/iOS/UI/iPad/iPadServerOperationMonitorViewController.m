//
//  iPadServerOperationMonitorViewController.m
//  Medi_Pad
//
//  Created by mark2 on 4/23/11.
//  Copyright 2011 HFS. All rights reserved.
//

#import "iPadServerOperationMonitorViewController.h"
#import "ServerOperationQueueEntity.h"
#import <QuartzCore/QuartzCore.h>
#import "iPadServerOperationMonitorCell.h"
#import "Constants.h"
#import "iPadThemeBuildHelper.h"
#import "HFSUIButton.h"
#import "CoreDataProxy.h"

#define HFS_MONITORING_BUTTONS_VIEW 543
#define HFS_SYNC_CONTROLLER_VEIL_TAG 112244 // вуаль для прикрытия завершающейся в бэкграунде синхронизации

@interface iPadServerOperationMonitorViewController(PrivateMethods)
- (void)toggleDetails;
@end

@implementation iPadServerOperationMonitorViewController

@synthesize detailController;

- (iPadServerOpMonDetailViewController *)detailController {
    if (detailController == nil) {
        iPadServerOpMonDetailViewController *tmpController = 
            [[iPadServerOpMonDetailViewController alloc] initWithFrame:self.tableViewPlaceholder.bounds];
        self.detailController = tmpController;
        [tmpController release];
        [self.tableViewPlaceholder addSubview:detailController.view];
        return detailController;
    }
    return detailController;
}

- (id)initWithServerOpMonitorDelegate:(id<iPadServerOperationMonitorViewControllerDelegate>)newDelegate {
    if ((self = [super initWithFrame:self.view.bounds])) {
        self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.view.opaque = YES;
        self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];

        delegate = newDelegate;
        queueEntity = [[ServerOperationQueueEntity alloc] initWithContext:[[CoreDataProxy sharedProxy] workContext]];
        
        self.entityName = @"ServerOperationQueue";
        self.predicate = [NSPredicate predicateWithFormat:@"%K = %@", @"visible", [NSNumber numberWithBool:YES]];
        self.sortDescriptors = [NSArray arrayWithObjects:
                                [NSSortDescriptor sortDescriptorWithKey:@"group" ascending:YES],
                                [NSSortDescriptor sortDescriptorWithKey:@"dateEnqueued" ascending:YES],
                                nil];
        self.sectionNameKeyPath = @"group";
        
        float offsetX = 75.0f;
        float offsetY = 50.0f;
        CGRect titleFrame, tableFrame, footerFrame;
        CGRectDivide(CGRectInset(self.view.frame, offsetX, offsetY), &titleFrame, &tableFrame, 30.0f, CGRectMinYEdge);
        CGRectDivide(tableFrame, &footerFrame, &tableFrame, 50.0f, CGRectMaxYEdge);
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectOffset(titleFrame, 0, -5)];
        headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.view addSubview:headerView];

        UILabel *titleLabel = [[UILabel alloc] initWithFrame:headerView.bounds];
        titleLabel.layer.cornerRadius = 7.0f;
        titleLabel.clipsToBounds = YES;
        titleLabel.textAlignment = UITextAlignmentCenter;
        titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        titleLabel.font = [UIFont boldSystemFontOfSize:constXXLargeFontSize];
        titleLabel.textColor = [iPadThemeBuildHelper syncHeaderFontColor];
        titleLabel.backgroundColor = [iPadThemeBuildHelper syncHeaderBackColor];
        titleLabel.text = NSLocalizedString(@"ServerOperationProgressTitle", nil);
        [headerView addSubview:titleLabel];
        [titleLabel release];
        
        tableViewPraceholderView = [[UIView alloc] initWithFrame:tableFrame];
        tableViewPraceholderView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        tableViewPraceholderView.layer.cornerRadius = 7.0f;
        tableViewPraceholderView.clipsToBounds = YES;
        [self.view addSubview:tableViewPraceholderView];
        
        footerView = [[UIView alloc] initWithFrame:CGRectOffset(footerFrame, 0, 5)];
        footerView.hidden = YES;
        footerView.backgroundColor = [iPadThemeBuildHelper syncHeaderBackColor];
        footerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        footerView.layer.cornerRadius = 7.0f;
        footerView.clipsToBounds = YES;
        [self.view addSubview:footerView];
                
        UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
        [detailButton addTarget:self action:@selector(toggleDetails) forControlEvents:UIControlEventTouchUpInside];
        detailButton.frame = CGRectMake(headerView.bounds.size.width - 35.0f, 0.0f, 30.0f, 30.0f);
        detailButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [headerView addSubview:detailButton];

        [headerView release];

        viewIsDisplayed = NO;
    }
    return self;
}

- (void)showWaitForSyncResetFinishVeil {
    UIView *veil = [[UIView alloc] initWithFrame:self.tableViewPlaceholder.frame];
    veil.tag = HFS_SYNC_CONTROLLER_VEIL_TAG;
    veil.backgroundColor = [iPadThemeBuildHelper syncHeaderBackColor];
    veil.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    veil.layer.cornerRadius = constCornerRadius;
    [self.view addSubview:veil];
    
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.frame = veil.bounds;
    activityView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    activityView.contentMode = UIViewContentModeCenter;
    activityView.color = [UIColor grayColor];    
    [veil addSubview:activityView];
    [activityView startAnimating];

    [activityView release];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, veil.bounds.size.height/2-90, veil.bounds.size.width, 40)];
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
    titleLabel.font = [UIFont boldSystemFontOfSize:constXXLargeFontSize];
    titleLabel.textColor = [iPadThemeBuildHelper syncHeaderFontColor];
    titleLabel.backgroundColor = [iPadThemeBuildHelper syncHeaderBackColor];
    titleLabel.text = NSLocalizedString(@"ServerOperationInitialisationTitle", nil);
    [veil addSubview:titleLabel];
    
    [veil release];
}

- (void)showControls:(MonitoringControlsSet)controlsSet {
    UIView *buttonsView = [footerView viewWithTag:HFS_MONITORING_BUTTONS_VIEW];
    if (buttonsView != nil) {
        [buttonsView removeFromSuperview];
        buttonsView = nil;
    }
    
    if (controlsSet == MonitoringControlsSetNone) {
        footerView.hidden = YES;
    }
    else {
        footerView.hidden = NO;
        float buttonsViewWidth = (controlsSet == MonitoringControlsSetDoneOnly) ? 124.0f : (103.0f + 104.0f);
        //float buttonsViewWidth = (controlsSet == MonitoringControlsSetDoneOnly) ? 124.0f : (103.0f + 124.0f + 104.0f);
        CGRect buttonsFrame = CGRectMake(CGRectGetMidX(footerView.bounds) - buttonsViewWidth/2, 10.0f, buttonsViewWidth, 30.0f);
        UIView *buttonsView = [[UIView alloc] initWithFrame:buttonsFrame];
        buttonsView.tag = HFS_MONITORING_BUTTONS_VIEW;
        buttonsView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [footerView addSubview:buttonsView];

        if (controlsSet == MonitoringControlsSetDoneRestart) {
            CGRect leftButtonFrame, rightButtonFrame; //, middleButtonFrame;
            CGRectDivide(buttonsView.bounds, &leftButtonFrame, &rightButtonFrame, 103.0f, CGRectMinXEdge);

            NSString *normalStateBackImage = [iPadThemeBuildHelper nameForImage:@"bottom_toolbar_left_button_normal.png"];
            NSString *selectedStateBackImage = [iPadThemeBuildHelper nameForImage:@"bottom_toolbar_left_button_selected.png"];
            HFSUIButton *doneButton = 
                [HFSUIButton prepareButtonWithBackImageForNormalState:normalStateBackImage
                                            backImageForSelectedState:selectedStateBackImage 
                                                              caption:NSLocalizedString(@"DoneButtonTitle", nil)
                                                         captionColor:[iPadThemeBuildHelper commonButtonFontColor1]
                                                   captionShadowColor:[iPadThemeBuildHelper commonShadowColor1]
                                                                 icon:nil];
            doneButton.buttonTitle.font = [UIFont boldSystemFontOfSize:constMediumFontSize];
            doneButton.buttonTitle.textAlignment = UITextAlignmentCenter;
            doneButton.buttonTitle.font = [UIFont boldSystemFontOfSize:constMediumFontSize];          
            doneButton.leftMargin = -5;
            doneButton.buttonTitleOffset = -5;
            [doneButton addTarget:delegate action:@selector(onSyncFinished) forControlEvents:UIControlEventTouchUpInside];
            doneButton.frame = leftButtonFrame;
            doneButton.autoresizingMask = UIViewAutoresizingNone;
            [buttonsView addSubview:doneButton];

            normalStateBackImage = [iPadThemeBuildHelper nameForImage:@"bottom_toolbar_right_button_normal.png"];
            selectedStateBackImage = [iPadThemeBuildHelper nameForImage:@"bottom_toolbar_right_button_selected.png"];
            HFSUIButton *restartButton = 
                [HFSUIButton prepareButtonWithBackImageForNormalState:normalStateBackImage
                                            backImageForSelectedState:selectedStateBackImage
                                                              caption:NSLocalizedString(@"RestartButtonTitle", nil) 
                                                         captionColor:[iPadThemeBuildHelper commonButtonFontColor1]
                                                   captionShadowColor:[iPadThemeBuildHelper commonShadowColor1]
                                                                 icon:nil];
            restartButton.buttonTitle.font = [UIFont boldSystemFontOfSize:constMediumFontSize];
            restartButton.buttonTitle.textAlignment = UITextAlignmentCenter;        
            restartButton.leftMargin = -5;
            restartButton.buttonTitleOffset = -5;
            [restartButton addTarget:delegate action:@selector(repeatLastSync) forControlEvents:UIControlEventTouchUpInside];
            restartButton.frame = rightButtonFrame;
            restartButton.autoresizingMask = UIViewAutoresizingNone;
            [buttonsView addSubview:restartButton];
        }
        else if (controlsSet == MonitoringControlsSetDoneOnly || controlsSet == MonitoringControlsSetRestartOnly) {
            NSString *normalStateBackImage = [iPadThemeBuildHelper nameForImage:@"bottom_toolbar_middle_button_normal.png"];
            NSString *selectedStateBackImage = [iPadThemeBuildHelper nameForImage:@"bottom_toolbar_middle_button_selected.png"];
            NSString *buttonCaption = (controlsSet == MonitoringControlsSetRestartOnly) ? 
                NSLocalizedString(@"RestartButtonTitle", nil) : NSLocalizedString(@"DoneButtonTitle", nil);
            HFSUIButton *actionButton = 
                [HFSUIButton prepareButtonWithBackImageForNormalState:normalStateBackImage
                                            backImageForSelectedState:selectedStateBackImage
                                                              caption:buttonCaption
                                                         captionColor:[iPadThemeBuildHelper commonButtonFontColor1]
                                                   captionShadowColor:[iPadThemeBuildHelper commonShadowColor1]
                                                                 icon:nil];
            actionButton.buttonTitle.font = [UIFont boldSystemFontOfSize:constMediumFontSize];
            actionButton.buttonTitle.textAlignment = UITextAlignmentCenter;
            actionButton.buttonTitle.font = [UIFont boldSystemFontOfSize:constMediumFontSize];          
            actionButton.leftMargin = -5;
            actionButton.buttonTitleOffset = -5;
            if (controlsSet == MonitoringControlsSetDoneOnly)
                [actionButton addTarget:delegate action:@selector(onSyncFinished) forControlEvents:UIControlEventTouchUpInside];
            else if (controlsSet == MonitoringControlsSetRestartOnly)
                [actionButton addTarget:delegate action:@selector(repeatLastSync) forControlEvents:UIControlEventTouchUpInside];
            actionButton.frame = buttonsView.bounds;
            actionButton.autoresizingMask = UIViewAutoresizingNone;
            [buttonsView addSubview:actionButton];
            [self toggleDetails];
        }
        [buttonsView release];
    }
    [[NSRunLoop currentRunLoop] runUntilDate:[[NSDate date] dateByAddingTimeInterval:0.01]];
}

- (void)toggleDetails {
    if (detailController) {
        [detailController.view removeFromSuperview];
        detailController = nil;
    }
    else {
        //создастся, если еще не создан, и сбрасывается фильтр по родительскому событию
        [self.detailController setDetailOperationQueue:nil];
        [detailController loadData];
    }
}

- (void)startQueueOperations {
    //первичная загрузка. последующие обновления делаются автоматически через фетч-контроллер при изменении managedContext-а
    [self performFetch];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    viewIsDisplayed = YES;
}

#pragma mark Base Class methods:
- (UIView *)tableViewPlaceholder {
    return tableViewPraceholderView;
}

- (void)addTableView {
    [super addTableView];
    tableView.rowHeight = 50.0f;
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    [super controller:controller didChangeObject:anObject atIndexPath:indexPath forChangeType:type newIndexPath:newIndexPath];
    if (type == NSFetchedResultsChangeInsert) {
        [self setSelectionTo:anObject];
    }
}

- (NSString *)controller:(NSFetchedResultsController *)controller sectionIndexTitleForSectionName:(NSString *)sectionName{
    return [[ServerOperationQueue serverOperationLabels] valueForKey:sectionName];
}

- (void)selectCellAtIndexPath:(NSIndexPath *)indexPath{
    ServerOperationQueue *entity = (ServerOperationQueue *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    if (entity.statusCodeEnum >= DSEventStatusWarning) {
        [self.detailController setDetailOperationQueue:entity];
        [self.detailController loadData];
    }
}

- (UITableViewCell *)prepareCellForIndexPath:(NSIndexPath *)indexPath {    
    iPadServerOperationMonitorCell *cell = (iPadServerOperationMonitorCell *)[self.tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[[iPadServerOperationMonitorCell alloc] initWithReuseIdentifier:@"cell"] autorelease];       
    }
    return cell;
}

- (void)processCell:(UITableViewCell *)cell fromIndexPath:(NSIndexPath *)indexPath {
    ServerOperationQueue *entity = (ServerOperationQueue *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    iPadServerOperationMonitorCell *pCell = (iPadServerOperationMonitorCell *)cell;
    pCell.textLabel.text = entity.serverOperationName;

    NSString *iconFile = (entity.statusCodeEnum == DSEventStatusInfo
                            ? @"ok_icon.png" 
                            : (entity.statusCodeEnum == DSEventStatusError
                                    ? @"error_icon.png"
                                    : (entity.statusCodeEnum == DSEventStatusWarning 
                                       ? @"icon_mark_warning.png"
                                       : @"clockBlue_icon.png")));
    [pCell.statusIcon setImage:[UIImage imageNamed:[iPadThemeBuildHelper nameForImage:iconFile]]]; 
    
    if (entity.statusCodeEnum == DSEventStatusProcessing) {
        [pCell.statusIcon setHidden:YES];
        [pCell.activityIndicator setHidden:NO];
        [pCell.activityIndicator startAnimating];
    }
    else if (entity.dateFinished) {
        [pCell.activityIndicator setHidden:YES];
        [pCell.activityIndicator stopAnimating];
        [pCell.statusIcon setHidden:NO];
    }
    pCell.accessoryType = ((entity.statusCodeEnum >= DSEventStatusWarning) 
                           ? UITableViewCellAccessoryDetailDisclosureButton 
                           : UITableViewCellAccessoryNone);
    
    [pCell setNeedsLayout];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    [self selectCellAtIndexPath:indexPath];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (BOOL)disablesAutomaticKeyboardDismissal {
    return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return ((interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight));
}

- (void)dealloc {
    [queueEntity release];
    
    self.detailController = nil;
    [tableViewPraceholderView release];
    [footerView release];
    
    [super dealloc];
}

@end
