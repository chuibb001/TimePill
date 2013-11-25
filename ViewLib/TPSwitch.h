//
//  TPSwitch.h
//  TimePill
//
//  Created by yan simon on 13-9-18.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface TPSwitch : UIControl

@property (nonatomic,assign) BOOL isOn;

- (id)initWithFrame:(CGRect)frame BackgroundImage:(UIImage *)backgroundImage ButtonImage:(UIImage *)buttonImage;

@end
