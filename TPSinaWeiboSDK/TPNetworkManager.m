//
//  TPNetworkManager.m
//  TPSinaWeiboSDK
//
//  Created by simon on 13-9-7.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "TPNetworkManager.h"
#import "AFHTTPRequestOperationManager.h"

@interface TPNetworkManager ()

@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;

@end

@implementation TPNetworkManager

static TPNetworkManager * networkManager = nil;
static TPWeiboRequestID requestID = 0;
static NSString *baseURL = @"https://open.weibo.cn/2/";

+(id)sharedInstance
{
    if (!networkManager) {
        networkManager = [[TPNetworkManager alloc] initWithBaseURL:baseURL];
    }
    return networkManager;
}

- (id)initWithBaseURL:(NSString *)baseUrl
{
    self = [self init];
    if (self) {
        self.manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:baseUrl]];
    }
    return self;
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

- (TPWeiboRequestID)requestWithPostFix:(NSString *)postfix httpMethod:(NSString *)httpMethod params:(NSMutableDictionary *)params completionHandler:(TPNetworkManagerHandler)handler
{
    BOOL isUploadImage = NO;
    NSString *imageKey = nil;
    NSData *imageData = nil;
    for (NSString *key in [params allKeys]) // 碰到UIImage,转成NSData
    {
        if([[params objectForKey:key] isKindOfClass:[UIImage class]])
        {
            UIImage *image = [params objectForKey:key];
            imageData = UIImageJPEGRepresentation(image, 0.6);
            [params removeObjectForKey:key];
            isUploadImage = YES;
            imageKey = key;
        }
    }
    
    AFHTTPRequestOperation *op = nil;
    if ([httpMethod isEqualToString:@"POST"]) {
        if (isUploadImage) {
            op = [self.manager POST:postfix parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                  {
                      //
                      //[formData appendPartWithFormData:imageData name:imageKey];
                      [formData appendPartWithFileData:imageData name:imageKey fileName:imageKey mimeType:@"image/jpeg"];
                  }success:^(AFHTTPRequestOperation * operation,id responseObject)
                  {
                      int statusCode = operation.response.statusCode;
                      handler(responseObject,statusCode);
                      // remove from cache
                      NSString *requestID = [operation.userInfo valueForKey:@"requestID"];
                      [self.requestDic removeObjectForKey:requestID];
                  } failure:^(AFHTTPRequestOperation * operation, NSError *error)
                  {
                      int statusCode = operation.response.statusCode;
                      handler(nil,statusCode);
                      // remove from cache
                      NSString *requestID = [operation.userInfo valueForKey:@"requestID"];
                      [self.requestDic removeObjectForKey:requestID];
                  }];
        } else {
            op = [self.manager POST:postfix parameters:params success:^(AFHTTPRequestOperation * operation,id responseObject)
                  {
                      int statusCode = operation.response.statusCode;
                      handler(responseObject,statusCode);
                      // remove from cache
                      NSString *requestID = [operation.userInfo valueForKey:@"requestID"];
                      [self.requestDic removeObjectForKey:requestID];
                  }
                            failure:^(AFHTTPRequestOperation * operation, NSError *error)
                  {
                      int statusCode = operation.response.statusCode;
                      handler(nil,statusCode);
                      // remove from cache
                      NSString *requestID = [operation.userInfo valueForKey:@"requestID"];
                      [self.requestDic removeObjectForKey:requestID];
                  }];
        }
    }
    else if ([httpMethod isEqualToString:@"GET"])
    {
        op = [self.manager GET:postfix parameters:params success:^(AFHTTPRequestOperation * operation,id responseObject)
        {
            int statusCode = operation.response.statusCode;
            handler(responseObject,statusCode);
            // remove from cache
            NSString *requestID = [operation.userInfo valueForKey:@"requestID"];
            [self.requestDic removeObjectForKey:requestID];
        }
        failure:^(AFHTTPRequestOperation * operation, NSError *error)
        {
            int statusCode = operation.response.statusCode;
            handler(nil,statusCode);
            // remove from cache
            NSString *requestID = [operation.userInfo valueForKey:@"requestID"];
            [self.requestDic removeObjectForKey:requestID];
        }];
    }
    
    op.userInfo = [[NSMutableDictionary alloc] init];
    [op.userInfo setValue:[NSString stringWithFormat:@"requestID_%d",requestID] forKey:@"requestID"];
    
    [self.requestDic setObject:op forKey:[NSString stringWithFormat:@"requestID_%d",requestID]];
    
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
