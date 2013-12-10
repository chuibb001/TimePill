//
//  TPCreateDiaryViewController.m
//  TPSinaWeiboSDK
//
//  Created by simon on 13-9-14.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "TPCreateDiaryViewController.h"

@interface TPCreateDiaryViewController ()
{
    BOOL isEmotionViewOpen;
    CGRect emotionViewOpenRect;
    CGRect emotionViewCloseRect;
    BOOL isShareViewOpen;
    CGRect shareViewOpenRect;
    CGRect shareViewCloseRect;
}
@end

@implementation TPCreateDiaryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[TPTheme currentBackgroundImageNoLine]];
    [self initNavigation];
    [self initData];
    [self initTextView];
    [self initKeyboardHeaderView];
    [self initInfoLabel];
    [self setCurrentTime];
    
    if (self.longWeiboImage) {
        [self initPreviewImageView];
        [self initShareView];
        self.shareView.weiboSwitch.isOn = YES;
        self.previewImageView.image = self.longWeiboImage;
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
    [self addObserver:self forKeyPath:@"self.keyboardHeaderView.frame" options:NSKeyValueObservingOptionNew context:nil];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeObserver:self forKeyPath:@"self.keyboardHeaderView.frame"];
}
#pragma mark Notification
-(void)KeyboardWillShowNotification:(NSNotification *)note
{
    if(isEmotionViewOpen)   // 修正逻辑
    {
        isEmotionViewOpen = NO;
        [self beginEmotionViewAnimation:NO];
    }
}
-(void)KeyboardWillHideNotification:(NSNotification *)note
{
}

