//
//  TPDiaryTableViewCell.m
//  TimePill
//
//  Created by simon on 13-9-20.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "TPDiaryTableViewCell.h"

@implementation TPDiaryTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        // 背景卡片
        self.cardImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 290, 50)];
        UIEdgeInsets insets = UIEdgeInsetsMake(50, 50, 50, 100);
        UIImage *image = [[TPTheme currentBubbleImage] resizableImageWithCapInsets:insets];
        self.cardImageView.image = image;
        [self.contentView addSubview:self.cardImageView];
        // 姓名标签
        self.nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(15, 10, 250, 18)];
        self.nameLabel.font=[UIFont systemFontOfSize:15.0];
        self.nameLabel.textColor=[UIColor colorWithRed:222.0/255.0 green:105.0/255.0 blue:25.0/255.0 alpha:1.0];
        self.nameLabel.textAlignment=kCTLeftTextAlignment;
        self.nameLabel.backgroundColor=[UIColor clearColor];
        [self.cardImageView addSubview:self.nameLabel];
        // 时间标签
        self.timeLabel=[[UILabel alloc] initWithFrame:CGRectMake(120, 32, 250, 12)];
        self.timeLabel.font=[UIFont systemFontOfSize:12.0];
        self.timeLabel.textColor=[UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:1.0];
        self.timeLabel.textAlignment=kCTLeftTextAlignment;
        self.timeLabel.backgroundColor=[UIColor clearColor];
        [self.cardImageView addSubview:self.timeLabel];
        // 文本
        self.textView=[[TQRichTextView alloc] initWithFrame:CGRectMake(15,32, 290, 400)];
        self.textView.backgroundColor=[UIColor clearColor];
        self.textView.font=[UIFont systemFontOfSize:16.0];
        self.textView.textColor = [UIColor colorWithRed:55./255. green:55./255. blue:55./255. alpha:1.0];
        self.textView.lineSpacing = 2.0;
        [self.cardImageView addSubview:self.textView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        // 图片
        self.picImageView=[[UIImageView alloc] init];
        self.picImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.cardImageView addSubview:self.picImageView];
        // 日记Icon
        self.iconImageView = [[UIImageView alloc] init];
        self.iconImageView.image = [UIImage imageNamed:@"pencilIcon.png"];
        [self addSubview:self.iconImageView];
        // 加号按钮
        self.addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.addButton setBackgroundImage:[UIImage imageNamed:@"bianji.png"] forState:UIControlStateNormal];
        [self.addButton setBackgroundImage:[UIImage imageNamed:@"bianjiclick.png"] forState:UIControlStateHighlighted];
        [self addSubview:self.addButton];
    }
    return self;
}

- (void)setDisplayData:(TPDiaryDataModel *)dataModel
{
    const CGRect textViewFrame = CGRectMake(self.textView.frame.origin.x, self.textView.frame.origin.y, dataModel.textSize.width, dataModel.textSize.height);
    const CGRect imageViewFrame = CGRectMake(6, 5 + textViewFrame.size.height + textViewFrame.origin.y, dataModel.imageSize.width - 1, dataModel.imageSize.height);
    const CGRect cardImageViewFrame = CGRectMake(self.cardImageView.frame.origin.x, self.cardImageView.frame.origin.y, self.cardImageView.frame.size.width, dataModel.rowHeight - 20.0);
    const CGRect timeLabelFrame = CGRectMake(self.timeLabel.frame.origin.x, CGRectGetMaxY(cardImageViewFrame) - 30, self.timeLabel.frame.size.width,self.timeLabel.frame.size.height);
    const CGRect addButtonFrame = CGRectMake(CGRectGetMaxX(self.cardImageView.frame)  - 38 , timeLabelFrame.origin.y , 27.5, 27);
    const CGRect iconImageViewFrame = CGRectMake(230, timeLabelFrame.origin.y + 5, 27, 17);
    
    self.textView.text = dataModel.rawText;
    self.nameLabel.text = @"我:";
    self.textView.frame = textViewFrame;
    self.picImageView.frame = imageViewFrame;
    self.picImageView.image = dataModel.image;
    self.cardImageView.frame = cardImageViewFrame;
    self.timeLabel.text = [[dataModel.date description] substringToIndex:16];
    self.timeLabel.frame = timeLabelFrame;
    self.addButton.frame = addButtonFrame;
    self.iconImageView.frame = iconImageViewFrame;
    
    // for theme
    UIEdgeInsets insets = UIEdgeInsetsMake(50, 50, 50, 100);
    UIImage *image = [[TPTheme currentBubbleImage] resizableImageWithCapInsets:insets];
    self.cardImageView.image = image;
}

#pragma mark private
-(void)initAddButtonView
{
    // 背景
    addViewOpenRect = CGRectMake(self.addButton.frame.origin.x - 40, self.addButton.frame.origin.y - 55, 70, 55.0);
    addViewCloseRect = CGRectMake(self.addButton.frame.origin.x - 40, self.addButton.frame.origin.y - 35, 70, 55.0);
    
    self.addBackgroundImageView = [[UIImageView alloc] initWithFrame:addViewCloseRect];
    self.addBackgroundImageView.image = [UIImage imageNamed:@"bianjikuang.png"];
    self.addBackgroundImageView.userInteractionEnabled = YES;
    [self addSubview:self.addBackgroundImageView];
    // 删除按钮
    CGRect deleteButtonFrame =  CGRectMake(5, -10 , 60, 60);
    self.addDeleteButton = [[UIButton alloc] initWithFrame:deleteButtonFrame];
    UIImage *deleteImage = [UIImage imageNamed:@"shanchu.png"];
    [self.addDeleteButton setImage:deleteImage forState:UIControlStateNormal];
    [self.addDeleteButton setTitle:@" 删除" forState:UIControlStateNormal];
    self.addDeleteButton.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
    self.addDeleteButton.titleLabel.textAlignment = UITextAlignmentRight;
    [self.addDeleteButton setTitleColor:[UIColor colorWithRed:75./255. green:75./255. blue:75./255. alpha:1.0] forState:UIControlStateNormal];
    [self.addBackgroundImageView addSubview:self.addDeleteButton];
    
}
-(void)beginAddViewAnimation:(BOOL)isOpen
{
    addViewOpenRect = CGRectMake(self.addButton.frame.origin.x - 40, self.addButton.frame.origin.y - 55, 70, 55.0);
    addViewCloseRect = CGRectMake(self.addButton.frame.origin.x - 40, self.addButton.frame.origin.y - 35, 70, 55.0);
    
    if(isOpen)
    {
        if(!self.addBackgroundImageView)  // 首次初始化
        {
            [self initAddButtonView];
        }
        
        [UIView animateWithDuration:0.1f animations:^(){
            self.addBackgroundImageView.frame = addViewOpenRect;
            self.addBackgroundImageView.alpha = 1.0;
        } completion:^(BOOL finished){
            self.addBackgroundImageView.frame = addViewOpenRect;
            self.addBackgroundImageView.alpha = 1.0;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.1f animations:^(){
            self.addBackgroundImageView.frame = addViewCloseRect;
            self.addBackgroundImageView.alpha = 0.0;
        } completion:^(BOOL finished){
            self.addBackgroundImageView.frame = addViewCloseRect;
            self.addBackgroundImageView.alpha = 0.0;
        }];
    }
}

- (void)setAddButtonHidden:(BOOL)hidden
{
    self.addButton.hidden = hidden;
}

- (void)setAddButtonEnable:(BOOL)enable
{
    self.addButton.userInteractionEnabled = enable;
}

@end
