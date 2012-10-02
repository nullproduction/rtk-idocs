//
//  ClientSettingsEntity.m
//  iDoc
//
//  Created by katrin on 14.04.11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import "ClientSettingsXmlParser.h"
#import "TaskActionTemplate.h"
#import "SMXMLDocument+RPC.h"
#import "NSData+Additions.h"
#import "Constants.h"

@implementation ClientSettingsXmlParser

- (id)initWithContext:(NSManagedObjectContext *)context {   
    if ((self = [super initWithContext:context])) {    
        clientEntity = [[ClientSettingsDataEntity alloc] initWithContext:context];
        taskEntity = [[TaskDataEntity alloc] initWithContext:context];
        taskActionTempalteEntity = [[TaskActionTemplateDataEntity alloc] initWithContext:context];
    }
	return self;
}

- (NSString *)getClientSettingsCheckSumFromData:(NSData *)data error:(NSError **)parseError {
    NSLog(@"ClientSettingsXmlParser getClientSettingsDataFromData started");  
     
    NSError *error = nil;
    SMXMLDocument *document = [SMXMLDocument documentWithData:data RPCError:&error];
    if (error) {
        NSLog(@"ClientSettingsXmlParser parseContent error: %@", [error localizedDescription]);
        if (parseError)
            *parseError = error;
        return nil;
    }
    
    SMXMLElement *checksumPacket = [document.root descendantWithPath:@"Body.getClientSettingsCheckSumResponse.return"];
    NSString *checksum = [checksumPacket value];
    return checksum;
}

- (NSData *)getClientSettingsDataFromData:(NSData *)data error:(NSError **)parseError {
    NSLog(@"ClientSettingsXmlParser getClientSettingsDataFromData started");  
    
    NSError *error = nil;
    SMXMLDocument *document = [SMXMLDocument documentWithData:data RPCError:&error];
    if (error) {
        NSLog(@"ClientSettingsXmlParser parseContent error: %@", [error localizedDescription]);
        if (parseError)
            *parseError = error;
        return nil;
    }
    
    SMXMLElement *contentsPacket = [document.root descendantWithPath:@"Body.getClientSettingsResponse.return.Contents.Value"];
    NSString *contentBase64String = [contentsPacket value];
    NSData *contentData = [NSData dataWithBase64EncodedString:contentBase64String];
    return contentData;
}

- (NSString *)parseAndInsertClientSettingsData:(NSData *)data { 
    NSLog(@"ClientSettingsXmlParser parseAndInsertClientSettingsData started");    
    self.parserPool = [[NSAutoreleasePool alloc] init];
    
    NSError *error = nil;
    SMXMLDocument *document = [SMXMLDocument documentWithData:data RPCError:&error];
    if (error) {
        NSLog(@"ClientSettingsXmlParser parseTaskGroupData error: %@", [error localizedDescription]);
        return [error localizedDescription];
    }

    NSArray *settingsList = [[document.root childNamed:@"general_settings"] childrenNamed:@"setting"];
    [clientEntity deleteAllGeneralSettings];
    for (SMXMLElement *item in settingsList) {
        GeneralSetting *setting = [clientEntity createGeneralSetting];
        setting.name = [item attributeNamed:@"name"];
        setting.value = [item value];
    }

    NSArray *dashboardList = [[document.root childNamed:@"dashboards"] childrenNamed:@"dashboard"];
    int  sortIndex;
    
    for (SMXMLElement *item in dashboardList) {
        sortIndex = 1;
        
        Dashboard *dashboard = [clientEntity createDashboard];
        int dashboardId = [[item attributeNamed:@"id"] intValue];
        dashboard.id = [NSNumber numberWithInt:dashboardId];
        dashboard.name = [item attributeNamed:@"name"];
        NSLog(@"ClientSettingsDataEntity added dashboard with id:%i", dashboardId); 
        
        for (SMXMLElement * itemData in [item childrenNamed:@"item"]) {
            DashboardItem *dashboardItem = [clientEntity createDashboardItem];
            NSString *dashboardItemType = [[itemData childWithAttribute:@"name" value:@"type"] value];
            dashboardItem.type = ([dashboardItemType length] > 0) ? dashboardItemType : constEmptyStringValue; 
            NSString *dashboardItemId = [[itemData childWithAttribute:@"name" value:@"id"] value];
            dashboardItem.id = ([dashboardItemId length] > 0) ? dashboardItemId : constEmptyStringValue;
           
            dashboardItem.parentId = [[itemData childWithAttribute:@"name" value:@"parent_id"] value];
            dashboardItem.name = [[itemData childWithAttribute:@"name" value:@"name"]value];
            dashboardItem.dashboardIcon  = [[itemData childWithAttribute:@"name" value:@"dashboard_icon"] value];
            dashboardItem.block = [[itemData childWithAttribute:@"name" value:@"block"] value];
            if ([dashboardItem.type isEqualToString:constWidgetTypeORDGroup] ||
                [dashboardItem.type isEqualToString:constWidgetTypeWebDavFolder]) 
            {
                dashboardItem.countTotal = [NSNumber numberWithInt:0];
                dashboardItem.countNew = [NSNumber numberWithInt:0];
                dashboardItem.countOverdue = [NSNumber numberWithInt:0];
            }
            
            SMXMLElement *actionTemplatesNode = [itemData childWithAttribute:@"name" value:@"action_templates"];
            if (actionTemplatesNode) {
                int i = 0;
                for (SMXMLElement * actionTemplateNode in [actionTemplatesNode childrenNamed:@"action"]) {
                    TaskActionTemplate *newTemplate = [taskActionTempalteEntity createTaskActionTemplate];
                    newTemplate.systemSortIndex = [NSNumber numberWithInt:i];
                    newTemplate.name = [[actionTemplateNode childWithAttribute:@"name" value:@"action_name"] value];
                    newTemplate.buttonColor = [[actionTemplateNode childWithAttribute:@"name" value:@"color"] value];
                    newTemplate.resultText = [[actionTemplateNode childWithAttribute:@"name" value:@"resultText"] value];
                    newTemplate.type = [[actionTemplateNode childWithAttribute:@"name" value:@"action_type"] value];
                    newTemplate.id = [[actionTemplateNode childWithAttribute:@"name" value:@"action_id"] value];
                    NSString *actionIsFinal = [[actionTemplateNode childWithAttribute:@"name" value:@"isFinal"] value];
                    bool isFinal = [actionIsFinal boolValue];
                    newTemplate.isFinal = [NSNumber numberWithBool:isFinal];
                    newTemplate.dashboardItem = dashboardItem;
                    i++;
                }
            }
            dashboardItem.dashboard = dashboard;
            dashboardItem.systemSortIndex = [NSNumber numberWithInt:sortIndex];
            sortIndex ++;
            
            NSLog(@"ClientSettingsDataEntity added dashboard item with id:%@ and type:%@", dashboardItemId, dashboardItemType);
        }        
    }
    
    [self saveParsedData];
    [parserPool release];
    self.parserPool = nil;
    
    NSLog(@"ClientSettingsXmlParser parseAndInsertClientSettingsData finished");
    return nil;
}

- (void)dealloc {
    [clientEntity release];
    [taskEntity release];
    [taskActionTempalteEntity release];
    [super dealloc];
}

@end
