//
//  TPDiaryDataModel.h
//  TimePill
//
//  Created by simon on 13-9-19.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TPWeiboTextParser.h"
#import "TPWeiboDataModel.h"

@interface TPDiaryDataModel : NSObject<NSCoding>

@property (nonatomic,strong) NSString *rawText;
@property (nonatomic,strong) UIImage *image;
@property (nonatomic,strong) NSDate *date;
@property (nonatomic,strong) NSString *locationString;

// UI数据
@property (nonatomic,assign) CGSize textSize;
@property (nonatomic,assign) CGSize imageSize;
@property (nonatomic,assign) CGFloat rowHeight;

@property (nonatomic,strong) TPWeiboTextParser *parser;

-(void)setupUIData;

@end
