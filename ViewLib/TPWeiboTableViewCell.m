//
//  TPWeiboTableViewCell.m
//  TPSinaWeiboSDK
//
//  Created by yan simon on 13-9-12.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "TPWeiboTableViewCell.h"

@implementation TPWeiboTableViewTextCell // 0

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor colorWithRed:246./255. green:246./255. blue:246./255. alpha:1.0];
        // 背景卡片
        self.cardImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 8, 310, 50)];
        UIEdgeInsets insets = UIEdgeInsetsMake(17, 22, 17, 22);
        UIImage *image = [[UIImage imageNamed:@"weiboCardBackground@2x.png"] resizableImageWithCapInsets:insets];
        self.cardImageView.image = image;
        [self.contentView addSubview:self.cardImageView];
        // 选择按钮
        self.radioButton=[UIButton buttonWithType:UIButtonTypeCustom];
        self.radioButton.frame=CGRectMake(15, 15, 25, 25);
        [self.cardImageView addSubview:self.radioButton];
        // 姓名标签
        self.nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 10, 250, 18)];
        self.nameLabel.font=[UIFont systemFontOfSize:15.0];
        self.nameLabel.textColor=[UIColor colorWithRed:222.0/255.0 green:105.0/255.0 blue:25.0/255.0 alpha:1.0];
        self.nameLabel.textAlignment=kCTLeftTextAlignment;
        self.nameLabel.backgroundColor=[UIColor clearColor];
        [self.cardImageView addSubview:self.nameLabel];
        // 时间标签
        self.timeLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 32, 250, 12)];
        self.timeLabel.font=[UIFont systemFontOfSize:12.0];
        self.timeLabel.textColor=[UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:1.0];
        self.timeLabel.textAlignment=kCTLeftTextAlignment;
        self.timeLabel.backgroundColor=[UIColor clearColor];
        [self.cardImageView addSubview:self.timeLabel];
        // 文本
        self.textView=[[TQRichTextView alloc] initWithFrame:CGRectMake(12,50, 290, 400)];
        self.textView.backgroundColor=[UIColor clearColor];
        self.textView.font=[UIFont systemFontOfSize:16.0];
        self.textView.textColor = [UIColor colorWithRed:55./255. green:55./255. blue:55./255. alpha:1.0];
        [self.cardImageView addSubview:self.textView];
        self.textView.lineSpacing = 2.0;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        // 评论按钮
        UIEdgeInsets commenInsets = UIEdgeInsetsMake(6, 22, 6, 22);
        UIImage *commentImage = [[UIImage imageNamed:@"weiboCommentButton.png"] resizableImageWithCapInsets:commenInsets];
        UIImage *commentImageClicked = [[UIImage imageNamed:@"weiboCommentButtonClicked.png"] resizableImageWithCapInsets:commenInsets];
        self.commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.commentButton.frame = CGRectMake(6, 0, 308, 40);
        [self.commentButton setTitle:@"点击查看评论" forState:UIControlStateNormal];
        [self.commentButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        self.commentButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        self.commentButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.commentButton.layer.anchorPoint = CGPointMake(0.5, 0.0);
        [self.commentButton setBackgroundImage:commentImage forState:UIControlStateNormal];
        [self.commentButton setBackgroundImage:commentImageClicked forState:UIControlStateHighlighted];
        [self addSubview:self.commentButton];
    }
    return self;
}

- (void)setDisplayData:(TPWeiboDataModel *)dataModel
{
    const CGRect textViewFrame = CGRectMake(self.textView.frame.origin.x, self.textView.frame.origin.y, dataModel.textSize.width, dataModel.textSize.height);
    const CGRect cardImageViewFrame = CGRectMake(self.cardImageView.frame.origin.x, self.cardImageView.frame.origin.y, self.cardImageView.frame.size.width, dataModel.rowHeight - 48.0);
    
    self.textView.text = dataModel.rawText;
    self.nameLabel.text = dataModel.userName;
    self.textView.frame = textViewFrame;
    self.cardImageView.frame = cardImageViewFrame;
    self.timeLabel.text = [[dataModel.time description] substringToIndex:16];
    if(!dataModel.isSelected)
        [self.radioButton setImage:[UIImage imageNamed:@"check_unselected@2x.png"] forState:UIControlStateNormal];
    else
        [self.radioButton setImage:[UIImage imageNamed:@"check_selected@2x.png"] forState:UIControlStateNormal];
    self.commentButton.center = CGPointMake(self.commentButton.center.x, CGRectGetMaxY(cardImageViewFrame));
}

