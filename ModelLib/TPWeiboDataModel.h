//
//  TPWeiboDataModel.h
//  TPSinaWeiboSDK

//  时光胶囊关心的字段

//  Created by yan simon on 13-9-12.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TPWeiboTextParser.h"
#import "TPImageDownloader.h"
#import "TPCommentDataModel.h"

#define kDefaultTextFont        [UIFont systemFontOfSize:16.0]
#define kDefaultRepostTextFont  [UIFont systemFontOfSize:15.0]
#define kDefaultTextSize        CGSizeMake(285.0, 100.0)
#define kDefaultRepostTextSize  CGSizeMake(268.0, 100.0)
#define kDefaultImageSize       CGSizeMake(100.0, 100.0)
#define kDefaultImageHeight     100.0
#define kTimelineTextSize        CGSizeMake(250.0, 100.0)
#define kTimelineRepostTextSize  CGSizeMake(230.0, 100.0)

typedef enum
{
    TPWeiboDataTypeText,                    // 原创文字
    TPWeiboDataTypeTextWithImage,           // 原创文字+图片
    TPWeiboDataTypeRepostText,              // 转发文字
    TPWeiboDataTypeRepostTextWithImage      // 转发文字+图片
}
TPWeiboDataType;

typedef enum
{
    TPWeiboDataUserTypeMine,                 // 我的微博
    TPWeiboDataUserTypeOther                 // 朋友微博
}
TPWeiboDataUserType;

/*-----------------------------------
            微博数据模型
 ------------------------------------*/
@interface TPWeiboDataModel : NSObject<NSCoding>

@property (nonatomic,strong) NSString *weiboId;
@property (nonatomic,strong) NSString *userName;
@property (nonatomic,strong) NSString *repostUserName;
@property (nonatomic,strong) NSDate *time;
@property (nonatomic,strong) NSString *rawText;
@property (nonatomic,strong) NSString *rawRepostText;
@property (nonatomic,strong) NSString *thumbnailImageURL;
@property (nonatomic,strong) NSString *bmiddleImageURL;
@property (nonatomic,strong) NSString *originalImageURL;
@property (nonatomic,strong) UIImage  *thumbnailImage;  
@property (nonatomic,strong) NSArray  *commentArray;

// UI数据
@property (nonatomic,assign) CGSize textSize;
@property (nonatomic,assign) CGSize repostTextSize;
@property (nonatomic,assign) CGSize imageSize;
@property (nonatomic,assign) TPWeiboDataType type;
@property (nonatomic,assign) TPWeiboDataUserType userType;
@property (nonatomic,assign) CGFloat rowHeight;
@property (nonatomic,assign) CGFloat commentTableViewHeight;
@property (nonatomic,assign) BOOL isSelected;

@property (nonatomic,strong) TPWeiboTextParser *parser;

-(id)initWithDictionary:(NSDictionary *)dic;

-(void)computeNewSize;   // 计算适合首页显示的UI数据

-(void)computeNewCommenTableViewSize;  // 计算更新评论后的UI数据

@end
