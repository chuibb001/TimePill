//
//  TPTimelineTableViewCell.m
//  TimePill
//
//  Created by simon on 13-9-19.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "TPTimelineTableViewCell.h"

@implementation TPTimelineTableViewTextCell // 0

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        // 背景卡片
        self.cardImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 290, 50)];
        UIEdgeInsets insets = UIEdgeInsetsMake(60, 270, 60, 270);
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
        // 微博Icon
        self.iconImageView = [[UIImageView alloc] init];
        self.iconImageView.image = [UIImage imageNamed:@"weiboIcon.png"];
        [self addSubview:self.iconImageView];
        // 加号按钮
        self.addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.addButton setBackgroundImage:[UIImage imageNamed:@"bianji.png"] forState:UIControlStateNormal];
        [self.addButton setBackgroundImage:[UIImage imageNamed:@"bianjiclick.png"] forState:UIControlStateHighlighted];
        [self addSubview:self.addButton];
        // 评论列表
        self.commentBackgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0 , 175, 10)];
        UIEdgeInsets commentBackgroundImageInsets = UIEdgeInsetsMake(50, 20, 20, 20);
        UIImage *commentBackgroundImage = [[TPTheme currentCommentBackgroundImage] resizableImageWithCapInsets:commentBackgroundImageInsets];
        self.commentBackgroundImageView.image = commentBackgroundImage;
        [self addSubview:self.commentBackgroundImageView];
        self.commentTableView = [[UITableView alloc] initWithFrame:CGRectMake(8, 0, 159, 10)];
        self.commentTableView.dataSource = self;
        self.commentTableView.delegate = self;
        self.commentTableView.layer.cornerRadius = 5.0;
        self.commentTableView.layer.masksToBounds = YES;
        //self.commentTableView.backgroundColor = [UIColor clearColor];
        [self.commentBackgroundImageView addSubview:self.commentTableView];
        
    }
    return self;
}

- (void)setDisplayData:(TPWeiboDataModel *)dataModel
{
    const CGRect textViewFrame = CGRectMake(self.textView.frame.origin.x, self.textView.frame.origin.y, dataModel.textSize.width, dataModel.textSize.height);
    const CGRect cardImageViewFrame = CGRectMake(self.cardImageView.frame.origin.x, self.cardImageView.frame.origin.y, self.cardImageView.frame.size.width, dataModel.rowHeight - dataModel.commentTableViewHeight - 40.0);
    const CGRect timeLabelFrame = CGRectMake(self.timeLabel.frame.origin.x, CGRectGetMaxY(cardImageViewFrame) - 30, self.timeLabel.frame.size.width,self.timeLabel.frame.size.height);
    const CGRect addButtonFrame = CGRectMake(CGRectGetMaxX(self.cardImageView.frame)  - 38 , timeLabelFrame.origin.y , 27.5, 27);
    const CGRect iconImageViewFrame = CGRectMake(230, timeLabelFrame.origin.y + 5, 27, 17);
    
    self.textView.text = dataModel.rawText;
    self.nameLabel.text = dataModel.userName;
    self.textView.frame = textViewFrame;
    self.cardImageView.frame = cardImageViewFrame;
    self.timeLabel.text = [[dataModel.time description] substringToIndex:16];
    self.timeLabel.frame = timeLabelFrame;
    self.addButton.frame = addButtonFrame;
    self.iconImageView.frame = iconImageViewFrame;
    
    if(dataModel.commentArray && [dataModel.commentArray count] > 0)  // 处理评论
    {
        self.commentBackgroundImageView.hidden = NO;
        self.dataModel = dataModel;
        // 设置评论表的Frame
        self.commentBackgroundImageView.frame = CGRectMake(self.commentBackgroundImageView.frame.origin.x, cardImageViewFrame.origin.x + cardImageViewFrame.size.height - 9, self.commentBackgroundImageView.frame.size.width, dataModel.commentTableViewHeight + 24);
        self.commentTableView.frame = CGRectMake(self.commentTableView.frame.origin.x, 17, self.commentTableView.frame.size.width, dataModel.commentTableViewHeight );
        [self.commentTableView reloadData];
    }
    else
    {
        self.commentBackgroundImageView.hidden = YES;  // 隐藏试试,避免dealloc它
        self.dataModel = nil;
    }
    
    // for theme
    UIEdgeInsets insets = UIEdgeInsetsMake(30, 130, 30, 130);
    UIImage *image = [[TPTheme currentBubbleImage] resizableImageWithCapInsets:insets];
    self.cardImageView.image = image;
    UIEdgeInsets commentBackgroundImageInsets = UIEdgeInsetsMake(20, 25, 10, 25);
    UIImage *commentBackgroundImage = [[TPTheme currentCommentBackgroundImage] resizableImageWithCapInsets:commentBackgroundImageInsets];
    self.commentBackgroundImageView.image = commentBackgroundImage;
}

