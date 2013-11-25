//
//  TPSinaWeiboRequestFactory.m
//  TPSinaWeiboSDK
//
//  Created by yan simon on 13-9-9.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "TPSinaWeiboRequestFactory.h"

@implementation TPSinaWeiboRequestFactory

+(TPSinaWeiboRequest *)requestWithType:(TPSinaWeiboRequestType)type
{
    TPSinaWeiboRequest *request = nil;
    switch (type) {
        case TPSinaWeiboRequestTypeUserInfo:
            request = [[TPSinaWeiboUserInfoRequest alloc] init];
            break;
        case TPSinaWeiboRequestTypeUserTimeline:
            request = [[TPSinaWeiboUserTimelineRequest alloc] init];
            break;
        case TPSinaWeiboRequestTypeFriends:
            request = [[TPSinaWeiboFriendsRequest alloc] init];
            break;
        case TPSinaWeiboRequestTypeComments:
            request = [[TPSinaWeiboCommentsRequest alloc] init];
            break;
        case TPSinaWeiboRequestTypeUpdateStatus:
            request = [[TPSinaWeiboUpdateStatusRequest alloc] init];
            break;
        case TPSinaWeiboRequestTypeUploadStatus:
            request = [[TPSinaWeiboUploadStatusRequest alloc] init];
            break;
        default:
            break;
    }
    
    return request;
}

@end
