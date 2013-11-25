//
//  TPSettingViewController.h
//  TimePill
//
//  Created by yan simon on 13-9-18.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPLoginViewController.h"
#import "TPNavigationViewController.h"
#import "TPRevealViewController.h"
#import "TPAboutUsViewController.h"
#import "TPSinaWeiboEngine.h"

typedef enum {
    TPSettingTypeAccount,
    TPSettingTypeVersion,
    TPSettingTypeRecommend,
    TPSettingTypeFeedback,
    TPSettingCount
}TPSettingType;

@interface TPSettingViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *settingTableView;

@end
