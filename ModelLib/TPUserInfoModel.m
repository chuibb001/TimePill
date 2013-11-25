//
//  TPUserInfoModel.m
//  TimePill
//
//  Created by yan simon on 13-9-24.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "TPUserInfoModel.h"

@implementation TPUserInfoModel

static TPUserInfoModel *instance = nil;

+(id)sharedInstance
{
    if(!instance)
        instance = [[TPUtil sharedInstance] userInfoModel];
    if(!instance)
        instance = [[TPUserInfoModel alloc] init];
    
    return instance;
}

#pragma mark NSCoding

#define kTPUserInfoModelUserIDKey @"kTPUserInfoModelUserIDKey"
#define kTPUserInfoModelNameKey @"kTPUserInfoModelNameKey"
#define kTPUserInfoModelProfileImageURLKey @"kTPUserInfoModelProfileImageURLKey"
#define kTPUserInfoModelProfileImageKey @"kTPUserInfoModelProfileImageKey"
#define kTPUserInfoModelIsSetKey @"kTPUserInfoModelIsSetKey"
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.userID forKey:kTPUserInfoModelUserIDKey];
    [aCoder encodeObject:self.name forKey:kTPUserInfoModelNameKey];
    [aCoder encodeObject:self.profileImageURL forKey:kTPUserInfoModelProfileImageURLKey];
    [aCoder encodeObject:self.profileImage forKey:kTPUserInfoModelProfileImageKey];
    [aCoder encodeBool:self.isPersonallySet forKey:kTPUserInfoModelIsSetKey];
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self.userID = [aDecoder decodeObjectForKey:kTPUserInfoModelUserIDKey];
    self.name = [aDecoder decodeObjectForKey:kTPUserInfoModelNameKey];
    self.profileImageURL = [aDecoder decodeObjectForKey:kTPUserInfoModelProfileImageURLKey];
    self.profileImage = [aDecoder decodeObjectForKey:kTPUserInfoModelProfileImageKey];
    self.isPersonallySet = [aDecoder decodeBoolForKey:kTPUserInfoModelIsSetKey];
    return self;
}
#pragma mark TPAbstractModelDelegate
-(void)cacheWithImage:(UIImage *)image type:(TPWeiboImageType)type   // 缓存数据
{
    self.profileImage = image;
}
@end
