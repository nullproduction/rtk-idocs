//
//  iPadServerOpMonDetailViewController.h
//  iDoc
//
//  Created by Konstantin Krupovich on 8/10/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerOperationQueue.h"

@interface iPadServerOpMonDetailViewController : UIViewController {
    ServerOperationQueue *detailOperationQueue;
    UIWebView *contentView;
}

- (id)initWithFrame:(CGRect)frame;
- (void)setDetailOperationQueue:(ServerOperationQueue *)newDetailEntity;
- (void)loadData;

@end
