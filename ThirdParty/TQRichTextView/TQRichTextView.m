//
//  TQRichTextView.m
//  TQRichTextViewDemo
//
//  Created by fuqiang on 13-9-12.
//  Copyright (c) 2013年 fuqiang. All rights reserved.
//

#import "TQRichTextView.h"
#import <CoreText/CoreText.h>
#import "TQRichTextEmojiRun.h"
#import "TQRichTextURLRun.h"

@implementation TQRichTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _text = @"";
        _font = [UIFont systemFontOfSize:12.0];
        _textColor = [UIColor blackColor];
        _lineSpacing = 1.5;
        //
        _richTextRunsArray = [[NSMutableArray alloc] init];
        _richTextRunRectDic = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#pragma mark - Draw Rect
- (void)drawRect:(CGRect)rect
{
    //解析文本
    _textAnalyzed = [self analyzeText:_text];
    
    //要绘制的文本
    NSMutableAttributedString* attString = [[NSMutableAttributedString alloc] initWithString:self.textAnalyzed];

    //设置字体
    CTFontRef aFont = CTFontCreateWithName((__bridge CFStringRef)self.font.fontName, self.font.pointSize, NULL);
    [attString addAttribute:(NSString*)kCTFontAttributeName value:(__bridge id)aFont range:NSMakeRange(0,attString.length)];
    CFRelease(aFont);
    
    //设置颜色
    [attString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)self.textColor.CGColor range:NSMakeRange(0,attString.length)];
    
    //文本处理:Emoji使用一个@“ ”的AttributeString,通过delegate设置其宽度等属性。URL只需设置该Range的前景色
    for (TQRichTextBaseRun *textRun in self.richTextRunsArray)
    {
        [textRun replaceTextWithAttributedString:attString];
    }

    //绘图上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //修正坐标系
    CGAffineTransform textTran = CGAffineTransformIdentity;
    textTran = CGAffineTransformMakeTranslation(0.0, self.bounds.size.height);
    textTran = CGAffineTransformScale(textTran, 1.0, -1.0);
    CGContextConcatCTM(context, textTran);

    //绘制
    int lineCount = 0;
    CFRange lineRange = CFRangeMake(0,0);
    CTTypesetterRef typeSetter = CTTypesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attString);
    float drawLineX = 0;
    float drawLineY = self.bounds.origin.y + self.bounds.size.height - self.font.ascender;
    BOOL drawFlag = YES;
    [self.richTextRunRectDic removeAllObjects];
    
    while(drawFlag)
    {
        // 一行多少个字
        CFIndex testLineLength = CTTypesetterSuggestLineBreak(typeSetter,lineRange.location,self.bounds.size.width);
check:  lineRange = CFRangeMake(lineRange.location,testLineLength);
        CTLineRef line = CTTypesetterCreateLine(typeSetter,lineRange);
        CFArrayRef runs = CTLineGetGlyphRuns(line);
        
        //边界检查
        CTRunRef lastRun = CFArrayGetValueAtIndex(runs, CFArrayGetCount(runs) - 1);
        CGFloat lastRunAscent;
        CGFloat laseRunDescent;
        CGFloat lastRunWidth  = CTRunGetTypographicBounds(lastRun, CFRangeMake(0,0), &lastRunAscent, &laseRunDescent, NULL);
        CGFloat lastRunPointX = drawLineX + CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(lastRun).location, NULL);
        
        if ((lastRunWidth + lastRunPointX) > self.bounds.size.width)
        {
            testLineLength--;
            CFRelease(line);
goto check;
        }
        
        //绘制普通行元素（包括有前景色的）
        drawLineX = CTLineGetPenOffsetForFlush(line,0,self.bounds.size.width);
        CGContextSetTextPosition(context,drawLineX,drawLineY);
        CTLineDraw(line,context);
        
        //绘制替换过的特殊文本单元
        for (int i = 0; i < CFArrayGetCount(runs); i++)
        {
            CTRunRef run = CFArrayGetValueAtIndex(runs, i);
            NSDictionary* attributes = (__bridge NSDictionary*)CTRunGetAttributes(run);
            TQRichTextBaseRun *textRun = [attributes objectForKey:@"TQRichTextAttribute"];
            if (textRun) // 绘制表情
            {
                CGFloat runAscent,runDescent;
                CGFloat runWidth  = CTRunGetTypographicBounds(run, CFRangeMake(0,0), &runAscent, &runDescent, NULL);
                CGFloat runHeight = runAscent + (-runDescent);
                CGFloat runPointX = drawLineX + CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
                CGFloat runPointY = drawLineY - (-runDescent);

                CGRect runRect = CGRectMake(runPointX, runPointY, runWidth, runHeight);
                
                [textRun drawRunWithRect:runRect];
                
//                if (textRun.isResponseTouch)  // URL手势
//                {
//                    if (isDraw)
//                    {
//                        [self.richTextRunRectDic setObject:textRun forKey:[NSValue valueWithCGRect:runRect]];
//                    }
//                    else
//                    {
//                        runRect = CTRunGetImageBounds(run, context, CFRangeMake(0, 0));
//                        runRect.origin.x = runPointX;
//                        [self.richTextRunRectDic setObject:textRun forKey:[NSValue valueWithCGRect:runRect]];
//                    }
//                }
            }
        }

        CFRelease(line);
        
        if(lineRange.location + lineRange.length >= attString.length)
        {
            drawFlag = NO;
        }

        lineCount++;
        drawLineY -= self.font.ascender + (- self.font.descender) + self.lineSpacing;
        lineRange.location += lineRange.length;
    }
    
    CFRelease(typeSetter);
}

