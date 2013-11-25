//
//  TPImageTextView.m
//  TPSinaWeiboSDK
//
//  Created by yan simon on 13-9-12.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "TPImageTextView.h"
#import <QuartzCore/QuartzCore.h>

@implementation TPImageTextView

-(void)setTextArray:(NSArray *)parsedTextArray
{
    self.weiboEmotions=[[NSArray alloc] initWithObjects:@"[爱你]",@"[悲伤]",@"[闭嘴]",@"[馋嘴]",@"[吃惊]",@"[哈哈]",@"[害羞]",@"[汗]",@"[呵呵]",@"[黑线]",@"[花心]",@"[挤眼]",@"[可爱]",@"[可怜]",@"[酷]",@"[困]",@"[泪]",@"[生病]",@"[失望]",@"[偷笑]",@"[晕]",@"[挖鼻屎]",@"[阴险]",@"[囧]",@"[怒]",@"[good]",@"[给力]",@"[浮云]",@"[嘻嘻]",@"[鄙视]",@"[亲亲]",@"[太开心]",@"[懒得理你]",@"[右哼哼]",@"[左哼哼]",@"[嘘]",@"[衰]",@"[委屈]",@"[吐]",@"[打哈气]",@"[抱抱]",@"[疑问]",@"[拜拜]",@"[思考]",@"[睡觉]",@"[钱]",@"[哼]",@"[鼓掌]",@"[抓狂]",@"[怒骂]",@"[熊猫]",@"[奥特曼]",@"[猪头]",@"[蜡烛]",@"[蛋糕]",@"[din推撞]",nil];
    
    self.parsedTextArray = parsedTextArray;
    
    [self setNeedsDisplay];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{@autoreleasepool{
    // 初始化坐标起点
    CGFloat x = kXMargine;
    CGFloat y = kYMargine;
    CGSize textSize = CGSizeZero;
    
    // 初始化颜色
    if(!self.nomalColor)
        self.nomalColor = [UIColor blackColor];
    
    if(!self.hightLightColor)
        self.hightLightColor = [UIColor colorWithRed:87.0/255.0 green:121.0/255.0 blue:158.0/255.0 alpha:1.0];
    
    int count = [self.parsedTextArray count];
    
    for(int i = 0;i<count;i++)
    {
        NSDictionary *textDic = self.parsedTextArray[i];
        NSNumber *typeNumber = textDic[kWeiboTextTypeKey];
        NSString *content = textDic[kWeiboTextStringKey];
        
        switch (typeNumber.intValue) {
            case TPWeiboTextTypeEmotion:
            {
                NSString *imageName = [content substringWithRange:NSMakeRange(0, content.length)];
                textSize = [imageName sizeWithFont:self.font constrainedToSize:CGSizeMake(self.frame.size.width, 100)];
                
                if (x + textSize.height > self.frame.size.width) {
                    //换行
                    x = kXMargine;
                    y += textSize.height;
                }
                
                // 该表情在数组中的索引
                int index=[self.weiboEmotions indexOfObject:imageName];
                if(index>27)
                {
                    index=index-28;
                    imageName=[NSString stringWithFormat:@"r%d.gif",index];
                }
                else {
                    imageName=[NSString stringWithFormat:@"w%d.gif",index];
                }
                
                // 绘制表情
                UIImage *image = [UIImage imageNamed:imageName];
                [image drawInRect:CGRectMake(x, y, kEmotionWidth, kEmotionHeight)];
                
                x += kEmotionWidth;
            }
                break;
            case TPWeiboTextTypeHightLightText:
            {
                textColor = self.hightLightColor;
                [self drawSingleText:content X:&x Y:&y];
            }
                break;
            case TPWeiboTextTypeNomalText:
            {
                textColor = self.nomalColor;
                [self drawSingleText:content X:&x Y:&y];
            }
                break;
            default:
                break;
        }
    }}
}

-(void)drawSingleText:(NSString *)text X:(CGFloat *)x Y:(CGFloat*)y
{@autoreleasepool{
    [textColor set];
    for (int i = 0; i < [text length]; i++)
    {
        NSString *temp = [text substringWithRange:NSMakeRange(i, 1)];

        CGSize size = [temp sizeWithFont:self.font constrainedToSize:CGSizeMake(self.frame.size.width, 100)];
        // 14 * 18
        if (*x + size.width > self.frame.size.width)
        {
            *x = kXMargine;
            *y += size.height + 2;
            
        }
        [temp drawInRect:CGRectMake(*x, *y, size.width, size.height) withFont:self.font];
        
        *x = *x + size.width;
    }}
}


@end