#pragma mark Init Method
-(void)initData
{
    isEmotionViewOpen = NO;
    isShareViewOpen = NO;
}
-(void)initTextView
{
    self.textView = [[TPTextView alloc] initWithFrame:CGRectMake(10, 30, CGRectGetWidth(self.view.frame) - 20 , CGRectGetHeight(self.view.frame) - 100)];
    self.textView.placeHolder = @"写点什么吧..";
    self.textView.text = @"";
    self.textView.font = [UIFont systemFontOfSize:16.0];
    self.textView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.textView];
    [self.textView becomeFirstResponder];
}
-(void)initKeyboardHeaderView
{
    self.keyboardHeaderView = [[TPKeyboardHeaderView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - 37.5, CGRectGetWidth(self.view.frame), 37.5)];
    [self.keyboardHeaderView.emotionButton addTarget:self action:@selector(emotionButtonTaped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.keyboardHeaderView];
    // 按钮事件
    [self.keyboardHeaderView.locationButton addTarget:self action:@selector(locationButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.keyboardHeaderView.photoButton addTarget:self action:@selector(photoButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.keyboardHeaderView.paintingButton addTarget:self action:@selector(paintingButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.keyboardHeaderView.shareButton addTarget:self action:@selector(shareButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)initEmotionView
{
    emotionViewOpenRect = CGRectMake(0, CGRectGetHeight(self.view.frame) - 216.0, CGRectGetWidth(self.view.frame), 216.0);
    emotionViewCloseRect = CGRectMake(0, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame), 216.0);
    self.emotionView = [[TPEmotionView alloc] initWithFrame:emotionViewCloseRect];
    [self.view addSubview:self.emotionView];
    
    __weak TPCreateDiaryViewController *weakSelf = self;
    self.emotionView.handler = ^(NSString *emotionStr)
    {
        weakSelf.textView.text  = [weakSelf.textView.text stringByAppendingString:emotionStr];
        weakSelf.textView.placeHolderLabel.hidden = YES;
    };
}
-(void)initNavigation
{
    self.title = @"写日记";
    //返回按钮
    UIButton *returnBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    returnBtn.frame=CGRectMake(0, 0, 40, 40);
    [returnBtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [returnBtn addTarget:self action:@selector(returnBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:returnBtn];
    self.navigationItem.leftBarButtonItem=leftBarButtonItem;
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setBackgroundColor:[UIColor clearColor]];
    rightButton.frame = CGRectMake(0, 0, 40, 40);
    [rightButton setImage:[UIImage imageNamed:@"done.png"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(DoneClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = button;
    
}
-(void)initInfoLabel
{
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 46, 21)];
    self.timeLabel.backgroundColor = [UIColor clearColor];
    self.timeLabel.font = [UIFont systemFontOfSize:12.0];
    [self.timeLabel setTextColor:[UIColor colorWithRed:145./255. green:195./255. blue:186./255. alpha:1.0]];
    [self.view addSubview:self.timeLabel];
    self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 10, 200, 21)];
    self.dateLabel.backgroundColor = [UIColor clearColor];
    self.dateLabel.font = [UIFont systemFontOfSize:11.0];
    [self.view addSubview:self.dateLabel];
    self.locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(226, 10, 74, 21)];
    self.locationLabel.backgroundColor = [UIColor clearColor];
    self.locationLabel.font = [UIFont systemFontOfSize:11.0];
    [self.view addSubview:self.locationLabel];
}
-(void)initShareView
{
    self.shareView = [[TPShareView alloc] initWithFrame:CGRectMake(240, 500, 73.5, 63.5)];
    [self.view insertSubview:self.shareView belowSubview:self.keyboardHeaderView];
    
}
-(void)initPreviewImageView
{
    self.previewImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, CGRectGetMinY(self.keyboardHeaderView.frame) - 65, 40, 50)];
    [self.view addSubview:self.previewImageView];
}

#pragma mark ButtonTaped
-(void)emotionButtonTaped:(id)sender
{
    if(!isEmotionViewOpen)
    {
        isEmotionViewOpen = YES;
        if(!self.emotionView)  // 首次初始化
            [self initEmotionView];
        [self beginEmotionViewAnimation:YES];
        [self.textView resignFirstResponder];
        self.keyboardHeaderView.frame = CGRectMake(self.keyboardHeaderView.frame.origin.x, emotionViewOpenRect.origin.y - self.keyboardHeaderView.frame.size.height, self.keyboardHeaderView.frame.size.width, self.keyboardHeaderView.frame.size.height);
    }
    else
    {
        isEmotionViewOpen = NO;
        [self beginEmotionViewAnimation:NO];
        [self.textView becomeFirstResponder];
    }
}
-(void)returnBack:(id)sender
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
    
    if (!self.longWeiboImage) {
        [[TPRevealViewController sharedInstance] showRightViewControllerAnimated:NO];
    }
}

-(void)DoneClicked:(id)sender
{
    if (self.longWeiboImage) {
        if ([[TPSinaWeiboEngine sharedInstance] isLogon]) {
            [[TPSinaWeiboEngine sharedInstance] postImageStatusWithText:self.textView.text Latitude:nil Longitude:nil Image:self.longWeiboImage];
        } else {
            TPLoginViewController *login = [[TPLoginViewController alloc] init];
            [self presentModalViewController:[[TPNavigationViewController alloc] initWithRootViewController:login] animated:YES];
        }
        
    }
    else {
        TPDiaryDataModel *dataModel = [[TPDiaryDataModel alloc] init];
        dataModel.rawText = self.textView.text;
        NSDate *date = [NSDate date];
        // 调整8小时时差
        NSTimeZone *zone = [NSTimeZone systemTimeZone];
        NSInteger interval = [zone secondsFromGMTForDate:date];
        NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
        dataModel.date = localeDate;
        if(self.previewImageView.image)
            dataModel.image = self.previewImageView.image;
        
        [dataModel setupUIData];
        
        [[TPRevealViewController sharedInstance] showRootViewControllerAnimated:NO];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kTPDiaryPublishNotification object:dataModel];
    }
    
    [self.navigationController dismissModalViewControllerAnimated:YES];
}
-(void)locationButtonClicked:(id)sender
{
    [self.keyboardHeaderView.locationButton setImage:[UIImage imageNamed:@"positionclick.png"] forState:UIControlStateNormal];
    
    if(!self.locationManager)
    {
        self.locationManager = [TPLocationManager sharedInstance];
        self.locationManager.delegate = self;
    }
    
    [self.locationManager startLocate];
}

-(void)photoButtonClicked:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"照相机",@"相册",nil];
    [actionSheet showInView:self.view];
}
-(void)paintingButtonClicked:(id)sender
{
    TPPaintingViewController *p = [[TPPaintingViewController alloc] init];
    
    __weak TPCreateDiaryViewController *weakSelf = self;
    
    p.handler = ^(UIImage *image)
    {
        if(image)
        {
            if(!weakSelf.previewImageView)
                [weakSelf initPreviewImageView];
            weakSelf.previewImageView.image = image;
        }
    };
    
    [self.navigationController pushViewController:p animated:YES];
}
-(void)shareButtonClicked:(id)sender
{
    if(!isShareViewOpen)
    {
        isShareViewOpen = YES;
        if(!self.shareView)
           [self initShareView];
        
        [self beginShareViewAnimation:YES];
    }
    else
    {
        isShareViewOpen = NO;
        [self beginShareViewAnimation:NO];
    }
    
}

