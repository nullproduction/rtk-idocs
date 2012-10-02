//
//  iPadEmployeeInfoCell.h
//  iDoc
//
//  Created by Dmitry Likhachev on 2/22/09.
//  Copyright 2009 KORUS Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iPadEmployeeInfoCell: UITableViewCell {
	UILabel *employeeIdLabel;	
	UILabel *employeeNameLabel;
    UILabel *employeeSubdivisionLabel;
    UILabel *employeePositionLabel;
    UIImageView *employeePicture;
}

- (void)setEmployeeId:(NSString *)employeeId;
- (void)setEmployeeName:(NSString *)name;
- (void)setEmployeeSubdivision:(NSString *)subdivision;
- (void)setEmployeePosition:(NSString *)position;
- (void)setEmployeePicture:(UIImage *)picture;
- (NSString *)value;

@end
