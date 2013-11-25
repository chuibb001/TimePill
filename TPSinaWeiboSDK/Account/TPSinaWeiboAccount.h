//
//  TPSinaWeiboAccount.h
//  TPSinaWeiboSDK

//  管理授权账户信息及其数据存储

//  Created by yan simon on 13-9-12.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TPSinaWeiboAccount : NSObject

@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSDate   *expirationDate;
@property (nonatomic, strong) NSString *refreshToken;


+ (id)sharedInstance;
- (void)removeAuthDataFromUserDefaults;
- (void)storeAuthDataToUserDefaults;
- (void)readAutuDataFromUserDefault;

@end
