//
//  TQRichTextEmojiRun.m
//  TQRichTextViewDemo
//
//  Created by fuqiang on 13-9-21.
//  Copyright (c) 2013年 fuqiang. All rights reserved.
//

#import "TQRichTextEmojiRun.h"

@implementation TQRichTextEmojiRun

- (id)init
{
    self = [super init];
    if (self) {
        self.type = richTextEmojiRunType;
        self.isResponseTouch = NO;
    }
    return self;
}

- (BOOL)drawRunWithRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    NSString *emojiString = [NSString stringWithFormat:@"%@.gif",self.originalText];
    
    UIImage *image = [UIImage imageNamed:emojiString];
    if (image)
    {
        CGContextDrawImage(context, rect, image.CGImage);
    }
    return YES;
}

+ (NSArray *) emojiStringArray
{
    return [[NSArray alloc] initWithObjects:@"[爱你]",@"[悲伤]",@"[闭嘴]",@"[馋嘴]",@"[吃惊]",@"[哈哈]",@"[害羞]",@"[汗]",@"[呵呵]",@"[黑线]",@"[花心]",@"[挤眼]",@"[可爱]",@"[可怜]",@"[酷]",@"[困]",@"[泪]",@"[生病]",@"[失望]",@"[偷笑]",@"[晕]",@"[挖鼻屎]",@"[阴险]",@"[囧]",@"[怒]",@"[good]",@"[给力]",@"[浮云]",@"[嘻嘻]",@"[鄙视]",@"[亲亲]",@"[太开心]",@"[懒得理你]",@"[右哼哼]",@"[左哼哼]",@"[嘘]",@"[衰]",@"[委屈]",@"[吐]",@"[打哈气]",@"[抱抱]",@"[疑问]",@"[拜拜]",@"[思考]",@"[睡觉]",@"[钱]",@"[哼]",@"[鼓掌]",@"[抓狂]",@"[怒骂]",@"[熊猫]",@"[奥特曼]",@"[猪头]",@"[蜡烛]",@"[蛋糕]",@"[din推撞]",nil];
}

+ (NSString *)analyzeText:(NSString *)string runsArray:(NSMutableArray **)runArray
{
    NSString *markL = @"[";
    NSString *markR = @"]";
    NSMutableArray *stack = [[NSMutableArray alloc] init];
    NSMutableString *newString = [[NSMutableString alloc] initWithCapacity:string.length];
    
    //偏移索引 由于会把长度大于1的字符串替换成一个空白字符。这里要记录每次的偏移了索引。以便简历下一次替换的正确索引
    int offsetIndex = 0;
    
    for (int i = 0; i < string.length; i++)
    {
        NSString *s = [string substringWithRange:NSMakeRange(i, 1)];
        
        if (([s isEqualToString:markL]) || ((stack.count > 0) && [stack[0] isEqualToString:markL]))
        {
            if (([s isEqualToString:markL]) && ((stack.count > 0) && [stack[0] isEqualToString:markL]))
            {
                for (NSString *c in stack)
                {
                    [newString appendString:c];
                }
                [stack removeAllObjects];
            }
            
            [stack addObject:s];
            
            if ([s isEqualToString:markR] || (i == string.length - 1))
            {
                NSMutableString *emojiStr = [[NSMutableString alloc] init];
                for (NSString *c in stack)
                {
                    [emojiStr appendString:c];
                }
                
                if ([[TQRichTextEmojiRun emojiStringArray] containsObject:emojiStr])
                {
                    TQRichTextEmojiRun *emoji = [[TQRichTextEmojiRun alloc] init];
                    emoji.range = NSMakeRange(i + 1 - emojiStr.length - offsetIndex, 1);
                    emoji.originalText = emojiStr;
                    [*runArray addObject:emoji];
                    [newString appendString:@" "];
                    
                    offsetIndex += emojiStr.length - 1;
                }
                else
                {
                    [newString appendString:emojiStr];
                }
                
                [stack removeAllObjects];
            }
        }
        else
        {
            [newString appendString:s];
        }
    }

    return newString;
}

@end
