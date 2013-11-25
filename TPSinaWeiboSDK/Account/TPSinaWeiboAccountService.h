//
//  TPSinaWeiboAccountService.h
//  TPSinaWeiboSDK

//  负责登陆登出的授权流程

//  Created by simon on 13-9-7.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TPSinaWeiboCommonFuction.h"
#import "TPSinaWeiboConst.h"
#import "SinaWeiboAuthorizeView.h"
#import "TPNetworkManager.h"
#import "TPSinaWeiboAccount.h"

typedef enum
{
    TPSinaWeiboAccountLoginDidSuccess = 0,
    TPSinaWeiboAccountLoginDidFail
}
TPSinaWeiboAccountStatus;

@interface TPSinaWeiboAccountService : NSObject<SinaWeiboAuthorizeViewDelegate>

@property (nonatomic, strong) TPSinaWeiboAccount *account;
@property (nonatomic, strong) NSString *ssoCallbackScheme;
@property (nonatomic, strong) NSString *appKey;
@property (nonatomic, strong) NSString *appSecret;
@property (nonatomic, strong) NSString *appRedirectURI;
@property (nonatomic, assign) BOOL  ssoLoggingIn;

+(id)sharedInstance;
-(void)Login;
-(void)Logout;
- (BOOL)handleOpenURL:(NSURL *)url;
- (BOOL)isAuthValid;

@end
