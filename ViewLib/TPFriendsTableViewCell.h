//
//  TPFriendsTableViewCell.h
//  TimePill
//
//  Created by simon on 13-9-28.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "TPImageDownloadCenter.h"
#import "TPFriendDataModel.h"
#import "UIImageView+WebCache.h"

@interface TPFriendsTableViewCell : UITableViewCell<TPAbstractViewDelegate>

@property (strong,nonatomic) UIImageView *headImageView;
@property (strong,nonatomic) UILabel *nameLabel;

- (void)setDisplayData:(TPFriendDataModel *)dataModel;

@end
