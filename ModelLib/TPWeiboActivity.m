//
//  TPWeiboActivity.m
//  TimePill
//
//  Created by yan simon on 13-12-12.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "TPWeiboActivity.h"

@implementation TPWeiboActivity

- (NSString *)activityType
{
    return NSStringFromClass([self class]);
}

- (NSString *)activityTitle
{
    return @"新浪微博";
}

- (UIImage *)activityImage
{
    return nil;
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems
{
    return NO;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems
{
    
}

- (void)performActivity
{
    
}
@end
