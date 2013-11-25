//
//  TPFriendDataModel.m
//  TimePill
//
//  Created by simon on 13-9-28.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "TPFriendDataModel.h"

@implementation TPFriendDataModel

-(id)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        [self setupFriendDataModalWithDictionary:dic];
    }
    return self;
}

-(void)setupFriendDataModalWithDictionary:(NSDictionary *)dic
{
    self.userID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
    self.name = [dic objectForKey:@"screen_name"];
    self.profileImageURL = [dic objectForKey:@"profile_image_url"];
}

#pragma mark NSCoding
#define kFriendDataModelUserIDKey @"kFriendDataModelUserIDKey"
#define kFriendDataModelNameKey @"kFriendDataModelNameKey"
#define kFriendDataModelProfileImageURLKey @"kFriendDataModelProfileImageURLKey"
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.userID forKey:kFriendDataModelUserIDKey];
    [aCoder encodeObject:self.name forKey:kFriendDataModelNameKey];
    [aCoder encodeObject:self.profileImageURL forKey:kFriendDataModelProfileImageURLKey];
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self.userID = [aDecoder decodeObjectForKey:kFriendDataModelUserIDKey];
    self.name = [aDecoder decodeObjectForKey:kFriendDataModelNameKey];
    self.profileImageURL = [aDecoder decodeObjectForKey:kFriendDataModelProfileImageURLKey];
    return self;
}

@end
