//
//  SupportFunctions.m
//  iDoc
//
//  Created by Dmitry Likhachev on 2/25/09.
//  Copyright 2009 KORUS Consulting. All rights reserved.
//

#import "SupportFunctions.h"
#import "Constants.h"
#import "UserDefaults.h"

@implementation SupportFunctions

#pragma mark date functions
+ (NSDate *)currentDate {
	return [NSDate date];
}

+ (NSDate *)dateTime {
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger flags = NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit;
    NSDateComponents *components = [calendar components:flags fromDate:date];
    NSDate *dateTime = [calendar dateFromComponents:components];
    return dateTime;
}

#pragma mark date conversion functions
+ (NSDate *)convertStringToDate:(NSString *)dateString withFormat:(NSString *)formatString {
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:formatString];
	[dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
	NSDate *date = [dateFormatter dateFromString:dateString];
	[dateFormatter release];
	return date;
}

+ (NSString *)convertDateToString:(NSDate *)date withFormat:(NSString *)formatString {
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:formatString];
	[dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];    
	NSString *dateString = [dateFormatter stringFromDate:date];
	[dateFormatter release];
	return dateString;
}

+ (NSString *)formatDateString:(NSString *)dateString {
	return [dateString substringToIndex:5];	
}

+ (NSString *)convertDateToXMLDateTimeString:(NSDate *)date {
	//xml format example - 2001-10-26T21:32:52.000+03:00
	NSString *dateNoZone = [SupportFunctions convertDateToString:date withFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
	NSString *dateZone = [SupportFunctions convertDateToString:date withFormat:@"ZZZ"];
	NSString *dateZonePart1 = [dateZone substringToIndex:([dateZone length] - 2)];
	NSString *dateZonePart2 = [dateZone substringFromIndex:([dateZone length] - 2)];
	NSString *xmlDate = [NSString stringWithFormat:@"%@%@:%@", dateNoZone, dateZonePart1, dateZonePart2];
	return xmlDate;
}

+ (NSDate *)convertXMLDateTimeStringToDate:(NSString *)dateString {
	//xml format example - 2001-10-26T21:32:52.000+03:00
	NSDate *date = nil;
    if ([dateString length] == 29) {
        NSString *dateStringPart1 = [dateString substringToIndex:([dateString length] - 3)];
        NSString *dateStringPart2 = [dateString substringFromIndex:([dateString length] - 2)]; 
        dateString = [NSString stringWithFormat:@"%@%@", dateStringPart1, dateStringPart2];
    
        date = [SupportFunctions convertStringToDate:dateString withFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZ"];
    }
	return date;
}

+ (NSDate *)dateFromRFC1123:(NSString*)value {
    NSString *value_ = value;
    if(value_ == nil)
        return nil;
    static NSDateFormatter *rfc1123 = nil;
    if(rfc1123 == nil) {
        rfc1123 = [[NSDateFormatter alloc] init];
        rfc1123.locale = [[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease];
        rfc1123.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        rfc1123.dateFormat = @"EEE',' dd MMM yyyy HH':'mm':'ss z";
        //        rfc1123.dateFormat = @"EEE, dd MMM yyyy HH:mm:ss z";
    }
    NSDate *ret = [rfc1123 dateFromString:value_];
    if(ret != nil)
        return ret;
    
    static NSDateFormatter *rfc850 = nil;
    if(rfc850 == nil) {
        rfc850 = [[NSDateFormatter alloc] init];
        rfc850.locale = rfc1123.locale;
        rfc850.timeZone = rfc1123.timeZone;
        rfc850.dateFormat = @"EEEE',' dd'-'MMM'-'yy HH':'mm':'ss z";
    }
    ret = [rfc850 dateFromString:value_];
    if(ret != nil)
        return ret;
    
    static NSDateFormatter *asctime = nil;
    if(asctime == nil) {
        asctime = [[NSDateFormatter alloc] init];
        asctime.locale = rfc1123.locale;
        asctime.timeZone = rfc1123.timeZone;
        asctime.dateFormat = @"EEE MMM d HH':'mm':'ss yyyy";
    }
    return [asctime dateFromString:value_];
}


#pragma mark date compare functions
+ (BOOL)date:(NSDate *)aDate lessThanDate:(NSDate *)bDate {
	BOOL result = false;
	if([aDate compare:bDate] == NSOrderedAscending) result = true;
	return result;
}

+ (BOOL)date:(NSDate *)aDate equalToDate:(NSDate *)bDate {
	BOOL result = false;
	if([aDate compare:bDate] == NSOrderedSame) result = true;
	return result;
}

+ (BOOL)date:(NSDate *)aDate greaterThanDate:(NSDate *)bDate {
	BOOL result = false;
	if([aDate compare:bDate] == NSOrderedDescending) result = true;
	return result;
}

#pragma mark validation functions
+ (BOOL)isStringInRussian:(NSString *)string {
	BOOL isInRussian = YES;
	NSCharacterSet *russianLetterCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"`-АаБбВвГгДдЕеЁёЖжЗзИиЙйКкЛлМмНнОоПпРрСсТтУуФфХхЦцЧчШшЩщЪъЫыЬьЭэЮюЯя"];	
	NSCharacterSet *whitespaceCharacterSet = [NSCharacterSet whitespaceCharacterSet];	
	for(int i = 0; string.length > i; i++) {
		unichar symbol = [string characterAtIndex:i];
		isInRussian = ([russianLetterCharacterSet characterIsMember:symbol] || [whitespaceCharacterSet characterIsMember:symbol]);
		if(!isInRussian)
			break;
	}
	return isInRussian;
}

+ (BOOL)isStringInLatin:(NSString *)string {
	BOOL isInLatin = YES;
	NSCharacterSet *englishLetterCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"`-AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz"];	
	NSCharacterSet *whitespaceCharacterSet = [NSCharacterSet whitespaceCharacterSet];	
	for(int i = 0; string.length > i; i++) {
		unichar symbol = [string characterAtIndex:i];
		isInLatin = ([englishLetterCharacterSet characterIsMember:symbol] || [whitespaceCharacterSet characterIsMember:symbol]);
		if(!isInLatin)
			break;
	}
	return isInLatin;	
}

+ (BOOL)isNumberString:(NSString *)string {
	BOOL isNumberString = YES;	
	NSCharacterSet *numberCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];	
	for(int i = 0; string.length > i; i++) {
		unichar symbol = [string characterAtIndex:i];
		isNumberString = [numberCharacterSet characterIsMember:symbol];
		if(!isNumberString)
			break;
	}	
	return isNumberString;
}

