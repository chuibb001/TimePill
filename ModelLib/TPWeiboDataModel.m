//
//  TPWeiboDataModel.m
//  TPSinaWeiboSDK
//
//  Created by yan simon on 13-9-12.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "TPWeiboDataModel.h"

/*-----------------------------------
            微博数据模型
 ------------------------------------*/
@implementation TPWeiboDataModel

- (id)init
{
    self = [super init];
    if (self) {
        self.parser = [[TPWeiboTextParser alloc] init];
    }
    return self;
}
- (id)initWithDictionary:(NSDictionary *)dic;
{
    self = [self init];
    if (self) {
        [self setupWeiboDataModalWithDictionary:dic];
    }
    return self;
}

-(void)setupWeiboDataModalWithDictionary:(NSDictionary *)dic
{
    self.weiboId = [dic objectForKey:@"idstr"];  // 微博ID
    self.userName = [[dic objectForKey:@"user"] objectForKey:@"screen_name"];  // 用户昵称
    NSDate *date=[self fdateFromString:[dic objectForKey:@"created_at"]];   
    self.time = date;     // 时间
    self.isSelected = NO;
    
    // 处理原文本
    self.rawText = [dic objectForKey:@"text"];
    self.textSize = [self.parser sizeWithRawString:self.rawText constrainsToWidth:kDefaultTextSize.width Font:kDefaultTextFont];
    
    self.rowHeight += self.textSize.height + 50;
    
    /*-----------------------------------
                1:原创文字+图片
     -----------------------------------*/
    if([dic objectForKey:@"thumbnail_pic"])  
    {
        // 处理图片URL
        self.type = TPWeiboDataTypeTextWithImage;
        
        self.thumbnailImageURL = [dic objectForKey:@"thumbnail_pic"];
        self.bmiddleImageURL = [dic objectForKey:@"bmiddle_pic"];
        self.originalImageURL = [dic objectForKey:@"original_pic"];
        
        self.rowHeight += kDefaultImageHeight +63;
    }
    else
    {
        if([dic objectForKey:@"retweeted_status"])
        {
            NSDictionary *repostDic = [dic objectForKey:@"retweeted_status"];
            
            // 处理转发数据
            self.repostUserName = [[repostDic objectForKey:@"user"] objectForKey:@"screen_name"];  // 用户昵称
            
            NSString *repostTextAndName = [NSString stringWithFormat:@"@%@:%@",self.repostUserName,[repostDic objectForKey:@"text"]];
            // 转发文本
            self.rawRepostText = repostTextAndName;
            
            // 转发文本UI
            self.repostTextSize = [self.parser sizeWithRawString:self.rawRepostText constrainsToWidth:kDefaultRepostTextSize.width Font:kDefaultRepostTextFont];

            /*-----------------------------------
                       3:转发文字+图片
             -----------------------------------*/
            if([repostDic objectForKey:@"thumbnail_pic"])  
            {
                // 处理转发图片URL
                self.type = TPWeiboDataTypeRepostTextWithImage;
                
                self.thumbnailImageURL = [repostDic objectForKey:@"thumbnail_pic"];
                self.bmiddleImageURL = [repostDic objectForKey:@"bmiddle_pic"];
                self.originalImageURL = [repostDic objectForKey:@"original_pic"];
                
                self.rowHeight += self.repostTextSize.height + kDefaultImageHeight + 100;
            }
            /*-----------------------------------
                            2:转发文字
             -----------------------------------*/
            else
            {
                self.type = TPWeiboDataTypeRepostText;
                self.rowHeight += self.repostTextSize.height + 88;
            }
        }
        /*-----------------------------------
                    0:原创文字
         -----------------------------------*/
        else
        {
            self.type = TPWeiboDataTypeText;
            self.rowHeight += 55;
        }
    }
}

