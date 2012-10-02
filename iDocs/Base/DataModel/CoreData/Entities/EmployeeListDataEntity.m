////  EmployeeListDataEntity.m//  iDoc////  Created by Dmitry Likhachev on 12/9/09.//  Copyright 2009 KORUS Consulting. All rights reserved.//#import "EmployeeListDataEntity.h"@implementation EmployeeListDataEntity- (id)initWithContext:(NSManagedObjectContext *)newContext {	if ((self = [super initWithContext:newContext andEntityName:@"Employee"])) {	}	return self;}- (void)updateItem:(NSManagedObject *)item withData:(NSDictionary *)data {        ((Employee *)item).id = [data valueForKey:@"idElement"];    ((Employee *)item).name = [data valueForKey:@"nameElement"];    ((Employee *)item).subdivision = [data valueForKey:@"info_element_1"];    ((Employee *)item).organization = [data valueForKey:@"info_element_2"];    ((Employee *)item).position = [data valueForKey:@"info_element_3"];}- (Employee *)selectEmployeeById:(NSString *)employeeId {		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id = %@", employeeId];    NSArray *items = [context executeFetchRequestWithPredicate:predicate andEntityName:entityName andSortDescriptors:nil];	return ([items count] == 1) ? (Employee *)[items objectAtIndex:0] : nil;	}- (NSArray *)selectAllEmployeesInOrganization:(NSString *)organization {    NSSortDescriptor *sortByName = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortByName, nil];    BOOL allOrganizations = ([organization length] == 0) ? YES : NO;	NSPredicate *predicate =         [NSPredicate predicateWithFormat:@"(organization = %@) || (%@ == YES)", organization, [NSNumber numberWithBool:allOrganizations]];    NSArray *items =         [context executeFetchRequestWithPredicate:predicate andEntityName:entityName andSortDescriptors:sortDescriptors];	[sortDescriptors release];    return items;    }- (NSArray *)selectAllOrganizations {    return [context distinctValuesForField:@"organization" withEntityName:entityName withPredicate:nil];}- (void)dealloc {	[super dealloc];}@end