//
//  iPadServerOpMonDetailViewController.m
//  iDoc
//
//  Created by Konstantin Krupovich on 8/10/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import "iPadServerOpMonDetailViewController.h"
#import "ServerOperationQueueEntity.h"
#import "CoreDataProxy.h"

@implementation iPadServerOpMonDetailViewController

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithNibName:nil bundle:nil])) {
        self.view.frame = frame;
        self.view.backgroundColor = [UIColor whiteColor];
        
        contentView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:contentView];
    }
    
    return self;
}

- (void)setDetailOperationQueue:(ServerOperationQueue *)newDetailOperationQueue {
    detailOperationQueue = (newDetailOperationQueue != nil) ? [newDetailOperationQueue retain] : nil;
}

- (void)loadData {
    NSString *outputString = @"<html><head></head><body>";
    NSString *status = constEmptyStringValue;
    if (detailOperationQueue != nil) {/* отобразить детали только одной ветки (лог по одному loader'у) */
        outputString = [outputString stringByAppendingFormat:@"%@: %@ <br/>", detailOperationQueue.serverOperationName, detailOperationQueue.statusMessage];
        for (ServerOperationQueue *item in detailOperationQueue.children) {
            status = (item.statusMessage != nil) ? item.statusMessage : constEmptyStringValue;
            outputString = [outputString stringByAppendingFormat:@"%@: %@ <br/>", @"-- ", status];
        }
    }
    else {/* пройтись по всем записям верхнего уровня и собрать все детали с нижних уровней (общий лог по всем loader'ам) */
        ServerOperationQueueEntity *entity = [[ServerOperationQueueEntity alloc] initWithContext:[[CoreDataProxy sharedProxy] workContext]];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"visible = %@",[NSNumber numberWithBool:YES]];
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"dateEnqueued" ascending:YES];
        NSArray *list = [entity getListForPredicate:predicate sortDescriptor:sortDescriptor];
        for (ServerOperationQueue *item in list) {
            status = (item.statusMessage != nil) ? item.statusMessage : constEmptyStringValue;
            outputString = [outputString stringByAppendingFormat:@"%@: %@ <br/>", item.serverOperationName, status];
            for (ServerOperationQueue *child in item.children) {
                status = (child.statusMessage != nil) ? child.statusMessage : constEmptyStringValue;
                outputString = [outputString stringByAppendingFormat:@"%@: %@ <br/>", @"-- ", status];
            }
        }
        [entity release];
    }
    outputString = [outputString stringByAppendingFormat:@"<br/></body></html>"];
    [contentView loadHTMLString:outputString baseURL:nil];
}

- (void)dealloc {
    detailOperationQueue = nil;
    contentView = nil;
    [super dealloc];
}

@end
