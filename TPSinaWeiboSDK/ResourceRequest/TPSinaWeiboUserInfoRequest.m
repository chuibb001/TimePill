//
//  TPSinaWeiboUserInfoRequest.m
//  TPSinaWeiboSDK
//
//  Created by simon on 13-9-8.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "TPSinaWeiboUserInfoRequest.h"

@implementation TPSinaWeiboUserInfoRequest

- (id)init
{
    self = [super init];
    if (self) {
        self.httpMethod = @"GET";
        self.urlPostfix = @"users/show.json";
        self.uid = ((TPSinaWeiboAccount *)[TPSinaWeiboAccount sharedInstance]).userID; //默认当前用户
        [self setupDefaultParams];
    }
    return self;
}

-(void)setupDefaultParams
{
    if(self.accessToken)
        [self.params setObject:self.accessToken forKey:@"access_token"];
    
    if(self.uid)
        [self.params setObject:self.uid forKey:@"uid"];
}

-(id)decodeResponseJsonObject:(NSData *)jsonObject
{
    // 解析JSON
    NSError *error = nil;
    NSMutableDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:jsonObject options:NSJSONReadingMutableContainers error:&error];
    
    return responseDic;
}

-(void)postNotificationWithError:(NSError *)error ResponseData:(id)responseData
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kTPSinaWeiboEngineUserInfoNotification object:@{kTPSinaWeiboEngineErrorCodeKey:error,kTPSinaWeiboEngineResponseDataKey:responseData} userInfo:nil];
}

@end
