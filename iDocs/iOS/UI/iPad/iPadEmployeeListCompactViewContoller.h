//
//  iPadEmployeeListCompactViewContoller.h
//  iDoc
//
//  Created by Konstantin Krupovich on 7/30/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iPadBaseViewController.h"

@protocol iPadEmployeeListCompactViewContollerDelegate <NSObject>
- (void)didSelectEmployeeWithName:(NSString *)employeeName andId:(NSString *)employeeId;
@end

@interface iPadEmployeeListCompactViewContoller: iPadBaseViewController <UITableViewDelegate, UITableViewDataSource> {
    UITableView *employeeListTable; 
	id<iPadEmployeeListCompactViewContollerDelegate> delegate;	
    NSArray *employees;
	NSMutableArray *filteredEmployees;

}
@property (nonatomic, retain) NSArray *employees;
@property (nonatomic, retain) NSMutableArray *filteredEmployees;

- (id)initWithFrame:(CGRect)frame listDelegate:(id<iPadEmployeeListCompactViewContollerDelegate>)newDelegate;
- (void)filterEmployeeListBySearchText:(NSString *)searchString;

@end
