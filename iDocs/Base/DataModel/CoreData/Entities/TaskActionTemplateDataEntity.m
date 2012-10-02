//
//  TaskActionTemplateDataEntity.m
//  iDoc
//
//  Created by Konstantin Krupovich on 8/17/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import "TaskActionTemplateDataEntity.h"

@implementation TaskActionTemplateDataEntity

- (id)initWithContext:(NSManagedObjectContext *)newContext {
	if ((self = [super initWithContext:newContext andEntityName:@"TaskActionTemplate"])) {
	}
	return self;
}

- (TaskActionTemplate *)createTaskActionTemplate {
    return (TaskActionTemplate *)[NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:context];
}
@end