-(void)computeNewSize
{
    if(self.rawText)
    {
        CGSize oldSize = self.textSize;
        self.textSize = [self.parser sizeWithRawString:self.rawText constrainsToWidth:kTimelineTextSize.width Font:kDefaultTextFont];
        CGFloat heightChange = self.textSize.height - oldSize.height;
        self.rowHeight += heightChange;
    }
    
    if(self.rawRepostText)
    {
        CGSize oldSize = self.repostTextSize;
        self.repostTextSize = [self.parser sizeWithRawString:self.rawRepostText constrainsToWidth:kTimelineRepostTextSize.width Font:kDefaultRepostTextFont];
        CGFloat heightChange = self.repostTextSize.height - oldSize.height;
        self.rowHeight += heightChange;
    }
    
    if(self.commentArray && [self.commentArray count] > 0)
    {
        for(TPCommentDataModel *dataModel in self.commentArray)
        {
            [dataModel computeNewSize];
            self.rowHeight += dataModel.rowHeight;
            self.commentTableViewHeight += dataModel.rowHeight;
        }
    }
    
    if(self.thumbnailImage)     // 修改图片的Frame
    {
        CGFloat w = self.thumbnailImage.size.width;
        CGFloat h = self.thumbnailImage.size.height;
        CGFloat width,height;
        
        if(self.rawRepostText)    // 转发图
        {
            width = kTimelineRepostTextSize.width + 20;
        }
        else        // 原创图
        {
            width = kTimelineTextSize.width + 20;
        }
        height = width * h / w;  // 等比放大
        self.imageSize = CGSizeMake(width, height);
        CGFloat heightChange = height - kDefaultImageHeight;
        self.rowHeight += heightChange;
    }
}
-(void)computeNewCommenTableViewSize
{
    self.rowHeight -= self.commentTableViewHeight;
    self.commentTableViewHeight = 0;
    
    if(self.commentArray && [self.commentArray count] > 0)
    {
        for(TPCommentDataModel *dataModel in self.commentArray)
        {
            [dataModel computeNewSize];
            self.rowHeight += dataModel.rowHeight;
            self.commentTableViewHeight += dataModel.rowHeight;
        }
    }
}

#pragma mark private
-(NSDate *)fdateFromString:(NSString *)string {
    //Wed Mar 14 16:40:08 +0800 2012
    if (!string)
        return nil;
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"EEE MMM dd HH:mm:ss zzzz yyyy"];
    // NSDateFormatter会默认使用本机时间
    [formater setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    NSDate* date = [formater dateFromString:string];
    // 调整8小时时差
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    return localeDate;
}


