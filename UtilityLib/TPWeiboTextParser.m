//
//  TPWeiboTextParser.m
//  TPSinaWeiboSDK
//
//  Created by yan simon on 13-9-12.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "TPWeiboTextParser.h"

@implementation TPWeiboTextParser

+(NSArray *)textArrayWithRawString:(NSString *)text;
{
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    
    NSMutableArray *tempArray1 = [[NSMutableArray alloc] init];
    [self parseText1:text withArray:tempArray1];  // 先解析表情和文字
    
    if (tempArray1)
    {
        for (int i = 0; i < [tempArray1 count]; i++)
        {
            NSString *content = [tempArray1 objectAtIndex:i];
            
            if ([content hasPrefix:@"["] && [content hasSuffix:@"]"])  // 0
            {
                NSDictionary *contentDic = @{kWeiboTextTypeKey:@(TPWeiboTextTypeEmotion),kWeiboTextStringKey:content};
                [returnArray addObject:contentDic];  // 添加该子串

            }
            else //要显示的文本段
            {
                [self parseText2:content withArray:returnArray];  // 再解析文字中的@和#
            }
        }
    }
    
    return returnArray;
}


+(void)parseText1:(NSString *)text withArray:(NSMutableArray *)mary
{
    NSRange rangeLeft = [text rangeOfString:@"["];
    NSRange rangeRight = [text rangeOfString:@"]"];
    
    if(rangeLeft.length && rangeRight.length) //判断是否为一个完整的表情
    {
        if (rangeLeft.location > 0) // 说明文字在先
        {
            NSString *temStr = [text substringToIndex:rangeLeft.location]; //截取文本
            [mary addObject:temStr];//添加文本
            temStr = [text substringWithRange:NSMakeRange(rangeLeft.location, rangeRight.location+1-rangeLeft.location)];// 截取表情
            [mary addObject:temStr]; //添加表情
            NSString *newString = [text substringFromIndex:rangeRight.location+1];  // 获得新的字符串
            [self parseText1:newString withArray:mary];
        }
        else
        {
            NSString *temStr = [text substringWithRange:NSMakeRange(rangeLeft.location, rangeRight.location+1-rangeLeft.location)]; // 截取表情
            if (![temStr isEqualToString:@""])
            {
                [mary addObject:temStr];
                temStr = [text substringFromIndex:rangeRight.location+1]; // 获得新的字符串
                [self parseText1:temStr withArray:mary];
            }
            else
            {
                return;
            }
        }
        
    }
    else //  在字符串中，没发现有表情符号
    {
        if (text!=nil)
            [mary addObject:text];
    }
    
}

+ (void)parseText2:(NSString *)content withArray:(NSMutableArray *)array
{
    NSString *newString;
    newString =[self htmlToText:content];
    
    NSError *error;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"((@)([A-Z0-9a-z(é|ë|ê|è|à|â|ä|á|ù|ü|û|ú|ì|ï|î|í)]|[\u4e00-\u9fa5]|(_|-))+)|(http(s)?://([A-Z0-9a-z._-]*(/)?)*)|((#)([A-Z0-9a-z(é|ë|ê|è|à|â|ä|á|ù|ü|û|ú|ì|ï|î|í)]|[\u4e00-\u9fa5]|(_|-))+(#))" options:NSRegularExpressionCaseInsensitive error:&error];
    
    while (![newString isEqualToString:@""]) {
        
        //下一个匹配的串
        NSTextCheckingResult *next_match = [regex firstMatchInString:newString options:0 range:NSMakeRange(0, [newString length])];
        if(next_match!=nil)
        {
            NSRange range=[next_match range];
            NSString *pre_string=[newString substringToIndex:range.location];
            NSString *match_string=[newString substringWithRange:range];
            newString=[newString substringFromIndex:range.location+range.length];

            if(pre_string)  // 添加正常子串
            {
                NSDictionary *contentDic = @{kWeiboTextTypeKey:@(TPWeiboTextTypeNomalText),kWeiboTextStringKey:pre_string};
                [array addObject:contentDic];
            }
            
            if(match_string) // 添加 @ 和 #
            {
                NSDictionary *contentDic = @{kWeiboTextTypeKey:@(TPWeiboTextTypeHightLightText),kWeiboTextStringKey:match_string};
                [array addObject:contentDic];
            }
            
        }
        else
        {
            NSDictionary *contentDic = @{kWeiboTextTypeKey:@(TPWeiboTextTypeNomalText),kWeiboTextStringKey:newString};
            [array addObject:contentDic];
            newString = @"";
        }
    }
}

