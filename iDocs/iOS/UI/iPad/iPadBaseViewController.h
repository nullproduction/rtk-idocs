//
//  BaseiPadViewController.h
//  iDoc
//
//  Created by mark2 on 12/17/10.
//  Copyright 2010 KORUS Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+Blockable.h"
#import "UIViewController+Alert.h"

@interface iPadBaseViewController : UIViewController {
}

//Переопределяется для использования нестандартного цвета (background_tile.png)
- (UIColor *)backgroundColor;
- (void)onOperationStart;
- (void)onOperationEnd:(NSError *)error;

@end
