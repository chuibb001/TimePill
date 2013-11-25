//
//  TPNetworkManager.m
//  TPSinaWeiboSDK
//
//  Created by simon on 13-9-7.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "TPNetworkManager.h"

@implementation TPNetworkManager

static TPNetworkManager * networkManager = nil;

static TPWeiboRequestID requestID = 0;

+(id)sharedInstance
{
    if (!networkManager) {
        networkManager = [[TPNetworkManager alloc] init];
    }
    return networkManager;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.requestDic = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(TPWeiboRequestID)requestWithURL:(NSString *)urlString httpMethod:(NSString *)httpMethod params:(NSDictionary *)params completionHandler:(TPNetworkManagerHandler)handler
{
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    if([httpMethod isEqualToString:@"POST"])
    {
        for(NSString *key in [params allKeys]) // 设置参数
        {
            if([[params objectForKey:key] isKindOfClass:[NSString class]])
                [request setPostValue:[params objectForKey:key] forKey:key];
            else    // raw data
            {
                UIImage *image = [params objectForKey:key];
                NSData *data = UIImageJPEGRepresentation(image, 1.0);
                [request setData:data forKey:key];
            }
        }
        
    }
    
    [request setRequestMethod:httpMethod];
    
    request.userInfo = [[NSMutableDictionary alloc] init];
    [request.userInfo setValue:[NSString stringWithFormat:@"requestID_%d",requestID] forKey:@"requestID"];
    
    __weak ASIFormDataRequest *weakRequest = request; // 防止cycle
    
    // 回调block
    [request setCompletionBlock:^{
    
        NSData *responseData = [weakRequest responseData];
        int statusCode = [weakRequest responseStatusCode];
        handler(responseData,statusCode);
        // remove from cache
        NSString *requestID = [weakRequest.userInfo valueForKey:@"requestID"];
        [self.requestDic removeObjectForKey:requestID];
    }];
    
    [request setFailedBlock:^{
        int statusCode = [weakRequest responseStatusCode];
        handler(nil,statusCode);
        // remove from cache
        NSString *requestID = [weakRequest.userInfo valueForKey:@"requestID"];
        [self.requestDic removeObjectForKey:requestID];
    }];
    
    // cache request object
    [self.requestDic setObject:request forKey:[NSString stringWithFormat:@"requestID_%d",requestID]];
     
    // 发起异步请求
    [request startAsynchronous];

    return requestID ++;
}

-(void)cancelRequestWithID:(TPWeiboRequestID)requestID
{
    id request = [self.requestDic valueForKey:[NSString stringWithFormat:@"requestID_%d",requestID]];
    if(request)
    {
        ASIHTTPRequest *ASIRequest = (ASIHTTPRequest *)request;
        [ASIRequest clearDelegatesAndCancel];
    }
}

@end
