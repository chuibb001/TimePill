//
//  TPLoginViewController.h
//  TimePill
//
//  Created by simon on 13-10-7.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPTheme.h"
#import "TPSinaWeiboEngine.h"
#import "SVProgressHUD.h"

typedef void(^TPLoginViewControllerReturnHandler)(void);

@interface TPLoginViewController : UIViewController

@property (nonatomic ,strong) UIButton *loginButton;
@property (nonatomic ,strong) UIButton *logoutButton;
@property (nonatomic ,strong) TPLoginViewControllerReturnHandler handler;

@end
