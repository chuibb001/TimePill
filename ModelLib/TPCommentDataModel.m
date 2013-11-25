//
//  TPCommentDataModel.m
//  TimePill
//
//  Created by simon on 13-9-19.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "TPCommentDataModel.h"

@implementation TPCommentDataModel
- (id)init
{
    self = [super init];
    if (self) {
        self.parser = [[TPWeiboTextParser alloc] init];
    }
    return self;
}
-(id)initWithDictionary:(NSDictionary *)dic
{
    self = [self init];
    if (self) {
        [self setupCommentDataModalWithDictionary:dic];
    }
    return self;
}

-(void)setupCommentDataModalWithDictionary:(NSDictionary *)dic
{
    self.commentId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
    self.userName = [[dic objectForKey:@"user"] objectForKey:@"screen_name"];
    self.profileImageURL = [[dic objectForKey:@"user"] objectForKey:@"profile_image_url"];
    self.rawText = [dic objectForKey:@"text"];
    self.textSize = [self.parser sizeWithRawString:self.rawText constrainsToWidth:kDefaultCommentTextSize.width Font:kDefaultCommentTextFont];
    
    self.isSelected = NO;
    self.rowHeight = self.textSize.height + 40;
}
-(void)computeNewSize
{
    CGSize oldSize = self.textSize;
    self.textSize = [self.parser sizeWithRawString:self.rawText constrainsToWidth:kTimelineCommentTextSize.width Font:kTimelineCommentTextFont];

    CGFloat heightChange = self.textSize.height - oldSize.height;
    self.rowHeight += heightChange;
}

#pragma mark NSCoding
#define kTPCommentDataModelCommentIdKey @"kTPCommentDataModelCommentIdKey"
#define kTPCommentDataModelUserNameKey @"kTPCommentDataModelUserNameKey"
#define kTPCommentDataModelProfileImageURLKey @"kTPCommentDataModelProfileImageURLKey"
#define kTPCommentDataModelProfileImageKey @"kTPCommentDataModelProfileImageKey"
#define kTPCommentDataModelRawTextKey @"kTPCommentDataModelRawTextKey"
#define kTPCommentDataModelTextSizeKey @"kTPCommentDataModelTextSizeKey"
#define kTPCommentDataModelRowHeightKey @"kTPCommentDataModelRowHeightKey"
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.commentId forKey:kTPCommentDataModelCommentIdKey];
    [aCoder encodeObject:self.userName forKey:kTPCommentDataModelUserNameKey];
    [aCoder encodeObject:self.profileImageURL forKey:kTPCommentDataModelProfileImageURLKey];
    [aCoder encodeObject:self.rawText forKey:kTPCommentDataModelRawTextKey];
    [aCoder encodeCGSize:self.textSize forKey:kTPCommentDataModelTextSizeKey];
    [aCoder encodeFloat:self.rowHeight forKey:kTPCommentDataModelRowHeightKey];
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self.commentId = [aDecoder decodeObjectForKey:kTPCommentDataModelCommentIdKey];
    self.userName = [aDecoder decodeObjectForKey:kTPCommentDataModelUserNameKey];
    self.profileImageURL = [aDecoder decodeObjectForKey:kTPCommentDataModelProfileImageURLKey];
    self.rawText = [aDecoder decodeObjectForKey:kTPCommentDataModelRawTextKey];
    self.textSize = [aDecoder decodeCGSizeForKey:kTPCommentDataModelTextSizeKey];
    self.rowHeight = [aDecoder decodeFloatForKey:kTPCommentDataModelRowHeightKey];
    return self;
}
@end
