//
//  TPCommentDataModel.h
//  TimePill
//
//  Created by simon on 13-9-19.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TPWeiboTextParser.h"
#import "TPImageDownloadCenter.h"

#define kDefaultCommentTextSize CGSizeMake(245, 100.0f)
#define kDefaultCommentTextFont [UIFont systemFontOfSize:16.0]
#define kTimelineCommentTextSize CGSizeMake(143.0, 100.0)
#define kTimelineCommentTextFont [UIFont systemFontOfSize:14.0]

@interface TPCommentDataModel : NSObject<NSCoding>

@property (nonatomic, strong) NSString *commentId;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *profileImageURL;
@property (nonatomic, strong) NSString *rawText;
@property (nonatomic, assign) CGSize textSize;
@property (nonatomic, assign) CGFloat rowHeight;
@property (nonatomic, assign) BOOL isSelected;

@property (nonatomic, strong) TPWeiboTextParser *parser;

-(id)initWithDictionary:(NSDictionary *)dic;

-(void)computeNewSize;   // 计算适合首页显示的UI数据

@end
