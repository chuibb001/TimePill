//
//  TPSinaWeiboUploadStatusRequest.m
//  TPSinaWeiboSDK
//
//  Created by yan simon on 13-9-9.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "TPSinaWeiboUploadStatusRequest.h"

@implementation TPSinaWeiboUploadStatusRequest

- (id)init
{
    self = [super init];
    if (self) {
        self.httpMethod = @"POST";
        self.urlPostfix = @"statuses/upload.json";
        self.status = @"test";
        self.image = [UIImage imageNamed:@"testImage.png"];
        self.latitude = nil;
        self.longitude = nil;
        [self setupDefaultParams];
    }
    return self;
}

-(void)setupDefaultParams
{
    if(self.accessToken)
        [self.params setObject:self.accessToken forKey:@"access_token"];
    
    if(self.status)
        [self.params setObject:self.status forKey:@"status"];
    
    if(self.latitude)
        [self.params setObject:self.latitude forKey:@"lat"];
    
    if(self.longitude)
        [self.params setObject:self.longitude forKey:@"long"];
    
    if(self.image)
        [self.params setObject:self.image forKey:@"pic"];
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
    [[NSNotificationCenter defaultCenter] postNotificationName:kTPSinaWeiboEngineUploadStatusNotification object:@{kTPSinaWeiboEngineErrorCodeKey:error,kTPSinaWeiboEngineResponseDataKey:responseData} userInfo:nil];
}

@end
