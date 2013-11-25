//
//  TPZoomImageView.m
//  TimePill
//
//  Created by yan simon on 13-9-29.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "TPZoomImageView.h"

@interface TPZoomImageView ()

@property(nonatomic, assign) float rate; // 宽高比
@property(nonatomic, assign) CGRect windowRect;

@end

@implementation TPZoomImageView

- (id)initWithCustomViews:(NSArray *)array {
    self = [self init];
    if (self) {
        if (array) {
            for (UIView *view in array) {
                [self addSubview:view];
            }
        }
    }
    return self;
}

- (id)initWithLongPressHandler:(TPZoomImageViewLongPressHandler)hander {
    self = [self init];
    if (self) {
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        [self addGestureRecognizer:longPress];
        self.longPressHandler = hander;
    }
    return self;
}

- (id)init
{
    self.windowRect = [[UIApplication sharedApplication] keyWindow].frame;
    self = [super initWithFrame:CGRectMake(0, 0, 320, self.windowRect.size.height)];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        // 背景滚动视图
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
        self.scrollView.delegate = self;
        self.scrollView.maximumZoomScale = 5.0;
        self.scrollView.zoomScale = 1.0;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = YES;
        [self addSubview:self.scrollView];
        
        // ImageView
        self.imageView = [[UIImageView alloc] initWithFrame:self.frame];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.scrollView addSubview:self.imageView];
        self.scrollView.scrollEnabled = YES;
        
        // 支持Tap手势
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(UserClicked:)];
        [self addGestureRecognizer:tap];
        
        // 进度
        self.progressView = [[DACircularProgressView alloc] initWithFrame:CGRectMake(self.frame.size.width/2-15, self.frame.size.height/2-15, 30, 30)];
        [self addSubview:self.progressView];
        
        self.rate = self.windowRect.size.width / self.windowRect.size.height;
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

-(void)showWithBmiddleURL:(NSString *)bmiddleUrl ThumbnailImage:(UIImage *)image
{
    self.progressView.hidden = YES;
    
    // reset imageView's frame
    if (image.size.width / image.size.height < self.rate) {
        float newHeight = self.imageView.frame.size.width * image.size.height / image.size.width;
        self.imageView.frame = CGRectMake(self.imageView.frame.origin.x, self.imageView.frame.origin.y, self.imageView.frame.size.width, newHeight);
    } else {
        self.imageView.frame = self.windowRect;
    }
    
    __weak TPZoomImageView *weakSelf = self;
    [self.imageView setImageWithURL:[NSURL URLWithString:bmiddleUrl] placeholderImage:image options:0 progress:^(NSUInteger receivedSize, long long expectedSize)
     {
         weakSelf.progressView.hidden = NO;
         if (expectedSize > 0) {
             float rate = (float)receivedSize / (float)expectedSize;
             weakSelf.progressView.progress = rate;
             
         }
     }
    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType)
     {
         weakSelf.progressView.hidden = YES;
     }];
    
    [self show];
}

-(void)showWithImage:(UIImage *)image {
    
    // reset imageView's frame
    if (image.size.width / image.size.height < self.rate) {
        float newHeight = self.imageView.frame.size.width * image.size.height / image.size.width;
        self.imageView.frame = CGRectMake(self.imageView.frame.origin.x, self.imageView.frame.origin.y, self.imageView.frame.size.width, newHeight);
    } else {
        self.imageView.frame = self.windowRect;
    }
    
    self.progressView.hidden = YES;
    self.imageView.image = image;
    [self show];
}

-(void)show
{
    self.scrollView.zoomScale = 1.0;
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    self.imageView.alpha = 0.0;
    self.alpha = 1.0;
    [UIView animateWithDuration:0.2 animations:^{
        self.backgroundColor=[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.85];
        self.imageView.alpha=1.0;}];
}

-(void)UserClicked:(UIGestureRecognizer *)sender
{
    [self dismiss];
    
}

-(void)handleLongPress:(UIGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"删除", nil];
        [sheet showInView:self];
    }
    
}

-(void)dismiss {
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0.0;
        ;} completion:^(BOOL finished)
     {
         [self removeFromSuperview];
     }];
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        self.longPressHandler();
        [self dismiss];
    }
}

#pragma mark UIScrollViewDelegate
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}
-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
//    CGFloat zs = scrollView.zoomScale;
//    zs = MAX(zs, 0.1);
//    zs = MIN(zs, 5.0);
//    
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration:0.3];
//    scrollView.zoomScale = zs;
//    [UIView commitAnimations];
}

@end
