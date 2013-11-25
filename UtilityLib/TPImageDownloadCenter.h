//
//  TPImageDownloadCenter.h
//  TPSinaWeiboSDK
//
//  Created by yan simon on 13-9-13.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TPImageDownloader.h"

@interface TPImageDownloadCenter : NSObject

@property (nonatomic,strong) NSMutableArray *requestsList;

+(id)sharedInstance;

-(void)loadImageWithURL:(NSString *)urlString Type:(TPWeiboImageType)type ViewDelegate:(id<TPAbstractViewDelegate>)viewDelegate ModelDelegate:(id<TPAbstractModelDelegate>) modelDelegate ProgressDelegate:(id<TPAbstractProgressDelegate>) progressDelegate;

// 当DataModel被销毁时要取消,否则delegate是野指针,有需要可以写一个CancelRequestWithType:
-(void)CancelAllRequests;  

@end
