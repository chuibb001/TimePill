//
//  TPWeiboListViewController.h
//  TPSinaWeiboSDK
//
//  Created by yan simon on 13-9-12.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPWeiboTableViewCell.h"
#import "TPWeiboDataModel.h"
#import "TPSinaWeiboEngine.h"
#import "TPRefreshTableView.h"
#import "SVProgressHUD.h"
#import "TPConst.h"
#import "TPRevealViewController.h"
#import "TPCommentViewController.h"
#import "TPZoomImageView.h"
#import "UIImageView+WebCache.h"
#import "TPUtil.h"

typedef enum
{
    TPWeiboUpDateTypeRefresh,
    TPWeiboUpDateTypeLoadMore
}
TPWeiboUpDateType;

typedef enum
{
    TPWeiboListViewControllerFromTypeMenu,
    TPWeiboListViewControllerFromTypeFriends
}
TPWeiboListViewControllerFromType;

@interface TPWeiboListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,DisPlayDataSource>
{
    int page;
    int count;
    TPWeiboUpDateType type;
    TPWeiboRequestID currentRequestID;
}

@property (nonatomic,strong) TPRefreshTableView *weiboTableView;
@property (nonatomic,strong) TPZoomImageView *zoomImageView;
@property (nonatomic,strong) NSMutableArray *listData;
@property (nonatomic,strong) NSString *userID;  // 用户ID 
@property (nonatomic,assign) TPWeiboListViewControllerFromType fromType;

@end
