//
//  TPCommentViewController.h
//  TimePill
//
//  Created by simon on 13-9-19.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPSinaWeiboEngine.h"
#import "TPRefreshTableView.h"
#import "TPCommentTableViewCell.h"
#import "TPCommentDataModel.h"
#import "SVProgressHUD.h"
#import "TPWeiboDataModel.h"

typedef void(^TPCommentHandler) (NSArray * array);  // 回调选中的评论

typedef enum
{
    TPCommentUpDateTypeRefresh,
    TPCommentUpDateTypeLoadMore
}
TPCommentUpDateType;

typedef enum
{
    TPCommentViewControllerFromTypeTimeline,
    TPCommentViewControllerFromTypeWeibo
}
TPCommentViewControllerFromType;

@interface TPCommentViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,DisPlayDataSource>
{
    int page;
    int count;
    TPCommentUpDateType type;
    BOOL isEditing;
    NSMutableSet *idset; // 已选择的评论ID数组
    TPWeiboRequestID currenRequestID;
}

@property (nonatomic,strong) TPRefreshTableView *commentTableView;
@property(retain,nonatomic) UIButton *rightButton;
@property(retain,nonatomic) UIButton *leftButton;
@property (nonatomic,strong) UIImageView *defaultImageView;
@property (nonatomic,strong) NSMutableArray *listData;
@property (nonatomic,strong) NSString *weiboID;  // 微博ID
@property (nonatomic,strong) NSArray *selecteCcommentModelList; // 已选择的评论列表,如果非空,拉回来的结果会与其比较
@property (nonatomic,strong) TPCommentHandler handler;
@property (nonatomic,assign) TPCommentViewControllerFromType fromType;

@end
