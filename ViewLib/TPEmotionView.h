//
//  TPEmotionView.h
//  TPSinaWeiboSDK
//
//  Created by simon on 13-9-14.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TPEmotionViewHandler)(NSString *emotionStr);

@interface TPEmotionView : UIView<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *emotionScrollView;
@property (nonatomic,strong) NSArray *emotionsArray1;
@property (nonatomic,strong) NSArray *emotionsArray2;
@property (nonatomic,strong) UIPageControl *emotionPageControl;
@property (nonatomic,strong) TPEmotionViewHandler handler;

@end
