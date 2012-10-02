//
//  iPadTitleValueCell.h
//  iDoc
//
//  Created by Dmitry Likhachev on 02/09/10.
//  Copyright 2010 KORUS Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFSUITableViewCell.h"

@interface iPadDocRequisiteCell: HFSUITableViewCell {	
	UILabel *requisiteName;
	UILabel *requisiteValue;
}

- (void)setRequisiteName:(NSString *)name;
- (void)setRequisiteValue:(NSString *)value;
@end


