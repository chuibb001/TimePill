//
//  TPTimelineTableViewCell.h
//  TimePill
//
//  Created by simon on 13-9-19.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "TPImageTextView.h"
#import "TPWeiboDataModel.h"
#import "TPImageDownloadCenter.h"
#import "TPTheme.h"
#import "TPTimelineCommentTableViewCell.h"
#import "TQRichTextView.h"

typedef void(^DeleteButtonHandler)(void);
typedef void(^CommentButtonHandler)(void);

@interface TPTimelineTableViewTextCell : UITableViewCell<UITableViewDataSource,UITableViewDelegate>
{
    CGRect addViewOpenRect;
    CGRect addViewCloseRect;
}

@property (nonatomic,strong) UIImageView *cardImageView;
@property (nonatomic,strong) TQRichTextView *textView;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UIImageView *commentBackgroundImageView;
@property (nonatomic,strong) UITableView *commentTableView;
@property (nonatomic,strong) UIImageView *iconImageView;
@property (nonatomic,strong) UIButton *addButton;
@property (nonatomic,strong) UIButton *addCommentButton;
@property (nonatomic,strong) UIButton *addDeleteButton;
@property (nonatomic,strong) UIImageView *addBackgroundImageView;
@property (nonatomic,strong) DeleteButtonHandler deleteButtonHandler;
@property (nonatomic,strong) CommentButtonHandler commentButtonHandler;

// DataModel
@property (nonatomic,strong) TPWeiboDataModel *dataModel;   // hold一个强指针，供TableView使用

- (void)setDisplayData:(TPWeiboDataModel *)dataModel;

-(void)beginAddViewAnimation:(BOOL)isOpen;

-(void)setAddButtonHidden:(BOOL)hidden;

-(void)setAddButtonEnable:(BOOL)enable;

@end

@interface TPTimelineTableViewTextWithImageCell : TPTimelineTableViewTextCell

@property (nonatomic,strong) UIImageView *picImageView;

@end

@interface TPTimelineTableViewRepostTextCell : TPTimelineTableViewTextCell

@property (nonatomic,strong) TQRichTextView *repostTextView;
@property (nonatomic,strong) UIImageView *repostBackgroundImageView;

@end

@interface TPTimelineTableViewRepostTextWithImageCell : TPTimelineTableViewRepostTextCell

@property (nonatomic,strong) UIImageView *picImageView;

@end