- (void)setRadioButtonSelected:(BOOL)selected
{
    if(!selected)
        [self.radioButton setImage:[UIImage imageNamed:@"check_unselected@2x.png"] forState:UIControlStateNormal];
    else
        [self.radioButton setImage:[UIImage imageNamed:@"check_selected@2x.png"] forState:UIControlStateNormal];
}
@end

@implementation TPWeiboTableViewTextWithImageCell  // 1

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        /*图片*/
        self.picImageView=[[UIImageView alloc] init];
        self.picImageView.contentMode = UIViewContentModeScaleAspectFit;
        self.cardImageView.userInteractionEnabled = YES;
        [self.cardImageView addSubview:self.picImageView];
    }
    return self;
}

- (void)setDisplayData:(TPWeiboDataModel *)dataModel
{
    const CGRect textViewFrame = CGRectMake(self.textView.frame.origin.x, self.textView.frame.origin.y, dataModel.textSize.width, dataModel.textSize.height);
    const CGRect imageViewFrame = CGRectMake(textViewFrame.origin.x, 5 + textViewFrame.size.height + textViewFrame.origin.y, kDefaultImageHeight, kDefaultImageHeight);
    const CGRect cardImageViewFrame = CGRectMake(self.cardImageView.frame.origin.x, self.cardImageView.frame.origin.y, self.cardImageView.frame.size.width, dataModel.rowHeight - 48.0);
    
    self.textView.text = dataModel.rawText;
    self.textView.frame = textViewFrame;
    // 加载图片
    [self.picImageView setImageWithURL:[NSURL URLWithString:dataModel.thumbnailImageURL] placeholderImage:[UIImage imageNamed:@"placesHolderImage.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType)
     {
         dataModel.thumbnailImage = image;
     }];
    self.nameLabel.text = dataModel.userName;
    self.picImageView.frame = imageViewFrame;
    self.cardImageView.frame = cardImageViewFrame;
    self.timeLabel.text = [[dataModel.time description] substringToIndex:16];
    if(!dataModel.isSelected)
        [self.radioButton setImage:[UIImage imageNamed:@"check_unselected@2x.png"] forState:UIControlStateNormal];
    else
        [self.radioButton setImage:[UIImage imageNamed:@"check_selected@2x.png"] forState:UIControlStateNormal];
    self.commentButton.center = CGPointMake(self.commentButton.center.x, CGRectGetMaxY(cardImageViewFrame));
}

#pragma mark TPAbstractViewDelegate
-(void)updateViewWithImage:(UIImage *)image
{
    self.picImageView.image = image;
}

@end

@implementation TPWeiboTableViewRepostTextCell  // 2

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 背景色块
        self.repostBackgroundImageView=[[UIImageView alloc] initWithFrame:CGRectZero];
        UIEdgeInsets insets = UIEdgeInsetsMake(20, 50, 5, 20);
        UIImage *image = [[UIImage imageNamed:@"weiboRepostBackgroundImage@2x.png"] resizableImageWithCapInsets:insets];
        self.repostBackgroundImageView.image = image;
        [self.cardImageView addSubview:self.repostBackgroundImageView];
        // 转发文本 
        self.repostTextView=[[TQRichTextView alloc] init];
        self.repostTextView.backgroundColor=[UIColor clearColor];
        self.repostTextView.font=[UIFont systemFontOfSize:15.0];
        self.repostTextView.textColor = [UIColor colorWithRed:82./255. green:82./255. blue:82./255. alpha:1.0];
        self.repostTextView.lineSpacing = 2.0;
        [self.repostBackgroundImageView addSubview:self.repostTextView];
        
    }
    return self;
}

