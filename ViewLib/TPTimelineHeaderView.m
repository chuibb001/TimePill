//
//  TPTimelineHeaderView.m
//  TimePill
//
//  Created by simon on 13-9-19.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "TPTimelineHeaderView.h"

@implementation TPTimelineHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithPatternImage:[TPTheme currentHeadImage]];
        
        //圆圈边框
        UIView *circleKuang=[[UIView alloc] initWithFrame:CGRectMake(8, 77, 80, 80)];
        [circleKuang setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"touxiangkuang.png"]]];
        [self addSubview:circleKuang];
        
        //日记本条
        UIView *bijiben=[[UIView alloc] initWithFrame:CGRectMake(100, 116, 212, 24)];
        [bijiben setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bijiben.png"]]];
        [self addSubview:bijiben];
        
        UIImage *headImage = [UIImage imageNamed:@"defaultHeadImage.png"];
        self.headImageView=[[UIImageView alloc ]initWithFrame:CGRectMake(14, 83, 64, 64)];
        [self.headImageView setImage:headImage];
        self.headImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.headImageView.layer.cornerRadius=31;
        self.headImageView.layer.masksToBounds=YES;
        self.headImageView.userInteractionEnabled = YES;
        [self addSubview:self.headImageView];
    }
    return self;
}

-(void)updateViewWithImage:(UIImage *)image
{
    self.headImageView.image = image;
}
@end
