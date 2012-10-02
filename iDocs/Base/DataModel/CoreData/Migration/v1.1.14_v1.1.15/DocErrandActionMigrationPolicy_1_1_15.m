//
//  DocErrandActionsMigrationPolicy.m
//  iDoc
//
//  Created by Andrey Demyanets on 2/1/12.
//  Copyright (c) 2012 KORUS Consulting. All rights reserved.
//

#import "DocErrandActionMigrationPolicy_1_1_15.h"

@implementation DocErrandActionMigrationPolicy_1_1_15

- (BOOL)createDestinationInstancesForSourceInstance:(NSManagedObject *)instance
                                      entityMapping:(NSEntityMapping *)mapping
                                            manager:(NSMigrationManager *)manager
                                              error:(NSError **)error {
    NSString *source = [instance valueForKey:@"actions"];
    NSArray *items = [source componentsSeparatedByString:@";"];
    
    NSLog(@"DocErrandActions migration %@", source);
        
    int sortIndex = 1;
    for (NSString *item in items) {
        NSArray *itemData = [item componentsSeparatedByString:@","];
        if ([itemData count] == 2) {
            NSManagedObject *action = [NSEntityDescription insertNewObjectForEntityForName:[mapping destinationEntityName] 
                                                                                       inManagedObjectContext:[manager destinationContext]];
            
            [action setValue:[itemData objectAtIndex:0] forKey:@"id"];
            [action setValue:[itemData objectAtIndex:0] forKey:@"type"];
            [action setValue:[itemData objectAtIndex:1] forKey:@"name"];
            [action setValue:[NSNumber numberWithInt:sortIndex] forKey:@"systemSortIndex"];
            sortIndex++;
            
            [manager associateSourceInstance:instance withDestinationInstance:action forEntityMapping:mapping];
        }
    }
    return YES;   
}
@end