+ (BOOL)isWhiteSpaceString:(NSString *)string {
	BOOL isWhiteSpaceString = YES;	
	for(int i = 0; string.length > i; i++) {
		unichar symbol = [string characterAtIndex:i];
		isWhiteSpaceString = [[NSCharacterSet whitespaceCharacterSet] characterIsMember:symbol];
		if(!isWhiteSpaceString)
			break;
	}	
	return isWhiteSpaceString;
}

+ (BOOL)isPlusSymbol:(NSString *)string {
	BOOL isPlusSymbol = YES;	
	NSCharacterSet *plusCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"+"];	
	for(int i = 0; string.length > i; i++) {
		unichar symbol = [string characterAtIndex:i];
		isPlusSymbol = [plusCharacterSet characterIsMember:symbol];
		if(!isPlusSymbol)
			break;
	}	
	return isPlusSymbol;
}

+ (BOOL)isEmailCharacters:(NSString *)string {
	BOOL isEmailCharacters = YES;
	NSCharacterSet *emailSymbolsCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@".@-_1234567890AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz"];		
	for(int i = 0; string.length > i; i++) {
		unichar symbol = [string characterAtIndex:i];
		isEmailCharacters = ([emailSymbolsCharacterSet characterIsMember:symbol]);
		if(!isEmailCharacters)
			break;
	}
	return isEmailCharacters;	
}


