//
//  TPSinaWeiboAccountService.m
//  TPSinaWeiboSDK
//
//  Created by simon on 13-9-7.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "TPSinaWeiboAccountService.h"


@implementation TPSinaWeiboAccountService

static TPSinaWeiboAccountService * accountService = nil;

+(id)sharedInstance
{
    if (!accountService) {
        accountService = [[TPSinaWeiboAccountService alloc] init];
    }
    return accountService;
}
- (id)init
{
    self = [self initWithAppKey:kAppKey appSecret:kAppSecret appRedirectURI:kAppRedirectURI ssoCallbackScheme:nil];
    if (self) {
        self.account = [TPSinaWeiboAccount sharedInstance];
    }
    return self;
}
- (id)initWithAppKey:(NSString *)appKey appSecret:(NSString *)appSecrect
      appRedirectURI:(NSString *)appRedirectURI
   ssoCallbackScheme:(NSString *)ssoCallbackScheme
{
    if ((self = [super init]))
    {
        self.appKey = appKey;
        self.appSecret = appSecrect;
        self.appRedirectURI = appRedirectURI;
        
        if (!ssoCallbackScheme)
        {
            ssoCallbackScheme = [NSString stringWithFormat:@"sinaweibosso.%@://", self.appKey];
        }
        self.ssoCallbackScheme = ssoCallbackScheme;
        
    }
    
    return self;
}

#pragma mark - Validation
/*
   判断是否登录
*/
- (BOOL)isLoggedIn
{
    return self.account.userID && self.account.accessToken && self.account.expirationDate;
}

/*
   判断登录是否过期
*/
- (BOOL)isAuthorizeExpired
{
    NSDate *now = [NSDate date];
    return ([now compare:self.account.expirationDate] == NSOrderedDescending);
}

/*
   判断登录是否有效，当已登录并且登录未过期时为有效状态
*/
- (BOOL)isAuthValid
{
    return ([self isLoggedIn] && ![self isAuthorizeExpired]);
}

#pragma mark - LogIn / LogOut
/*
    登录入口
*/
- (void)Login
{
    if ([self isAuthValid])
    {
        return ;
    }
    
    [self removeAuthData];
    
    _ssoLoggingIn = NO;
    
//    // open sina weibo app
//    UIDevice *device = [UIDevice currentDevice];
//    if ([device respondsToSelector:@selector(isMultitaskingSupported)] &&
//        [device isMultitaskingSupported])
//    {
//        NSDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                self.appKey, @"client_id",
//                                self.appRedirectURI, @"redirect_uri",
//                                self.ssoCallbackScheme, @"callback_uri", nil];
//        
//        // 先用iPad微博打开
//        NSString *appAuthBaseURL = kSinaWeiboAppAuthURL_iPad;
//        if ([self SinaWeiboIsDeviceIPad])
//        {
//            NSString *appAuthURL = [TPSinaWeiboCommonFuction serializeURL:appAuthBaseURL
//                                                           params:params httpMethod:@"GET"];
//            _ssoLoggingIn = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appAuthURL]];
//        }
//        
//        // 在用iPhone微博打开
//        if (!_ssoLoggingIn)
//        {
//            appAuthBaseURL = kSinaWeiboAppAuthURL_iPhone;
//            NSString *appAuthURL = [TPSinaWeiboCommonFuction serializeURL:appAuthBaseURL
//                                                           params:params httpMethod:@"GET"];
//            _ssoLoggingIn = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appAuthURL]];
//            
//        }
//    }
    
    if (!_ssoLoggingIn)
    {
        // open authorize view
        
        NSDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                self.appKey, @"client_id",
                                @"code", @"response_type",
                                self.appRedirectURI, @"redirect_uri",
                                @"mobile", @"display", nil];
        
        SinaWeiboAuthorizeView *authorizeView = [[SinaWeiboAuthorizeView alloc] initWithAuthParams:params delegate:self];
        [authorizeView show];
    }
}

/*
   退出方法，需要退出时直接调用此方法
*/
- (void)Logout
{
    [self removeAuthData];
    [[NSNotificationCenter defaultCenter] postNotificationName:kTPSinaWeiboEngineDidLogoutNotification object:nil];
}

