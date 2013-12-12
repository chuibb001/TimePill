//
//  TPGuideManager.h
//  TimePill
//
//  Created by yan simon on 13-12-12.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TPConst.h"

@interface TPGuideManager : NSObject
{
    BOOL canShow;
}
/**
 *  单例
 */
+ (instancetype)sharedInstance;

- (void)showMenuGuide;

- (void)removeAllGuides;

@end
