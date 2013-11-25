//
//  TPSinaWeiboRequest.h
//  TPSinaWeiboSDK

//  请求对象的基类

//  Created by simon on 13-9-7.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TPSinaWeiboAccountService.h"

@interface TPSinaWeiboRequest : NSObject

// 以下三个是必填参数
@property (nonatomic,strong) NSString *accessToken;
@property (nonatomic,strong) NSString *urlPostfix;
@property (nonatomic,strong) NSString *httpMethod;
@property (nonatomic,strong) NSMutableDictionary *params;

@property (nonatomic,assign) BOOL isRequestCanceled;

-(TPWeiboRequestID)request;
-(void)cancel;

@end

// 子类实现
@interface TPSinaWeiboRequest(SubclassingHooks)

-(id)decodeResponseJsonObject:(NSData *)jsonObject;

-(void)postNotificationWithError:(NSError *)error ResponseData:(id)responseData;

@end