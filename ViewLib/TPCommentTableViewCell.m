//
//  TPCommentTableViewCell.m
//  TimePill
//
//  Created by simon on 13-9-19.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "TPCommentTableViewCell.h"

@implementation TPCommentTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.commentsLabel = [[TQRichTextView alloc] init];
        self.commentsLabel.backgroundColor = [UIColor clearColor];
        self.commentsLabel.font = [UIFont systemFontOfSize:16.0];
        self.commentsLabel.lineSpacing = 2.0;
        self.commentsLabel.textColor = [UIColor colorWithRed:55./255. green:55./255. blue:55./255. alpha:1.0];
        [self addSubview:self.commentsLabel];
        
        self.nameLabel=[[UILabel alloc] init];
        self.nameLabel.backgroundColor = [UIColor clearColor];
        self.nameLabel.font = [UIFont fontWithName:@"Verdana-Bold" size:16];
        [self addSubview:self.nameLabel];
        
        self.headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10+50, 7, 40, 40)];
        self.headImageView.layer.cornerRadius = 8.0;
        self.headImageView.layer.masksToBounds = YES;
        
        [self addSubview:self.headImageView];
        
        self.radioButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.radioButton.frame = CGRectMake(20, 15, 25, 25);
        [self insertSubview:self.radioButton atIndex:5];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setDisplayData:(TPCommentDataModel *)dataModel
{
    // 昵称
    self.nameLabel.text = dataModel.userName;
    self.nameLabel.frame=CGRectMake(65+50, 5, 320, 20);
    
    // 加载图片
    [self.headImageView setImageWithURL:[NSURL URLWithString:dataModel.profileImageURL] placeholderImage:nil];
    
    // 评论内容
    self.commentsLabel.text = dataModel.rawText;
    self.commentsLabel.frame = CGRectMake(65+50, 30, dataModel.textSize.width, dataModel.textSize.height);

    // 修改button样式
    BOOL isSelected = dataModel.isSelected;
    if(isSelected == YES)
        [self.radioButton setImage:[UIImage imageNamed:@"check_selected.png"] forState:UIControlStateNormal];
    else
        [self.radioButton setImage:[UIImage imageNamed:@"check_unselected.png"] forState:UIControlStateNormal];
}

- (void)setRadioButtonSelected:(BOOL)selected
{
    if(!selected)
        [self.radioButton setImage:[UIImage imageNamed:@"check_unselected@2x.png"] forState:UIControlStateNormal];
    else
        [self.radioButton setImage:[UIImage imageNamed:@"check_selected@2x.png"] forState:UIControlStateNormal];
}

- (void)setFrame:(CGRect)frame
{
    frame.size.width += 50;
    [super setFrame:frame];
}

#pragma mark TPAbstractViewDelegate
-(void)updateViewWithImage:(UIImage *)image
{
    self.headImageView.image = image;
}
@end
