//
//  TaskActionTemplateDataEntity.h
//  iDoc
//
//  Created by Konstantin Krupovich on 8/17/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DictionaryBaseDataEntity.h"
#import "TaskActionTemplate.h"

@interface TaskActionTemplateDataEntity : DictionaryBaseDataEntity

- (id)initWithContext:(NSManagedObjectContext *)newContext;
- (TaskActionTemplate *)createTaskActionTemplate;

@end
