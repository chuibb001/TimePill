//
//  TPConst.h
//  TimePill
//
//  Created by simon on 13-9-19.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import <Foundation/Foundation.h>

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

// Notification
#define kTPWeiboSelectedNotification @"kTPWeiboSelectedNotification"
#define kTPDiaryPublishNotification  @"kTPDiaryPublishNotification"

// Key
#define kTPThemeKey @"kTPThemeKey"
#define kTPUpgradeKey @"kTPUpgradeKey"
#define kTPFirstShowExtendedBarKey @"kTPFirstShowExtendedBarKey"

@interface TPConst : NSObject

@end
