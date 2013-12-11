//
//  TPFriendDataModel.h
//  TimePill
//
//  Created by simon on 13-9-28.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TPImageDownloadCenter.h"

@interface TPFriendDataModel : NSObject<NSCoding>

@property (nonatomic,strong) NSString *userID;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *profileImageURL;

-(id)initWithDictionary:(NSDictionary *)dic;

@end
