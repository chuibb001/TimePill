//
//  TPSinaWeiboEngine.m
//  TPSinaWeiboSDK
//
//  Created by simon on 13-9-7.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "TPSinaWeiboEngine.h"

@implementation TPSinaWeiboEngine

static TPSinaWeiboEngine *instance = nil;

#pragma mark init
+(id)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(!instance)
        {
            instance = [[TPSinaWeiboEngine alloc] init];
        }
    });
    return instance;
}
- (id)init
{
    self = [super init];
    if (self) {
        self.accountServeice = [TPSinaWeiboAccountService sharedInstance];
    }
    return self;
}
- (void)Login
{
    [self.accountServeice Login];
}
- (void)Logout
{
    [self.accountServeice Logout];
}
- (BOOL)isLogon
{
    return [self.accountServeice isAuthValid];
}

- (TPWeiboRequestID)requestUserInfoWithUID:(NSString *)uid
{
    TPSinaWeiboRequest * request = [TPSinaWeiboRequestFactory requestWithType:TPSinaWeiboRequestTypeUserInfo];
    
    if(uid)
       [request.params setObject:uid forKey:@"uid"];
    
    return [request request];
}

- (TPWeiboRequestID)requestUserTimelineWithUID:(NSString *)uid Count:(NSString *)count Page:(NSString *)page SinceId:(NSString *)sinceId trimUSer:(NSString *)trimUser
{
    TPSinaWeiboRequest * request = [TPSinaWeiboRequestFactory requestWithType:TPSinaWeiboRequestTypeUserTimeline];
    
    if(uid)
        [request.params setObject:uid forKey:@"uid"];
    
    if(count)
        [request.params setObject:count forKey:@"count"];
    
    if(page)
        [request.params setObject:page forKey:@"page"];
    
    if(sinceId)
        [request.params setObject:sinceId forKey:@"since_id"];
    
    if(trimUser)
        [request.params setObject:trimUser forKey:@"trim_user"];
    
    return [request request];
}

- (TPWeiboRequestID)requestFriendsWithUID:(NSString *)uid Count:(NSString *)count Cursor:(NSString *)cursor trimStatus:(NSString *)trimStatus
{
    TPSinaWeiboRequest * request = [TPSinaWeiboRequestFactory requestWithType:TPSinaWeiboRequestTypeFriends];
    
    if(uid)
        [request.params setObject:uid forKey:@"uid"];
    
    if(count)
        [request.params setObject:count forKey:@"count"];
    
    if(cursor)
        [request.params setObject:cursor forKey:@"cursor"];
    
    if(trimStatus)
        [request.params setObject:trimStatus forKey:@"trim_status"];
    
    return [request request];
}

- (TPWeiboRequestID)requestCommentsWithWeiboId:(NSString *)weiboId Count:(NSString *)count Page:(NSString *)page
{
    TPSinaWeiboRequest * request = [TPSinaWeiboRequestFactory requestWithType:TPSinaWeiboRequestTypeComments];
    
    if(weiboId)
        [request.params setObject:weiboId forKey:@"id"];
    
    if(count)
        [request.params setObject:count forKey:@"count"];
    
    if(page)
        [request.params setObject:page forKey:@"page"];
    
    return [request request];
}

- (TPWeiboRequestID)postStatusWithText:(NSString *)text Latitude:(NSString *)latitude Longitude:(NSString *)longitude
{
    TPSinaWeiboRequest * request = [TPSinaWeiboRequestFactory requestWithType:TPSinaWeiboRequestTypeUpdateStatus];
    
    if(text)
        [request.params setObject:text forKey:@"status"];
    
    if(latitude)
        [request.params setObject:latitude forKey:@"lat"];
    
    if(longitude)
        [request.params setObject:longitude forKey:@"long"];
    
    return [request request];
}

- (TPWeiboRequestID)postImageStatusWithText:(NSString *)text Latitude:(NSString *)latitude Longitude:(NSString *)longitude Image:(UIImage *)image
{
    TPSinaWeiboRequest * request = [TPSinaWeiboRequestFactory requestWithType:TPSinaWeiboRequestTypeUploadStatus];
    
    if(text)
        [request.params setObject:text forKey:@"status"];
    
    if(latitude)
        [request.params setObject:latitude forKey:@"lat"];
    
    if(longitude)
        [request.params setObject:longitude forKey:@"long"];
    
    if(image)
        [request.params setObject:image forKey:@"pic"];
    
    return [request request];
}
@end
