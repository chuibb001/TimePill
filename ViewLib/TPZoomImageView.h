//
//  TPZoomImageView.h
//  TimePill
//
//  Created by yan simon on 13-9-29.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DACircularProgressView.h"
#import "TPImageDownloadCenter.h"
#import "UIImageView+WebCache.h"

typedef void (^TPZoomImageViewHandler)(UIImage *bmiddleImage);
typedef void (^TPZoomImageViewLongPressHandler)(void);

@interface TPZoomImageView : UIView<UIScrollViewDelegate,UIActionSheetDelegate>

@property(nonatomic, strong) UIImage *thumbnailImage;
@property(nonatomic, strong) UIImage *bmiddleImage;
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) DACircularProgressView *progressView;
@property(nonatomic, strong) TPZoomImageViewHandler handler;  // 大图回调
@property(nonatomic, strong) TPZoomImageViewLongPressHandler longPressHandler; // 长按回调

-(id)initWithCustomViews:(NSArray *)array;

-(void)showWithBmiddleURL:(NSString *)bmiddleUrl ThumbnailImage:(UIImage *)image;

-(void)showWithImage:(UIImage *)image;

-(void)dismiss;

- (id)initWithLongPressHandler:(TPZoomImageViewLongPressHandler)hander;

@end
