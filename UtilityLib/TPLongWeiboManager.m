//
//  TPLongWeiboManager.m
//  TimePill
//
//  Created by yan simon on 13-10-12.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "TPLongWeiboManager.h"
#import <CommonCrypto/CommonDigest.h>
#import <mach/mach.h>
#import <mach/mach_host.h>

#define kTPImageIDKey @"kTPImageIDKey"
#define kTPThumnailImageKey @"kTPThumnailImageKey"
#define kTPCurrentIDKey @"kTPCurrentIDKey"

#define kTPResizeRate 2

@implementation TPLongWeiboItemInfo

#pragma mark NSCoding
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.thumnailImage forKey:kTPThumnailImageKey];
    [aCoder encodeInteger:self.imageID forKey:kTPImageIDKey];
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self.thumnailImage = [aDecoder decodeObjectForKey:kTPThumnailImageKey];
    self.imageID = [aDecoder decodeIntegerForKey:kTPImageIDKey];
    return self;
}

@end

static TPLongWeiboManager *instance = nil;

@implementation TPLongWeiboManager

+ (id)sharedInstance{
    if (nil == instance) {
        instance = [[TPLongWeiboManager alloc] init];
    }
    return instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.currentID = [[NSUserDefaults standardUserDefaults] integerForKey:kTPCurrentIDKey];
    }
    return self;
}

- (void)saveLongWeibo:(UIImage *)image completionHandler:(LongWeiboHandler)handler{
    // prepare data
    UIImage *thumbnail = [self resizeImage:image];
    self.currentID ++;
    [[NSUserDefaults standardUserDefaults] setInteger:self.currentID forKey:kTPCurrentIDKey];
    TPLongWeiboItemInfo *info = [[TPLongWeiboItemInfo alloc] init];
    info.imageID = self.currentID;
    info.thumnailImage = thumbnail;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 先存缩略
        BOOL success = [NSKeyedArchiver archiveRootObject:info toFile:[self ThumbnailFliePath]];
        
        // 再存大图
        if (success) {
            NSData *data = UIImageJPEGRepresentation(image, 1.0);
            success = [data writeToFile:[self OriginalFliePath] atomically:YES];
        }
        
        // 主线程回调
        dispatch_async(dispatch_get_main_queue(), ^{
            handler(success);
        });
    });
}

- (void)readAllThumbnailImagesWithCompletionHandler:(ThumnailImageHandler)handler{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        NSError *error = nil;
        NSArray *allFileNames = [fileManager contentsOfDirectoryAtPath:[self thumbnailSaveDirection] error:&error];
        
        NSMutableArray *array = nil;
        if (allFileNames && [allFileNames count] > 0) {
            array = [[NSMutableArray alloc] init];
            for (int i = 0; i < [allFileNames count]; ++i) {
                NSString *fileName = allFileNames[i];
                if (![fileName isEqualToString:@".DS_Store"]) {
                    NSString *filePath = [[self thumbnailSaveDirection] stringByAppendingPathComponent:fileName];
                    NSData *data = [fileManager contentsAtPath:filePath];
                    TPLongWeiboItemInfo *itemInfo = (TPLongWeiboItemInfo *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
                    [array addObject:itemInfo];
                }
            }
            
        }
        
        // 主线程回调
        dispatch_async(dispatch_get_main_queue(), ^{
            handler(array);
        });
    });
}

- (void)readOriginalImageWithID:(int)imageID completionHandler:(OriginalImageHandler)handler{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *filePath = [self OriginalFliePathWithID:imageID];
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        NSData *data = [fileManager contentsAtPath:filePath];
        UIImage *image = [UIImage imageWithData:data];
        
        // 主线程回调
        dispatch_async(dispatch_get_main_queue(), ^{
            handler(image);
        });
    });
}

- (void)removeLongWeiboWithID:(int)imageID{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *tPath = [self ThumbnailFliePathWithID:imageID];
        NSString *oPath = [self OriginalFliePathWithID:imageID];
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        if ([fileManager fileExistsAtPath:tPath]) {
            NSError *error = nil;
            [fileManager removeItemAtPath:tPath error:&error];
        }
        if ([fileManager fileExistsAtPath:oPath]) {
            NSError *error = nil;
            [fileManager removeItemAtPath:oPath error:&error];
        }
    });
}

#pragma mark Private
- (NSString *)thumbnailSaveDirection{
    do {
        NSFileManager *defaultFileManager = [NSFileManager defaultManager];
        if (self.thumbnailSavePath && [defaultFileManager fileExistsAtPath:self.thumbnailSavePath]){
            break;
        }
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        if ([paths count] == 0){
            break;
        }
        
        NSString *docPath = [paths objectAtIndex:0];
        NSString *aDirectionPath = [docPath stringByAppendingPathComponent:[self md5String:@"Thumbnail"]];
        [self checkDirectionAndCreateIfNeed:aDirectionPath];
        self.thumbnailSavePath = aDirectionPath;
    } while (0);
    
    return self.thumbnailSavePath;
}
- (NSString *)originalSaveDirection{
    do {
        NSFileManager *defaultFileManager = [NSFileManager defaultManager];
        if (self.originalSavePath && [defaultFileManager fileExistsAtPath:self.originalSavePath]){
            break;
        }
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        if ([paths count] == 0){
            break;
        }
        
        NSString *docPath = [paths objectAtIndex:0];
        NSString *aDirectionPath = [docPath stringByAppendingPathComponent:[self md5String:@"Original"]];
        [self checkDirectionAndCreateIfNeed:aDirectionPath];
        self.originalSavePath = aDirectionPath;
    } while (0);
    
    return self.originalSavePath;
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

- (NSString*)ThumbnailFliePath
{
    NSString *fileName = [NSString stringWithFormat:@"thumbnail_%d",self.currentID];
    return [[self thumbnailSaveDirection] stringByAppendingPathComponent:[self md5String:fileName]];
}

- (NSString*)OriginalFliePath //
{
    NSString *fileName = [NSString stringWithFormat:@"original_%d",self.currentID];
    return [[self originalSaveDirection] stringByAppendingPathComponent:[self md5String:fileName]];
}

- (NSString*)OriginalFliePathWithID:(int)ID
{
    NSString *fileName = [NSString stringWithFormat:@"original_%d",ID];
    return [[self originalSaveDirection] stringByAppendingPathComponent:[self md5String:fileName]];
}

- (NSString*)ThumbnailFliePathWithID:(int)ID
{
    NSString *fileName = [NSString stringWithFormat:@"thumbnail_%d",ID];
    return [[self thumbnailSaveDirection] stringByAppendingPathComponent:[self md5String:fileName]];
}

-(UIImage *)resizeImage:(UIImage *)origineImage
{
    CGRect windowRect = [UIScreen mainScreen].bounds;
    
    float newWidth = origineImage.size.width / kTPResizeRate;
    float newHeight  = (windowRect.size.height - 150) * 0.65;
    
    
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth ,newHeight));
    [origineImage drawInRect:CGRectMake(0, 0, origineImage.size.width / kTPResizeRate ,origineImage.size.height / kTPResizeRate )];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

-(NSString *)md5String:(NSString *)string
{
    const char *str = [string UTF8String];
    if (str == NULL)
    {
        str = "";
    }
    unsigned char r[16];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *md5String = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    return md5String;
}
@end
