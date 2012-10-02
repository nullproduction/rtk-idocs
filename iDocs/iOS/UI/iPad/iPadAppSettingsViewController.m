//
//  iPadAppSettingsViewController.m
//  iDoc
//
//  Created by Алексей Алехин on 28.09.11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import "iPadAppSettingsViewController.h"
#import "iPadThemeBuildHelper.h"
#import "iPadPanelHeaderBarBackgroundView.h"
#import "IASKSettingsReader.h"
#import "IASKSpecifier.h"
#import "IASKPSTitleValueSpecifierViewCell.h"
#import "IASKSpecifierValuesViewController.h"
#import "iPadPanelBodyBackgroundView.h"
#import "SupportFunctions.h"

@interface iPadAppSettingsViewController(PrivateMethods)
- (BOOL)isItemRequired:(NSDictionary *)item;
@end

@implementation iPadAppSettingsViewController

- (id)initAppSettingsDelegate:(id<iPadAppSettingsViewControllerDelegate>)newAppSettingsDelegate {
    if ((self = [super initWithNibName:@"IASKAppSettingsView" bundle:nil])) {
        appSettingsDelegate = newAppSettingsDelegate;
        self.delegate = self; // делегат родительского класса IASKAppSettingsViewController
        UIView *backView = [[UIView alloc] initWithFrame:self.tableView.frame];
        self.tableView.backgroundView = backView;
        [backView release];  
    }
    return self;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
	if ([viewController isKindOfClass:[IASKSpecifierValuesViewController class]]) {
        IASKSpecifierValuesViewController *controller = ((IASKSpecifierValuesViewController *)viewController);
        UIView *backView = [[UIView alloc] initWithFrame:controller.tableView.frame];
		controller.tableView.backgroundView = backView;
        [backView release];
        controller.tableView.backgroundColor = [UIColor clearColor];
        controller.view.backgroundColor = [UIColor clearColor];
        [controller viewWillAppear:NO];
	}
    else if ([viewController isKindOfClass:[IASKAppSettingsViewController class]]) {
        [super viewWillAppear:NO];
    }
    [super navigationController:navigationController willShowViewController:viewController animated:animated];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    IASKSpecifier *specifier  = [self.settingsReader specifierForIndexPath:indexPath];
    NSString *key = [specifier key];
    if ([key isEqualToString:constDictionariesLastUpdatedDate]) {
        NSDate *date = [SupportFunctions convertXMLDateTimeStringToDate:(NSString *)[self.settingsStore objectForKey:key]];
		cell.detailTextLabel.text = [SupportFunctions convertDateToString:date withFormat:constDateTimeFormat];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    IASKSpecifier *specifier = [self.settingsReader specifierForIndexPath:indexPath];
    if ([[specifier type] isEqualToString:kIASKPSMultiValueSpecifier] ||
        [[specifier type] isEqualToString:kIASKPSChildPaneSpecifier]) {
        if (appSettingsDelegate != nil && [appSettingsDelegate respondsToSelector:@selector(showBackButton)]) {
            [appSettingsDelegate showBackButton];
        }		        
    }
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
	return [super tableView:tableView willSelectRowAtIndexPath:indexPath];
}

- (void)synchronizeSettings {
    [super synchronizeSettings];
}

- (BOOL)checkIfAllRequiredFieldsAreFilled {
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    NSString *settingsPath = [bundlePath stringByAppendingPathComponent:@"InAppSettings.bundle"];
    NSString *plistFile = [settingsPath stringByAppendingPathComponent:@"Root.inApp.plist"];
    NSDictionary *settingsDictionary = [NSDictionary dictionaryWithContentsOfFile:plistFile];
    NSArray *inAppPrefsArray = [settingsDictionary objectForKey:@"PreferenceSpecifiers"];
    
    for(NSDictionary *item in inAppPrefsArray) {
        if ([self isItemRequired:item]) {
            NSString *requiredKey = [item objectForKey:@"Key"];
            id value = [self.settingsStore objectForKey:requiredKey];
            
            if ([value description].length == 0) {
                IASKSpecifier *specifier = [self.settingsReader specifierForKey:requiredKey];
                [[[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"RequiredSettingAlertHeader", nil) 
                                            message:[NSString stringWithFormat:NSLocalizedString(@"RequiredSettingAlertBodyFormat", nil), [specifier title]]
                                           delegate:nil 
                                  cancelButtonTitle:NSLocalizedString(@"OkButtonTitle", nil)  
                                  otherButtonTitles: nil] autorelease] show];
                return NO;
            }
        }
    }
    return YES;
}

- (BOOL)isItemRequired:(NSDictionary *)item {
    NSString *requiredField = [item objectForKey:@"Required"];
    if (requiredField == nil || 
        requiredField.description.length == 0 ||
        [requiredField.description isEqualToString:@"0"]) { // не обязательное поле
        return NO;
    } 
    else if ([requiredField.description isEqualToString:@"1"]) { // безусловно обязательное поле
        return YES;
    } 
    else { // значит обязательность этого поля зависит от того, заполненно ли другое поле
        NSString *dependenceKey = requiredField; // в Required хранится ключ к этому полю
        // считаем, что это текстовое поле
        NSString *value = [self.settingsStore objectForKey:dependenceKey];     
        if (value == nil || 
            value.description.length == 0 || 
            [value.description isEqualToString:@"0"]) {
            return NO;
        } 
        else { 
            return YES;
        }
    } 
}

#pragma mark IASKAppSettingsViewControllerDelegate protocol
- (void)settingsViewControllerDidEnd:(IASKAppSettingsViewController*)sender {
    NSLog(@"IASKAppSettingsViewControllerDelegate settingsViewControllerDidEnd");
    [self dismissModalViewControllerAnimated:YES];
}

- (void)settingsViewController:(IASKAppSettingsViewController*)sender buttonTappedForKey:(NSString*)key {
    NSLog(@"IASKAppSettingsViewControllerDelegate settingsViewController: buttonTappedForKey: %@", key); 
}

- (void)dealloc {
    [super dealloc];
}
@end