/*
   清空认证信息
*/
- (void)removeAuthData
{
    self.account.accessToken = nil;
    self.account.userID = nil;
    self.account.expirationDate = nil;
   
    // 清除WebView里的cookie
    NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray* sinaweiboCookies = [cookies cookiesForURL:
                                 [NSURL URLWithString:@"https://open.weibo.cn"]];
    
    for (NSHTTPCookie* cookie in sinaweiboCookies)
    {
        [cookies deleteCookie:cookie];
    }
    [self.account removeAuthDataFromUserDefaults];
}

#pragma mark - SinaWeiboAuthorizeView Delegate

- (void)authorizeView:(SinaWeiboAuthorizeView *)authView didRecieveAuthorizationCode:(NSString *)code
{
    [self requestAccessTokenWithAuthorizationCode:code];
}

- (void)authorizeView:(SinaWeiboAuthorizeView *)authView didFailWithErrorInfo:(NSDictionary *)errorInfo
{
    [self logInDidFailWithErrorInfo:errorInfo];
}

- (void)authorizeViewDidCancel:(SinaWeiboAuthorizeView *)authView
{
    //[self logInDidCancel];
}

#pragma mark private
- (void)requestAccessTokenWithAuthorizationCode:(NSString *)code
{
    NSDictionary *params = @{@"client_id":self.appKey,@"client_secret":self.appSecret,@"grant_type":@"authorization_code",@"redirect_uri":self.appRedirectURI,@"code":code};
    
    [[TPNetworkManager sharedInstance] requestWithURL:kSinaWeiboWebAccessTokenURL httpMethod:@"POST" params:params completionHandler:^(NSData *responseData,int httpStatusCode)
     {
         if(httpStatusCode == 200)
         {

             [self handleResponseData:responseData];
             
             [[NSNotificationCenter defaultCenter] postNotificationName:kTPSinaWeiboEngineLoginDidSuccessNotification object:nil];
             
         }
         else
         {
             [[NSNotificationCenter defaultCenter] postNotificationName:kTPSinaWeiboEngineLoginDidFailNotification object:nil];
             NSLog(@"请求accessToken失败");
         }
         
     }];
}

-(void) handleResponseData:(NSData *)responseData
{
    // 解析JSON
    NSError *error = nil;
    NSMutableDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
    
    NSString *access_token = [responseDic objectForKey:@"access_token"];
    NSString *uid = [responseDic objectForKey:@"uid"];
    NSString *remind_in = [responseDic objectForKey:@"remind_in"];
    NSString *refresh_token = [responseDic objectForKey:@"refresh_token"];
    if (access_token && uid)
    {
        if (remind_in != nil)
        {
            int expVal = [remind_in intValue];
            if (expVal == 0)
            {
                self.account.expirationDate = [NSDate distantFuture];
            }
            else
            {
                self.account.expirationDate = [NSDate dateWithTimeIntervalSinceNow:expVal];
            }
        }
        
        self.account.accessToken = access_token;
        self.account.userID = uid;
        self.account.refreshToken = refresh_token;
        
        [self.account storeAuthDataToUserDefaults];
    }
}

- (void)logInDidFailWithErrorInfo:(NSDictionary *)errorInfo
{
    NSString *error_code = [errorInfo objectForKey:@"error_code"];
    if ([error_code isEqualToString:@"21330"])
    {
        //[self logInDidCancel];
    }
    else
    {
        NSString *error_description = [errorInfo objectForKey:@"error_description"];
        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                  errorInfo, @"error",
                                  error_description, NSLocalizedDescriptionKey, nil];
        NSError *error = [NSError errorWithDomain:kSinaWeiboSDKErrorDomain
                                             code:[error_code intValue]
                                         userInfo:userInfo];
        
    }
}
/**
 * @description sso回调方法，官方客户端完成sso授权后，回调唤起应用，应用中应调用此方法完成sso登录
 * @param url: 官方客户端回调给应用时传回的参数，包含认证信息等
 * @return YES
 */
