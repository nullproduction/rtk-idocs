//
//  iPadDocCalendarEntryCustomizer.h
//  iDoc
//
//  Created by Michael Syasko on 7/3/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface iPadDocCalendarEntryCustomizer : UIViewController <UITextFieldDelegate> {

    UINavigationItem *navigationItem;
    UITextField *textField;
    
}

-(IBAction)scrollDate;
-(IBAction)buttonPressed;

@end
