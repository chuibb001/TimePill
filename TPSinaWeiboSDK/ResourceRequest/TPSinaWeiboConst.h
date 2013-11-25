//
//  TPSinaWeiboConst.h
//  TPSinaWeiboSDK
//
//  Created by simon on 13-9-7.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#define kAppKey             @"1213792051"
#define kAppSecret          @"4fc6b43b7a6b7dd69aecf26204f7ff96"
#define kAppRedirectURI     @"https://api.weibo.com/oauth2/default.html"

#ifndef kAppKey
#error
#endif

#ifndef kAppSecret
#error
#endif

#ifndef kAppRedirectURI
#error
#endif

#ifndef sinaweibo_ios_sdk_SinaWeiboConstants_h
#define sinaweibo_ios_sdk_SinaWeiboConstants_h

#define SinaWeiboSdkVersion                @"2.0"

#define kSinaWeiboSDKErrorDomain           @"SinaWeiboSDKErrorDomain"
#define kSinaWeiboSDKErrorCodeKey          @"SinaWeiboSDKErrorCodeKey"

#define kSinaWeiboSDKAPIDomain             @"https://open.weibo.cn/2/"
#define kSinaWeiboSDKOAuth2APIDomain       @"https://open.weibo.cn/2/oauth2/"
#define kSinaWeiboWebAuthURL               @"https://open.weibo.cn/2/oauth2/authorize"
#define kSinaWeiboWebAccessTokenURL        @"https://open.weibo.cn/2/oauth2/access_token"

#define kSinaWeiboAppAuthURL_iPhone        @"sinaweibosso://login"
#define kSinaWeiboAppAuthURL_iPad          @"sinaweibohdsso://login"
#endif

typedef enum
{
	kSinaWeiboSDKErrorCodeParseError       = 200,
	kSinaWeiboSDKErrorCodeSSOParamsError   = 202,
} SinaWeiboSDKErrorCode;

extern NSString *const TPHttpErrorCodeDomain;


/*
 *   @brief 客户端接收相应通知获取数据
 */
extern NSString *const kTPSinaWeiboEngineErrorCodeKey;
extern NSString *const kTPSinaWeiboEngineResponseDataKey;
extern NSString *const kTPSinaWeiboEngineLoginDidSuccessNotification;
extern NSString *const kTPSinaWeiboEngineLoginDidFailNotification;
extern NSString *const kTPSinaWeiboEngineDidLogoutNotification;
extern NSString *const kTPSinaWeiboEngineUserInfoNotification;
extern NSString *const kTPSinaWeiboEngineUserTimelineNotification;
extern NSString *const kTPSinaWeiboEngineFriendsNotification;
extern NSString *const kTPSinaWeiboEngineCommentsNotification;
extern NSString *const kTPSinaWeiboEngineUpdateStatusNotification;
extern NSString *const kTPSinaWeiboEngineUploadStatusNotification;


