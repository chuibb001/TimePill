//
//  TPWeixinShareManager.m
//  TimePill
//
//  Created by yan simon on 13-12-12.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "TPWeixinShareManager.h"

static TPWeixinShareManager *instance = nil;

@implementation TPWeixinShareManager

+ (instancetype)sharedInstance
{
    if (!instance) {
        instance = [[TPWeixinShareManager alloc] init];
    }
    return instance;
}

- (void)sendImageToTimeline:(UIImage *)image
{
    WXMediaMessage *message = [WXMediaMessage message];
    UIImage *thumbnailImage = [[TPLongWeiboManager sharedInstance] resizeImage:image];
    [message setThumbImage:thumbnailImage];
    
    WXImageObject *imageObject = [WXImageObject object];
    imageObject.imageData = UIImageJPEGRepresentation(image , 0.6);
    
    message.mediaObject = imageObject;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneTimeline;
    [WXApi sendReq:req];
}

- (void)sendImageToSession:(UIImage *)image
{
    WXMediaMessage *message = [WXMediaMessage message];
    UIImage *thumbnailImage = [[TPLongWeiboManager sharedInstance] resizeImage:image];
    [message setThumbImage:thumbnailImage];
    
    WXImageObject *imageObject = [WXImageObject object];
    imageObject.imageData = UIImageJPEGRepresentation(image , 0.6);
    
    message.mediaObject = imageObject;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;
    [WXApi sendReq:req];
}

@end
