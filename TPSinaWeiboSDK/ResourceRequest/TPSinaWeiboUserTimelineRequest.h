//
//  TPSinaWeiboUserTimelineRequest.h
//  TPSinaWeiboSDK
//
//  Created by yan simon on 13-9-9.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "TPSinaWeiboRequest.h"

@interface TPSinaWeiboUserTimelineRequest : TPSinaWeiboRequest

@property (nonatomic,strong) NSString *uid;
@property (nonatomic,strong) NSString *page;
@property (nonatomic,strong) NSString *count;
@property (nonatomic,strong) NSString *sinceId;
@property (nonatomic,strong) NSString *trimUser;

@end
