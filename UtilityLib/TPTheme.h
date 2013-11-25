//
//  TPTheme.h
//  TimePill
//
//  Created by simon on 13-9-19.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TPConst.h"

typedef enum
{
    TPThemeTypeDefault,
    TPThemeTypeBlue,
    TPThemeTypeYellow,
    TPThemeTypeGray,
}
TPThemeType;

@interface TPTheme : NSObject

+ (id)currentTheme;

+ (void)changeTheme:(TPThemeType) type;

+ (UIImage *)currentHeadImage;

+ (UIImage *)currentBackgroundImage;

+ (UIImage *)currentBackgroundImageNoLine;

+ (UIImage *)currentBubbleImage;

+ (UIImage *)currentCommentBackgroundImage;

+ (UIImage *)currentMenuBackgroundImage;

@end
