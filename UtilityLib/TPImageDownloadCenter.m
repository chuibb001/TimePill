//
//  TPImageDownloadCenter.m
//  TPSinaWeiboSDK
//
//  Created by yan simon on 13-9-13.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "TPImageDownloadCenter.h"

@implementation TPImageDownloadCenter

static TPImageDownloadCenter *instance = nil;

+(id)sharedInstance
{
    if(!instance)
        instance = [[TPImageDownloadCenter alloc] init];
    
    return instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.requestsList = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)loadImageWithURL:(NSString *)urlString Type:(TPWeiboImageType)type ViewDelegate:(id<TPAbstractViewDelegate>)viewDelegate ModelDelegate:(id<TPAbstractModelDelegate>) modelDelegate ProgressDelegate:(id<TPAbstractProgressDelegate>) progressDelegate
{
    TPImageDownloader *downloader = [[TPImageDownloader alloc] init];
    downloader.urlString = urlString;
    downloader.type = type;
    downloader.viewDelegate = viewDelegate;
    downloader.modelDelegate = modelDelegate;
    downloader.progressDelegate = progressDelegate;
    // completion hanlder
    __weak TPImageDownloader * weakRef = downloader;
    downloader.handler = ^(TPImageDownloaderErrorCode code)
    {
        [self removeRequest:weakRef];
    };
    [self.requestsList addObject:downloader];  // keep a refrence
    [downloader loadImage];
}

-(void)CancelAllRequests
{
    for(TPImageDownloader *downloader in self.requestsList)
    {
        [downloader cancel];
    }
}

#pragma mark private
-(void)removeRequest:(TPImageDownloader *)downloader
{
    [self.requestsList removeObject:downloader]; // remove a refrence
}

@end
