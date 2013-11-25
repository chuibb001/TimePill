//
//  TPPalette.h
//  TimePill
//
//  Created by yan simon on 13-9-18.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPPalette : UIView

@property (nonatomic,assign) float x;
@property (nonatomic,assign) float y;

@property (nonatomic,assign) BOOL isFirst;
@property (nonatomic,assign) int Intsegmentcolor;
@property (nonatomic,assign) float Intsegmentwidth;
@property (nonatomic,strong) UIColor * segmentColor;

@property (nonatomic,strong) NSMutableArray* myallpoint;
@property (nonatomic,strong) NSMutableArray* myallline;
@property (nonatomic,strong) NSMutableArray* myallColor;
@property (nonatomic,strong) NSMutableArray* myallwidth;

-(void)initAllPoints;
-(void)addLines;
-(void)addPoints:(CGPoint)sender;
-(void)addColors:(int)sender;
-(void)addWidths:(int)sender;

-(void)clearAllLines;
-(void)RemoveLine;
@end
