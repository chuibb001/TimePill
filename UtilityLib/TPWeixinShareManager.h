//
//  TPWeixinShareManager.h
//  TimePill
//
//  Created by yan simon on 13-12-12.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
#import "WXApiObject.h"
#import "TPLongWeiboManager.h"

@interface TPWeixinShareManager : NSObject

/**
 *  单例
 */
+ (instancetype)sharedInstance;

/**
 *  分享照片到朋友圈
 */
- (void)sendImageToTimeline:(UIImage *)image;

/**
 *  分享照片给微信好友
 */
- (void)sendImageToSession:(UIImage *)image;

@end
