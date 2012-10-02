//
//  AutoBuildIndexedCollation.m
//  iDoc
//
//  Created by Arthur on 8/4/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import "AutoBuildIndexedCollation.h"

static NSString * kOtherSym = @"#";

@interface AutoBuildIndexedCollation (PrivateMethods)
+ (NSString *)unicharToString:(unichar)c;
- (void)buildIndexForArray:(NSArray *)array collationStringSelector:(SEL)selector;
@end

@implementation AutoBuildIndexedCollation
// TODO: Стоит ли ограничивать максимальное (и минимальное) количество индексов и заменять их точками?
@synthesize sectionTitles = sectionTitles_, sectionIndexTitles = sectionIndexTitles_;

+ (NSString *)unicharToString:(unichar)c {
	return [NSString stringWithFormat:@"%C", c];
}

- (id)initAndBuildIndexForArray:(NSArray *)array collationStringSelector:(SEL)selector {
	self = [super init];
	if (self) {
		[self buildIndexForArray:array collationStringSelector:selector];
	}
	return self;
}

- (void)dealloc {
	[sectionTitles_ release];
	[sectionIndexTitles_ release];
	[super dealloc];
}

- (void)buildIndexForArray:(NSArray *)array collationStringSelector:(SEL)selector {
	[sectionIndexTitles_ release];
	sectionIndexTitles_ = [[NSMutableArray alloc] init];
	NSCharacterSet * letters = [NSCharacterSet letterCharacterSet];

	BOOL hasOtherSym = FALSE;
	for (id obj in array) {
		id strObj = [obj performSelector:selector];
		
		if (![strObj isKindOfClass:[NSString class]]) continue;
		
		NSString * str = strObj;		
		if ([str length] == 0) hasOtherSym = TRUE;
		
		unichar firstChar = [[str uppercaseString] characterAtIndex:0];
		if ([letters characterIsMember:firstChar]) {
			NSString * key = [[self class] unicharToString:firstChar];
			if ([sectionIndexTitles_ indexOfObject:key] == NSNotFound) {
				[sectionIndexTitles_ addObject:key];
			}
		}      
		else if (!hasOtherSym){
			hasOtherSym = TRUE;
		}
	}
	
	[sectionIndexTitles_ sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];  
	if (hasOtherSym) [sectionIndexTitles_ addObject:kOtherSym];
	
	[sectionTitles_ release];
	sectionTitles_ = [sectionIndexTitles_ retain];
}

#pragma mark - UILocalizedIndexedCollation iface

- (NSInteger)sectionForSectionIndexTitleAtIndex:(NSInteger)indexTitleIndex {
	return indexTitleIndex;
}

- (NSInteger)sectionForObject:(id)object collationStringSelector:(SEL)selector {
	NSInteger const otherSymId = [self.sectionTitles indexOfObject:kOtherSym];
	
	id strObj = [object performSelector:selector];
	if (![strObj isKindOfClass:[NSString class]]) return otherSymId;

	NSString * str = strObj;
	if ([str length] == 0) return otherSymId;
	
	unichar firstChar = [[str uppercaseString] characterAtIndex:0];
	
	NSInteger const foundAt = [self.sectionTitles indexOfObject:[[self class] unicharToString:firstChar]];
	if (foundAt == NSNotFound) return otherSymId;
	return foundAt;
}

- (NSArray *)sortedArrayFromArray:(NSArray *)array collationStringSelector:(SEL)selector {
	NSArray * sortedArray = [array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
		NSString * str1 = [obj1 performSelector:selector];
		NSString * str2 = [obj2 performSelector:selector];
		return [str1 compare:str2];
	}];
	return sortedArray;
}

@end
