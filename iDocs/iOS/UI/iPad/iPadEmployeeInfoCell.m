//
//  iPadEmployeeInfoCell.m
//  iDoc
//
//  Created by Dmitry Likhachev on 2/22/09.
//  Copyright 2009 KORUS Consulting. All rights reserved.
//

#import "iPadEmployeeInfoCell.h"
#import "Constants.h"
#import "iPadThemeBuildHelper.h"

@implementation iPadEmployeeInfoCell

- (id)initWithStyle:(UITableViewCellStyle)UITableViewCellStyle reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier])) {
		self.accessoryType = UITableViewCellAccessoryNone;
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		self.backgroundColor = [UIColor clearColor];
		self.opaque = NO;
		
		employeeIdLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 0.0f, 0.0f)];
		employeeIdLabel.hidden = YES;
		[[self contentView] addSubview:employeeIdLabel];
		
		employeeNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(74.0f, 3.0f, 450.0f, 20.0f)];
		employeeNameLabel.hidden = NO;
		employeeNameLabel.opaque = YES;
		employeeNameLabel.enabled = YES;
		employeeNameLabel.font = [UIFont systemFontOfSize:constMediumFontSize];
		employeeNameLabel.textColor = [iPadThemeBuildHelper commonTextFontColor1];        
		employeeNameLabel.textAlignment = UITextAlignmentLeft;
		employeeNameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;			
		employeeNameLabel.backgroundColor = [UIColor clearColor];		
		[[self contentView] addSubview:employeeNameLabel];
        
        employeePositionLabel = [[UILabel alloc] initWithFrame:CGRectMake(74.0f, 22.0f, 450.0f, 20.0f)];
		employeePositionLabel.hidden = NO;
		employeePositionLabel.opaque = YES;
		employeePositionLabel.enabled = YES;
		employeePositionLabel.font = [UIFont systemFontOfSize:constSmallFontSize];
		employeePositionLabel.textColor = [iPadThemeBuildHelper commonTextFontColor2];        
		employeePositionLabel.textAlignment = UITextAlignmentLeft;
		employeePositionLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;			
		employeePositionLabel.backgroundColor = [UIColor clearColor];		
		[[self contentView] addSubview:employeePositionLabel];
        
        employeeSubdivisionLabel = [[UILabel alloc] initWithFrame:CGRectMake(74.0f, 34.0f, 450.0f, 20.0f)];
		employeeSubdivisionLabel.hidden = NO;
		employeeSubdivisionLabel.opaque = YES;
		employeeSubdivisionLabel.enabled = YES;
		employeeSubdivisionLabel.font = [UIFont systemFontOfSize:constSmallFontSize];
		employeeSubdivisionLabel.textColor = [iPadThemeBuildHelper commonTextFontColor2];        
		employeeSubdivisionLabel.textAlignment = UITextAlignmentLeft;
		employeeSubdivisionLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;			
		employeeSubdivisionLabel.backgroundColor = [UIColor clearColor];		
		[[self contentView] addSubview:employeeSubdivisionLabel];
                
        employeePicture = [[UIImageView alloc] initWithFrame:CGRectMake(8.0f, 8.0f, 44.0f, 44.0f)];
        [[self contentView] addSubview:employeePicture];
    }
    return self;
}

- (void)setEmployeeId:(NSString *)employeeId {
	employeeIdLabel.text = employeeId;	
}

- (void)setEmployeeName:(NSString *)name {
	employeeNameLabel.text = name;	
}

- (void)setEmployeeSubdivision:(NSString *)subdivision {
    employeeSubdivisionLabel.text = subdivision;
}

- (void)setEmployeePosition:(NSString *)position {
    employeePositionLabel.text = position; 
}

- (void)setEmployeePicture:(UIImage *)picture {
    employeePicture.image = picture;
}

- (NSString *)value {
	return employeeNameLabel.text;
}
 
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)dealloc {
	[employeeIdLabel release];	
	[employeeNameLabel release];
    [super dealloc];
}


@end