#pragma mark private
-(void)initAddButtonView
{
    // 背景
    addViewOpenRect = CGRectMake(self.addButton.frame.origin.x - 90, self.addButton.frame.origin.y - 55, 120.0, 55.0);
    addViewCloseRect = CGRectMake(self.addButton.frame.origin.x - 90, self.addButton.frame.origin.y - 35, 120.0, 55.0);
    
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
    // 查询评论按钮
    CGRect commentsButtonFrame =  CGRectMake(55, -10,60, 60);
    self.addCommentButton = [[UIButton alloc] initWithFrame:commentsButtonFrame];
    [self.addCommentButton setImage:[UIImage imageNamed:@"tucao.png"] forState:UIControlStateNormal];
    [self.addCommentButton setTitle:@"评论" forState:UIControlStateNormal];
    self.addCommentButton.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
    self.addCommentButton.titleLabel.textAlignment = UITextAlignmentRight;
    [self.addCommentButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [self.addCommentButton setTitleColor:[UIColor colorWithRed:75./255. green:75./255. blue:75./255. alpha:1.0] forState:UIControlStateNormal];
    [self.addBackgroundImageView addSubview:self.addCommentButton];
    
}
-(void)beginAddViewAnimation:(BOOL)isOpen
{
    addViewOpenRect = CGRectMake(self.addButton.frame.origin.x - 90, self.addButton.frame.origin.y - 55, 120.0, 55.0);
    addViewCloseRect = CGRectMake(self.addButton.frame.origin.x - 90, self.addButton.frame.origin.y - 35, 120.0, 55.0);
    
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

-(void)setAddButtonHidden:(BOOL)hidden
{
    self.addButton.hidden = hidden;
}

-(void)setAddButtonEnable:(BOOL)enable
{
    self.addButton.userInteractionEnabled = enable;
}

#pragma mark UITableView
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.dataModel)
        return [self.dataModel.commentArray count];
    else
        return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TPCommentDataModel *dataModel = [self.dataModel.commentArray objectAtIndex:indexPath.row];
    return dataModel.rowHeight;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.commentTableView)
    {
        TPCommentDataModel *dataModel = [self.dataModel.commentArray objectAtIndex:indexPath.row];
        static NSString *CellIdentifier = @"TPTimelineCommentTableViewCell";
        
        TPTimelineCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[TPTimelineCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        [cell setDisplayData:dataModel];
        return cell;
    }
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    BOOL selected = ((TPWeiboDataModel *)[self.listData objectAtIndex:indexPath.row]).isSelected;
//    ((TPWeiboDataModel *)[self.listData objectAtIndex:indexPath.row]).isSelected = !selected;
//    TPWeiboTableViewTextCell *cell=(TPWeiboTableViewTextCell *)[tableView cellForRowAtIndexPath:indexPath];
//    [cell setRadioButtonSelected:!selected];
}

@end