+ (NSString *)htmlToText:(NSString *)htmlString
{
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&amp;"  withString:@"&"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&lt;"  withString:@"<"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&gt;"  withString:@">"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&quot;" withString:@""""];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&#039;"  withString:@"'"];
    
    // Newline character (if you have a better idea...)
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"\n"  withString:@">newLine"];
    
    // Extras
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<3" withString:@"♥"];
    
    return htmlString;
}

+(CGSize)sizeWithTextArray:(NSArray *)textArray constrainsToSize:(CGSize)size Font:(UIFont *)font
{
    CGFloat x = kXMargine;
    CGFloat y = kYMargine;
    CGSize textSize = CGSizeZero;
    
    int count = [textArray count];
    
    for(int i = 0;i<count;i++)
    {
        NSDictionary *textDic = textArray[i];
        NSNumber *typeNumber = textDic[kWeiboTextTypeKey];
        NSString *content = textDic[kWeiboTextStringKey];
        
        switch (typeNumber.intValue) {
            case TPWeiboTextTypeEmotion:
            {
                NSString *imageName = [content substringWithRange:NSMakeRange(0, content.length)];
                textSize = [imageName sizeWithFont:font constrainedToSize:CGSizeMake(size.width, 100)];
                
                if (x + textSize.height > size.width) {
                    //换行
                    x = kXMargine;
                    y += textSize.height;
                }
                x += kEmotionWidth;
            }
                break;
            case TPWeiboTextTypeHightLightText:
            case TPWeiboTextTypeNomalText:
            {
                for (int i = 0; i < [content length]; i++)
                {
                    // 单个字
                    NSString *temp = [content substringWithRange:NSMakeRange(i, 1)];
                    textSize = [temp sizeWithFont:font constrainedToSize:CGSizeMake(size.width, 100)];
                    
                    if (x + textSize.width > size.width) {
                        //换行
                        x = kXMargine;
                        y += textSize.height + 2;
                    }
                    
                    x += textSize.width;
                }
                
            }
                break;
            default:
                break;
        }
    }
    
    y += textSize.height;
    
    return CGSizeMake(size.width, y + 5);
}


#pragma mark v2
-(id)init
{
    self = [super init];
    if (self) {
        self.richTextRunsArray = [[NSMutableArray alloc] init];
    }
    return self;
}
- (CGSize)sizeWithRawString:(NSString *)string constrainsToWidth:(CGFloat)width Font:(UIFont *)font
{
    
    NSAttributedString *attString = [self analyzeText:string Font:font];
    
//    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attString);    //string 为要计算高度的NSAttributedString
//    CGRect drawingRect = CGRectMake(0, 0, width, 1000);  //这里的高要设置足够大
//    CGMutablePathRef path = CGPathCreateMutable();
//    CGPathAddRect(path, NULL, drawingRect);
//    CTFrameRef textFrame = CTFramesetterCreateFrame(framesetter,CFRangeMake(0,0), path, NULL);
//    CGPathRelease(path);
//    CFRelease(framesetter);
//    
//    NSArray *linesArray = (NSArray *) CTFrameGetLines(textFrame);
//    
//    CGPoint origins[[linesArray count]];
//    CTFrameGetLineOrigins(textFrame, CFRangeMake(0, 0), origins);
//    
//    int line_y = (int) origins[[linesArray count] -1].y;  //最后一行line的原点y坐标
//    
//    CGFloat ascent;
//    CGFloat descent;
//    CGFloat leading;
//    
//    CTLineRef line = (CTLineRef) CFBridgingRetain([linesArray objectAtIndex:[linesArray count]-1]);
//    CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
//    
//    total_height = 1000 - line_y + (int) descent +1;    //+1为了纠正descent转换成int小数点后舍去的值
//    
//    CFRelease(textFrame);
    
    
    //绘制
    int lineCount = 0;
    CFRange lineRange = CFRangeMake(0,0);
    CTTypesetterRef typeSetter = CTTypesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attString);
    float drawLineX = 0;
    float drawLineY = 0 ;
    BOOL drawFlag = YES;
    
    while(drawFlag)
    {
        // 一行多少个字
        CFIndex testLineLength = CTTypesetterSuggestLineBreak(typeSetter,lineRange.location,width);
    check:  lineRange = CFRangeMake(lineRange.location,testLineLength);
        CTLineRef line = CTTypesetterCreateLine(typeSetter,lineRange);
        CFArrayRef runs = CTLineGetGlyphRuns(line);
        
        //边界检查
        CTRunRef lastRun = CFArrayGetValueAtIndex(runs, CFArrayGetCount(runs) - 1);
        CGFloat lastRunAscent;
        CGFloat laseRunDescent;
        CGFloat lastRunWidth  = CTRunGetTypographicBounds(lastRun, CFRangeMake(0,0), &lastRunAscent, &laseRunDescent, NULL);
        CGFloat lastRunPointX = drawLineX + CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(lastRun).location, NULL);
        
        if ((lastRunWidth + lastRunPointX) > width)
        {
            testLineLength--;
            CFRelease(line);
            goto check;
        }
        
        CFRelease(line);
        
        if(lineRange.location + lineRange.length >= attString.length)
        {
            drawFlag = NO;
        }
        
        lineCount++;
        drawLineY += font.ascender - font.descender + 2 ;  // 2是行距
        lineRange.location += lineRange.length;
    }
    
    CFRelease(typeSetter);
    return CGSizeMake(width, drawLineY);
}

- (NSAttributedString *)analyzeText:(NSString *)string Font:(UIFont *)font
{
    [self.richTextRunsArray removeAllObjects];
    
    NSString *result = @"";
    
    NSMutableArray *array = self.richTextRunsArray;
    
    // 所有[表情]构成对应的EmojiRun对象的数组以及新的newString,newString中的表情已变成空格
    result = [TQRichTextEmojiRun analyzeText:string runsArray:&array];
    
    // 生成URLRun对象
    result = [TQRichTextURLRun analyzeText:result runsArray:&array];
    
    
    // Get
    [self.richTextRunsArray makeObjectsPerformSelector:@selector(setOriginalFont:) withObject:font];
    
    
    //要绘制的文本
    NSMutableAttributedString* attString = [[NSMutableAttributedString alloc] initWithString:result];
    
    //设置字体
    CTFontRef aFont = CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize, NULL);
    [attString addAttribute:(NSString*)kCTFontAttributeName value:(__bridge id)aFont range:NSMakeRange(0,attString.length)];
    CFRelease(aFont);
    
    //文本处理:Emoji使用一个@“ ”的AttributeString,通过delegate设置其宽度等属性。URL只需设置该Range的前景色
    for (TQRichTextBaseRun *textRun in self.richTextRunsArray)
    {
        [textRun replaceTextWithAttributedString:attString];
    }
    
    return attString;
}
@end
