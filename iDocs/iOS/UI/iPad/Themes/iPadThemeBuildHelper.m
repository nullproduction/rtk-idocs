//
//  iPadThemeBuildHelper.m
//  iDoc
//
//  Created by rednekis on 11-04-27.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import "iPadThemeBuildHelper.h"
#import "UserDefaults.h"


@implementation iPadThemeBuildHelper

+ (NSString *)currentTheme {
    return [UserDefaults stringSettingByKey:constCurrentTheme];
}

#pragma mark images
+ (NSString *)nameForImage:(NSString *)imageName {
    NSString *currentTheme = [iPadThemeBuildHelper currentTheme];
    NSString *themeImageName = constEmptyStringValue;
    if (imageName != nil)
        themeImageName = [NSString stringWithFormat:@"%@_%@", currentTheme, imageName];
    return themeImageName;
}


#pragma mark fonts
+ (UIColor *)infoTextFontColor1 {
    NSString *currentTheme = [iPadThemeBuildHelper currentTheme];
    UIColor *color = nil;
    if ([currentTheme isEqualToString:constThemeBlue])
        color = [UIColor colorWithRed:0.31f green:0.33f blue:0.35f alpha:1.0f]; // #4f5459
    else if ([currentTheme isEqualToString:constThemeDefault])
        color = [UIColor colorWithWhite:10.0f alpha:0.7f];
    
    return color;
}

+ (UIColor *)infoTextFontColor2 {
    NSString *currentTheme = [iPadThemeBuildHelper currentTheme];
    UIColor *color = nil;
    if ([currentTheme isEqualToString:constThemeBlue])
        color = [UIColor colorWithRed:0.31f green:0.33f blue:0.35f alpha:1.0f]; // #4f5459
    else if ([currentTheme isEqualToString:constThemeDefault])
        color = [UIColor colorWithRed:0.988f green:0.961f blue:0.847f alpha:0.9f];
    
    return color;
}


#pragma mark titles
+ (UIColor *)syncHeaderFontColor {
    NSString *currentTheme = [iPadThemeBuildHelper currentTheme];
    UIColor *color = nil;
    if ([currentTheme isEqualToString:constThemeBlue])
        color = [UIColor colorWithRed:0.07f green:0.46f blue:0.66f alpha:1.0f]; //blue #1175a9
    else if ([currentTheme isEqualToString:constThemeDefault])
        color = [UIColor brownColor];
    
    return color;
}

+ (UIColor *)dashboardHeaderFontColor {
    NSString *currentTheme = [iPadThemeBuildHelper currentTheme];
    UIColor *color = nil;
    if ([currentTheme isEqualToString:constThemeBlue])
        color = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f]; //black #000000
    else if ([currentTheme isEqualToString:constThemeDefault])
        color = [UIColor brownColor];
    
    return color;
}


+ (UIColor *)dashboardWidgetTitleFontColor {
    NSString *currentTheme = [iPadThemeBuildHelper currentTheme];
    UIColor *color = nil;
    if ([currentTheme isEqualToString:constThemeBlue])
        color = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f]; //black #000000
    else if ([currentTheme isEqualToString:constThemeDefault])
        color = [UIColor colorWithRed:0.29f green:0.596f blue:0.094f alpha:1.0f]; //green
    
    return color;
}


+ (UIColor *)commonHeaderFontColor1  {
    NSString *currentTheme = [iPadThemeBuildHelper currentTheme];
    UIColor *color = nil;
    if ([currentTheme isEqualToString:constThemeBlue])
        color = [UIColor blackColor]; //black
    else if ([currentTheme isEqualToString:constThemeDefault])
        color = [UIColor colorWithRed:0.988f green:0.961f blue:0.847f alpha:0.9f];
    
    return color;    
}

+ (UIColor *)commonHeaderFontColor2  {
    NSString *currentTheme = [iPadThemeBuildHelper currentTheme];
    UIColor *color = nil;
    if ([currentTheme isEqualToString:constThemeBlue])
        color = [UIColor whiteColor]; //white #ffffff
    else if ([currentTheme isEqualToString:constThemeDefault])
        color = [UIColor colorWithRed:0.988f green:0.961f blue:0.847f alpha:0.9f];
    
    return color;    
}

+ (UIColor *)itemInListHeaderFontColor {
    NSString *currentTheme = [iPadThemeBuildHelper currentTheme];
    UIColor *color = nil;
    if ([currentTheme isEqualToString:constThemeBlue])
        color = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f]; //black #000000
    else if ([currentTheme isEqualToString:constThemeDefault])
        color = [UIColor brownColor];
    
    return color;
}

