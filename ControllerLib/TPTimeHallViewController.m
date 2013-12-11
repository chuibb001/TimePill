//
//  TPTimeHallViewController.m
//  TimePill
//
//  Created by yan simon on 13-9-18.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "TPTimeHallViewController.h"

#define ITEM_SPACING 200

@interface TPTimeHallViewController ()

@end

@implementation TPTimeHallViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = [UIColor blackColor];
        self.hasGesture = NO;
        self.hasShadow = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.iCarousel = [[iCarousel alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    [self.view addSubview:self.iCarousel];
    self.iCarousel.type = iCarouselTypeCoverFlow2;
    self.iCarousel.delegate = self;
    self.iCarousel.dataSource = self;
    self.iCarousel.layer.masksToBounds = YES;
    self.iCarousel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"hlbackground.png"]];
    
    self.view.backgroundColor = [UIColor blueColor];
    [self initNavigation];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(25, self.view.frame.size.height - 60, 40, 40);
    [button addTarget:self action:@selector(deleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"deleteTimeline.png"] forState:UIControlStateNormal];
    //self.zoomView = [[TPZoomImageView alloc] initWithCustomViews:@[button]];
    self.zoomView = [[TPZoomImageView alloc] initWithLongPressHandler:^{
        [self longPressHandle];}];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[TPLongWeiboManager sharedInstance] readAllThumbnailImagesWithCompletionHandler:^(NSMutableArray *array) {
        self.listData = array;
        NSLog(@"%@",self.listData);
        [self.iCarousel reloadData];
    }];
}

- (NSUInteger)numberOfPlaceholdersInCarousel:(iCarousel *)carousel
{
	return 0;
}

- (NSUInteger)numberOfVisibleItemsInCarousel:(iCarousel *)carousel
{
    return 3;
}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    return ITEM_SPACING;
}

- (CATransform3D)carousel:(iCarousel *)_carousel transformForItemView:(UIView *)view withOffset:(CGFloat)offset
{
    view.alpha = 1.0 - fminf(fmaxf(offset, 0.0), 1.0);
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = self.iCarousel.perspective;
    transform = CATransform3DRotate(transform, M_PI / 8.0, 0, 1.0, 0);
    return CATransform3DTranslate(transform, 0.0, 0.0, offset * self.iCarousel.itemWidth);
}

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [self.listData count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index
{
    UIImage *thumnailImage = ((TPLongWeiboItemInfo *)[self.listData objectAtIndex:index]).thumnailImage;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:thumnailImage];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.layer.masksToBounds = YES;
    imageView.frame = CGRectMake(70, 60, 250, self.view.frame.size.height * 0.65);
    imageView.userInteractionEnabled = YES;

    return imageView;
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index { NSLog(@"%d",index);
    self.currentIndex = index;
    TPLongWeiboItemInfo *item = [self.listData objectAtIndex:index];
    int imageId = item.imageID;
    [[TPLongWeiboManager sharedInstance] readOriginalImageWithID:imageId completionHandler:^(UIImage *image) {
        [self.zoomView showWithImage:image];
    }];
}


-(void)showLeft:(id)Sender
{
    if ([[TPRevealViewController sharedInstance] isCentered]) {
        [[TPRevealViewController sharedInstance] showLeftViewControllerAnimated:YES];
    } else {
        [[TPRevealViewController sharedInstance] showRootViewControllerAnimated:YES];
    }
    
    
}

-(void)deleteButtonClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"您确定要删除本条长微博吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        TPLongWeiboItemInfo *item = [self.listData objectAtIndex:self.currentIndex];
        int imageId = item.imageID;
        [[TPLongWeiboManager sharedInstance] removeLongWeiboWithID:imageId];
        [self.listData removeObjectAtIndex:self.currentIndex];
        [self.iCarousel removeItemAtIndex:self.currentIndex animated:YES];
        [self.iCarousel reloadData];
        [self.zoomView dismiss];
    }
}

-(void)longPressHandle {
    TPLongWeiboItemInfo *item = [self.listData objectAtIndex:self.currentIndex];
    int imageId = item.imageID;
    [[TPLongWeiboManager sharedInstance] removeLongWeiboWithID:imageId];
    [self.listData removeObjectAtIndex:self.currentIndex];
    [self.iCarousel removeItemAtIndex:self.currentIndex animated:YES];
    [self.iCarousel reloadData];
}
-(void)initNavigation
{
    //导航bar
    UINavigationBar *navBar = nil;
    //[navBar setBackgroundImage:[UIImage imageNamed:@"nav-bar.png"] forBarMetrics:UIBarMetricsDefault];
    
    if(iOS7)
    {
        navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
        [navBar setBackgroundImage:[UIImage imageNamed:@"nav-bar128.png"] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
    }
    else
    {
        navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        [navBar setBackgroundImage:[UIImage imageNamed:@"nav-bar.png"] forBarMetrics:UIBarMetricsDefault];
    }
    
    navBar.titleTextAttributes = @{UITextAttributeTextColor : [UIColor whiteColor],UITextAttributeFont:[UIFont fontWithName: @"ShiShangZhongHeiJianTi" size:20.0],UITextAttributeTextShadowOffset:[NSValue valueWithUIOffset:UIOffsetMake(0.8, 0.8)]};
    
    //导航item
    UINavigationItem *item=[[UINavigationItem alloc] initWithTitle:nil];
    [navBar pushNavigationItem:item animated:YES];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 40, 40);
    [backButton setImage:[UIImage imageNamed:@"change.png"] forState:UIControlStateNormal];
    //[backButton setImage:[UIImage imageNamed:@"timeclick.png"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(showLeft:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    item.leftBarButtonItem = button;
    
    item.title = @"时光画廊";
    
    [self.view addSubview:navBar];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
