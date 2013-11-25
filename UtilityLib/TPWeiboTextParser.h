//
//  TPWeiboTextParser.h
//  TPSinaWeiboSDK
//
//  Created by yan simon on 13-9-12.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import "TQRichTextEmojiRun.h"
#import "TQRichTextURLRun.h"

#define kWeiboTextTypeKey       @"kWeiboTextTypeKey"
#define kWeiboTextStringKey     @"kWeiboTextStringKey"

#define kEmotionWidth  18
#define kEmotionHeight 18
#define kXMargine       0
#define kYMargine       0

typedef enum
{
    TPWeiboTextTypeEmotion,          // et. [哈哈]
    TPWeiboTextTypeHightLightText,   // et. @ xxx
    TPWeiboTextTypeNomalText         // et.  ..
}
TPWeiboTextType;

@interface TPWeiboTextParser : NSObject

@property(nonatomic,strong)       NSMutableArray *richTextRunsArray;

+(NSArray *)textArrayWithRawString:(NSString *)text;

+(CGSize)sizeWithTextArray:(NSArray *)textArray constrainsToSize:(CGSize)size Font:(UIFont *)font;


// v2
- (CGSize)sizeWithRawString:(NSString *)string constrainsToWidth:(CGFloat)width Font:(UIFont *)font;

@end
