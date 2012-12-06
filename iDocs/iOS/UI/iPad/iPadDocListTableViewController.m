//
//  iPadDocListTableViewController.m
//  iDoc
//
//  Created by Michael Syasko on 6/16/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import "iPadDocListTableViewController.h"
#import "SupportFunctions.h"
#import "iPadThemeBuildHelper.h"
#import "iPadDocViewCell.h"
#import "iPadPanelBodyBackgroundView.h"

#import <QuartzCore/QuartzCore.h>

#define HFS_FileAttributesDictionaryFileName @"fileName"
#define HFS_FileAttributesDictionaryFileExtension @"fileExtension"
#define HFS_FileAttributesDictionaryFileIcon @"fileIcon"
#define HFS_FileAttributesDictionaryFilePath @"filePath"
#define HFS_Level @"level"

NSInteger sortFilesByName(id file1, id file2, void *ascending) {
    NSString *file1Name = [((NSDictionary *)file1) valueForKey:HFS_FileAttributesDictionaryFileName];
    NSString *file2Name = [((NSDictionary *)file2) valueForKey:HFS_FileAttributesDictionaryFileName];
	if ([(NSNumber *)ascending boolValue] == NO)
		return [file2Name localizedCaseInsensitiveCompare:file1Name];
	else
        return [file1Name localizedCaseInsensitiveCompare:file2Name];
}

NSInteger sortFilesByCreationDate(id file1, id file2, void *ascending) {
    NSDate *file1Date = [((NSDictionary *)file1) objectForKey:NSFileCreationDate];
    NSDate *file2Date = [((NSDictionary *)file2) objectForKey:NSFileCreationDate];
	if ([(NSNumber *)ascending boolValue] == NO)
		return [file2Date compare:file1Date];
	else
        return [file1Date compare:file2Date];
}

NSInteger sortFilesByModificationDate(id file1, id file2, void *ascending) {
    NSDate *file1Date = [((NSDictionary *)file1) objectForKey:NSFileModificationDate];
    NSDate *file2Date = [((NSDictionary *)file2) objectForKey:NSFileModificationDate];
	if ([(NSNumber *)ascending boolValue] == NO)
		return [file2Date compare:file1Date];
	else
        return [file1Date compare:file2Date];
}


@implementation iPadDocListTableViewController

@synthesize tableView, items, currentPath, currentLevel, currentSearchString, sortField;

- (id)initWithDelegate:(id<iPadDocListTableViewControllerDelegate>)newDelegate {
	NSLog(@"iPadDocList initWithTableViewController");		
	if ((self = [super initWithNibName:nil bundle:nil])) {    
        
        delegate = newDelegate;
        iPadPanelBodyBackgroundView *leftSliderBodyBack = [[iPadPanelBodyBackgroundView alloc] init];
        leftSliderBodyBack.frame = CGRectOffset(CGRectInset(self.view.bounds, -2, 0), 2, 0);
        
        UIView *colorMaskView  = [[UIView alloc] initWithFrame:leftSliderBodyBack.bounds];
        colorMaskView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        colorMaskView.backgroundColor = [iPadThemeBuildHelper itemListBackgroundOverlayColor];
        [leftSliderBodyBack addSubview:colorMaskView];
        [colorMaskView release];

        [self.view addSubview:leftSliderBodyBack];
        [leftSliderBodyBack release];
        
        UITableView *tmpTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        self.tableView = tmpTableView;
        [tmpTableView release];
        tableView.scrollEnabled = YES;
        tableView.showsVerticalScrollIndicator = YES;
        tableView.showsHorizontalScrollIndicator = NO;
        tableView.rowHeight = 50.0f;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        tableView.dataSource = self;
        tableView.delegate = self;
        
        [self.view addSubview:tableView];
        
        NSMutableArray *emptyArray = [[NSMutableArray alloc] initWithCapacity:0];
        self.items = emptyArray;
        [emptyArray release];
        
        iconsMap = [[AttachmentTypeIconsDictionaryEntity alloc] init];
    }
    return self;    
}

- (NSIndexPath *)indexPathForSelectedRow {
    return [tableView indexPathForSelectedRow];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	int numberOfRowsInSection = [items count];
    return numberOfRowsInSection;
}

