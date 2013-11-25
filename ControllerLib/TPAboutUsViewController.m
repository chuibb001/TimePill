//
//  TPAboutUsViewController.m
//  TimePill
//
//  Created by yan simon on 13-10-30.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "TPAboutUsViewController.h"

@interface TPAboutUsViewController ()

@end

@implementation TPAboutUsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[TPTheme currentBackgroundImageNoLine]];
    [self initNavigation];
    self.rightLabel.frame = CGRectMake(self.rightLabel.frame.origin.x, [UIScreen mainScreen].bounds.size.height - 110, self.rightLabel.frame.size.width, self.rightLabel.frame.size.height);
}

-(void)returnBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark init
-(void)initNavigation
{
    self.title = @"版本信息";
    //返回按钮
    UIButton *returnBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    returnBtn.frame=CGRectMake(0, 0, 40, 40);
    [returnBtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [returnBtn addTarget:self action:@selector(returnBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:returnBtn];
    self.navigationItem.leftBarButtonItem=leftBarButtonItem;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)visitWeb:(id)sender {
    UIWebView *myWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    NSURL *url = [NSURL URLWithString:@"http://www.applesysu.com/blog/"];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    [myWebView loadRequest:req];
    
    
    [self.view addSubview:myWebView];
}
@end
