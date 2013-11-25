//
//  TPImageDownloader.h
//  TPSinaWeiboSDK
//
//  Created by yan simon on 13-9-13.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
//#import "TPImageDownloadCenter.h"

typedef enum
{
    TPWeiboImageTypeThumbnail,
    TPWeiboImageTypeBmiddle,
    TPWeiboImageTypeOriginal,
    TPWeiboImageTypeHead
}
TPWeiboImageType;

typedef enum
{
    TPImageDownloaderSuccess,
    TPImageDownloaderFail
}
TPImageDownloaderErrorCode;

/*-----------------------------------
    抽象View接口,用于下载完后更新视图
 ------------------------------------*/
@protocol TPAbstractViewDelegate <NSObject>

-(void)updateViewWithImage:(UIImage *)image;

@end

/*-----------------------------------
    抽象Model接口,用于下载完后缓存图像
 ------------------------------------*/
@protocol TPAbstractModelDelegate <NSObject>

-(void)cacheWithImage:(UIImage *)image type:(TPWeiboImageType)type;

@end

/*-----------------------------------
    抽象Progress接口,用于下载时更新进度
 ------------------------------------*/
@protocol TPAbstractProgressDelegate <NSObject>

-(void)updateProgress:(float)progress;

@end

typedef void (^TPImageDownloaderHandler)(TPImageDownloaderErrorCode code);  // 对Center的回调
 
@interface TPImageDownloader : NSObject<ASIProgressDelegate,ASIHTTPRequestDelegate>
{
    int totalBytes;
    int accumulateBytes;
    ASIHTTPRequest *request;
}

@property (nonatomic,strong) NSString *urlString;
@property (nonatomic,weak) id<TPAbstractViewDelegate>     viewDelegate;
@property (nonatomic,weak) id<TPAbstractModelDelegate>     modelDelegate;
@property (nonatomic,weak) id<TPAbstractProgressDelegate> progressDelegate;
@property (nonatomic,strong) NSMutableData *responseData;
@property (nonatomic,assign) TPWeiboImageType type;
@property (nonatomic,strong) TPImageDownloaderHandler handler;

-(void)loadImage;
-(void)cancel;

@end
