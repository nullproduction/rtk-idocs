//
//  HFSXMLParserDelegate.h
//  iDoc
//
//  Created by mark2 on 2/5/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HFSXMLParserDelegate<NSObject>

- (void)dataItemParsed:(NSMutableDictionary *)dataItem;

@end
