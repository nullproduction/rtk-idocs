//
//  DictionaryBaseDataEntity.h
//  iDoc
//
//  Created by rednekis on 11-07-21.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DictionaryDataItemEntityDelegate.h"
#import "NSManagedObjectContext+CustomFetch.h"
#import "Constants.h"

@interface DictionaryBaseDataEntity : NSObject <DictionaryDataItemEntityDelegate> {
	NSManagedObjectContext *context;     
    NSString *entityName;
}

- (id)initWithContext:(NSManagedObjectContext *)newContext andEntityName:(NSString *)newEntityName;
- (void)deleteAll;
- (NSArray *)selectAll;
- (void)deleteItemWithId:(NSString *)itemId;
- (void)updateItemWithData:(NSDictionary *)data;
- (void)createItemWithData:(NSDictionary *)data;
- (void)updateItem:(NSManagedObject *)item withData:(NSDictionary *)data;

@end
