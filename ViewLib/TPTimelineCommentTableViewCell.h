//
//  TPTimelineCommentTableViewCell.h
//  TimePill

//  Cell中Cell

//  Created by simon on 13-9-20.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "TPWeiboTextParser.h"
#import "TPImageTextView.h"
#import "TPCommentDataModel.h"
#import "UIImageView+WebCache.h"
#import "TQRichTextView.h"

@interface TPTimelineCommentTableViewCell : UITableViewCell

@property (nonatomic,strong) UIImageView *headImageView;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) TQRichTextView *commentTextView;

- (void)setDisplayData:(TPCommentDataModel *)dataModel;

@end
