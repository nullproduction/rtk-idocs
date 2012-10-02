//
//  AttachmentTypeIconsDictionaryEntity.h
//  iDoc
//
//  Created by rednekis on 10-12-20.
//  Copyright 2010 KORUS Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AttachmentTypeIconsDictionaryEntity : NSObject {
	NSDictionary *icons;	
}

- (id)init;
- (NSString *)iconForAttachmentType:(NSString *)type;

@end
