//
//  TPNavigationViewController.m
//  TimePill
//
//  Created by yan simon on 13-9-17.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "TPNavigationViewController.h"

@interface TPNavigationViewController ()

@end

@implementation TPNavigationViewController

-(id)initWithRootViewController:(UIViewController *)rootViewController{
    self = [super initWithRootViewController:rootViewController];
    if (self){
        [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav-bar.png"] forBarMetrics:UIBarMetricsDefault];
        self.navigationBar.translucent = NO;
        
        if(iOS7)
           [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav-bar128.png"] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
        
        self.navigationBar.titleTextAttributes = @{UITextAttributeTextColor : [UIColor whiteColor],UITextAttributeFont:[UIFont fontWithName: @"ShiShangZhongHeiJianTi" size:20.0],UITextAttributeTextShadowOffset:[NSValue valueWithUIOffset:UIOffsetMake(0.8, 0.8)]};
        
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
