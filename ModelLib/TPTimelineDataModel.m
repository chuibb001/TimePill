//
//  TPTimelineDataModel.m
//  TimePill
//
//  Created by simon on 13-9-19.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "TPTimelineDataModel.h"

@implementation TPTimelineDataModel

#pragma mark NSCoding
#define kTPTimelineDataModelWeiboDataModelKey @"kTPTimelineDataModelWeiboDataModelKey"
#define kTPTimelineDataModelDiaryDataModelKey @"kTPTimelineDataModelDiaryDataModelKey"
#define kTPTimelineDataModelTypeKey @"kTPTimelineDataModelTypeKey"
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.weiboDataModel forKey:kTPTimelineDataModelWeiboDataModelKey];
    [aCoder encodeObject:self.diaryDataModel forKey:kTPTimelineDataModelDiaryDataModelKey];
    [aCoder encodeInteger:self.type forKey:kTPTimelineDataModelTypeKey];
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self.weiboDataModel = [aDecoder decodeObjectForKey:kTPTimelineDataModelWeiboDataModelKey];
    self.diaryDataModel = [aDecoder decodeObjectForKey:kTPTimelineDataModelDiaryDataModelKey];
    self.type = [aDecoder decodeIntegerForKey:kTPTimelineDataModelTypeKey];
    self.isAddViewOpen = NO;
    return self;
}

- (NSComparisonResult)timeComparator:(TPTimelineDataModel *)dataModel{
    NSDate *date1 = nil;
    NSDate *date2 = nil;
    
    switch (self.type) {
        case TPTimelineDataModelTypeWeibo:
            date1 = self.weiboDataModel.time;
            break;
         case TPTimelineDataModelTypeDiary:
            date1 = self.diaryDataModel.date;
        default:
            break;
    }
    
    switch (dataModel.type) {
        case TPTimelineDataModelTypeWeibo:
            date2 = dataModel.weiboDataModel.time;
            break;
        case TPTimelineDataModelTypeDiary:
            date2 = dataModel.diaryDataModel.date;
        default:
            break;
    }
    
    return [date2 compare:date1];
}

@end
