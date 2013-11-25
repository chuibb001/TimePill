//
//  TPWeiboTableViewCell.h
//  TPSinaWeiboSDK
//
//  Created by yan simon on 13-9-12.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "TPImageTextView.h"
#import "TPWeiboDataModel.h"
#import "TPImageDownloadCenter.h"
#import "UIImageView+WebCache.h"
#import "TQRichTextView.h"

@interface TPWeiboTableViewTextCell : UITableViewCell

@property (nonatomic,strong) UIImageView *cardImageView;
@property (nonatomic,strong) TQRichTextView *textView;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UIButton *radioButton;
@property (nonatomic,strong) UIButton *commentButton;

- (void)setDisplayData:(TPWeiboDataModel *)dataModel;

- (void)setRadioButtonSelected:(BOOL)selected;

@end

@interface TPWeiboTableViewTextWithImageCell : TPWeiboTableViewTextCell<TPAbstractViewDelegate>

@property (nonatomic,strong) UIImageView *picImageView;

@end

@interface TPWeiboTableViewRepostTextCell : TPWeiboTableViewTextCell

@property (nonatomic,strong) TQRichTextView *repostTextView;
@property (nonatomic,strong) UIImageView *repostBackgroundImageView;

@end

@interface TPWeiboTableViewRepostTextWithImageCell : TPWeiboTableViewRepostTextCell<TPAbstractViewDelegate>

@property (nonatomic,strong) UIImageView *picImageView;

@end