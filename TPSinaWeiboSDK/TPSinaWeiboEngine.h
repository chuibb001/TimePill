//
//  TPSinaWeiboEngine.h
//  TPSinaWeiboSDK

//  对外接口

//  Created by simon on 13-9-7.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TPSinaWeiboAccountService.h"
#import "TPSinaWeiboRequestFactory.h"

@interface TPSinaWeiboEngine : NSObject

@property (nonatomic, strong) TPSinaWeiboAccountService *accountServeice;

@property (nonatomic, strong) NSString *const TPSinaWeiboEngineLoginDidSuccessNotification;

/**
 *  @brief 单例
 */
+ (id)sharedInstance;

/**
 *  @brief 登陆接口,会调用本地新浪微博客户端或网页进行授权
 */
- (void)Login;

/**
 *  @brief 登出接口,会清空本地存储的账户信息
 */
- (void)Logout;

/**
 *  @brief 返回是否登录
 */
- (BOOL)isLogon;

/**
 *  @brief 请求用户信息
 *  @param uid:要请求的用户ID
 */
- (TPWeiboRequestID)requestUserInfoWithUID:(NSString *)uid;

/**
 *  @brief 请求用户微博
 *  @param uid:需要查询的用户ID
 *  @param count:单页返回的记录条数
 *  @param page:返回结果的页码
 *  @param sinceId:返回ID比since_id大的微博
 *  @param trimUser:返回值中user字段开关,0:返回完整user字段 1:user字段仅返回user_id
 */
- (TPWeiboRequestID)requestUserTimelineWithUID:(NSString *)uid Count:(NSString *)count Page:(NSString *)page SinceId:(NSString *)sinceId trimUSer:(NSString *)trimUser;

/**
 *  @brief 请求用户微博
 *  @param uid:需要查询的用户ID
 *  @param count:单页返回的记录条数
 *  @param cursor:返回结果的游标
 *  @param trimStatus:返回值中user字段中的status字段开关,0:返回完整status字段 1：status字段仅返回status_id,默认为1。
 */
- (TPWeiboRequestID)requestFriendsWithUID:(NSString *)uid Count:(NSString *)count Cursor:(NSString *)cursor trimStatus:(NSString *)trimStatus;

/**
 *  @brief 请求用户微博
 *  @param weiboId:需要查询的微博ID
 *  @param count:单页返回的记录条数
 *  @param page:返回结果的页码
 */
- (TPWeiboRequestID)requestCommentsWithWeiboId:(NSString *)weiboId Count:(NSString *)count Page:(NSString *)page;

/**
 *  @brief 请求用户微博
 *  @param text:要发布的微博文本内容
 *  @param latitude:经度
 *  @param longitude:纬度
 */
- (TPWeiboRequestID)postStatusWithText:(NSString *)text Latitude:(NSString *)latitude Longitude:(NSString *)longitude;

/**
 *  @brief 请求用户微博
 *  @param text:要发布的微博文本内容
 *  @param latitude:经度
 *  @param longitude:纬度
 *  @param image:要发布的照片
 */
- (TPWeiboRequestID)postImageStatusWithText:(NSString *)text Latitude:(NSString *)latitude Longitude:(NSString *)longitude Image:(UIImage *)image;


@end
