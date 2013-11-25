//
//  TPTimelineCommentTableViewCell.m
//  TimePill
//
//  Created by simon on 13-9-20.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "TPTimelineCommentTableViewCell.h"

@implementation TPTimelineCommentTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.commentTextView = [[TQRichTextView alloc] init];
        self.commentTextView.backgroundColor = [UIColor clearColor];
        self.commentTextView.font = [UIFont systemFontOfSize:14.0];
        self.commentTextView.textColor = [UIColor colorWithRed:55./255. green:55./255. blue:55./255. alpha:1.0];
        self.commentTextView.lineSpacing = 2.0;
        [self addSubview:self.commentTextView];
        
        self.nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(40, 10, 100, 20)];
        self.nameLabel.backgroundColor = [UIColor clearColor];
        self.nameLabel.font = [UIFont systemFontOfSize:15.0];
        self.nameLabel.textColor = [UIColor colorWithRed:55./255. green:55./255. blue:55./255. alpha:1.0];
        [self addSubview:self.nameLabel];
        
        self.headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 5, 25, 25)];
        self.headImageView.layer.cornerRadius = 2.0;
        self.headImageView.layer.masksToBounds = YES;
        
        [self addSubview:self.headImageView];
    }
    return self;
}

- (void)setDisplayData:(TPCommentDataModel *)dataModel
{
    self.nameLabel.text = dataModel.userName;
    self.commentTextView.text = dataModel.rawText;
    // 加载图片
    [self.headImageView setImageWithURL:[NSURL URLWithString:dataModel.profileImageURL] placeholderImage:nil];
    self.commentTextView.frame = CGRectMake(8, 35, dataModel.textSize.width, dataModel.textSize.height);
}

@end
