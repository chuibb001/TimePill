//
//  TPTimelineDataModel.h
//  TimePill
//
//  Created by simon on 13-9-19.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TPWeiboDataModel.h"
#import "TPDiaryDataModel.h"

typedef enum
{
    TPTimelineDataModelTypeWeibo,
    TPTimelineDataModelTypeDiary
}
TPTimelineDataModelType;

@interface TPTimelineDataModel : NSObject<NSCoding,NSCopying>

@property (nonatomic,strong) TPWeiboDataModel *weiboDataModel;
@property (nonatomic,strong) TPDiaryDataModel *diaryDataModel;
@property (nonatomic,assign) TPTimelineDataModelType type;
@property (nonatomic,assign) BOOL isAddViewOpen;

@end