@implementation TPTimelineTableViewTextWithImageCell  // 1

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 图片
        self.picImageView=[[UIImageView alloc] init];
        self.picImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.cardImageView addSubview:self.picImageView];
    }
    return self;
}

- (void)setDisplayData:(TPWeiboDataModel *)dataModel
{
    const CGRect textViewFrame = CGRectMake(self.textView.frame.origin.x, self.textView.frame.origin.y, dataModel.textSize.width, dataModel.textSize.height);
    const CGRect imageViewFrame = CGRectMake(5, 5 + textViewFrame.size.height + textViewFrame.origin.y, dataModel.imageSize.width + 1, dataModel.imageSize.height);
    const CGRect cardImageViewFrame = CGRectMake(self.cardImageView.frame.origin.x, self.cardImageView.frame.origin.y, self.cardImageView.frame.size.width, dataModel.rowHeight - dataModel.commentTableViewHeight - 40.0);
    const CGRect timeLabelFrame = CGRectMake(self.timeLabel.frame.origin.x, CGRectGetMaxY(cardImageViewFrame) - 30, self.timeLabel.frame.size.width,self.timeLabel.frame.size.height);
    const CGRect addButtonFrame = CGRectMake(CGRectGetMaxX(self.cardImageView.frame)  - 38 , timeLabelFrame.origin.y , 27.5, 27);
    const CGRect iconImageViewFrame = CGRectMake(230, timeLabelFrame.origin.y + 5, 27, 17);
    
    self.textView.text = dataModel.rawText;
    self.textView.frame = textViewFrame;
    // 加载图片
    [self.picImageView setImageWithURL:[NSURL URLWithString:dataModel.bmiddleImageURL] placeholderImage:dataModel.thumbnailImage];
    self.nameLabel.text = dataModel.userName;
    self.picImageView.frame = imageViewFrame;
    self.cardImageView.frame = cardImageViewFrame;
    self.timeLabel.text = [[dataModel.time description] substringToIndex:16];
    self.timeLabel.frame = timeLabelFrame;
    self.addButton.frame = addButtonFrame;
    self.iconImageView.frame = iconImageViewFrame;
    
    if(dataModel.commentArray && [dataModel.commentArray count] > 0)  // 处理评论
    {
        self.commentBackgroundImageView.hidden = NO;
        self.dataModel = dataModel;
        // 设置评论表的Frame
        self.commentBackgroundImageView.frame = CGRectMake(self.commentBackgroundImageView.frame.origin.x, cardImageViewFrame.origin.x + cardImageViewFrame.size.height - 9, self.commentBackgroundImageView.frame.size.width, dataModel.commentTableViewHeight + 24);
        self.commentTableView.frame = CGRectMake(self.commentTableView.frame.origin.x, 17, self.commentTableView.frame.size.width, dataModel.commentTableViewHeight );
        [self.commentTableView reloadData];
    }
    else
    {
        self.commentBackgroundImageView.hidden = YES;  // 隐藏试试,避免dealloc它
        self.dataModel = nil;
    }
    
    // for theme
    UIEdgeInsets insets = UIEdgeInsetsMake(30, 130, 30, 130);
    UIImage *image = [[TPTheme currentBubbleImage] resizableImageWithCapInsets:insets];
    self.cardImageView.image = image;
    UIEdgeInsets commentBackgroundImageInsets = UIEdgeInsetsMake(20, 25, 10, 25);
    UIImage *commentBackgroundImage = [[TPTheme currentCommentBackgroundImage] resizableImageWithCapInsets:commentBackgroundImageInsets];
    self.commentBackgroundImageView.image = commentBackgroundImage;
}

@end

