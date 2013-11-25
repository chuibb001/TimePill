//
//  TPFriendsViewController.h
//  TimePill
//
//  Created by simon on 13-9-28.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPSinaWeiboEngine.h"
#import "TPRefreshTableView.h"
#import "SVProgressHUD.h"
#import "TPConst.h"
#import "TPRevealViewController.h"
#import "TPFriendDataModel.h"
#import "TPFriendsTableViewCell.h"
#import "TPWeiboListViewController.h"

typedef enum
{
    TPFriendsUpDateTypeRefresh,
    TPFriendsUpDateTypeLoadMore
}
TPFriendsUpDateType;

typedef void(^TPFriendsViewControllerHandler)(TPFriendDataModel *dataModel);

@interface TPFriendsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,DisPlayDataSource>
{
    int page;
    int count;
    TPFriendsUpDateType type;
    TPWeiboRequestID currentRequestID;
}

@property (nonatomic,strong) TPRefreshTableView *friendTableView;
@property (nonatomic,strong) NSMutableArray *listData;
@property (nonatomic,strong) NSString *userID;
@property (nonatomic,strong) NSString *nextCursor;
@property (nonatomic,strong) TPFriendsViewControllerHandler handler;

@end
