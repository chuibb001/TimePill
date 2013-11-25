//
//  TPDiaryTableViewCell.h
//  TimePill
//
//  Created by simon on 13-9-20.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPImageTextView.h"
#import "TPDiaryDataModel.h"
#import "TPTheme.h"
#import "TQRichTextView.h"

@interface TPDiaryTableViewCell : UITableViewCell
{
    CGRect addViewOpenRect;
    CGRect addViewCloseRect;
}

@property (nonatomic,strong) UIImageView *cardImageView;
@property (nonatomic,strong) TQRichTextView *textView;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UIImageView *iconImageView;
@property (nonatomic,strong) UIButton *addButton;
@property (nonatomic,strong) UIImageView *picImageView;
@property (nonatomic,strong) UIButton *addDeleteButton;
@property (nonatomic,strong) UIImageView *addBackgroundImageView;

- (void)setDisplayData:(TPDiaryDataModel *)dataModel;

-(void)beginAddViewAnimation:(BOOL)isOpen;

-(void)setAddButtonHidden:(BOOL)hidden;

@end