+ (UIColor *)commonTableHeaderFontColor {
    NSString *currentTheme = [iPadThemeBuildHelper currentTheme];
    UIColor *color = nil;
    if ([currentTheme isEqualToString:constThemeBlue])
        color = [UIColor colorWithRed:0.31f green:0.33f blue:0.35f alpha:1.0f]; //#4f5459
    else if ([currentTheme isEqualToString:constThemeDefault])
        color = [UIColor colorWithRed:0.345f green:0.349f blue:0.357f alpha:1.0f]; //dark gray
    
    return color;    
}

+ (UIColor *)commonTableSectionHeaderFontColor {
    NSString *currentTheme = [iPadThemeBuildHelper currentTheme];
    UIColor *color = nil;
    if ([currentTheme isEqualToString:constThemeBlue])
        color = [UIColor colorWithRed:0.31f green:0.33f blue:0.35f alpha:1.0f]; //#4f5459
    else if ([currentTheme isEqualToString:constThemeDefault])
        color = [UIColor brownColor]; 
    
    return color;    
}

+ (UIColor *)titleForValueFontColor {
    NSString *currentTheme = [iPadThemeBuildHelper currentTheme];
    UIColor *color = nil;
    if ([currentTheme isEqualToString:constThemeBlue])
        color = [UIColor colorWithRed:0.345f green:0.349f blue:0.357f alpha:1.0f]; //dark gray
    else if ([currentTheme isEqualToString:constThemeDefault])
        color = [UIColor colorWithRed:0.78f green:0.0f blue:0.137f alpha:1.0]; //red
    
    return color;    
}


#pragma mark buttons
+ (UIColor *)commonButtonFontColor1 {
    NSString *currentTheme = [iPadThemeBuildHelper currentTheme];
    UIColor *color = nil;
    if ([currentTheme isEqualToString:constThemeBlue])
        color = [UIColor colorWithRed:0.31f green:0.33f blue:0.35f alpha:1.0f]; // #4f5459
    else if ([currentTheme isEqualToString:constThemeDefault])
        color = [UIColor colorWithRed:0.988f green:0.961f blue:0.847f alpha:0.9f];
    return color;    
} 

+ (UIColor *)commonButtonFontColor2 {
    NSString *currentTheme = [iPadThemeBuildHelper currentTheme];
    UIColor *color = nil;
    if ([currentTheme isEqualToString:constThemeBlue])
        color = [UIColor whiteColor]; //white #ffffff
    else if ([currentTheme isEqualToString:constThemeDefault])
        color = [UIColor whiteColor]; //[UIColor colorWithRed:0.988f green:0.961f blue:0.847f alpha:0.9f];
    return color;    
}


#pragma mark text
+ (UIColor *)dashboardWidgetTextFontNormalColor {
    NSString *currentTheme = [iPadThemeBuildHelper currentTheme];
    UIColor *color = nil;
    if ([currentTheme isEqualToString:constThemeBlue])
        color = [UIColor colorWithRed:0.54f green:0.54f blue:0.50f alpha:1.0f]; //#898989З
    else if ([currentTheme isEqualToString:constThemeDefault])
        color = [UIColor grayColor];
    
    return color;
}

+ (UIColor *)dashboardWidgetTextFontNewColor {
    NSString *currentTheme = [iPadThemeBuildHelper currentTheme];
    UIColor *color = nil;
    if ([currentTheme isEqualToString:constThemeBlue])
        color = [UIColor colorWithRed:0.07f green:0.46f blue:0.66f alpha:1.0f]; //blue #1175a9
    else if ([currentTheme isEqualToString:constThemeDefault])
        color = [UIColor grayColor];
    
    return color;
}

+ (UIColor *)dashboardWidgetTextFontOverdueColor {
    NSString *currentTheme = [iPadThemeBuildHelper currentTheme];
    UIColor *color = nil;
    if ([currentTheme isEqualToString:constThemeBlue])
        color = [UIColor colorWithRed:0.67f green:0.15f blue:0.06f alpha:1.0f]; //red #ac260f
    else if ([currentTheme isEqualToString:constThemeDefault])
        color = [UIColor colorWithRed:0.78f green:0.0f blue:0.137f alpha:1.0f]; //red
    
    return color;
}

