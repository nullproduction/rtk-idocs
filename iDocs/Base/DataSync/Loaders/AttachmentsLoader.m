//
//  AttachmentsPushLoader.m
//  iDoc
//
//  Created by rednekis on 5/9/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import "AttachmentsLoader.h"
#import "DocAttachment.h"
#import "SystemDataEntity.h"
#import "AttachmentBase64Loader.h"
#import "AttachmentServletLoader.h"
#import "UserDefaults.h"
#import "WebServiceRequests.h"


@interface AttachmentsLoader(PrivateMethods)
- (NSString *)returnPathForMockXmlByAttachmentId:(NSString *)attachmentId andDocId:(NSString *)docId;
@end


@implementation AttachmentsLoader

- (id)initWithLoaderDelegate:(id<BaseLoaderDelegate>)newDelegate andContext:(NSManagedObjectContext *)context forSyncModule:(DataSyncModule)module {
    if ((self = [super initWithLoaderDelegate:newDelegate andContext:context])) {
        self.syncModule = module;   
        docEntity = [[DocDataEntity alloc] initWithContext:context];
	}
	return self;
}

- (NSString *)returnPathForMockXmlByAttachmentId:(NSString *)attachmentId andDocId:(NSString *)docId {
    return [NSString stringWithFormat:@"%@%@_%@%@", constTestAttachmentDataFilePrefix, attachmentId, docId, constTestFileExtension];
}

- (void)startLoad {  
    NSLog(@"AttachmentsLoader startLoad started"); 
    NSArray *attachments = [docEntity selectAttachmentsToLoad];
    if ([attachments count] > 0) {
        for (DocAttachment *attachment in attachments) {
            if ([loaderDelegate isAbortSyncRequested] == YES)
                break;
            
            NSString *downloadType = [UserDefaults stringSettingByKey:constORDAttachmentDownloadType];
            downloadType = ([downloadType length] > 0) ? downloadType : constORDAttachmentDownloadBase64Type;
            
            NSString *error = nil;
            if ([downloadType isEqualToString:constORDAttachmentDownloadBase64Type] || useTestData == YES) {
                AttachmentBase64Loader *loader = [[AttachmentBase64Loader alloc] init];
                NSString *testDataXMLPath = 
                    [self returnPathForMockXmlByAttachmentId:attachment.id andDocId:attachment.doc.id];
                loader.testDataXMLPath = (prepareTestData == YES) ? testDataXMLPath : nil;
                
                if (useTestData == NO) {
                    NSDictionary *requestData = [WebServiceRequests createRequestOfAttachmentContent:attachment.id forUser:[systemEntity userInfo]];
                    error = [loader downloadAndParseXMLWithRequest:requestData andSaveWithFileName:attachment.fileName];    
                }
                else {          
                    NSLog(@"AttachmentsLoader load test xml: %@", testDataXMLPath);
                    NSMutableData *testDataXML = 
                        [NSMutableData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:testDataXMLPath ofType:nil]];            
                    error = [loader parseAndSaveXML:testDataXML withFileName:attachment.fileName];
                }
                [loader release]; 
            }
            else {
                AttachmentServletLoader *loader = [[AttachmentServletLoader alloc] init];
                NSDictionary *requestData  = [WebServiceRequests createRequestOfAttachmentFile:attachment.id forUser:[systemEntity userInfo]];
                error = [loader downloadFileWithRequest:requestData andSaveWithFileName:attachment.fileName];
                [loader release];
            }
            
            
            if (error == nil) {
                NSLog(@"AttachmentsLoader loading of attachment finished: %@ \n", attachment.fileName);
                attachment.systemLoaded = [NSNumber numberWithBool:YES];
            }
            else {
                NSLog(@"AttachmentsLoader loading of attachment %@ failed: %@ \n", attachment.fileName, error);
                [self logEventWithCode:DSEventCodeLoaderSubevent 
                                status:DSEventStatusWarning 
                               message:[NSString stringWithFormat:@"%@ - %@", attachment.fileName, error]
                           usingPrefix:NSLocalizedString(@"AttachmentsLoadFailedMessage", nil)];       
            }
        }
    }
    requestInProcess = NO;    
    NSLog(@"AttachmentsLoader startLoad fininshed"); 
}

- (void)dealloc {
    [docEntity release];
    [super dealloc];
}

@end
