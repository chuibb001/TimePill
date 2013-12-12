//
//  TPLongWeiboManager.h
//  TimePill
//
//  Created by yan simon on 13-10-12.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TPConst.h"

@interface TPLongWeiboItemInfo : NSObject<NSCoding>

@property (nonatomic,assign) int imageID;       // 缩略图ID
@property (nonatomic,strong) UIImage *thumnailImage;        // 缩略图

@end

typedef void(^LongWeiboHandler)(BOOL success);
typedef void(^ThumnailImageHandler)(NSMutableArray *array);
typedef void(^OriginalImageHandler)(UIImage *image);

@interface TPLongWeiboManager : NSObject

@property (nonatomic, assign) int currentID;
@property (nonatomic, strong) NSString* thumbnailSavePath;
@property (nonatomic, strong) NSString* originalSavePath;

/**
 *  单例
 *
 *  @return
 */
+ (id)sharedInstance;

/**
 *  保存长微博x1,异步执行
 *
 *  @param image   长微博
 *  @param handler 回调成功与否
 */
- (void)saveLongWeibo:(UIImage *)image completionHandler:(LongWeiboHandler)handler;

/**
 *  读取所有缩略图,异步执行
 *
 *  @param hander 回调ItemInfo的数组,内含缩略图ID和缩略图
 */
- (void)readAllThumbnailImagesWithCompletionHandler:(ThumnailImageHandler)handler;

/**
 *  根据缩略图ID读取相应的大图,异步执行
 *
 *  @param imageID 缩略图ID
 *  @param handler 回调长微博大图
 */
- (void)readOriginalImageWithID:(int)imageID completionHandler:(OriginalImageHandler)handler;

/**
 *  删除长微博记录,异步执行
 *
 *  @param imageID 缩略图ID
 */
- (void)removeLongWeiboWithID:(int)imageID;

/**
 *  制作长微博的缩略图
 *
 */
-(UIImage *)resizeImage:(UIImage *)origineImage;

@end
