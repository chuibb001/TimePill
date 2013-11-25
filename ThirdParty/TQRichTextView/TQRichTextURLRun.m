//
//  TQRichTextURLRun.m
//  TQRichTextViewDemo
//
//  Created by fuqiang on 13-9-23.
//  Copyright (c) 2013年 fuqiang. All rights reserved.
//

#import "TQRichTextURLRun.h"

@implementation TQRichTextURLRun

- (id)init
{
    self = [super init];
    if (self) {
        self.type = richTextURLRunType;
        self.isResponseTouch = YES;
    }
    return self;
}

//-- 替换基础文本
- (void)replaceTextWithAttributedString:(NSMutableAttributedString*) attributedString
{
    [attributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColor colorWithRed:87.0/255.0 green:121.0/255.0 blue:158.0/255.0 alpha:1.0].CGColor range:self.range];
    [super replaceTextWithAttributedString:attributedString];
}

//-- 绘制内容
- (BOOL)drawRunWithRect:(CGRect)rect
{
    return NO;
}

//-- 解析文本内容
+ (NSString *)analyzeText:(NSString *)string runsArray:(NSMutableArray **)runArray
{
    //((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)"
    NSError *error;
    //NSString *regulaStr = @"\\bhttps?://[a-zA-Z0-9\\-.]+(?::(\\d+))?(?:(?:/[a-zA-Z0-9\\-._?,'+\\&%$=~*!():@\\\\]*)+)?";
    NSString *regulaStr =@"((@)([A-Z0-9a-z(é|ë|ê|è|à|â|ä|á|ù|ü|û|ú|ì|ï|î|í)]|[\u4e00-\u9fa5]|(_|-))+)|(http(s)?://([A-Z0-9a-z._-]*(/)?)*)|((#)([A-Z0-9a-z(é|ë|ê|è|à|â|ä|á|ù|ü|û|ú|ì|ï|î|í)]|[\u4e00-\u9fa5]|(_|-))+(#))";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *arrayOfAllMatches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    
    for (NSTextCheckingResult *match in arrayOfAllMatches)
    {
        NSString* substringForMatch = [string substringWithRange:match.range];
        TQRichTextURLRun *urlRun = [[TQRichTextURLRun alloc] init];
        urlRun.range = match.range;
        urlRun.originalText = substringForMatch;
        
        [*runArray addObject:urlRun];
    }
    
    return [string copy];
}

@end
