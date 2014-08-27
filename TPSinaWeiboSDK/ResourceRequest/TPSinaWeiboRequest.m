//
//  TPSinaWeiboRequest.m
//  TPSinaWeiboSDK
//
//  Created by simon on 13-9-7.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "TPSinaWeiboRequest.h"

@implementation TPSinaWeiboRequest

- (id)init
{
    self = [super init];
    if (self) {
        self.accessToken = ((TPSinaWeiboAccount *)[TPSinaWeiboAccount sharedInstance]).accessToken;
        self.httpMethod = @"POST";
        self.urlPostfix = nil;
        self.isRequestCanceled = NO;
        self.params = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(TPWeiboRequestID)request
{
    // 请求数据
    TPWeiboRequestID weiboID = [[TPNetworkManager sharedInstance] requestWithPostFix:self.urlPostfix httpMethod:self.httpMethod params:[self params] completionHandler:^(NSData *responseData,int httpStatusCode)
     {
         if(!self.isRequestCanceled)  // 如果取消了就不发通知了
         {
             NSError *error = [NSError errorWithDomain:TPHttpErrorCodeDomain code:httpStatusCode userInfo:nil];
             id decodedResponseData = nil;
             
             if(httpStatusCode == 200)
             {
                 decodedResponseData = responseData;
              }
             else
             {
                 decodedResponseData = [[NSDictionary alloc] init]; // 先搞个空的吧，避免insert nil
             }
             
             [self postNotificationWithError:error ResponseData:decodedResponseData];
         }
         
     }];
    return weiboID;
}

-(void)cancel  // 目前采取不接数据的方式
{
    self.isRequestCanceled = YES;
}

#pragma mark subClassHooks
-(NSDictionary *)requestParamsDictionary
{
    return nil;
}

-(id)decodeResponseJsonObject:(NSData *)jsonObject
{
    return nil;
}

-(void)postNotificationWithError:(NSError *)error ResponseData:(id)responseData
{
    
}

@end