+ (UIColor *)commonTextFontColor1 {
    NSString *currentTheme = [iPadThemeBuildHelper currentTheme];
    UIColor *color = nil;
    if ([currentTheme isEqualToString:constThemeBlue])
        color = [UIColor blackColor]; //black #000000
    else if ([currentTheme isEqualToString:constThemeDefault])
        color = [UIColor blackColor];
    
    return color;    
}

+ (UIColor *)commonTextFontColor2 {
    NSString *currentTheme = [iPadThemeBuildHelper currentTheme];
    UIColor *color = nil;
    if ([currentTheme isEqualToString:constThemeBlue])
        color = [UIColor colorWithRed:0.345f green:0.349f blue:0.357f alpha:1.0f]; //dark gray
    else if ([currentTheme isEqualToString:constThemeDefault])
        color = [UIColor colorWithRed:0.345f green:0.349f blue:0.357f alpha:1.0f]; //dark gray
    
    return color;    
}

+ (UIColor *)commonTextFontColor3 {
    NSString *currentTheme = [iPadThemeBuildHelper currentTheme];
    UIColor *color = nil;
    if ([currentTheme isEqualToString:constThemeBlue])
        color = [UIColor colorWithRed:0.67f green:0.15f blue:0.06f alpha:1.0f]; //red #ac260f
    else if ([currentTheme isEqualToString:constThemeDefault])
        color = [UIColor colorWithRed:0.78f green:0.0f blue:0.137f alpha:1.0f]; //red
    
    return color;    
}

+ (UIColor *)commonTextFontColor4 {
    NSString *currentTheme = [iPadThemeBuildHelper currentTheme];
    UIColor *color = nil;
    if ([currentTheme isEqualToString:constThemeBlue])
        color = [UIColor whiteColor]; // #4f5459
    else if ([currentTheme isEqualToString:constThemeDefault])
        color = [UIColor colorWithRed:0.988f green:0.961f blue:0.847f alpha:0.9f];
    return color;    
}

+ (UIColor *)commonTextFontColor5 {
    NSString *currentTheme = [iPadThemeBuildHelper currentTheme];
    UIColor *color = nil;
    if ([currentTheme isEqualToString:constThemeBlue])
        color =[UIColor colorWithRed:0.31f green:0.33f blue:0.35f alpha:1.0f]; // #4f5459
    else if ([currentTheme isEqualToString:constThemeDefault])
        color = [UIColor colorWithRed:0.988f green:0.961f blue:0.847f alpha:0.9f];
    return color;    
}


#pragma mark backgrounds
+ (UIColor *)commonSeparatorColor {
    NSString *currentTheme = [iPadThemeBuildHelper currentTheme];
    UIColor *color = nil;
    if ([currentTheme isEqualToString:constThemeBlue])
        color = [UIColor lightGrayColor]; //light gray
    else if ([currentTheme isEqualToString:constThemeDefault])
        color = [UIColor lightGrayColor];
    
    return color;
}

+ (UIColor *)commonSeparatorColorSemitransparent {
    UIColor *color = [[self commonSeparatorColor] colorWithAlphaComponent:0.4f];
    return color;
}

+ (UIColor *)syncHeaderBackColor {
    NSString *currentTheme = [iPadThemeBuildHelper currentTheme];
    UIColor *color = nil;
    if ([currentTheme isEqualToString:constThemeBlue])
        color = [UIColor whiteColor]; //white #ffffff
    else if ([currentTheme isEqualToString:constThemeDefault])
        color = [UIColor whiteColor]; //white #ffffff
    return color; 
}

+ (UIColor *)dashboardHeaderBackColor {
    NSString *currentTheme = [iPadThemeBuildHelper currentTheme];
    UIColor *color = nil;
    if ([currentTheme isEqualToString:constThemeBlue])
        color = [UIColor clearColor]; //no back
    else if ([currentTheme isEqualToString:constThemeDefault])
        color = [UIColor colorWithRed:0.839f green:0.78f blue:0.678f alpha:0.4f];
    
    return color;
}

+ (UIColor *)tabBarBackColor {
    NSString *currentTheme = [iPadThemeBuildHelper currentTheme];
    UIColor *color = nil;
    if ([currentTheme isEqualToString:constThemeBlue])
        color = [UIColor colorWithRed:0.07f green:0.46f blue:0.66f alpha:1.0f]; //blue
    else if ([currentTheme isEqualToString:constThemeDefault])
        color = [UIColor brownColor];
    
    return color;
}

