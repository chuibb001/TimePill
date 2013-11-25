//
//  TPUtil.m
//  TimePill
//
//  Created by yan simon on 13-9-22.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "TPUtil.h"
#import <CommonCrypto/CommonDigest.h>
#import <mach/mach.h>
#import <mach/mach_host.h>

@implementation TPUtil

static TPUtil *instance = nil;

+ (id)sharedInstance
{
    if (nil == instance) {
        instance = [[TPUtil alloc] init];
    }
    return instance;
}

- (BOOL)saveTimelineList:(NSMutableArray *)array
{
    return [NSKeyedArchiver archiveRootObject:array toFile:[self TimelineListFliePath]];
}

- (NSMutableArray *)TimelineList
{
    NSFileManager *defaultFileManager = [NSFileManager defaultManager];
    if (YES == [defaultFileManager fileExistsAtPath:[self TimelineListFliePath]])
    {
        NSData *data = [defaultFileManager contentsAtPath:[self TimelineListFliePath]];
        return (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    return nil;
}

- (BOOL)saveUserInfo:(id)model
{
    return [NSKeyedArchiver archiveRootObject:model toFile:[self userInfoModelFliePath]];
}

- (id)userInfoModel
{
    NSFileManager *defaultFileManager = [NSFileManager defaultManager];
    if (YES == [defaultFileManager fileExistsAtPath:[self userInfoModelFliePath]])
    {
        NSData *data = [defaultFileManager contentsAtPath:[self userInfoModelFliePath]];
        return (id)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    return nil;
}

- (BOOL)saveFriendList:(NSMutableArray *)array
{
    return [NSKeyedArchiver archiveRootObject:array toFile:[self friendListFliePath]];
}

- (NSMutableArray *)FriendList
{
    NSFileManager *defaultFileManager = [NSFileManager defaultManager];
    if (YES == [defaultFileManager fileExistsAtPath:[self friendListFliePath]])
    {
        NSData *data = [defaultFileManager contentsAtPath:[self friendListFliePath]];
        return (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    return nil;
}

- (BOOL)saveWeiboList:(NSMutableArray *)array UIN:(NSString *)uin
{
    return [NSKeyedArchiver archiveRootObject:array toFile:[self weiboListFliePathForUIN:uin]];
}

- (NSMutableArray *)weiboListForUIN:(NSString *)uin
{
    NSFileManager *defaultFileManager = [NSFileManager defaultManager];
    if (YES == [defaultFileManager fileExistsAtPath:[self weiboListFliePathForUIN:uin]])
    {
        NSData *data = [defaultFileManager contentsAtPath:[self weiboListFliePathForUIN:uin]];
        return (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    return nil;
}
#pragma mark Path
- (NSString *)saveDirection{
    do {
        NSFileManager *defaultFileManager = [NSFileManager defaultManager];
        if (self.savePath && [defaultFileManager fileExistsAtPath:self.savePath]){
            break;
        }
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        if ([paths count] == 0){
            break;
        }
        
        NSString *docPath = [paths objectAtIndex:0];
        NSString *aDirectionPath = [docPath stringByAppendingPathComponent:@"TimePill"];
        [self checkDirectionAndCreateIfNeed:aDirectionPath];
        self.savePath = aDirectionPath;
    } while (0);
    
    return self.savePath;
}

- (void) checkDirectionAndCreateIfNeed:(NSString*)dirPath{
    BOOL isDirection = NO;
    if (![[NSFileManager defaultManager] fileExistsAtPath:dirPath isDirectory:&isDirection] ||
        !isDirection){
        [[NSFileManager defaultManager] createDirectoryAtPath:dirPath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
    }
}

- (NSString*)TimelineListFliePath
{
    return [[self saveDirection] stringByAppendingPathComponent: @"timeline.list"];
}
- (NSString*)userInfoModelFliePath
{
    return [[self saveDirection] stringByAppendingPathComponent: @"userInfo.model"];
}
- (NSString*)friendListFliePath
{
    return [[self saveDirection] stringByAppendingPathComponent: @"friends.list"];
}
- (NSString*)weiboListFliePathForUIN:(NSString *)uin
{
    const char *str = [uin UTF8String];
    if (str == NULL)
    {
        str = "";
    }
    unsigned char r[16];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    
    return [[self saveDirection] stringByAppendingPathComponent:filename];
}
@end
