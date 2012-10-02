//
//  iPadTaskDocDescCell.h
//  iDoc
//
//  Created by Dmitry Likhachev on 1/31/10.
//  Copyright 2009 KORUS Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iPadTaskDocDescCell: UITableViewCell {
	UILabel *docTypeNameLabel;
	UILabel *docDescLabel;
}

- (void)setDocTypeName:(NSString *)docTypeName;
- (void)setDocDesc:(NSString *)docDesc;	
@end
