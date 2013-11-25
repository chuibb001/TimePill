//
//  TPSinaWeiboUserTimelineRequest.m
//  TPSinaWeiboSDK
//
//  Created by yan simon on 13-9-9.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "TPSinaWeiboUserTimelineRequest.h"

@implementation TPSinaWeiboUserTimelineRequest

- (id)init
{
    self = [super init];
    if (self) {
        self.httpMethod = @"GET";
        self.urlPostfix = @"statuses/user_timeline.json";
        self.uid = ((TPSinaWeiboAccount *)[TPSinaWeiboAccount sharedInstance]).userID; // 默认当前用户
        self.page = @"1"; // 默认第一页
        self.count = @"50"; // 默认每页50条
        self.trimUser = @"0";
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
    
    if(self.count)
        [self.params setObject:self.count forKey:@"count"];
    
    if(self.page)
        [self.params setObject:self.page forKey:@"page"];
    
    if(self.sinceId)
        [self.params setObject:self.sinceId forKey:@"since_id"];
    
    if(self.trimUser)
        [self.params setObject:self.trimUser forKey:@"trim_user"];
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
    [[NSNotificationCenter defaultCenter] postNotificationName:kTPSinaWeiboEngineUserTimelineNotification object:@{kTPSinaWeiboEngineErrorCodeKey:error,kTPSinaWeiboEngineResponseDataKey:responseData} userInfo:nil];
}
@end
