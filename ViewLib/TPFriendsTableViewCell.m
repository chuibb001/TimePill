//
//  TPFriendsTableViewCell.m
//  TimePill
//
//  Created by simon on 13-9-28.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "TPFriendsTableViewCell.h"

@interface TPFriendsTableViewCell ()
{
    CGRect centerRect;
    CGRect leftRect;
    CGRect currentRect;
}
@end

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
        [self.contentView addSubview:self.nameLabel];
        
        self.headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 7, 40, 40)];
        self.headImageView.layer.cornerRadius = 8.0;
        self.headImageView.layer.masksToBounds = YES;
        
        [self.contentView addSubview:self.headImageView];
        self.contentView.backgroundColor = [UIColor blackColor];
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        centerRect = self.contentView.frame;
        leftRect = CGRectMake(self.contentView.frame.origin.x - 100.0, self.contentView.frame.origin.y, self.contentView.frame.size.width, self.contentView.frame.size.height);
        currentRect = centerRect;
        //UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(gestureRecognizerDidPan:)];
        //[self.contentView addGestureRecognizer:pan];
    }
    return self;
}

- (void)gestureRecognizerDidPan:(UIPanGestureRecognizer *)pan
{
    CGPoint point = [pan translationInView:self.contentView];
    CGFloat newX = currentRect.origin.x + point.x;
    
    if(pan.state == UIGestureRecognizerStateChanged) {
        if (newX >= leftRect.origin.x && newX <= centerRect.origin.x) {
            self.contentView.frame = CGRectMake(currentRect.origin.x + point.x, self.contentView.frame.origin.y, self.contentView.frame.size.width, self.contentView.frame.size.height);
        }
    } else if(pan.state == UIGestureRecognizerStateEnded) {
        CGFloat mid = (leftRect.origin.x + centerRect.origin.x) / 2;
        CGRect endRect = CGRectZero;
        if (newX > mid) {
            endRect = centerRect;
        } else {
            endRect = leftRect;
        }
        // start animation
        if(!CGRectEqualToRect(endRect, CGRectZero))
        {
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView animateWithDuration:0.1 animations:^{
                self.contentView.frame = endRect;
            } completion:^(BOOL Finished){
                self.contentView.frame = endRect;
                currentRect = endRect;
            }];
        }
    }
    
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