#pragma mark private
-(void)setCurrentTime
{
    // NSDateFormatter
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    // NSDate
    NSDate *date = [NSDate date];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    // NSCalendar
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    // NSDateComponents
    NSDateComponents *comps;
    NSInteger unitFlags = NSYearCalendarUnit |
    NSMonthCalendarUnit |
    NSDayCalendarUnit |
    NSWeekdayCalendarUnit |
    NSHourCalendarUnit |
    NSMinuteCalendarUnit |
    NSSecondCalendarUnit;
    comps = [calendar components:unitFlags fromDate:date];
    int week = [comps weekday];
    int year=[comps year];
    int month = [comps month];
    int day = [comps day];
    int hour = [comps hour];
    int min = [comps minute];
    NSArray * weeks=[[NSArray alloc] initWithObjects:@"星期x",@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六", nil];
    NSString *timeStr=[NSString stringWithFormat:@"%d:%d",hour,min];
    NSString *dateStr=[NSString stringWithFormat:@"%@ %d年%d月%d日",[weeks objectAtIndex:week],year,month,day];
    self.timeLabel.text=timeStr;
    self.dateLabel.text=dateStr;
}
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	UIImagePickerController *picker=[[UIImagePickerController alloc] init];
	picker.delegate=self;
	picker.allowsEditing=YES;
    
    // 调用照相机
    if(buttonIndex==0)
    {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            NSLog(@"照相机不能用");
        }
        //前后摄像机
        //picker.cameraDevice=UIImagePickerControllerCameraDeviceFront;
        picker.sourceType=UIImagePickerControllerSourceTypeCamera;
        [self presentModalViewController:picker animated:YES];
    }
    // 调用相册
    else if(buttonIndex==1){
        picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentModalViewController:picker animated:YES];
    }
}
#pragma mark UIImagePickerControllerDelegate
//调用照片成功
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	//返回原来界面
	[picker dismissModalViewControllerAnimated:YES];
	UIImage* image=[info objectForKey:UIImagePickerControllerEditedImage];
    if(!self.previewImageView)
        [self initPreviewImageView];
    self.previewImageView.image = image;
}

#pragma mark TPLocationDelegate
-(void)TPLocationManagerDidReceiveLocation:(LocationObject *)lc
{
    self.locationLabel.text = lc.cityName;
}
-(void)TPLocationManagerDidFailWithError:(NSError *)error
{
    [self.keyboardHeaderView.locationButton setImage:[UIImage imageNamed:@"position.png"] forState:UIControlStateNormal];
}

#pragma mark Animations
-(void)beginEmotionViewAnimation:(BOOL)isOpen
{
    if(isOpen) // 打开
    {
        self.emotionView.frame = emotionViewCloseRect;
        [UIView beginAnimations:@"emotionViewOpenAnimation" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        self.emotionView.frame = emotionViewOpenRect;
        [UIView commitAnimations];
    }
    else
    {
        self.emotionView.frame = emotionViewOpenRect;
        [UIView beginAnimations:@"emotionViewCloseAnimation" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        self.emotionView.frame = emotionViewCloseRect;
        [UIView commitAnimations];
    }
}
-(void)beginShareViewAnimation:(BOOL)isOpen
{
    shareViewCloseRect = CGRectMake(self.shareView.frame.origin.x, self.keyboardHeaderView.frame.origin.y + 75, self.shareView.frame.size.width, self.shareView.frame.size.height);
    shareViewOpenRect = CGRectMake(self.shareView.frame.origin.x, self.keyboardHeaderView.frame.origin.y - 75, self.shareView.frame.size.width, self.shareView.frame.size.height);
    
    if(isOpen) // 打开
    {
        self.shareView.frame = shareViewCloseRect;
        self.shareView.hidden = NO;
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView animateWithDuration:0.2 animations:^{
            self.shareView.frame = shareViewOpenRect;
        }
        completion:^(BOOL finished)
         {
             self.shareView.frame = shareViewOpenRect;
             
         }];
    }
    else
    {
        self.shareView.frame = shareViewOpenRect;
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView animateWithDuration:0.2 animations:^{
            self.shareView.frame = shareViewCloseRect;
        }
                         completion:^(BOOL finished)
         {
             self.shareView.frame = shareViewCloseRect;
             self.shareView.hidden = YES;
         }];
    }
}

#pragma mark kvo
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"self.keyboardHeaderView.frame"] ) {
        NSValue *rectValue = [change objectForKey:@"new"];
        CGRect rect = [rectValue CGRectValue];
        
        if(self.shareView)  // 修正分享栏Frame
        {
            if(isShareViewOpen)
            {
                self.shareView.frame = CGRectMake(self.shareView.frame.origin.x, rect.origin.y - 75, self.shareView.frame.size.width, self.shareView.frame.size.height);
                self.shareView.hidden = NO;
            }
            else
            {
                self.shareView.frame = CGRectMake(self.shareView.frame.origin.x, rect.origin.y + 75, self.shareView.frame.size.width, self.shareView.frame.size.height);
                self.shareView.hidden = YES;
            }
        }
        
        
        if(self.previewImageView)   // 修正预览图Frame
        {
            self.previewImageView.frame = CGRectMake(self.previewImageView.frame.origin.x, rect.origin.y - 65, self.previewImageView.frame.size.width, self.previewImageView.frame.size.height);
        }
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