- (UITableViewCell *)tableView:(UITableView *)atableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *folderInfoCell = @"folderInfoCell";
    static NSString *fileInfoCell = @"fileInfoCell";
    NSDictionary *item = [items objectAtIndex:indexPath.row];
    BOOL isFolder = [[item objectForKey:NSFileType] isEqualToString:NSFileTypeDirectory];
    
    NSString *cellIdentifier = (isFolder?folderInfoCell:fileInfoCell);
    iPadDocViewCell *cell = (iPadDocViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil) {
		cell = [[[iPadDocViewCell alloc] initWithStyle:((isFolder || [item valueForKey:HFS_Level]) ? UITableViewCellStyleValue1 : UITableViewCellStyleDefault) reuseIdentifier:cellIdentifier] autorelease];
	}
    [cell setFileName:[item objectForKey:HFS_FileAttributesDictionaryFileName]];
    if ([item valueForKey:HFS_Level]){
        [cell.imageView setImage:[UIImage imageNamed:[iPadThemeBuildHelper nameForImage:@"back_icon.png"]]];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else {
        [cell.imageView setImage:(isFolder ? 
                                  [UIImage imageNamed:[iPadThemeBuildHelper nameForImage:@"file_folder_icon.png"]] :
                                  [UIImage imageNamed:[item objectForKey:HFS_FileAttributesDictionaryFileIcon]] 
                                  )];
        [cell setSizeValue:(isFolder ? constEmptyStringValue : [item objectForKey:NSFileSize])];
        
        [cell setTimeValue:[SupportFunctions convertDateToString:[item objectForKey:NSFileModificationDate] 
                                                      withFormat:constDateTimeFormat]];
        cell.accessoryType = (isFolder ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone);
    }    
	return cell;
}

- (void)tableView:(UITableView *)atableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSLog(@"iPadDocList didSelectRowAtIndexPath rowIndex: %i", indexPath.row);
	[self selectItemInRow:indexPath.row];
}

- (void)performInitialSelection {
    //Если первый элемент - папка, либо нет элементов в списке - сбрасываем превью, передавая в метод делегата nil
    //Иначе - выбираем первый элемент
    if ([items count] && [NSFileTypeRegular isEqualToString:[[items objectAtIndex:0] valueForKey:NSFileType]]) {
        [self selectItemInRow:0];
    } else if (delegate != nil && [delegate respondsToSelector:@selector(didSelectItem:)]) {
        [delegate didSelectItem:nil];
    }
}

- (NSDictionary *)makeItemForFileName:(NSString *)fileName
                        fileExtension:(NSString *)fileExtension
                             fileIcon:(NSString *)fileIcon
                             filePath:(NSString *)filePath
                             fileType:(NSString *)fileType
                     fileCreationDate:(NSDate *)fileCreationDate
                 fileModificationDate:(NSDate *)fileModificationDate
                             fileSize:(NSString *)fileSize {
    NSDictionary *storedAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                      fileName, HFS_FileAttributesDictionaryFileName,
                                      fileExtension, HFS_FileAttributesDictionaryFileExtension,
                                      fileIcon, HFS_FileAttributesDictionaryFileIcon,
                                      filePath, HFS_FileAttributesDictionaryFilePath,
                                      fileType, NSFileType, 
                                      fileCreationDate, NSFileCreationDate,
                                      fileModificationDate, NSFileModificationDate,
                                      fileSize, NSFileSize,
                                      nil];
    return storedAttributes;
}

