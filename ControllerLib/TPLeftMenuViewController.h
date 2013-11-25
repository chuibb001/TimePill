//
//  TPLeftMenuViewController.h
//  TimePill
//
//  Created by simon on 13-9-15.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPTimeHallViewController.h"
#import "TPSettingViewController.h"
#import "TPTimelineViewController.h"
#import "TPRevealViewController.h"

typedef enum
{
    TPLeftMenuTypeTimeLine,
    TPLeftMenuTypeTimeHall,
    TPLeftMenuTypeSetting,
    TPLeftMenuTypeCount
}
TPLeftMenuType;

@interface TPLeftMenuViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *menuTableView;
@property (nonatomic,strong) UIImageView *headImageView;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) NSMutableArray *listData;
@property (nonatomic,strong) TPTimelineViewController *timelineController;
@property (nonatomic,strong) TPTimeHallViewController *hallController;
@property (nonatomic,strong) TPSettingViewController *settingController;
@property (nonatomic,assign) TPLeftMenuType currentSelectedType;


-(void)changeTheme;

@end
