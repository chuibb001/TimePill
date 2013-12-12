//
//  AppDelegate.m
//  TimePill
//
//  Created by simon on 13-9-15.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "AppDelegate.h"
#import "WXApi.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
     //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [TPRevealViewController sharedInstance];
    TPLeftMenuViewController *left = [[TPLeftMenuViewController alloc] init];
    TPRightMenuViewController *right = [[TPRightMenuViewController alloc] init];
    TPTimelineViewController *center = [[TPTimelineViewController alloc] init];
    left.timelineController = center;
    self.viewController.leftViewController = left;
    self.viewController.rightViewController = right;
    self.viewController.rootViewController = center;
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    BOOL first = [[NSUserDefaults standardUserDefaults] boolForKey:kTPUpgradeKey];
    if (!first) {
        // new feather
        TPNewFeatureViewController *new = [[TPNewFeatureViewController alloc] init];
        [new show];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kTPUpgradeKey];
    }
    
    [WXApi registerApp:@"wx7a462ae4bbc68095"];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [WXApi handleOpenURL:url delegate:self];
}

#pragma mark WXApiDelegate
-(void) onReq:(BaseReq*)req
{
    
}

-(void) onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]]) {
        int errorCode = resp.errCode;
        switch (errorCode) {
            case 0:
                [SVProgressHUD showSuccessWithStatus:@"分享成功"];
                break;
            default:
                [SVProgressHUD showSuccessWithStatus:@"分享失败"];
                break;
        }
    }
}
@end
