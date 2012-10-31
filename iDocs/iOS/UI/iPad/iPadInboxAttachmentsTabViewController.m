//
//  iPadInboxAttachmentsTabViewController.m
//  iDoc
//
//  Created by rednekis on 10-12-19.
//  Copyright 2010 KORUS Consulting. All rights reserved.
//

#import "iPadInboxAttachmentsTabViewController.h"
#import "Constants.h"
#import "SupportFunctions.h"
#import "iPadThemeBuildHelper.h"
#import "DocAttachment.h"
#import "UIWebView+Block.h"


@interface iPadInboxAttachmentsTabViewController (PrivateMethods)
- (void)showAttachmentButtonPressed:(id)sender;
@end

@implementation iPadInboxAttachmentsTabViewController

@synthesize treatmentItems;

#pragma mark custom methods - init
- (id)initWithPlaceholderPanel:(UIView *)placeholderPanel {
	NSLog(@"iPadInboxAttachmentsTab init");	
	if ((self = [super initWithNibName:nil bundle:nil])) {
		container = [[iPadInboxAttachmentsTabLayoutView alloc] init];
        [container setDelegate:self];
		container.frame = placeholderPanel.bounds;
		self.view = container;
		[placeholderPanel addSubview:container];
	}
	return self;
}


#pragma mark custom methods - load data

- (void)loadTabData:(NSArray *)newAttachments {
	NSLog(@"iPadInboxAttachmentsTab loadTabData");
    if (attachments != nil)
        [attachments release];
	attachments = [newAttachments copy];
    
    iPadInboxAttachmentsTabLayoutView *layout = (iPadInboxAttachmentsTabLayoutView *)self.view;
    [layout setupPages:[attachments count]];
}


#pragma mark iPadTaskAttachmentsTabLayoutViewDelegate methods

- (NSArray *)itemForPage:(int)page {
    NSArray *itemInfo = nil;
    DocAttachment *attachment = nil;
    if ([attachments count] && page < [attachments count]) {
        attachment = [attachments objectAtIndex:page];
        itemInfo = [NSArray arrayWithObjects:attachment.name, attachment.fileName, nil];
    }
    else {
        itemInfo = [NSArray arrayWithObjects:constEmptyStringValue, constEmptyStringValue, nil];
    }
    return itemInfo;
}


#pragma mark other methods

- (void)didReceiveMemoryWarning {
	NSLog(@"iPadInboxAttachmentsTab didReceiveMemoryWarning");		
    // Releases the iPadSearchFilter if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc. that aren't in use.
}

- (void)dealloc {
	[attachments release];
	[container release];
	[super dealloc];
}
@end
