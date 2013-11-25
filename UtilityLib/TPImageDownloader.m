//
//  TPImageDownloader.m
//  TPSinaWeiboSDK
//
//  Created by yan simon on 13-9-13.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "TPImageDownloader.h"

@implementation TPImageDownloader

-(void)loadImage
{
    NSURL *url = [NSURL URLWithString:self.urlString];
    request = [ASIHTTPRequest requestWithURL:url];
    request.downloadProgressDelegate = self;
    request.delegate = self;
    [request startAsynchronous];
}
-(void)cancel
{
    self.viewDelegate = nil;
    self.progressDelegate = nil;
    self.modelDelegate = nil;
    [request clearDelegatesAndCancel];
    request = nil;
}

#pragma mark ASIHTTPRequestDelegate
-(void)requestStarted:(ASIHTTPRequest *)request
{
    self.responseData = [[NSMutableData alloc] init];
}
-(void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders
{
    NSNumber *number = responseHeaders[@"Content-Length"];
    
    totalBytes = [number integerValue];
}
-(void)request:(ASIHTTPRequest *)request didReceiveData:(NSData *)data
{
    [self.responseData appendData:data];
    
    accumulateBytes += [data length];
    
    float percent = accumulateBytes / totalBytes;
    
    // 回调更新进度
    if(self.progressDelegate && [self.progressDelegate respondsToSelector:@selector(updateProgress:)])
        [self.progressDelegate updateProgress:percent];
}
-(void)requestFinished:(ASIHTTPRequest *)request
{
    UIImage *image = [UIImage imageWithData:self.responseData];
    
    // 回调更新视图
    if(self.viewDelegate && [self.viewDelegate respondsToSelector:@selector(updateViewWithImage:)])
        [self.viewDelegate updateViewWithImage:image];
    
    // 回调进行缓存
    if(self.modelDelegate && [self.modelDelegate respondsToSelector:@selector(cacheWithImage:type:)])
        [self.modelDelegate cacheWithImage:image type:self.type];
    
    self.handler(TPImageDownloaderSuccess);
    
}
-(void)requestFailed:(ASIHTTPRequest *)request
{
    self.responseData = nil;
    
    if(self.viewDelegate && [self.viewDelegate respondsToSelector:@selector(updateViewWithImage:)])
        [self.viewDelegate updateViewWithImage:nil];
    
    if(self.modelDelegate && [self.modelDelegate respondsToSelector:@selector(cacheWithImage:)])
        [self.modelDelegate cacheWithImage:nil type:self.type];
    
    self.handler(TPImageDownloaderFail);
}

#pragma mark ASIProgressDelegate
-(void)setProgress:(float)newProgress
{
    //NSLog(@"%f",newProgress);
}

@end
