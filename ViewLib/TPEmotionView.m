//
//  TPEmotionView.m
//  TPSinaWeiboSDK

//  表情面板

//  Created by simon on 13-9-14.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "TPEmotionView.h"

@implementation TPEmotionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"motionbg.png"]];
        [self initData];
        [self initScrollView];
        [self initPageControl];
    }
    return self;
}

#pragma mark Init
-(void)initData
{
    //表情文本数组
    self.emotionsArray1=[[NSArray alloc] initWithObjects:@"[爱你]",@"[悲伤]",@"[闭嘴]",@"[馋嘴]",@"[吃惊]",@"[哈哈]",@"[害羞]",@"[汗]",@"[呵呵]",@"[黑线]",@"[花心]",@"[挤眼]",@"[可爱]",@"[可怜]",@"[酷]",@"[困]",@"[泪]",@"[生病]",@"[失望]",@"[偷笑]",@"[晕]",@"[挖鼻屎]",@"[阴险]",@"[囧]",@"[怒]",@"[good]",@"[给力]",@"[浮云]", nil];
    self.emotionsArray2=[[NSArray alloc] initWithObjects:@"[嘻嘻]",@"[鄙视]",@"[亲亲]",@"[太开心]",@"[懒得理你]",@"[右哼哼]",@"[左哼哼]",@"[嘘]",@"[衰]",@"[委屈]",@"[吐]",@"[打哈欠]",@"[抱抱]",@"[疑问]",@"[拜拜]",@"[思考]",@"[睡觉]",@"[钱]",@"[哼]",@"[鼓掌]",@"[抓狂]",@"[怒骂]",@"[熊猫]",@"[奥特曼]",@"[猪头]",@"[蜡烛]",@"[蛋糕]",@"[din推撞]", nil];
}

- (void)initScrollView
{
    self.emotionScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - 30)];
    self.emotionScrollView.pagingEnabled=YES;  //是否自动滑到边缘的关键
    self.emotionScrollView.contentSize=CGSizeMake(CGRectGetWidth(self.frame) * 2, CGRectGetHeight(self.frame) - 30);
    self.emotionScrollView.showsHorizontalScrollIndicator=NO;
    self.emotionScrollView.delegate=self;
    [self addSubview:self.emotionScrollView];
    [self setupEmotions];
}

-(void)setupEmotions
{
    for(int i=0;i<4;i++)
    {
        for(int j=0;j<7;j++)
        {
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            button.frame=CGRectMake(18+j*43, 20+i*45, 25, 25);
            UIImage *image=[UIImage imageNamed:[NSString stringWithFormat:@"w%d.gif",i*7+j]];
            [button setImage:image forState:UIControlStateNormal];
            button.tag=i*7+j;
            [button addTarget:self action:@selector(emotionclicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.emotionScrollView addSubview:button];
        }
    }
    for(int i=0;i<4;i++)
    {
        for(int j=0;j<7;j++)
        {
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            button.frame=CGRectMake(320+18+j*43, 20+i*45, 25, 25);
            UIImage *image=[UIImage imageNamed:[NSString stringWithFormat:@"r%d.gif",i*7+j]];
            [button setImage:image forState:UIControlStateNormal];
            button.tag=28+i*7+j;
            [button addTarget:self action:@selector(emotionclicked:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.emotionScrollView addSubview:button];
        }
    }
}
-(void)initPageControl
{
    self.emotionPageControl=[[UIPageControl alloc] initWithFrame:CGRectMake(140, CGRectGetHeight(self.frame) - 45, 40, 50)];
    self.emotionPageControl.numberOfPages = 2;
    self.emotionPageControl.currentPage = 0;
    [self.emotionPageControl addTarget:self action:@selector(showChanges) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.emotionPageControl];
}

#pragma mark private
-(void)emotionclicked:(id)sender
{
    UIButton *button=(UIButton *)sender;
    int tag=button.tag;
    
    //该表情的文本
    NSString *emotionStr = nil;
    if(tag>=28)
    {
        int index=tag-28;
        emotionStr=[self.emotionsArray2 objectAtIndex:index];
    }
    else {
        emotionStr=[self.emotionsArray1 objectAtIndex:tag];
    }
    
    self.handler(emotionStr);
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView_
{
    CGFloat pageWidth = scrollView_.frame.size.width;
    
    int page = floor((scrollView_.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
	
	[self.emotionPageControl setCurrentPage:page];
}


@end