#pragma mark string functions
+ (NSString *)removeWhiteSpacesfromString:(NSString *)inString {
	NSString *outString = constEmptyStringValue;
	NSArray *inStringComponents = [inString componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	for(NSString *string in inStringComponents) {
		outString = [outString stringByAppendingString:string];
	}
	return outString;	
}


+ (NSString *)formatAttachmentContentSize:(NSString *)contentSize {
	float bytes = [contentSize floatValue];
	int kbytes = (int)ceil(bytes/1024.0f);
	NSString *formatedContentSize = [NSString stringWithFormat:@"%i %@", kbytes, NSLocalizedString(@"KbyteTitle", nil)];
	return formatedContentSize;
}

+ (NSString *)createShortFIO:(NSString *)fio {
    NSString *shortFio;
    NSArray *chunks = [fio componentsSeparatedByString:@" "];
    if ([chunks count] == 3) {
        NSString *surname = [chunks objectAtIndex:0];
        NSString *name = [chunks objectAtIndex:1];
        NSString *patronimic = [chunks objectAtIndex:2];
        if ([name length] >= 1 && [patronimic length] >= 1) {
            NSString *nameInitial = [name substringToIndex:1];       
            NSString *patronimicInitial = [patronimic substringToIndex:1];
            shortFio = [NSString stringWithFormat:@"%@ %@.%@.", surname, nameInitial, patronimicInitial];
        }
        else {
            shortFio = fio;
        }
    }
    else {
        shortFio = fio;      
    }
    return shortFio;
}


#pragma mark string with unicode symbols generation functions
+ (NSString *)copyrightSymbol {
	return [NSString stringWithUTF8String:"\u00A9"];
}

+ (NSString *)quatationMarkLeft {
	return [NSString stringWithUTF8String:"\u00AB"];
}

+ (NSString *)quatationMarkRight {
	return [NSString stringWithUTF8String:"\u00BB"];
}

+ (NSString *)addCopyrightSymbolToString:(NSString *)string {
	NSString *copyrightSymbol = [NSString stringWithUTF8String:"\u00A9"];	
	NSString *stringWithCopyrightSymbol = [NSString stringWithFormat:@"%@ %@", copyrightSymbol, string];	
	return stringWithCopyrightSymbol;
}

+ (NSString *)addQuatationMarksToString:(NSString *)string {
	NSString *quatationMarkLeft = [NSString stringWithUTF8String:"\u00AB"];
	NSString *quatationMarkRight = [NSString stringWithUTF8String:"\u00BB"];	
	NSString *stringWithQuatationMarks = [NSString stringWithFormat:@"%@%@%@", quatationMarkLeft, string, quatationMarkRight];
	return stringWithQuatationMarks;
}

+ (NSString *)convertXMLPredefinedEntitiesInString:(NSString *)string {
    string = [string stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];
    string = [string stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"];
    string = [string stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"];
    string = [string stringByReplacingOccurrencesOfString:@"'" withString:@"&apos;"];
    string = [string stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"];
    return string;
}

#pragma mark io management
+ (NSString *)getORDFolderPath {
    NSString *folderPath = [UserDefaults ordFolder];
    BOOL folderExists = [[NSFileManager defaultManager] fileExistsAtPath:folderPath];
    if (!folderExists) { 
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:&error];
        if (error != nil) {
            NSLog(@"Error description: %@ \n", [error localizedDescription]);
            NSLog(@"Error reason: %@", [error localizedFailureReason]);            
        }
    }
    return folderPath;
}

+ (NSString *)createPathForAttachment:(NSString *)attachmentId {
    NSString *folderPath = [SupportFunctions getORDFolderPath];
    NSString *itemPath = [folderPath stringByAppendingPathComponent:attachmentId];
    return itemPath;
}

+ (void)deleteAttachment:(NSString *)attachmentId {
    NSString *itemPath = [SupportFunctions createPathForAttachment:attachmentId];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:itemPath];
    if (fileExists) {
        NSError *error = nil;
        [[NSFileManager defaultManager] removeItemAtPath:itemPath error:&error];
        if (error != nil) {
            NSLog(@"Error description: %@ \n", [error localizedDescription]);
            NSLog(@"Error reason: %@", [error localizedFailureReason]);            
        }
    }
}

+ (NSString *)createWebDavFolderPathForDashboardItem:(NSString *)item {
    NSString *itemFolder = [SupportFunctions createWebDavFolderNameForDashboardItem:item];
    NSString *folderPath = [SupportFunctions getWebDavRootFolderPath];
    NSString *itemPath = [folderPath stringByAppendingPathComponent:itemFolder];
    return itemPath;
}

+ (NSString *)createWebDavFolderNameForDashboardItem:(NSString *)dashboardItem {
    NSString *webDavLogin = [UserDefaults stringSettingByKey:constWebDavServerUser];
    webDavLogin = ([webDavLogin length] > 0) ? webDavLogin : constEmptyStringValue; 
    NSString *webDavFolder = [dashboardItem stringByReplacingOccurrencesOfString:maskMyDocsWebDavFolder withString:webDavLogin];
    return webDavFolder;
}

+ (void)deleteWebDavFolderForDashBoardItem:(NSString *)item {
    NSString *itemFolder = [SupportFunctions createWebDavFolderNameForDashboardItem:item];
    NSString *folderPath = [SupportFunctions getWebDavRootFolderPath];
     NSString *itemPath = [folderPath stringByAppendingPathComponent:itemFolder];
    BOOL pathExists = [[NSFileManager defaultManager] fileExistsAtPath:itemPath];
    if (pathExists) {
        NSError *error = nil;
        [[NSFileManager defaultManager] removeItemAtPath:itemPath error:&error];
        if (error != nil) {
            NSLog(@"Error description: %@ \n", [error localizedDescription]);
            NSLog(@"Error reason: %@", [error localizedFailureReason]);            
        }
    }
}

+ (void)deletePersonalWebDavFolderNameForUser:(NSString *)userName usingDashboardItem:(NSString *)dashboardItem {
    userName = ([userName length] > 0) ? userName : constEmptyStringValue; 
    NSString *itemFolder = [dashboardItem stringByReplacingOccurrencesOfString:maskMyDocsWebDavFolder withString:userName];
    NSString *folderPath = [SupportFunctions getWebDavRootFolderPath];
    NSString *itemPath = [folderPath stringByAppendingPathComponent:itemFolder];
    BOOL pathExists = [[NSFileManager defaultManager] fileExistsAtPath:itemPath];
    if (pathExists) {
        NSError *error = nil;
        [[NSFileManager defaultManager] removeItemAtPath:itemPath error:&error];
        if (error != nil) {
            NSLog(@"Error description: %@ \n", [error localizedDescription]);
            NSLog(@"Error reason: %@", [error localizedFailureReason]);            
        }
    }    
}

+ (NSString *)getWebDavRootFolderPath {
	NSString *folderPath = [UserDefaults webDavFolder];
    BOOL folderExists = [[NSFileManager defaultManager] fileExistsAtPath:folderPath];
    if (!folderExists) { 
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:&error];
        if (error != nil) {
            NSLog(@"Error description: %@ \n", [error localizedDescription]);
            NSLog(@"Error reason: %@", [error localizedFailureReason]);            
        }
    }
    return folderPath;
}


+ (void)deleteAllWebDavFolders {
    NSString *path = [SupportFunctions getWebDavRootFolderPath];
    BOOL pathExists = [[NSFileManager defaultManager] fileExistsAtPath:path];
    if (pathExists) {
        NSError *error = nil;
        [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
        if (error != nil) {
            NSLog(@"Error description: %@ \n", [error localizedDescription]);
            NSLog(@"Error reason: %@", [error localizedFailureReason]);            
        }
    }
}

+ (void)createMockOutputFile:(NSString *)fileName withData:(NSMutableData *)data {
	NSLog(@"SupportFunctions creating output xml: %@", fileName);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *mockDirectory = [documentsDirectory stringByAppendingPathComponent:@"Mock"];
    
    BOOL folderExists = [[NSFileManager defaultManager] fileExistsAtPath:mockDirectory];
    if (!folderExists) { 
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:mockDirectory withIntermediateDirectories:YES attributes:nil error:&error];
        if (error != nil) {
            NSLog(@"Error description: %@ \n", [error localizedDescription]);
            NSLog(@"Error reason: %@", [error localizedFailureReason]);            
        }
    }
    
    NSString *pathForXmlFile = [mockDirectory stringByAppendingPathComponent:fileName];
    
    [data writeToFile:pathForXmlFile atomically:YES];
    
    NSLog(@"SupportFunctions writing output data to: %@", pathForXmlFile);
    
	return;
}

#pragma mark network functions
+ (void)setNetworkActivityIndicatorVisible:(BOOL)visible {
#if TARGET_OS_IPHONE
	// TODO: thread safe
	static NSInteger networkActivityIndicatorCounter = 0;
	if (visible) {
		++ networkActivityIndicatorCounter;    
		if (networkActivityIndicatorCounter == 1) {
			[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
		}    
	}
	else {
		-- networkActivityIndicatorCounter;
		if (networkActivityIndicatorCounter < 1) {
			[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
			networkActivityIndicatorCounter = 0;
		}
	}
#else
	// TODO: OS X?
#endif
}

@end
