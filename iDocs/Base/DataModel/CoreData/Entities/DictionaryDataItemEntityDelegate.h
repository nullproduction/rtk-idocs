//
//  DictionaryDataItemEntityDelegate.h
//  iDoc
//
//  Created by mark2 on 2/1/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

@protocol DictionaryDataItemEntityDelegate<NSObject>
- (void)deleteItemWithId:(NSString *)itemId;
- (void)updateItemWithData:(NSDictionary *)data;
- (void)createItemWithData:(NSDictionary *)data;
- (void)deleteAll;
@end
