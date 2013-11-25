//
//  TPLoginViewController.m
//  TimePill
//
//  Created by simon on 13-10-7.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "TPLoginViewController.h"

@interface TPLoginViewController ()

@end

@implementation TPLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[TPTheme currentBackgroundImageNoLine]];
    [self initNavigation];
    if ([[TPSinaWeiboEngine sharedInstance] isLogon]) {
        [self initLogoutButton];
        [self.view addSubview:self.logoutButton];
    } else {
        [self initLoginButton];
        [self.view addSubview:self.loginButton];
    }
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LoginDidSuccessNotification:) name:kTPSinaWeiboEngineLoginDidSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LoginDidFailNotification:) name:kTPSinaWeiboEngineLoginDidFailNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LogoutNotification:) name:kTPSinaWeiboEngineDidLogoutNotification object:nil];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark private
-(void)returnBack:(id)sender
{
    if (self.handler) {
        self.handler();
    } else {
        [self.navigationController dismissModalViewControllerAnimated:YES];
    }
}
-(void)loginButtonClicked:(id)sender
{
    [[TPSinaWeiboEngine sharedInstance] Login];
}
-(void)logoutButtonClicked:(id)sender
{
    [[TPSinaWeiboEngine sharedInstance] Logout];
}
-(void)LoginDidSuccessNotification:(NSNotification *)note
{
    [self.loginButton removeFromSuperview];
    if (!self.logoutButton) {
        [self initLogoutButton];
    }
    [self.view addSubview:self.logoutButton];
}
-(void)LoginDidFailNotification:(NSNotification *)note
{
    [SVProgressHUD showErrorWithStatus:@"登录失败"];
}
-(void)LogoutNotification:(NSNotification *)note
{
    [self.logoutButton removeFromSuperview];
    if (!self.loginButton) {
        [self initLoginButton];
    }
    [self.view addSubview:self.loginButton];
}

#pragma mark init 
-(void)initNavigation
{
    self.title = @"账户管理";
    //返回按钮
    UIButton *returnBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    returnBtn.frame=CGRectMake(0, 0, 40, 40);
    [returnBtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [returnBtn addTarget:self action:@selector(returnBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:returnBtn];
    self.navigationItem.leftBarButtonItem=leftBarButtonItem;
    
}
-(void)initLoginButton
{
    self.loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.loginButton.frame = CGRectMake(10, 30, 298, 42);
    [self.loginButton setImage:[UIImage imageNamed:@"weibologon.png"] forState:UIControlStateNormal];
    [self.loginButton setImage:[UIImage imageNamed:@"weibologon_click.png"] forState:UIControlStateHighlighted];
    [self.loginButton addTarget:self action:@selector(loginButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)initLogoutButton
{
    self.logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.logoutButton.frame = CGRectMake(10, 30, 298, 42);
    [self.logoutButton setImage:[UIImage imageNamed:@"weibologout.png"] forState:UIControlStateNormal];
    [self.logoutButton addTarget:self action:@selector(logoutButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