- (void)setDisplayData:(TPWeiboDataModel *)dataModel
{
    const CGRect textViewFrame = CGRectMake(self.textView.frame.origin.x, self.textView.frame.origin.y, dataModel.textSize.width, dataModel.textSize.height);
    const CGRect repostTextViewFrame = CGRectMake(12, 20 , dataModel.repostTextSize.width, dataModel.repostTextSize.height);
    const CGRect repostBackfroundImageViewFrame = CGRectMake(textViewFrame.origin.x, 5 + textViewFrame.size.height + textViewFrame.origin.y, textViewFrame.size.width, repostTextViewFrame.size.height  + 25);
    const CGRect cardImageViewFrame = CGRectMake(self.cardImageView.frame.origin.x, self.cardImageView.frame.origin.y, self.cardImageView.frame.size.width, dataModel.rowHeight - 48.0);
    
    self.textView.text = dataModel.rawText;
    self.textView.frame = textViewFrame;
    self.nameLabel.text = dataModel.userName;
    self.repostTextView.text = dataModel.rawRepostText;
    self.repostTextView.frame = repostTextViewFrame;
    self.repostBackgroundImageView.frame = repostBackfroundImageViewFrame;
    self.cardImageView.frame = cardImageViewFrame;
    self.timeLabel.text = [[dataModel.time description] substringToIndex:16];
    if(!dataModel.isSelected)
        [self.radioButton setImage:[UIImage imageNamed:@"check_unselected@2x.png"] forState:UIControlStateNormal];
    else
        [self.radioButton setImage:[UIImage imageNamed:@"check_selected@2x.png"] forState:UIControlStateNormal];
    self.commentButton.center = CGPointMake(self.commentButton.center.x, CGRectGetMaxY(cardImageViewFrame));
}

@end

@implementation TPWeiboTableViewRepostTextWithImageCell  // 3

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 图片
        self.picImageView=[[UIImageView alloc] init];
        self.picImageView.contentMode = UIViewContentModeCenter;
        self.picImageView.layer.masksToBounds = YES;
        self.cardImageView.userInteractionEnabled = YES;
        self.repostBackgroundImageView.userInteractionEnabled = YES;
        [self.repostBackgroundImageView addSubview:self.picImageView];
    }
    return self;
}

- (void)setDisplayData:(TPWeiboDataModel *)dataModel
{
    const CGRect textViewFrame = CGRectMake(self.textView.frame.origin.x, self.textView.frame.origin.y, dataModel.textSize.width, dataModel.textSize.height);
    const CGRect repostTextViewFrame = CGRectMake(12, 20 , dataModel.repostTextSize.width, dataModel.repostTextSize.height);
    const CGRect imageViewFrame = CGRectMake(repostTextViewFrame.origin.x, 5 + repostTextViewFrame.size.height + repostTextViewFrame.origin.y, 100.0, 100.0);
    const CGRect repostBackfroundImageViewFrame = CGRectMake(textViewFrame.origin.x, 5 + textViewFrame.size.height + textViewFrame.origin.y, textViewFrame.size.width, repostTextViewFrame.size.height  + imageViewFrame.size.height + 35);
    const CGRect cardImageViewFrame = CGRectMake(self.cardImageView.frame.origin.x, self.cardImageView.frame.origin.y, self.cardImageView.frame.size.width, dataModel.rowHeight - 48.0);
    
    self.textView.text = dataModel.rawText;
    self.textView.frame = textViewFrame;
    self.nameLabel.text = dataModel.userName;
    self.repostTextView.text = dataModel.rawRepostText;
    self.repostTextView.frame = repostTextViewFrame;
    self.repostBackgroundImageView.frame = repostBackfroundImageViewFrame;
    self.cardImageView.frame = cardImageViewFrame;
    self.picImageView.frame = imageViewFrame;
    // 加载图片
    [self.picImageView setImageWithURL:[NSURL URLWithString:dataModel.thumbnailImageURL] placeholderImage:[UIImage imageNamed:@"placesHolderImage.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType)
     {
         dataModel.thumbnailImage = image;
     }];
    self.timeLabel.text = [[dataModel.time description] substringToIndex:16];
    if(!dataModel.isSelected)
        [self.radioButton setImage:[UIImage imageNamed:@"check_unselected@2x.png"] forState:UIControlStateNormal];
    else
        [self.radioButton setImage:[UIImage imageNamed:@"check_selected@2x.png"] forState:UIControlStateNormal];
    self.commentButton.center = CGPointMake(self.commentButton.center.x, CGRectGetMaxY(cardImageViewFrame));
}

@end