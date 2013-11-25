//
//  TPSinaWeiboCommentsRequest.h
//  TPSinaWeiboSDK
//
//  Created by yan simon on 13-9-9.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "TPSinaWeiboRequest.h"

@interface TPSinaWeiboCommentsRequest : TPSinaWeiboRequest

@property (nonatomic,strong) NSString *weiboId;
@property (nonatomic,strong) NSString *count;
@property (nonatomic,strong) NSString *page;

@end
