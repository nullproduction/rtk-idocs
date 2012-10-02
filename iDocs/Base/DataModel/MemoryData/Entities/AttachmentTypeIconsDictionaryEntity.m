//
//  AttachmentTypeIconsDictionaryEntity.m
//  iDoc
//
//  Created by rednekis on 10-12-20.
//  Copyright 2010 KORUS Consulting. All rights reserved.
//

#import "AttachmentTypeIconsDictionaryEntity.h"

@implementation AttachmentTypeIconsDictionaryEntity

- (id)init {
	if ((self = [super init])) {
		NSBundle* bundle = [NSBundle mainBundle];
		NSString* plistPath = [bundle pathForResource:@"AttachmentTypeIconsDictionary" ofType:@"plist"];
		icons = [[NSDictionary alloc] initWithContentsOfFile:plistPath];		
	}
	return self;
}

- (NSString *)iconForAttachmentType:(NSString *)type {
	return [icons objectForKey:type];
}

- (void)dealloc {
	icons = nil;
	[super dealloc];
}

@end
