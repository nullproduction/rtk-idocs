//
//  DocErrandExecutorMigrationPolicy.m
//  iDoc
//
//  Created by Andrey Demyanets on 2/1/12.
//  Copyright (c) 2012 KORUS Consulting. All rights reserved.
//

#import "DocErrandExecutorMigrationPolicy_1_1_15.h"

@implementation DocErrandExecutorMigrationPolicy_1_1_15

- (BOOL)createDestinationInstancesForSourceInstance:(NSManagedObject *)instance
                                      entityMapping:(NSEntityMapping *)mapping
                                            manager:(NSMigrationManager *)manager
                                              error:(NSError **)error {
    NSString *executorInfo = [instance valueForKey:@"executorId"];
    NSString *executorNames = [instance valueForKey:@"executorName"];
    NSArray *executorInfoList = [executorInfo componentsSeparatedByString:@";"];
    NSArray *executorNamesList = [executorNames componentsSeparatedByString:@";"];     
    
    NSLog(@"DocErrandExecutor migration %@ - %@", executorInfo, executorNames);

    if ([executorInfoList count] == [executorNamesList count]) {
        for (int i = 0; [executorInfoList count] > i; i++) {
            NSManagedObject *executor = [NSEntityDescription insertNewObjectForEntityForName:[mapping destinationEntityName] 
                                                                                           inManagedObjectContext:[manager destinationContext]];
            
            NSArray *executorInfo = [[executorInfoList objectAtIndex:i] componentsSeparatedByString:@"="];
            [executor setValue:[executorInfo objectAtIndex:0] forKey:@"executorId"];
            if ([executorInfo count] == 2) {
                BOOL isMajorExecutor = [[executorInfo objectAtIndex:1] boolValue];
                [executor setValue:[NSNumber numberWithBool:isMajorExecutor] forKey:@"isMajorExecutor"];
            }
            
            [executor setValue:[executorNamesList objectAtIndex:i] forKey:@"executorName"];
            [executor setValue:[NSNumber numberWithInt:(i+1)] forKey: @"systemSortIndex"];
            
            [manager associateSourceInstance:instance withDestinationInstance:executor forEntityMapping:mapping];
        }
    }
    return YES;
}

@end
