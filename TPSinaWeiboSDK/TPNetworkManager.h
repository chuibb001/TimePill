//
//  TPNetworkManager.h
//  TPSinaWeiboSDK
//
//  Created by simon on 13-9-7.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

typedef void(^TPNetworkManagerHandler)(NSData *responseData,int httpStatusCode);

typedef int TPWeiboRequestID ;  // 标识一个ASIRequest & WeiboRequest

@interface TPNetworkManager : NSObject

@property (nonatomic,strong) NSMutableDictionary *requestDic;

+ (id)sharedInstance;
- (id)initWithBaseURL:(NSString *)baseUrl;
- (TPWeiboRequestID)requestWithURL:(NSString *)urlString httpMethod:(NSString *)httpMethod params:(NSDictionary *)params completionHandler:(TPNetworkManagerHandler)handler;
- (TPWeiboRequestID)requestWithPostFix:(NSString *)postfix httpMethod:(NSString *)httpMethod params:(NSMutableDictionary *)params completionHandler:(TPNetworkManagerHandler)handler;
- (void)cancelRequestWithID:(TPWeiboRequestID)requestID;

@end
