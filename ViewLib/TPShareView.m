//
//  TPShareView.m
//  TimePill
//
//  Created by yan simon on 13-9-18.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "TPShareView.h"

@implementation TPShareView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"switch_bg.png"]];
        self.weiboSwitch = [[TPSwitch alloc] initWithFrame:CGRectMake(18, 13, 47, 18) BackgroundImage:[UIImage imageNamed:@"onoff.png"] ButtonImage:[UIImage imageNamed:@"weibo.png"]];
        [self addSubview:self.weiboSwitch];
    }
    return self;
}


@end