+ (UIColor *)commonPlaceholderBackColor {
    NSString *currentTheme = [iPadThemeBuildHelper currentTheme];
    UIColor *color = nil;
    if ([currentTheme isEqualToString:constThemeBlue])
        color = [UIColor colorWithRed:0.863f green:0.863f blue:0.863f alpha:0.8f]; //gray
    else if ([currentTheme isEqualToString:constThemeDefault])
        color = [UIColor colorWithRed:0.839f green:0.78f blue:0.678f alpha:0.6f]; //brown
    return color;    
}

+ (UIColor *)commonHeaderBackColor {
    NSString *currentTheme = [iPadThemeBuildHelper currentTheme];
    UIColor *color = nil;
    if ([currentTheme isEqualToString:constThemeBlue])
        color = [UIColor colorWithRed:0.741f green:0.808f blue:0.878f alpha:1.0f]; //blue
    else if ([currentTheme isEqualToString:constThemeDefault])
        color = [UIColor colorWithRed:0.839f green:0.78f blue:0.678f alpha:0.6f]; //brown
    return color;    
}

+ (UIColor *)commonPopupVeilColor {
    NSString *currentTheme = [iPadThemeBuildHelper currentTheme];
    UIColor *color = nil;
    if ([currentTheme isEqualToString:constThemeBlue])
        color = [UIColor colorWithRed:0.863f green:0.863f blue:0.863f alpha:0.4f]; //gray
    else if ([currentTheme isEqualToString:constThemeDefault])
        color = [UIColor colorWithRed:0.329f green:0.157f blue:0.02f alpha:0.4f]; //brown
    
    return color;    
}

+ (UIColor *)progressBarBackColor {
    NSString *currentTheme = [iPadThemeBuildHelper currentTheme];
    UIColor *color = nil;
    if ([currentTheme isEqualToString:constThemeBlue])
        color = [UIColor colorWithWhite:10.0f alpha:0.7f];
    else if ([currentTheme isEqualToString:constThemeDefault])
        color = [UIColor colorWithWhite:10.0f alpha:0.7f];
    
    return color;    
}

+ (UIColor *)activityIndicatorBackColor {
    NSString *currentTheme = [iPadThemeBuildHelper currentTheme];
    UIColor *color = nil;
    if ([currentTheme isEqualToString:constThemeBlue])
        color = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.5f];
    else if ([currentTheme isEqualToString:constThemeDefault])
        color = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.5f];
    
    return color;    
}

+ (UIColor *)activityIndicatorColor {
    NSString *currentTheme = [iPadThemeBuildHelper currentTheme];
    UIColor *color = nil;
    if ([currentTheme isEqualToString:constThemeBlue])
        color = [UIColor grayColor];
    else if ([currentTheme isEqualToString:constThemeDefault])
        color = [UIColor grayColor];
    
    return color;    
}

+ (UIColor *)itemListBackgroundOverlayColor {
    NSString *currentTheme = [iPadThemeBuildHelper currentTheme];
    UIColor *color = nil;
    if ([currentTheme isEqualToString:constThemeBlue])
        color = [UIColor colorWithRed:0.863f green:0.863f blue:0.863f alpha:0.9f]; //gray
    else if ([currentTheme isEqualToString:constThemeDefault])
        color = [[UIColor yellowColor] colorWithAlphaComponent:0.1];
    
    return color;    
}


#pragma mark shadows
+ (UIColor *)commonShadowColor1 {
    NSString *currentTheme = [iPadThemeBuildHelper currentTheme];
    UIColor *color = nil;
    if ([currentTheme isEqualToString:constThemeBlue])
        color = [UIColor whiteColor];
    else if ([currentTheme isEqualToString:constThemeDefault])
        color = [UIColor colorWithRed:0.306f green:0.224f blue:0.157f alpha:1.0f];
    return color;    
}

+ (UIColor *)commonShadowColor2 {
    NSString *currentTheme = [iPadThemeBuildHelper currentTheme];
    UIColor *color = nil;
    if ([currentTheme isEqualToString:constThemeBlue])
        color = [UIColor colorWithRed:0.537f green:0.553f blue:0.533f alpha:1.0f];
    else if ([currentTheme isEqualToString:constThemeDefault])
        color = [UIColor colorWithRed:0.306f green:0.224f blue:0.157f alpha:1.0f];
    
    return color;     
}
@end