- (BOOL)handleOpenURL:(NSURL *)url
{
    NSString *urlString = [url absoluteString];
    if ([urlString hasPrefix:self.ssoCallbackScheme])
    {
        if (!_ssoLoggingIn)
        {
            // sso callback after user have manually opened the app
            // ignore the request
        }
        else
        {
            _ssoLoggingIn = NO;
            
            if ([TPSinaWeiboCommonFuction getParamValueFromUrl:urlString paramName:@"sso_error_user_cancelled"])
            {
                // 用户取消了授权
            }
            else if ([TPSinaWeiboCommonFuction getParamValueFromUrl:urlString paramName:@"sso_error_invalid_params"])
            {
                // 授权失败
                NSString *error_description = @"Invalid sso params";
                NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                          error_description, NSLocalizedDescriptionKey, nil];
                NSError *error = [NSError errorWithDomain:kSinaWeiboSDKErrorDomain
                                                     code:kSinaWeiboSDKErrorCodeSSOParamsError
                                                 userInfo:userInfo];
            }
            else if ([TPSinaWeiboCommonFuction getParamValueFromUrl:urlString paramName:@"error_code"])
            {
                NSString *error_code = [TPSinaWeiboCommonFuction getParamValueFromUrl:urlString paramName:@"error_code"];
                NSString *error = [TPSinaWeiboCommonFuction getParamValueFromUrl:urlString paramName:@"error"];
                NSString *error_uri = [TPSinaWeiboCommonFuction getParamValueFromUrl:urlString paramName:@"error_uri"];
                NSString *error_description = [TPSinaWeiboCommonFuction getParamValueFromUrl:urlString paramName:@"error_description"];
                
                NSDictionary *errorInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                           error, @"error",
                                           error_uri, @"error_uri",
                                           error_code, @"error_code",
                                           error_description, @"error_description", nil];
                            }
            else
            {
                NSString *access_token = [TPSinaWeiboCommonFuction getParamValueFromUrl:urlString paramName:@"access_token"];
                NSString *expires_in = [TPSinaWeiboCommonFuction getParamValueFromUrl:urlString paramName:@"expires_in"];
                NSString *remind_in = [TPSinaWeiboCommonFuction getParamValueFromUrl:urlString paramName:@"remind_in"];
                NSString *uid = [TPSinaWeiboCommonFuction getParamValueFromUrl:urlString paramName:@"uid"];
                NSString *refresh_token = [TPSinaWeiboCommonFuction getParamValueFromUrl:urlString paramName:@"refresh_token"];
                
                NSMutableDictionary *authInfo = [NSMutableDictionary dictionary];
                if (access_token) [authInfo setObject:access_token forKey:@"access_token"];
                if (expires_in) [authInfo setObject:expires_in forKey:@"expires_in"];
                if (remind_in) [authInfo setObject:remind_in forKey:@"remind_in"];
                if (refresh_token) [authInfo setObject:refresh_token forKey:@"refresh_token"];
                if (uid) [authInfo setObject:uid forKey:@"uid"];
                
                [self logInDidFinishWithAuthInfo:authInfo];
            }
        }
    }
    return YES;
}
- (void)logInDidFinishWithAuthInfo:(NSDictionary *)authInfo
{
    NSString *access_token = [authInfo objectForKey:@"access_token"];
    NSString *uid = [authInfo objectForKey:@"uid"];
    NSString *remind_in = [authInfo objectForKey:@"remind_in"];
    NSString *refresh_token = [authInfo objectForKey:@"refresh_token"];
    if (access_token && uid)
    {
        if (remind_in != nil)
        {
            int expVal = [remind_in intValue];
            if (expVal == 0)
            {
                self.account.expirationDate = [NSDate distantFuture];
            }
            else
            {
                self.account.expirationDate = [NSDate dateWithTimeIntervalSinceNow:expVal];
            }
        }
        
        self.account.accessToken = access_token;
        self.account.userID = uid;
        self.account.refreshToken = refresh_token;
        
        [self.account storeAuthDataToUserDefaults];
    }
}
- (BOOL) SinaWeiboIsDeviceIPad
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        return YES;
    }
#endif
    return NO;
}

@end
