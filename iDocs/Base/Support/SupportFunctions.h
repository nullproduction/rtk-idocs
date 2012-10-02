//
//  SupportFunctions.h
//  iDoc
//
//  Created by Dmitry Likhachev on 2/25/09.
//  Copyright 2009 KORUS Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SupportFunctions : NSObject {
}

+ (NSDate *)currentDate;
+ (NSDate *)dateTime;

+ (NSDate *)convertStringToDate:(NSString *)dateString withFormat:(NSString *)formatSring;
+ (NSString *)convertDateToString:(NSDate *)date withFormat:(NSString *)formatSring;
+ (NSString *)formatDateString:(NSString *)dateString;
+ (NSString *)convertDateToXMLDateTimeString:(NSDate *)date;
+ (NSDate *)convertXMLDateTimeStringToDate:(NSString *)dateString;
+ (NSDate *)dateFromRFC1123:(NSString *)value;

+ (BOOL)date:(NSDate *)aDate lessThanDate:(NSDate *)bDate;
+ (BOOL)date:(NSDate *)aDate equalToDate:(NSDate *)bDate;
+ (BOOL)date:(NSDate *)aDate greaterThanDate:(NSDate *)bDate;

+ (BOOL)isStringInRussian:(NSString *)string;
+ (BOOL)isStringInLatin:(NSString *)string;
+ (BOOL)isNumberString:(NSString *)string;
+ (BOOL)isWhiteSpaceString:(NSString *)string;
+ (BOOL)isPlusSymbol:(NSString *)string;
+ (BOOL)isEmailCharacters:(NSString *)string;

+ (NSString *)removeWhiteSpacesfromString:(NSString *)inString;
+ (NSString *)formatAttachmentContentSize:(NSString *)contentSize;
+ (NSString *)createShortFIO:(NSString *)fio;

+ (NSString *)copyrightSymbol;
+ (NSString *)quatationMarkLeft;
+ (NSString *)quatationMarkRight;
+ (NSString *)addCopyrightSymbolToString:(NSString *)string;
+ (NSString *)addQuatationMarksToString:(NSString *)string;
+ (NSString *)convertXMLPredefinedEntitiesInString:(NSString *)string;

+ (NSString *)getORDFolderPath;
+ (NSString *)createPathForAttachment:(NSString *)attachmentId;
+ (void)deleteAttachment:(NSString *)attachmentId;
+ (NSString *)createWebDavFolderPathForDashboardItem:(NSString *)item;
+ (NSString *)createWebDavFolderNameForDashboardItem:(NSString *)dashboardItem;
+ (void)deleteWebDavFolderForDashBoardItem:(NSString *)item;
+ (void)deletePersonalWebDavFolderNameForUser:(NSString *)userName usingDashboardItem:(NSString *)dashboardItem;
+ (NSString *)getWebDavRootFolderPath;
+ (void)deleteAllWebDavFolders;
+ (void)createMockOutputFile:(NSString *)fileName withData:(NSMutableData *)data;

+ (void)setNetworkActivityIndicatorVisible:(BOOL)visible;
@end
