//
//  TPUtil.h
//  TimePill

//  各种缓存

//  Created by yan simon on 13-9-22.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TPUtil : NSObject

@property (nonatomic, retain) NSString* savePath;

+ (id)sharedInstance;

- (BOOL)saveTimelineList:(NSMutableArray *)array;

- (NSMutableArray *)TimelineList;

- (BOOL)saveUserInfo:(id)model;

- (id)userInfoModel;

- (BOOL)saveFriendList:(NSMutableArray *)array;

- (NSMutableArray *)FriendList;

- (BOOL)saveWeiboList:(NSMutableArray *)array UIN:(NSString *)uin;

- (NSMutableArray *)weiboListForUIN:(NSString *)uin;

@end
