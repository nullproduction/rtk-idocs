//
//  EmployeeGroupDataEntity.m
//  iDoc
//
//  Created by rednekis on 11-07-21.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import "EmployeeGroupDataEntity.h"
#import "EmployeeGroup.h"

@implementation EmployeeGroupDataEntity

- (id)initWithContext:(NSManagedObjectContext *)newContext {
	if ((self = [super initWithContext:newContext andEntityName:@"EmployeeGroup"])) {
	}
	return self;
}

- (void)updateItem:(NSManagedObject *)item withData:(NSDictionary *)data {    
    ((EmployeeGroup *)item).id = [data valueForKey:@"idElement"];
    ((EmployeeGroup *)item).name = [data valueForKey:@"nameElement"];
}

- (void)dealloc {
	[super dealloc];
}

@end
