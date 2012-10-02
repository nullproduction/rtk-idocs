//
//  iPadDocCalendarEntryCustomizer.m
//  iDoc
//
//  Created by Michael Syasko on 7/3/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import "iPadDocCalendarEntryCustomizer.h"

@implementation iPadDocCalendarEntryCustomizer

- (id)init
{
    if ((self = [super init])) {
        
        
        textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 230, 50)];
        textField.delegate = self;
        textField.placeholder = @"<Entry Name>";
        textField.textAlignment = UITextAlignmentLeft;
        [self.view addSubview: textField];
    
        UIDatePicker *theDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, 224.0, 250.0, 216.0)];
        theDatePicker.datePickerMode = UIDatePickerModeDate;
        self.datePicker = theDatePicker;
        [theDatePicker release];
        [datePicker addTarget:self action:@selector(dateChanged) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:datePicker];
        
    }
    return self;

}

-(IBAction)scrollDate { 
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEE, MMM dd, yyyy"];
    
    NSDate *tmpDate = [[datePicker date] copy];
    
    if (startDate == nil) {
        
        startDateLabel.text = [formatter stringFromDate:tmpDate];       
    } else {
        
        endDateLabel.text = [formatter stringFromDate:tmpDate];
    } 
    
    [formatter release];
    [tmpDate release];
    
}

-(IBAction)buttonPressed { 
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEE, MMM dd, yyyy"];
    
    if (startDate == nil) {
        // Choose start Date
        startDate = [[datePicker date] copy];
        startDateLabel.text = [formatter stringFromDate:startDate];
        
        // Set up for End Date Selection
        endDateLabel.text = [formatter stringFromDate:startDate];
        [chooseDateButton setTitle:@"Choose This End Date" forState:UIControlStateNormal];
        [chooseDateButton setTitle:@"Choose This End Date" forState:UIControlStateHighlighted];
        
        
        
        
    } else {
        // Choose end Date
        endDate = [[datePicker date] copy];
        endDateLabel.text = [formatter stringFromDate:endDate];
        
        NSTimeInterval dateDiff = [endDate timeIntervalSinceDate:startDate];
        
        NSInteger dayDiff = ((dateDiff / 60) / 60) / 24;
        
        NSLog(@"Number of days is %i", dayDiff);
        
        if ([endDate compare:startDate] == NSOrderedAscending)
        {
            NSString *message = [[NSString alloc] initWithFormat:
                                 @"Your end trip date of %@ is before your start trip date %@.", 
                                 endDateLabel.text,
                                 startDateLabel.text];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Choose a Different End Date"
                                                            message:message delegate:nil
                                                  cancelButtonTitle:@"I Understand."
                                                  otherButtonTitles:nil]; 
            [alert show];
            [alert release]; 
            [message release];
            endDateLabel.text = @"TBD";
            [endDate release];
            endDate = nil;
        } 
    } 
    
    [formatter release];
}


- (void)layoutSubviews{
    
	[super layoutSubviews];
    
	[self addSubview: navigationItem];
}

@end
