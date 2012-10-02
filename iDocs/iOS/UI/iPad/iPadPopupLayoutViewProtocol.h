//
//  iPadPopupLayoutViewProtocol.h
//  iDoc
//
//  Created by Konstantin Krupovich on 7/30/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol iPadPopupLayoutViewDelegate <NSObject>

- (void)showAuxView:(BOOL)yesNo;
- (void)setAuxViewContent:(UIView *)auxContent;

@end
