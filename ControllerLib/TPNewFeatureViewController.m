//
//  TPNewFeatherViewController.m
//  TimePill
//
//  Created by yan simon on 13-10-24.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "TPNewFeatureViewController.h"

@interface TPNewFeatureViewController ()

@end

@implementation TPNewFeatureViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = [UIColor grayColor];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    // 引导图
    NSArray *array = @[[UIImage imageNamed:@"jieshao1.png"],[UIImage imageNamed:@"jieshao2.png"],[UIImage imageNamed:@"jieshao3.png"]];
    
    // 滚动视图
    self.pageScroll=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.bounds.size.height)];
    [self.view addSubview:self.pageScroll];
    
    self.pageScroll.contentSize = CGSizeMake(self.view.frame.size.width * 3, self.view.frame.size.height);
    self.pageScroll.showsHorizontalScrollIndicator = NO;
    self.pageScroll.pagingEnabled = YES;
    self.pageScroll.delegate = self;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    float button_y = self.view.bounds.size.height*(360.0 / 460.0);
    button.frame = CGRectMake(320 * 2 + 18,button_y,288,87.5);
    button.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"enter.png"]];
    [button addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    
    for(int i = 0; i < 3; i++)
    {
        UIImageView *image = [[UIImageView alloc] initWithImage:[array objectAtIndex:i]];
        image.contentMode = UIViewContentModeScaleAspectFill;
        image.layer.masksToBounds = YES;
        image.frame = CGRectMake(320 * i, 0, 320, self.view.bounds.size.height);
        [self.pageScroll addSubview:image];
        
    }
    
    float pageControl_y = self.view.bounds.size.height * (424.0/460.0);
    
    // 分页控制
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(125, pageControl_y, 60, 36)];
    self.pageControl.numberOfPages = 3;
    self.pageControl.currentPage = 0;
    
    [self.view addSubview:self.pageControl];
    
    [self.pageScroll addSubview:button];
}

- (void) show{
    UIWindow* window = [[self class] presentWindow:NO];
    window.hidden = NO;
    window.rootViewController = self;
    window.rootViewController.view.frame = window.bounds;
}

- (void) dismiss{
    [UIView beginAnimations:@"newFunctionAnimation" context:NULL];
    [UIView setAnimationDuration:1];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    
    self.view.alpha = 0.0;
    self.view.transform = CGAffineTransformMakeScale(2.0f, 2.0f);
    
    [UIView commitAnimations];
    
}

- (void) animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    if ([animationID isEqualToString:@"newFunctionAnimation"]){
        [[self class] presentWindow:YES];
    }
}

+ (UIWindow*) presentWindow:(BOOL)isDismiss{
    static UIWindow* window = nil;
    if (!isDismiss){
        if (!window){
            window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
            window.windowLevel = UIWindowLevelAlert;
        }
    }else{
        window.hidden = YES;
        window = nil;
    }
    
    return window;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.view.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