@implementation TPTimelineTableViewRepostTextCell  // 2

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 背景色块
        self.repostBackgroundImageView=[[UIImageView alloc] initWithFrame:CGRectZero];
        UIEdgeInsets insets = UIEdgeInsetsMake(11, 40, 16, 39);
        UIImage *image = [[UIImage imageNamed:@"zhuanfakuang3.png"] resizableImageWithCapInsets:insets];
        self.repostBackgroundImageView.image = image;
        [self.cardImageView addSubview:self.repostBackgroundImageView];
        // 转发文本
        self.repostTextView = [[TQRichTextView alloc] init];
        self.repostTextView.backgroundColor = [UIColor clearColor];
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
    const CGRect cardImageViewFrame = CGRectMake(self.cardImageView.frame.origin.x, self.cardImageView.frame.origin.y, self.cardImageView.frame.size.width, dataModel.rowHeight - dataModel.commentTableViewHeight - 40.0);
    const CGRect timeLabelFrame = CGRectMake(self.timeLabel.frame.origin.x, CGRectGetMaxY(cardImageViewFrame) - 30, self.timeLabel.frame.size.width,self.timeLabel.frame.size.height);
    const CGRect addButtonFrame = CGRectMake(CGRectGetMaxX(self.cardImageView.frame)  - 38 , timeLabelFrame.origin.y , 27.5, 27);
    const CGRect iconImageViewFrame = CGRectMake(230, timeLabelFrame.origin.y + 5, 27, 17);
    
    self.textView.text = dataModel.rawText;
    self.textView.frame = textViewFrame;
    self.nameLabel.text = dataModel.userName;
    self.repostTextView.text = dataModel.rawRepostText;
    self.repostTextView.frame = repostTextViewFrame;
    self.repostBackgroundImageView.frame = repostBackfroundImageViewFrame;
    self.cardImageView.frame = cardImageViewFrame;
    self.timeLabel.text = [[dataModel.time description] substringToIndex:16];
    self.timeLabel.frame = timeLabelFrame;
    self.addButton.frame = addButtonFrame;
    self.iconImageView.frame = iconImageViewFrame;
    
    if(dataModel.commentArray && [dataModel.commentArray count] > 0)  // 处理评论
    {
        self.commentBackgroundImageView.hidden = NO;
        self.dataModel = dataModel;
        // 设置评论表的Frame
        self.commentBackgroundImageView.frame = CGRectMake(self.commentBackgroundImageView.frame.origin.x, cardImageViewFrame.origin.x + cardImageViewFrame.size.height - 9, self.commentBackgroundImageView.frame.size.width, dataModel.commentTableViewHeight + 24);
        self.commentTableView.frame = CGRectMake(self.commentTableView.frame.origin.x, 17, self.commentTableView.frame.size.width, dataModel.commentTableViewHeight );
        [self.commentTableView reloadData];
    }
    else
    {
        self.commentBackgroundImageView.hidden = YES;  // 隐藏试试,避免dealloc它
        self.dataModel = nil;
    }
    
    // for theme
    UIEdgeInsets insets = UIEdgeInsetsMake(30, 130, 30, 130);
    UIImage *image = [[TPTheme currentBubbleImage] resizableImageWithCapInsets:insets];
    self.cardImageView.image = image;
    UIEdgeInsets commentBackgroundImageInsets = UIEdgeInsetsMake(20, 25, 10, 25);
    UIImage *commentBackgroundImage = [[TPTheme currentCommentBackgroundImage] resizableImageWithCapInsets:commentBackgroundImageInsets];
    self.commentBackgroundImageView.image = commentBackgroundImage;
}

@end

@implementation TPTimelineTableViewRepostTextWithImageCell  // 3

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 图片
        self.picImageView=[[UIImageView alloc] init];
        self.picImageView.contentMode = UIViewContentModeScaleAspectFit;
        self.picImageView.layer.masksToBounds = YES;
        [self.repostBackgroundImageView addSubview:self.picImageView];
    }
    return self;
}

