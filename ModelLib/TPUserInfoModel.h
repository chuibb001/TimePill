//
//  TPUserInfoModel.h
//  TimePill
//
//  Created by yan simon on 13-9-24.
//  Copyright (c) 2013年 simon. All rights reserved.
//
#pragma once
#import <Foundation/Foundation.h>
#import "TPImageDownloadCenter.h"
#import "TPUtil.h"

@interface TPUserInfoModel : NSObject<NSCoding,NSCopying>

@property (nonatomic,strong) NSString *userID;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *profileImageURL;
@property (nonatomic,strong) UIImage *profileImage;
@property (nonatomic,assign) BOOL isPersonallySet;

+(id)sharedInstance;

@end
