//
//  TPSinaWeiboUpdateStatusRequest.h
//  TPSinaWeiboSDK
//
//  Created by yan simon on 13-9-9.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "TPSinaWeiboRequest.h"

@interface TPSinaWeiboUpdateStatusRequest : TPSinaWeiboRequest

@property (nonatomic,strong) NSString *status;
@property (nonatomic,strong) NSString *latitude;
@property (nonatomic,strong) NSString *longitude;

@end
