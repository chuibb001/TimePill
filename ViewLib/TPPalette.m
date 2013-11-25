//
//  TPPalette.m
//  TimePill
//
//  Created by yan simon on 13-9-18.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "TPPalette.h"

@implementation TPPalette

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
        self.isFirst = YES;
    }
    return self;
	
}
-(void)IntsegmentColor
{
	switch (self.Intsegmentcolor)
	{
		case 0:
			self.segmentColor=[UIColor colorWithRed:255/255 green:36/255 blue:0 alpha:1];
			break;
		case 1:
			self.segmentColor=[UIColor colorWithRed:255.0/255.0 green:242.0/255.0 blue:30.0/255.0 alpha:1.0];
			break;
		case 2:
			self.segmentColor=[UIColor colorWithRed:220.0/255.0 green:184.0/255.0 blue:209.0/255.0 alpha:1.0];
            
			break;
		case 3:
			self.segmentColor=[UIColor colorWithRed:160.0/255.0 green:192.0/255.0 blue:90.0/255.0 alpha:1.0];
			break;
		case 4:
			self.segmentColor=[UIColor colorWithRed:100.0/255.0 green:151.0/255.0 blue:184.0/255.0 alpha:1.0];
			break;
		case 5:
			self.segmentColor=[UIColor colorWithRed:212.0/255.0 green:167.0/255.0 blue:117.0/255.0 alpha:1.0];
			break;
        case 6:
			self.segmentColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:1];
			break;
        case 7:
			self.segmentColor=[UIColor whiteColor];
			break;
            
		default:
			break;
	}
}

- (void)drawRect:(CGRect)rect
{
	//获取上下文
	CGContextRef context=UIGraphicsGetCurrentContext();
	//设置笔冒
	CGContextSetLineCap(context, kCGLineCapRound);
	//设置画线的连接处　拐点圆滑
	CGContextSetLineJoin(context, kCGLineJoinRound);
	//第一次时候个myallline开辟空间
	//static BOOL allline=NO;
	if (self.isFirst)
	{
		self.myallline = [[NSMutableArray alloc] initWithCapacity:10];
		self.myallColor = [[NSMutableArray alloc] initWithCapacity:10];
		self.myallwidth = [[NSMutableArray alloc] initWithCapacity:10];
		self.isFirst = NO;
	}
    
	//画之前的线
	if ([self.myallline count]>0)
	{
		for (int i=0; i<[self.myallline count]; i++)
		{
			NSArray* tempArray=[NSArray arrayWithArray:[self.myallline objectAtIndex:i]];
			
			if ([self.myallColor count]>0)
			{
				self.Intsegmentcolor=[[self.myallColor objectAtIndex:i] intValue];
				self.Intsegmentwidth=[[self.myallwidth objectAtIndex:i]floatValue]+1;
			}
			
			if ([tempArray count]>1)
			{
				CGContextBeginPath(context);
				CGPoint myStartPoint=[[tempArray objectAtIndex:0] CGPointValue];
				CGContextMoveToPoint(context, myStartPoint.x, myStartPoint.y);
				
				for (int j=0; j<[tempArray count]-1; j++)
				{
					CGPoint myEndPoint=[[tempArray objectAtIndex:j+1] CGPointValue];
					
					CGContextAddLineToPoint(context, myEndPoint.x,myEndPoint.y);
				}
				[self IntsegmentColor];
				CGContextSetStrokeColorWithColor(context, self.segmentColor.CGColor);
				
				CGContextSetLineWidth(context, self.Intsegmentwidth);
				CGContextStrokePath(context);
			}
		}
	}
	//画当前的线
	if ([self.myallpoint count]>1)
	{
		CGContextBeginPath(context);
		
		//起点
		
		CGPoint myStartPoint=[[self.myallpoint objectAtIndex:0]   CGPointValue];
		CGContextMoveToPoint(context,    myStartPoint.x, myStartPoint.y);
		//把move的点全部加入　数组
		for (int i=0; i<[self.myallpoint count]-1; i++)
		{
			CGPoint myEndPoint=  [[self.myallpoint objectAtIndex:i+1] CGPointValue];
			CGContextAddLineToPoint(context, myEndPoint.x,   myEndPoint.y);
		}
		//在颜色和画笔大小数组里面取不相应的值
		self.Intsegmentcolor=[[self.myallColor lastObject] intValue];
		self.Intsegmentwidth=[[self.myallwidth lastObject]floatValue]+1;
		
		
		//绘制画笔颜色
		[self IntsegmentColor];
        
        
		CGContextSetStrokeColorWithColor(context, self.segmentColor.CGColor);
		CGContextSetFillColorWithColor (context,  self.segmentColor.CGColor);
		
		//绘制画笔宽度
		CGContextSetLineWidth(context, self.Intsegmentwidth);
		//把数组里面的点全部画出来
		CGContextStrokePath(context);
	}
}

//初始化所有点
-(void)initAllPoints
{
	self.myallpoint=[[NSMutableArray alloc] initWithCapacity:10];
}

//把一次画过的点放到线的数组中
-(void)addLines
{
	[self.myallline addObject:self.myallpoint];
}

//把点加入数组
-(void)addPoints:(CGPoint)sender
{
	NSValue* pointvalue=[NSValue valueWithCGPoint:sender];
	[self.myallpoint addObject:pointvalue];
}


//接收颜色segement反过来的值
-(void)addColors:(int)sender
{
	NSNumber* Numbersender= [NSNumber numberWithInt:sender];
	[self.myallColor addObject:Numbersender];
}


//接收线条宽度按钮反回来的值
-(void)addWidths:(int)sender
{
	NSNumber* Numbersender= [NSNumber numberWithInt:sender];
	[self.myallwidth addObject:Numbersender];
}

//清屏
-(void)clearAllLines
{
	if ([self.myallline count]>0)
	{
		[self.myallline removeAllObjects];
		[self.myallColor removeAllObjects];
		[self.myallwidth removeAllObjects];
		[self.myallpoint removeAllObjects];
		self.myallline=[[NSMutableArray alloc] initWithCapacity:10];
		self.myallColor=[[NSMutableArray alloc] initWithCapacity:10];
		self.myallwidth=[[NSMutableArray alloc] initWithCapacity:10];
		[self setNeedsDisplay];
	}
}

//撤销
-(void)RemoveLine
{
	if ([self.myallline count]>0)
	{
		[self.myallline  removeLastObject];
		[self.myallColor removeLastObject];
		[self.myallwidth removeLastObject];
		[self.myallpoint removeAllObjects];
	}
	[self setNeedsDisplay];
}

@end
