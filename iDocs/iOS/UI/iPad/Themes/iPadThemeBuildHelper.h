//
//  iPadThemeBuildHelper.h
//  iDoc
//
//  Created by rednekis on 11-04-27.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

#define constCurrentTheme @"CurrentTheme"
#define constThemeDefault @"default"
#define constThemeBlue @"blue"

@interface iPadThemeBuildHelper : NSObject {
}


+ (NSString *)currentTheme;

//images
+ (NSString *)nameForImage:(NSString *)imageName;

//information titles
+ (UIColor *)infoTextFontColor1; //app name
+ (UIColor *)infoTextFontColor2; //user name

//titles
+ (UIColor *)syncHeaderFontColor;
+ (UIColor *)dashboardHeaderFontColor;
+ (UIColor *)dashboardWidgetTitleFontColor;
+ (UIColor *)commonHeaderFontColor1; //items list header
+ (UIColor *)commonHeaderFontColor2; //popups titles
+ (UIColor *)itemInListHeaderFontColor; //item header in list
+ (UIColor *)commonTableHeaderFontColor; //table headers
+ (UIColor *)commonTableSectionHeaderFontColor; //table sections
+ (UIColor *)titleForValueFontColor; //table cell titles

//general buttons 
+ (UIColor *)commonButtonFontColor1; //dashboard buttons, inbox item tabs
+ (UIColor *)commonButtonFontColor2; //other buttons 

//text
+ (UIColor *)dashboardWidgetTextFontNormalColor;
+ (UIColor *)dashboardWidgetTextFontNewColor;
+ (UIColor *)dashboardWidgetTextFontOverdueColor;
+ (UIColor *)commonTextFontColor1; //common text
+ (UIColor *)commonTextFontColor2; //common text
+ (UIColor *)commonTextFontColor3; //overdue items, titles for values
+ (UIColor *)commonTextFontColor4; //signs near buttons in modules
+ (UIColor *)commonTextFontColor5; //signs near buttons in dashboard

//backgrounds
+ (UIColor *)commonSeparatorColor;
+ (UIColor *)commonSeparatorColorSemitransparent;
+ (UIColor *)syncHeaderBackColor;
+ (UIColor *)dashboardHeaderBackColor;
+ (UIColor *)tabBarBackColor;
+ (UIColor *)commonPlaceholderBackColor; //background for placeholders
+ (UIColor *)commonHeaderBackColor; //back for titles in section
+ (UIColor *)commonPopupVeilColor;
+ (UIColor *)progressBarBackColor; //back color for progress bar
+ (UIColor *)activityIndicatorBackColor; //back color for activity indicator
+ (UIColor *)activityIndicatorColor; //color for activity indicator
+ (UIColor *)itemListBackgroundOverlayColor;//item list background overlay color

//shadows
+ (UIColor *)commonShadowColor1;
+ (UIColor *)commonShadowColor2;
@end
