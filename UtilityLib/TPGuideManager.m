//
//  TPGuideManager.m
//  TimePill
//
//  Created by yan simon on 13-12-12.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "TPGuideManager.h"

static TPGuideManager *instance = nil;

@implementation TPGuideManager

+ (instancetype)sharedInstance
{
    if (!instance) {
        instance = [[TPGuideManager alloc] init];
    }
    return instance;
}

#define kMenuGuideTag 100
- (void)showMenuGuide
{
    BOOL i = [[NSUserDefaults standardUserDefaults] boolForKey:kTPFirstShowExtendedBarKey];
    if (!i) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
        imageView.image = [UIImage imageNamed:@"guide.png"];
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        if (!IS_IPHONE_5) {
            imageView.frame = CGRectMake(imageView.frame.origin.x, - 88, imageView.frame.size.width, imageView.frame.size.height);
        }
        imageView.tag = kMenuGuideTag;
        imageView.alpha = 0.0;
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
        [window addSubview:imageView];
        [UIView animateWithDuration:0.5f animations:^{imageView.alpha = 1.0;} completion:^(BOOL finished) {imageView.alpha = 1.0;}];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kTPFirstShowExtendedBarKey];
    }
    
}

- (void)removeAllGuides
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    UIView *imageView = [window viewWithTag:kMenuGuideTag];
    [imageView removeFromSuperview];
    canShow = NO;
}

#pragma mark private
- (void)tap:(id)sender
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    UIView *imageView = [window viewWithTag:kMenuGuideTag];
    [UIView animateWithDuration:0.1f animations:^{imageView.alpha = 0.0;} completion:^(BOOL finished) {
    imageView.alpha = 0.0;
    [imageView removeFromSuperview];}];
    
}

@end
