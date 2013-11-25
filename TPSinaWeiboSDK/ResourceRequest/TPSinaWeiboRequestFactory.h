//
//  TPSinaWeiboRequestFactory.h
//  TPSinaWeiboSDK
//
//  Created by yan simon on 13-9-9.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TPSinaWeiboRequest.h"
#import "TPSinaWeiboUserInfoRequest.h"
#import "TPSinaWeiboUserTimelineRequest.h"
#import "TPSinaWeiboUpdateStatusRequest.h"
#import "TPSinaWeiboUploadStatusRequest.h"
#import "TPSinaWeiboFriendsRequest.h"
#import "TPSinaWeiboCommentsRequest.h"

typedef enum
{
    TPSinaWeiboRequestTypeUserInfo,         // 获取个人信息
    TPSinaWeiboRequestTypeUserTimeline,     // 获取用户微博
    TPSinaWeiboRequestTypeFriends,          // 获取用户关注列表
    TPSinaWeiboRequestTypeComments,         // 获取一条微博的评论列表
    TPSinaWeiboRequestTypeUpdateStatus,     // 发布一条微博
    TPSinaWeiboRequestTypeUploadStatus,     // 发布一条图片微博
}
TPSinaWeiboRequestType;

@interface TPSinaWeiboRequestFactory : NSObject

+(TPSinaWeiboRequest *)requestWithType:(TPSinaWeiboRequestType)type;

@end
