//
//  TPSinaWeiboAccount.m
//  TPSinaWeiboSDK
//
//  Created by yan simon on 13-9-12.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "TPSinaWeiboAccount.h"

#define kTPSinaWeiboEngineAuthDataKey          @"kTPSinaWeiboEngineAuthDataKey"
#define kTPSinaWeiboEngineAccessTokenKey       @"kTPSinaWeiboEngineAccessTokenKey"
#define kTPSinaWeiboEngineUserIDKey            @"kTPSinaWeiboEngineUserIDKey"
#define kTPSinaWeiboEngineExpirationDateKey    @"kTPSinaWeiboEngineExpirationDateKey"
#define kTPSinaWeiboEngineRefreshTokenKey      @"kTPSinaWeiboEngineRefreshTokenKey"


@implementation TPSinaWeiboAccount

static TPSinaWeiboAccount * account = nil;

+(id)sharedInstance
{
    if (!account) {
        account = [[TPSinaWeiboAccount alloc] init];
    }
    return account;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self readAutuDataFromUserDefault];
    }
    return self;
}

- (void)removeAuthDataFromUserDefaults
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kTPSinaWeiboEngineAuthDataKey];
}

- (void)storeAuthDataToUserDefaults
{
    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                              self.accessToken, kTPSinaWeiboEngineAccessTokenKey,
                              self.expirationDate, kTPSinaWeiboEngineExpirationDateKey,
                              self.userID, kTPSinaWeiboEngineUserIDKey,
                              self.refreshToken, kTPSinaWeiboEngineRefreshTokenKey, nil];
    
    [[NSUserDefaults standardUserDefaults] setObject:authData forKey:kTPSinaWeiboEngineAuthDataKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)readAutuDataFromUserDefault;
{
    // 读取存储的账号登录信息 ( weak login )
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *sinaweiboInfo = [defaults objectForKey:kTPSinaWeiboEngineAuthDataKey];
    if ([sinaweiboInfo objectForKey:kTPSinaWeiboEngineAccessTokenKey] && [sinaweiboInfo objectForKey:kTPSinaWeiboEngineExpirationDateKey] && [sinaweiboInfo objectForKey:kTPSinaWeiboEngineUserIDKey])
    {
        self.accessToken = [sinaweiboInfo objectForKey:kTPSinaWeiboEngineAccessTokenKey];
        self.expirationDate = [sinaweiboInfo objectForKey:kTPSinaWeiboEngineExpirationDateKey];
        self.userID = [sinaweiboInfo objectForKey:kTPSinaWeiboEngineUserIDKey];
    }
}
@end
