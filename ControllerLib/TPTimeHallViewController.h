//
//  TPTimeHallViewController.h
//  TimePill
//
//  Created by yan simon on 13-9-18.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "iCarousel.h"
#import "TPLongWeiboManager.h"
#import "TPRevealViewController.h"
#import "TPZoomImageView.h"

@interface TPTimeHallViewController : UIViewController<iCarouselDataSource,iCarouselDelegate,UIActionSheetDelegate,UIAlertViewDelegate>

@property (nonatomic,assign) BOOL hasShadow;
@property (nonatomic,assign) BOOL hasGesture;
@property (nonatomic,strong) iCarousel *iCarousel;
@property (nonatomic,strong) TPZoomImageView *zoomView;
@property (nonatomic,strong) NSMutableArray *listData;
@property (nonatomic,assign) int currentIndex;

@end

