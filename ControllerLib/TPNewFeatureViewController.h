//
//  TPNewFeatherViewController.h
//  TimePill
//
//  Created by yan simon on 13-10-24.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface TPNewFeatureViewController : UIViewController<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *pageScroll;
@property (strong, nonatomic) UIPageControl *pageControl;

- (void) show;
- (void) dismiss;

@end