- (void)loadItemsFilteredBySearchText:(NSString *)searchString 
                            sortField:(NSString *)field
                            ascending:(BOOL)asc {
	NSLog(@"iPadDocList loadItemsFilteredBySearchText:%@ withPath:%@ sortField:%@ asc:%i andLevel:%i", searchString, currentPath, field, asc, currentLevel);	
    
    [items removeAllObjects];
    self.currentSearchString = (searchString.length > 0) ? [searchString lowercaseString] : nil;
    self.sortField = field;
    ascending = asc;
    NSArray *allItems = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:currentPath error:nil];

    for (int i = 0; i < [allItems count]; i++) {        
        NSString *fileName = [allItems objectAtIndex:i];
        BOOL addToItems = YES;
        if (currentSearchString.length > 0) {
            NSRange searchTextRangeInFileName = [[fileName lowercaseString] rangeOfString:currentSearchString];
            addToItems = (searchTextRangeInFileName.location != NSNotFound) ? YES : NO;
        }

        if (addToItems == YES) {
            NSString *filePath = [NSString stringWithFormat: @"/%@/%@", currentPath, [allItems objectAtIndex:i]];
            NSString *fileExtension = [[NSString stringWithFormat: @"/%@/%@", currentPath, [allItems objectAtIndex:i]] pathExtension];
            NSString *fileIcon = [iPadThemeBuildHelper nameForImage:[iconsMap iconForAttachmentType:fileExtension]];
            
            NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
            NSString *fileType = [fileAttributes valueForKey:NSFileType];
            NSDate *fileCreationDate = [fileAttributes valueForKey:NSFileCreationDate];
            NSDate *fileModificationDate = [fileAttributes valueForKey:NSFileModificationDate];
            NSString *fileSize = [SupportFunctions formatAttachmentContentSize:[[fileAttributes valueForKey:NSFileSize] stringValue]];
            
            NSDictionary *storedAttributes = [self makeItemForFileName:fileName 
                                                         fileExtension:fileExtension 
                                                              fileIcon:fileIcon 
                                                              filePath:filePath 
                                                              fileType:fileType 
                                                      fileCreationDate:fileCreationDate 
                                              fileModificationDate:fileModificationDate
                                                              fileSize:fileSize];
            
            [items addObject:storedAttributes];
        }
    }
  
    if ([HFS_FileAttributesDictionaryFileName isEqualToString:sortField])
        self.items = [NSMutableArray arrayWithArray:[items sortedArrayUsingFunction:sortFilesByName context:[NSNumber numberWithBool:ascending]]];    
    else if ([NSFileCreationDate isEqualToString:sortField])
        self.items = [NSMutableArray arrayWithArray:[items sortedArrayUsingFunction:sortFilesByCreationDate context:[NSNumber numberWithBool:ascending]]];
    else if ([NSFileModificationDate isEqualToString:sortField])
        self.items = [NSMutableArray arrayWithArray:[items sortedArrayUsingFunction:sortFilesByModificationDate context:[NSNumber numberWithBool:ascending]]];
    
    //добавление обратной навигации для вложенных списков
    if (currentLevel > 0) {
        NSDictionary *storedAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                          @"..", HFS_FileAttributesDictionaryFileName,
                                          [NSNumber numberWithInt:currentLevel], HFS_Level,
                                          nil];
        [items insertObject:storedAttributes atIndex:0];
    }
	[tableView reloadData];
}

- (void)removeItemList {
	NSLog(@"iPadDocList removeItemList");
	[items removeAllObjects];
	[tableView reloadData];
}

- (void)selectItemInRow:(int)row {
	NSLog(@"iPadDocList selectItemInRow: %i", row);
	if ([items count] > row) {
		NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        NSDictionary *item = [items objectAtIndex:indexPath.row];	
        if ([item valueForKey:HFS_Level]) {
            [self.navigationController popViewControllerAnimated:YES];
        } else if ([[item valueForKey:NSFileType] isEqualToString:NSFileTypeRegular] && delegate != nil && [delegate respondsToSelector:@selector(didSelectItem:)]) {
			[delegate didSelectItem:item];
        } else {
            NSLog(@"[item valueForKey:HFS_FileAttributesDictionaryFilePath]: %@", [item valueForKey:HFS_FileAttributesDictionaryFilePath]);
            iPadDocListTableViewController *childController = [[iPadDocListTableViewController alloc] initWithDelegate:delegate];
            childController.currentPath = [item valueForKey:HFS_FileAttributesDictionaryFilePath];
            childController.currentLevel = (currentLevel + 1);
            //[childController loadItemsFilteredBySearchText:self.currentSearchString 
            //                                     sortField:sortField 
            //                                     ascending:ascending];
            [self.navigationController pushViewController:childController animated:YES];
            [childController release];
        }
	}
}

- (BOOL)isItemViewable:(int)row {
    if ([items count]>row) {
        NSDictionary *item = [items objectAtIndex:row];	
        return [NSFileTypeRegular isEqualToString:[item valueForKey:NSFileType]];
    }
    return NO;
}

- (int)numberOfLoadedItems {
	NSLog(@"iPadDocList numberOfLoadedItems");
	return [items count];
}

- (BOOL)hasFollowingRow:(int)index {
    return ([items count] > index + 1);
}

- (void)dealloc {
    self.items = nil;
    self.tableView = nil;
    self.currentPath = nil;
    self.currentSearchString = nil;
    self.sortField = nil;
    [iconsMap release];
    
    [super dealloc];
}
@end
