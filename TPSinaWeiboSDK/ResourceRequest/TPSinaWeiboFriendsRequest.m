//
//  TPSinaWeiboFriendsRequest.m
//  TPSinaWeiboSDK
//
//  Created by yan simon on 13-9-9.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "TPSinaWeiboFriendsRequest.h"

@implementation TPSinaWeiboFriendsRequest

- (id)init
{
    self = [super init];
    if (self) {
        self.httpMethod = @"GET";
        self.urlPostfix = @"friendships/friends.json";
        self.uid = ((TPSinaWeiboAccount *)[TPSinaWeiboAccount sharedInstance]).userID; // 默认当前用户
        self.count = @"50"; // 默认50条
        self.cursor = @"0"; // 默认第1页
        self.trimStatus = @"1";
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
    
    if(self.cursor)
        [self.params setObject:self.cursor forKey:@"cursor"];
    
    if(self.trimStatus)
        [self.params setObject:self.trimStatus forKey:@"trim_status"];
}

-(id)decodeResponseJsonObject:(NSData *)jsonObject
{
    // 解析JSON
    NSError *error = nil;
    NSMutableDictionary *responsedic = [NSJSONSerialization JSONObjectWithData:jsonObject options:NSJSONReadingMutableContainers error:&error];
    
    return responsedic;
}

-(void)postNotificationWithError:(NSError *)error ResponseData:(id)responseData
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kTPSinaWeiboEngineFriendsNotification object:@{kTPSinaWeiboEngineErrorCodeKey:error,kTPSinaWeiboEngineResponseDataKey:responseData} userInfo:nil];
}

@end
