//
//  TPSwitch.m
//  TimePill
//
//  Created by yan simon on 13-9-18.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "TPSwitch.h"

@implementation TPSwitch

- (id)initWithFrame:(CGRect)frame BackgroundImage:(UIImage *)backgroundImage ButtonImage:(UIImage *)buttonImage
{
    self = [super initWithFrame:frame];
    if (self) {
        /*
                背景层
         */
        
        //放置背景图的layer
        CALayer *backLayer=[CALayer layer];
        
        //宽度为view的两倍
        backLayer.frame=CGRectMake(-frame.size.width, 0, frame.size.width*2, frame.size.height);
        //设置背景图片
        //backLayer.backgroundColor=[UIColor blueColor].CGColor;
        backLayer.contents=(id)backgroundImage.CGImage;
        
        //加到根layer上
        [self.layer addSublayer:backLayer];
        
        //创建蒙版
        CAShapeLayer *maskLayer=[CAShapeLayer layer];
        //创建蒙版路径
        UIBezierPath *clipPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(-12, -4, 60, 26)
                                                            cornerRadius:20];
        
        maskLayer.path=clipPath.CGPath;
        //给背景层添加蒙版
        backLayer.mask=maskLayer;
        
        //重新定位背景层的frame，因为一开始为off
        backLayer.frame=CGRectMake(-frame.size.width, 0, backLayer.frame.size.width, backLayer.frame.size.height);
        backLayer.mask.position=CGPointMake(frame.size.width, 0);
        
        
        /*
                按钮层
         */
        CALayer *buttonLayer=[CALayer layer];
        buttonLayer.frame=CGRectMake(33, -3, 26, 26);
        buttonLayer.contents=(id)buttonImage.CGImage;
        [backLayer addSublayer:buttonLayer];
        
        /*
                手势
         */
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
        [self addGestureRecognizer:tapGesture];
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [self addGestureRecognizer:panGesture];
        
    }
    return self;
}

-(void) handleTap: (UITapGestureRecognizer *) sender {
    //若果想排除按钮上的点，加下列判断
    //if(CGRectContainsPoint(knobButton.frame,[sender locationInView:self]) !=YES)
    
    //背景层移动的动画
    [CATransaction setAnimationDuration:0.014];
    [CATransaction setCompletionBlock:^{
		[CATransaction begin];
        
		/*---------------------移动背景层--------------------*/
        CALayer *backLayer=[self.layer.sublayers objectAtIndex:0];
        
        if(self.isOn == NO)
        {
            self.isOn=YES;
            backLayer.frame=CGRectMake(-10, 0, backLayer.frame.size.width, backLayer.frame.size.height);
            backLayer.mask.position=CGPointMake(10, 0);
        }
        else {
            self.isOn=NO;
            //背景层的frame是相对于本view的
            backLayer.frame=CGRectMake(-self.frame.size.width, 0, backLayer.frame.size.width, backLayer.frame.size.height);
            //重新定位mask，否则mask会跟着背景层移动
            backLayer.mask.position=CGPointMake(self.frame.size.width, 0);
        }
        
        
		[CATransaction setCompletionBlock:^{
            //这个block能干嘛？？
			
		}];
        
        [CATransaction commit];
	}];
    
}

- (void)handlePan:(UIPanGestureRecognizer *)sender {
    
    if (sender.state == UIGestureRecognizerStateBegan)
	{
        
	}
    //移动过程中
	else if (sender.state == UIGestureRecognizerStateChanged)
	{
        CALayer *backLayer=[self.layer.sublayers objectAtIndex:0];
        /*-----------------按钮动画-----------------*/
        //当前手指坐标
        //translation是移动了多少
		CGPoint position = [sender translationInView:self];
        
        //新x=原x+位移x
        float newX=backLayer.frame.origin.x+position.x;
        //范围标定
        if(newX>-10)
            newX=-10;
        if(newX<-47)
            newX=-47;
        backLayer.frame=CGRectMake(newX, 0, backLayer.frame.size.width, backLayer.frame.size.height);
        backLayer.mask.position=CGPointMake(-newX, 0);
        
	}
    //移动结束
	else if (sender.state == UIGestureRecognizerStateEnded)
	{
        
        [CATransaction setAnimationDuration:0.1];
        [CATransaction setCompletionBlock:^{
            [CATransaction begin];
            
            /*---------------------移动背景层--------------------*/
            CALayer *backLayer=[self.layer.sublayers objectAtIndex:0];
            
            //中点=原点+宽的一半
            //CGPoint center = CGPointMake(backLayer.frame.origin.x+backLayer.frame.size.width/2, self.center.y);
            
            
            if(backLayer.frame.origin.x > -28.5)
            {
                backLayer.frame=CGRectMake(-10, 0, backLayer.frame.size.width, backLayer.frame.size.height);
                backLayer.mask.position=CGPointMake(10, 0);
                self.isOn=NO;

            }
            else {
                //背景层的frame是相对于本view的
                backLayer.frame=CGRectMake(-self.bounds.size.width, 0, backLayer.frame.size.width, backLayer.frame.size.height);
                //重新定位mask，否则mask会跟着背景层移动
                backLayer.mask.position=CGPointMake(self.bounds.size.width, 0);
                self.isOn=YES;

            }
            
            [CATransaction commit];
        }];    
	}
    
}

@end
