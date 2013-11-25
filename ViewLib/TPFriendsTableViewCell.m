//
//  TPFriendsTableViewCell.m
//  TimePill
//
//  Created by simon on 13-9-28.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "TPFriendsTableViewCell.h"

@implementation TPFriendsTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(110, 19, 150, 20)];
        self.nameLabel.backgroundColor = [UIColor clearColor];
        self.nameLabel.font = [UIFont boldSystemFontOfSize:16.0];
        self.nameLabel.textColor = [UIColor colorWithRed:55./255. green:55./255. blue:55./255. alpha:1.0];
        [self addSubview:self.nameLabel];
        
        self.headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 7, 40, 40)];
        self.headImageView.layer.cornerRadius = 8.0;
        self.headImageView.layer.masksToBounds = YES;
        
        [self addSubview:self.headImageView];
        
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

- (void)setDisplayData:(TPFriendDataModel *)dataModel
{
    self.nameLabel.text = dataModel.name;
    
    // 加载图片
    [self.headImageView setImageWithURL:[NSURL URLWithString:dataModel.profileImageURL] placeholderImage:[UIImage imageNamed:@"placesHolderHead.png"]];
    
    
}

#pragma mark TPAbstractViewDelegate
-(void)updateViewWithImage:(UIImage *)image
{
    self.headImageView.image = image;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
