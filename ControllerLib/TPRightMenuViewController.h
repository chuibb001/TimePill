//
//  TPRightMenuViewController.h
//  TimePill
//
//  Created by simon on 13-9-15.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "TPCreateDiaryViewController.h"
#import "TPWeiboListViewController.h"
#import "TPRevealViewController.h"
#import "TPSinaWeiboEngine.h"
#import "TPNavigationViewController.h"
#import "TPTheme.h"
#import "TPTimelineViewController.h"
#import "TPFriendsViewController.h"
#import "TPUtil.h"
#import "TPLoginViewController.h"
#import "TPLeftMenuViewController.h"

typedef enum
{
    TPRightMenuTypeCreateDiary = 0,
    TPRightMenuTypeMyWeibo,
    TPRightMenuTypeChangeTheme,
    TPRightMenuTypeMyFriends,
    TPRightMenuTypeCount
}
TPRightMenuType;

@interface TPRightMenuViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *menuTableView;
@property (nonatomic,strong) UIScrollView *themeScrollView;
@property (nonatomic,strong) NSMutableArray *listData;
@property (nonatomic,assign) BOOL isThemeOpen;

@end
