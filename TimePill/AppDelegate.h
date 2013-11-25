//
//  AppDelegate.h
//  TimePill
//
//  Created by simon on 13-9-15.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPRevealViewController.h"
#import "TPLeftMenuViewController.h"
#import "TPRightMenuViewController.h"
#import "TPTimelineViewController.h"
#import "TPNavigationViewController.h"
#import "TPNewFeatherViewController.h"

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) TPRevealViewController *viewController;

@end
