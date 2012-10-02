//
//  AutoBuildIndexedCollation.h
//  iDoc
//
//  Created by Arthur on 8/4/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AutoBuildIndexedCollation : NSObject {
@private
  NSMutableArray *sectionIndexTitles_;
  NSArray *sectionTitles_;
}

- (id)initAndBuildIndexForArray:(NSArray *)array collationStringSelector:(SEL)selector;

#pragma mark - UILocalizedIndexedCollation iface

- (NSInteger)sectionForSectionIndexTitleAtIndex:(NSInteger)indexTitleIndex;

- (NSInteger)sectionForObject:(id)object collationStringSelector:(SEL)selector;

- (NSArray *)sortedArrayFromArray:(NSArray *)array collationStringSelector:(SEL)selector;

@property(nonatomic, readonly) NSArray *sectionTitles;
@property(nonatomic, readonly) NSArray *sectionIndexTitles;

@end
