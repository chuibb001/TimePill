//
//  TPTheme.m
//  TimePill

//  主题

//  Created by simon on 13-9-19.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "TPTheme.h"

static TPTheme *instance = nil;

@implementation TPTheme

+ (id)currentTheme
{
    if(instance == nil)
        instance = [[TPTheme alloc] init];
    return instance;
}

+ (void)changeTheme:(TPThemeType) type
{
    NSUserDefaults *defalut=[NSUserDefaults standardUserDefaults];
    [defalut setObject:[NSNumber numberWithInt:type] forKey:kTPThemeKey];
}

+ (UIImage *)currentHeadImage
{
    NSUserDefaults *defalut=[NSUserDefaults standardUserDefaults];
    NSNumber * themeNumber=[defalut objectForKey:kTPThemeKey];
    UIImage *headImage;
    
    if(!themeNumber)
        return [UIImage imageNamed:@"toutu.png"];
    
    switch ([themeNumber intValue]) {
        case TPThemeTypeDefault:
            headImage = [UIImage imageNamed:@"toutu.png"];
            break;
        case TPThemeTypeBlue:
            headImage = [UIImage imageNamed:@"toutu_blue.png"];
            break;
        case TPThemeTypeYellow:
            headImage = [UIImage imageNamed:@"toutu_yellow.png"];
            break;
        case TPThemeTypeGray:
            headImage = [UIImage imageNamed:@"toutu_grey.png"];
            break;
            
        default:
            break;
    }
    
    return headImage;
}

+ (UIImage *)currentBackgroundImage
{
    NSUserDefaults *defalut=[NSUserDefaults standardUserDefaults];
    NSNumber * themeNumber=[defalut objectForKey:kTPThemeKey];
    UIImage *backgroundImage;
    
    if(!themeNumber)
        return [UIImage imageNamed:@"background.png"];
    
    switch ([themeNumber intValue]) {
        case TPThemeTypeDefault:
            backgroundImage = [UIImage imageNamed:@"background.png"];
            break;
        case TPThemeTypeBlue:
            backgroundImage = [UIImage imageNamed:@"background_blue.png"];
            break;
        case TPThemeTypeYellow:
            backgroundImage = [UIImage imageNamed:@"background_yellow.png"];
            break;
        case TPThemeTypeGray:
            backgroundImage = [UIImage imageNamed:@"background_grey.png"];
            break;
        default:
            break;
    }
    
    return backgroundImage;
}

+ (UIImage *)currentBackgroundImageNoLine;
{
    NSUserDefaults *defalut=[NSUserDefaults standardUserDefaults];
    NSNumber * themeNumber=[defalut objectForKey:kTPThemeKey];
    UIImage *backgroundImage;
    
    if(!themeNumber)
        return [UIImage imageNamed:@"background_noline.png"];
    
    switch ([themeNumber intValue]) {
        case TPThemeTypeDefault:
            backgroundImage = [UIImage imageNamed:@"background_noline.png"];
            break;
        case TPThemeTypeBlue:
            backgroundImage = [UIImage imageNamed:@"background_noline.png"];
            break;
        case TPThemeTypeYellow:
            backgroundImage = [UIImage imageNamed:@"background_noline.png"];
            break;
        case TPThemeTypeGray:
            backgroundImage = [UIImage imageNamed:@"background_noline.png"];
            break;
        default:
            break;
    }
    
    return backgroundImage;
}

+ (UIImage *)currentBubbleImage
{
    NSUserDefaults *defalut=[NSUserDefaults standardUserDefaults];
    NSNumber * themeNumber=[defalut objectForKey:kTPThemeKey];
    UIImage *bubbleImage;
    
    if(!themeNumber)
        return [UIImage imageNamed:@"duihuakuang.png"];
    
    switch ([themeNumber intValue]) {
        case TPThemeTypeDefault:
            bubbleImage = [UIImage imageNamed:@"duihuakuang.png"];
            break;
        case TPThemeTypeBlue:
            bubbleImage = [UIImage imageNamed:@"friend_blue.png"];
            break;
        case TPThemeTypeYellow:
            bubbleImage = [UIImage imageNamed:@"friend_yellow.png"];
            break;
        case TPThemeTypeGray:
            bubbleImage = [UIImage imageNamed:@"friend_grey.png"];
            break;
        default:
            break;
    }
    
    return bubbleImage;
}

+ (UIImage *)currentCommentBackgroundImage
{
    NSUserDefaults *defalut=[NSUserDefaults standardUserDefaults];
    NSNumber * themeNumber=[defalut objectForKey:kTPThemeKey];
    UIImage *bubbleImage;
    
    if(!themeNumber)
        return [UIImage imageNamed:@"tucaokuang.png"];
    
    switch ([themeNumber intValue]) {
        case TPThemeTypeDefault:
            bubbleImage = [UIImage imageNamed:@"tucaokuang.png"];
            break;
        case TPThemeTypeBlue:
            bubbleImage = [UIImage imageNamed:@"tucao_blue.png"];
            break;
        case TPThemeTypeYellow:
            bubbleImage = [UIImage imageNamed:@"tucao_yellow.png"];
            break;
        case TPThemeTypeGray:
            bubbleImage = [UIImage imageNamed:@"tucao_grey.png"];
            break;
        default:
            break;
    }
    
    return bubbleImage;
}

+ (UIImage *)currentMenuBackgroundImage {
    NSUserDefaults *defalut=[NSUserDefaults standardUserDefaults];
    NSNumber * themeNumber=[defalut objectForKey:kTPThemeKey];
    UIImage *bubbleImage;
    
    if(!themeNumber)
        return [UIImage imageNamed:@"slideCellClickNomal.png"];
    
    switch ([themeNumber intValue]) {
        case TPThemeTypeDefault:
            bubbleImage = [UIImage imageNamed:@"slideCellClickNomal.png"];
            break;
        case TPThemeTypeBlue:
            bubbleImage = [UIImage imageNamed:@"slideCellClickBlue.png"];
            break;
        case TPThemeTypeYellow:
            bubbleImage = [UIImage imageNamed:@"slideCellClickYellow.png"];
            break;
        case TPThemeTypeGray:
            bubbleImage = [UIImage imageNamed:@"slideCellClickGray.png"];
            break;
        default:
            break;
    }
    
    return bubbleImage;
}
@end
