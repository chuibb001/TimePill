//
//  TPDiaryDataModel.m
//  TimePill
//
//  Created by simon on 13-9-19.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "TPDiaryDataModel.h"

@implementation TPDiaryDataModel

- (id)init
{
    self = [super init];
    if (self) {
        self.parser = [[TPWeiboTextParser alloc] init];
    }
    return self;
}

-(void)setupUIData
{
    if(!self.rawText)
        return ;
    
    self.textSize = [self.parser sizeWithRawString:self.rawText constrainsToWidth:kTimelineTextSize.width Font:kDefaultTextFont];
    self.rowHeight += self.textSize.height + 80;
    
    if(self.image)
    {
        CGFloat w = self.image.size.width;
        CGFloat h = self.image.size.height;
        CGFloat width,height;
        
        width = kTimelineTextSize.width + 20;
        
        height = width * h / w;  // 等比放大
        self.imageSize = CGSizeMake(width, height);
        self.rowHeight += height + 15;
    }
    
}

#pragma mark NSCoding
#define kTPDiaryDataModelRawTextKey @"kTPDiaryDataModelRawTextKey"
#define kTPDiaryDataModelImageKey @"kTPDiaryDataModelImageKey"
#define kTPDiaryDataModelDateKey @"kTPDiaryDataModelDateKey"
#define kTPDiaryDataModelLocationStringKey @"kTPDiaryDataModelLocationStringKey"
#define kTPDiaryDataModelTextSizeKey @"kTPDiaryDataModelTextSizeKey"
#define kTPDiaryDataModelImageSizeKey @"kTPDiaryDataModelImageSizeKey"
#define kTPDiaryDataModelRowHeightKey @"kTPDiaryDataModelRowHeightKey"
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.rawText forKey:kTPDiaryDataModelRawTextKey];
    [aCoder encodeObject:self.image forKey:kTPDiaryDataModelImageKey];
    [aCoder encodeObject:self.date forKey:kTPDiaryDataModelDateKey];
    [aCoder encodeObject:self.locationString forKey:kTPDiaryDataModelLocationStringKey];
    [aCoder encodeCGSize:self.textSize forKey:kTPDiaryDataModelTextSizeKey];
    [aCoder encodeCGSize:self.imageSize forKey:kTPDiaryDataModelImageSizeKey];
    [aCoder encodeFloat:self.rowHeight forKey:kTPDiaryDataModelRowHeightKey];
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self.rawText = [aDecoder decodeObjectForKey:kTPDiaryDataModelRawTextKey];
    self.image = [aDecoder decodeObjectForKey:kTPDiaryDataModelImageKey];
    self.date = [aDecoder decodeObjectForKey:kTPDiaryDataModelDateKey];
    self.locationString = [aDecoder decodeObjectForKey:kTPDiaryDataModelLocationStringKey];
    self.textSize = [aDecoder decodeCGSizeForKey:kTPDiaryDataModelTextSizeKey];
    self.imageSize = [aDecoder decodeCGSizeForKey:kTPDiaryDataModelImageSizeKey];
    self.rowHeight = [aDecoder decodeFloatForKey:kTPDiaryDataModelRowHeightKey];
    return self;
}
@end
