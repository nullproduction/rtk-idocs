//
//  iPadEmployeeListCompactViewContoller.m
//  iDoc
//
//  Created by Konstantin Krupovich on 7/30/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import "iPadEmployeeListCompactViewContoller.h"
#import "CoreDataProxy.h"
#import "EmployeeListDataEntity.h"
#import "Employee.h"
#import "iPadThemeBuildHelper.h"
#import "SystemDataEntity.h"

@implementation iPadEmployeeListCompactViewContoller

@synthesize employees, filteredEmployees;

- (id)initWithFrame:(CGRect)frame listDelegate:(id<iPadEmployeeListCompactViewContollerDelegate>)newDelegate{
    self = [super initWithNibName:nil bundle:nil];
    if (self != nil) {
        self.view.frame = frame;
        self.view.backgroundColor = [UIColor whiteColor];
        self.view.opaque = YES;
        delegate = newDelegate;
        
		CGRect employeeListTableFrame = self.view.bounds;
        self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        employeeListTable = [[UITableView alloc] initWithFrame:employeeListTableFrame style:UITableViewStylePlain];
		employeeListTable.backgroundColor = [UIColor whiteColor];
		employeeListTable.opaque = YES;
		employeeListTable.rowHeight = constInboxTabCellHeight;
		employeeListTable.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		employeeListTable.delegate = self;
		employeeListTable.dataSource = self;
        
        [self.view addSubview:employeeListTable];
		
        SystemDataEntity *systemEntity = [[SystemDataEntity alloc] initWithContext:[[CoreDataProxy sharedProxy] workContext]];
        UserInfo *user = [systemEntity userInfo];
        EmployeeListDataEntity *employeeListDataEntity = 
            [[EmployeeListDataEntity alloc] initWithContext:[[CoreDataProxy sharedProxy] workContext]];
        
        self.employees = [employeeListDataEntity selectAllEmployeesInOrganization:user.organization];
        NSMutableArray *employeesCopy = [self.employees mutableCopy];
        self.filteredEmployees = employeesCopy;
        [employeesCopy release];
        
        [employeeListDataEntity release];
        [systemEntity release];
        
        [employeeListTable reloadData];	 
    }
    return self;
}

- (CGSize)contentSizeForViewInPopover {
    return CGSizeMake(400, 400);
}

- (void)filterEmployeeListBySearchText:(NSString *)searchString {
	NSLog(@"iPadEmployeeList filter by string:%@", searchString);	
	[self.filteredEmployees removeAllObjects];	
	if (searchString.length == 0) {
        NSMutableArray *employeesCopy = [self.employees mutableCopy];
		self.filteredEmployees = employeesCopy;
        [employeesCopy release];
	}
	else if (searchString.length > 0) {
		for (int i = 0; i < [self.employees count]; i++) {
			NSString *employeeName = ((Employee *)[self.employees objectAtIndex:i]).name;
			NSRange searchTextRangeInEmployeeName = [employeeName rangeOfString:searchString options:NSCaseInsensitiveSearch];
			if (searchTextRangeInEmployeeName.location != NSNotFound) {
				[self.filteredEmployees addObject:[self.employees objectAtIndex:i]];
			}
		}
	}
    [employeeListTable reloadData];	   
}

#pragma mark UITableViewDataSource and UITableViewDelegate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.filteredEmployees count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {	
    static NSString *cellIdentifier = @"EmployeeInfoCell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        cell.textLabel.font = [UIFont systemFontOfSize:constMediumFontSize];
//        cell.textLabel.textColor = [iPadThemeBuildHelper commonTableSectionHeaderFontColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	Employee *employee = (Employee *)[self.filteredEmployees objectAtIndex:indexPath.row];
    cell.textLabel.text = employee.name;
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSLog(@"iPadEmployeeList didSelectRowAtIndexPath indexPath.row: %i", indexPath.row);
	Employee *employee = (Employee *)[self.filteredEmployees objectAtIndex:indexPath.row];
	if (delegate != nil && [delegate respondsToSelector:@selector(didSelectEmployeeWithName:andId:)])
		[delegate didSelectEmployeeWithName:employee.name andId:employee.id];
}

- (void)dealloc {
    [employeeListTable release];
    
    self.employees = nil;
    self.filteredEmployees = nil;
    
    [super dealloc];
}

@end
