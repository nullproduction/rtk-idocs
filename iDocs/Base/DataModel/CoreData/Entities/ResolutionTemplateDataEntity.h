//
//  ResolutionTemplateDataEntity.h
//  iDoc
//
//  Created by rednekis on 11-07-21.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DictionaryBaseDataEntity.h"

@interface ResolutionTemplateDataEntity : DictionaryBaseDataEntity {
}

- (id)initWithContext:(NSManagedObjectContext *)newContext;
- (NSArray *)selectAll;

@end

