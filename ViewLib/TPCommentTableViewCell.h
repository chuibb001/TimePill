//
//  TPCommentTableViewCell.h
//  TimePill
//
//  Created by simon on 13-9-19.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "TPImageTextView.h"
#import "TPImageDownloadCenter.h"
#import "TPCommentDataModel.h"
#import "UIImageView+WebCache.h"
#import "TQRichTextView.h"

@interface TPCommentTableViewCell : UITableViewCell<TPAbstractViewDelegate>

@property (strong,nonatomic) UIImageView *headImageView;
@property (strong,nonatomic) UILabel *nameLabel;
@property (strong,nonatomic) TQRichTextView *commentsLabel;
@property (strong,nonatomic) UIButton *radioButton;

- (void)setDisplayData:(TPCommentDataModel *)dataModel;

- (void)setRadioButtonSelected:(BOOL)selected;

@end
