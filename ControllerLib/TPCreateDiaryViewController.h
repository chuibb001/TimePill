//
//  TPCreateDiaryViewController.h
//  TPSinaWeiboSDK
//
//  Created by simon on 13-9-14.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "TPTextView.h"
#import "TPKeyboardHeaderView.h"
#import "TPEmotionView.h"
#import "TPLocationManager.h"
#import "SVProgressHUD.h"
#import "TPPaintingViewController.h"
#import "TPShareView.h"
#import "TPDiaryDataModel.h"
#import "TPWeiboTextParser.h"
#import "TPConst.h"
#import "TPTimelineDataModel.h"
#import "TPRevealViewController.h"
#import "TPTheme.h"
#import "TPSinaWeiboEngine.h"
#import "TPLoginViewController.h"
#import "TPNavigationViewController.h"

@interface TPCreateDiaryViewController : UIViewController<TPLocationDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong) TPTextView *textView;
@property (nonatomic,strong) TPKeyboardHeaderView *keyboardHeaderView;
@property (nonatomic,strong) TPEmotionView *emotionView;
@property (nonatomic,strong) TPShareView *shareView;
@property (nonatomic,strong) TPLocationManager *locationManager;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UILabel *dateLabel;
@property (nonatomic,strong) UILabel *locationLabel;
@property (nonatomic,strong) UIImageView *previewImageView;
@property (nonatomic,strong) UIImage *longWeiboImage;

@end
