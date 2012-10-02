//
//  ResolutionTemplateDataEntity.m
//  iDoc
//
//  Created by rednekis on 11-07-21.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import "ResolutionTemplateDataEntity.h"
#import "ResolutionTemplate.h"

@implementation ResolutionTemplateDataEntity

- (id)initWithContext:(NSManagedObjectContext *)newContext {
	if ((self = [super initWithContext:newContext andEntityName:@"ResolutionTemplate"])) {
	}
	return self;
}

- (void)updateItem:(NSManagedObject *)item withData:(NSDictionary *)data { 
    ((ResolutionTemplate *)item).id = [data valueForKey:@"idElement"];
    ((ResolutionTemplate *)item).text = [data valueForKey:@"nameElement"];
}

- (NSArray *)selectAll {
    NSSortDescriptor *sortByText = [NSSortDescriptor sortDescriptorWithKey:@"text" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortByText, nil];
    NSArray *items = [context executeFetchRequestWithPredicate:nil andEntityName:entityName andSortDescriptors:sortDescriptors];
    [sortDescriptors release];
    
    return items;
}

- (void)dealloc {
	[super dealloc];
}

@end
