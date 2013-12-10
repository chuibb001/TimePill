//
//  TPTimelineViewController.h
//  TimePill
//
//  Created by simon on 13-9-15.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPConst.h"
#import "TPWeiboDataModel.h"
#import "TPDiaryDataModel.h"
#import "TPCommentDataModel.h"
#import "TPTimelineDataModel.h"
#import "TPTimelineTableViewCell.h"
#import "TPTimelineHeaderView.h"
#import "TPDiaryTableViewCell.h"
#import "TPSinaWeiboEngine.h"
#import "TPUtil.h"
#import "TPCommentViewController.h"
#import "TPNavigationViewController.h"
#import "TPUserInfoModel.h"
#import "TPRevealViewController.h"
#import "ExpandingButtonBar.h"
#import "TPCreateDiaryViewController.h"
#import "TPLongWeiboManager.h"

@interface TPTimelineViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSIndexPath *lastAddViewIndexPath;
    NSIndexPath *currentAddViewIndexPath;
    TPUserInfoModel *userInfoModel;
    BOOL shouldUpdateCell;
    BOOL shouldHideAddButton;
}

@property (nonatomic,strong) TPTimelineHeaderView *headView;
@property (nonatomic,strong) UIImageView *defaultImageView;
@property (nonatomic,strong) UITableView *timelineTableView;
@property (nonatomic,strong) NSMutableArray *listData;
@property (nonatomic,strong) ExpandingButtonBar *menuButtonBar;
@property (nonatomic,strong) UIImage *longWeiboImage;

-(void)changeTheme;

@end