#pragma mark - Analyze Text
//-- 解析文本内容
- (NSString *)analyzeText:(NSString *)string
{
    [self.richTextRunsArray removeAllObjects];
    [self.richTextRunRectDic removeAllObjects];
    
    NSString *result = @"";
    
    NSMutableArray *array = self.richTextRunsArray;
    
    // 所有[表情]构成对应的EmojiRun对象的数组以及新的newString,newString中的表情已变成空格
    result = [TQRichTextEmojiRun analyzeText:string runsArray:&array];
    
    // 生成URLRun对象
    result = [TQRichTextURLRun analyzeText:result runsArray:&array];
    
    
    // Get
    [self.richTextRunsArray makeObjectsPerformSelector:@selector(setOriginalFont:) withObject:self.font];

    return result;
}

//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    CGPoint location = [(UITouch *)[touches anyObject] locationInView:self];
//    CGPoint runLocation = CGPointMake(location.x, self.frame.size.height - location.y);
//    
//    if (self.delegage && [self.delegage respondsToSelector:@selector(richTextView: touchBeginRun:)])
//    {
//        __weak TQRichTextView *weakSelf = self;
//        [self.richTextRunRectDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
//         {
//             CGRect rect = [((NSValue *)key) CGRectValue];
//             TQRichTextBaseRun *run = obj;
//             if(CGRectContainsPoint(rect, runLocation))
//             {
//                 [weakSelf.delegage richTextView:weakSelf touchBeginRun:run];
//             }
//         }];
//    }
//}
//
//-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    CGPoint location = [(UITouch *)[touches anyObject] locationInView:self];
//    CGPoint runLocation = CGPointMake(location.x, self.frame.size.height - location.y);
//    
//    if (self.delegage && [self.delegage respondsToSelector:@selector(richTextView: touchEndRun:)])
//    {
//        [self.richTextRunRectDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
//         {
//             __weak TQRichTextView *weakSelf = self;
//             CGRect rect = [((NSValue *)key) CGRectValue];
//             TQRichTextBaseRun *run = obj;
//             if(CGRectContainsPoint(rect, runLocation))
//             {
//                 [weakSelf.delegage richTextView:weakSelf touchEndRun:run];
//             }
//         }];
//    }
//}

#pragma mark - Set
- (void)setText:(NSString *)text
{
    [self setNeedsDisplay];
    _text = text;
}

- (void)setFont:(UIFont *)font
{
    [self setNeedsDisplay];
    _font = font;
}

- (void)setTextColor:(UIColor *)textColor
{
    [self setNeedsDisplay];
    _textColor = textColor;
}

- (void)setLineSpacing:(float)lineSpacing
{
    [self setNeedsDisplay];
    _lineSpacing = lineSpacing;
}

@end