#pragma mark NSCoding
#define kTPWeiboDataModelWeiboIdKey @"kTPWeiboDataModelWeiboIdKey"
#define kTPWeiboDataModelUserNameKey @"kTPWeiboDataModelUserNameKey"
#define kTPWeiboDataModelRepostUserNameKey @"kTPWeiboDataModelRepostUserNameKey"
#define kTPWeiboDataModelTimeKey @"kTPWeiboDataModelTimeKey"
#define kTPWeiboDataModelRawTextKey @"kTPWeiboDataModelRawTextKey"
#define kTPWeiboDataModelRawRepostTextKey @"kTPWeiboDataModelRawRepostTextKey"
#define kTPWeiboDataModelThumbnailImageURLKey @"kTPWeiboDataModelThumbnailImageURLKey"
#define kTPWeiboDataModelBmiddleImageURLKey @"kTPWeiboDataModelBmiddleImageURLKey"
#define kTPWeiboDataModelOriginalImageURLKey @"kTPWeiboDataModelOriginalImageURLKey"
#define kTPWeiboDataModelCommentArrayKey @"kTPWeiboDataModelCommentArrayKey"
#define kTPWeiboDataModelTextSizeKey @"kTPWeiboDataModelTextSizeKey"
#define kTPWeiboDataModelRepostTextSizeKey @"kTPWeiboDataModelRepostTextSizeKey"
#define kTPWeiboDataModelImageSizeKey @"kTPWeiboDataModelImageSizeKey"
#define kTPWeiboDataModelTypeKey @"kTPWeiboDataModelTypeKey"
#define kTPWeiboDataModelUserTypeKey @"kTPWeiboDataModelUserTypeKey"
#define kTPWeiboDataModelRowHeightKey @"kTPWeiboDataModelRowHeightKey"
#define kTPWeiboDataModelCommentTableViewHeightKey @"kTPWeiboDataModelCommentTableViewHeightKey"

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.weiboId forKey:kTPWeiboDataModelWeiboIdKey];
    [aCoder encodeObject:self.userName forKey:kTPWeiboDataModelUserNameKey];
    [aCoder encodeObject:self.repostUserName forKey:kTPWeiboDataModelRepostUserNameKey];
    [aCoder encodeObject:self.time forKey:kTPWeiboDataModelTimeKey];
    [aCoder encodeObject:self.rawText forKey:kTPWeiboDataModelRawTextKey];
    [aCoder encodeObject:self.rawRepostText forKey:kTPWeiboDataModelRawRepostTextKey];
    [aCoder encodeObject:self.thumbnailImageURL forKey:kTPWeiboDataModelThumbnailImageURLKey];
    [aCoder encodeObject:self.bmiddleImageURL forKey:kTPWeiboDataModelBmiddleImageURLKey];
    [aCoder encodeObject:self.originalImageURL forKey:kTPWeiboDataModelOriginalImageURLKey];
    [aCoder encodeObject:self.commentArray forKey:kTPWeiboDataModelCommentArrayKey];
    [aCoder encodeCGSize:self.textSize forKey:kTPWeiboDataModelTextSizeKey];
    [aCoder encodeCGSize:self.repostTextSize forKey:kTPWeiboDataModelRepostTextSizeKey];
    [aCoder encodeCGSize:self.imageSize forKey:kTPWeiboDataModelImageSizeKey];
    [aCoder encodeInteger:self.type forKey:kTPWeiboDataModelTypeKey];
    [aCoder encodeInteger:self.userType forKey:kTPWeiboDataModelUserTypeKey];
    [aCoder encodeFloat:self.rowHeight forKey:kTPWeiboDataModelRowHeightKey];
    [aCoder encodeFloat:self.commentTableViewHeight forKey:kTPWeiboDataModelCommentTableViewHeightKey];
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self.weiboId = [aDecoder decodeObjectForKey:kTPWeiboDataModelWeiboIdKey];
    self.userName = [aDecoder decodeObjectForKey:kTPWeiboDataModelUserNameKey];
    self.repostUserName = [aDecoder decodeObjectForKey:kTPWeiboDataModelRepostUserNameKey];
    self.time = [aDecoder decodeObjectForKey:kTPWeiboDataModelTimeKey];
    self.rawText = [aDecoder decodeObjectForKey:kTPWeiboDataModelRawTextKey];
    self.rawRepostText = [aDecoder decodeObjectForKey:kTPWeiboDataModelRawRepostTextKey];
    self.thumbnailImageURL = [aDecoder decodeObjectForKey:kTPWeiboDataModelThumbnailImageURLKey];
    self.bmiddleImageURL = [aDecoder decodeObjectForKey:kTPWeiboDataModelBmiddleImageURLKey];
    self.originalImageURL = [aDecoder decodeObjectForKey:kTPWeiboDataModelOriginalImageURLKey];
    self.commentArray = [aDecoder decodeObjectForKey:kTPWeiboDataModelCommentArrayKey];
    self.textSize = [aDecoder decodeCGSizeForKey:kTPWeiboDataModelTextSizeKey];
    self.repostTextSize = [aDecoder decodeCGSizeForKey:kTPWeiboDataModelRepostTextSizeKey];
    self.imageSize = [aDecoder decodeCGSizeForKey:kTPWeiboDataModelImageSizeKey];
    self.type = [aDecoder decodeIntegerForKey:kTPWeiboDataModelTypeKey];
    self.userType = [aDecoder decodeIntegerForKey:kTPWeiboDataModelUserTypeKey];
    self.rowHeight = [aDecoder decodeFloatForKey:kTPWeiboDataModelRowHeightKey];
    self.commentTableViewHeight = [aDecoder decodeFloatForKey:kTPWeiboDataModelCommentTableViewHeightKey];
    return self;
}
@end