- (void)setDisplayData:(TPWeiboDataModel *)dataModel
{
    
    const CGRect textViewFrame = CGRectMake(self.textView.frame.origin.x, self.textView.frame.origin.y, dataModel.textSize.width, dataModel.textSize.height);
    const CGRect repostTextViewFrame = CGRectMake(12, 20 , dataModel.repostTextSize.width, dataModel.repostTextSize.height);
    const CGRect imageViewFrame = CGRectMake(1, 5 + repostTextViewFrame.size.height + repostTextViewFrame.origin.y, dataModel.imageSize.width - 2, dataModel.imageSize.height);
    const CGRect repostBackfroundImageViewFrame = CGRectMake(textViewFrame.origin.x, 5 + textViewFrame.size.height + textViewFrame.origin.y, textViewFrame.size.width , repostTextViewFrame.size.height  + imageViewFrame.size.height + 35);
    const CGRect cardImageViewFrame = CGRectMake(self.cardImageView.frame.origin.x, self.cardImageView.frame.origin.y, self.cardImageView.frame.size.width, dataModel.rowHeight - dataModel.commentTableViewHeight - 40.0);
    const CGRect timeLabelFrame = CGRectMake(self.timeLabel.frame.origin.x, CGRectGetMaxY(cardImageViewFrame) - 30, self.timeLabel.frame.size.width,self.timeLabel.frame.size.height);
    const CGRect addButtonFrame = CGRectMake(CGRectGetMaxX(self.cardImageView.frame)  - 38 , timeLabelFrame.origin.y , 27.5, 27);
    const CGRect iconImageViewFrame = CGRectMake(230, timeLabelFrame.origin.y + 5, 27, 17);
    
    self.textView.text = dataModel.rawText;
    self.textView.frame = textViewFrame;
    self.nameLabel.text = dataModel.userName;
    self.repostTextView.text = dataModel.rawRepostText;
    self.repostTextView.frame = repostTextViewFrame;
    self.repostBackgroundImageView.frame = repostBackfroundImageViewFrame;
    self.cardImageView.frame = cardImageViewFrame;
    self.picImageView.frame = imageViewFrame;
    // 加载图片
    [self.picImageView setImageWithURL:[NSURL URLWithString:dataModel.bmiddleImageURL] placeholderImage:dataModel.thumbnailImage];
    self.timeLabel.text = [[dataModel.time description] substringToIndex:16];
    self.timeLabel.frame = timeLabelFrame;
    self.addButton.frame = addButtonFrame;
    self.iconImageView.frame = iconImageViewFrame;
    
    if(dataModel.commentArray && [dataModel.commentArray count] > 0)  // 处理评论
    {
        self.commentBackgroundImageView.hidden = NO;
        self.dataModel = dataModel;
        // 设置评论表的Frame
        self.commentBackgroundImageView.frame = CGRectMake(self.commentBackgroundImageView.frame.origin.x, cardImageViewFrame.origin.x + cardImageViewFrame.size.height - 9, self.commentBackgroundImageView.frame.size.width, dataModel.commentTableViewHeight + 24);
        self.commentTableView.frame = CGRectMake(self.commentTableView.frame.origin.x, 17, self.commentTableView.frame.size.width, dataModel.commentTableViewHeight );
        [self.commentTableView reloadData];
    }
    else
    {
        self.commentBackgroundImageView.hidden = YES;  // 隐藏试试,避免dealloc它
        self.dataModel = nil;
    }
    
    // for theme
    UIEdgeInsets insets = UIEdgeInsetsMake(30, 130, 30, 130);
    UIImage *image = [[TPTheme currentBubbleImage] resizableImageWithCapInsets:insets];
    self.cardImageView.image = image;
    UIEdgeInsets commentBackgroundImageInsets = UIEdgeInsetsMake(20, 25, 10, 25);
    UIImage *commentBackgroundImage = [[TPTheme currentCommentBackgroundImage] resizableImageWithCapInsets:commentBackgroundImageInsets];
    self.commentBackgroundImageView.image = commentBackgroundImage;
}

@end
