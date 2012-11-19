//
//  ActionsSubmitResultXMLParser.h
//  iDoc
//
//  Created by rednekis on 8/12/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseXmlParser.h"

@interface ActionsSubmitResultXMLParser : BaseXmlParser {
    NSMutableArray *results;
    
}

- (id)init;
- (NSArray *)parseActionsSubmitResult:(NSData *)data error:(NSError **)parseError;
- (BOOL)parseTaskReadSubmitResult:(NSData *)data error:(NSError **)parseError;

@end
