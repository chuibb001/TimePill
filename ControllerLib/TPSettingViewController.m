//
//  TPSettingViewController.m
//  TimePill
//
//  Created by yan simon on 13-9-18.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "TPSettingViewController.h"


@interface TPSettingViewController ()

@end

@implementation TPSettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    self.view.backgroundColor = [UIColor whiteColor];
    self.settingTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) style:UITableViewStyleGrouped];
    self.settingTableView.delegate = self;
    self.settingTableView.dataSource = self;
    self.settingTableView.userInteractionEnabled = YES;
    
    [self.view addSubview:self.settingTableView];
    
    [self initNavigation];
}

#pragma mark UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return TPSettingCount;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"settingCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.contentView.tag = 1000;
    }
    [cell.textLabel setFont:[UIFont fontWithName:@"System Bold" size:17.0]];
    cell.userInteractionEnabled = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    switch (indexPath.row) {
        case TPSettingTypeAccount:
            cell.textLabel.text = @"账户管理";
            break;
        case TPSettingTypeVersion:
            cell.textLabel.text = @"版本信息";
            break;
        case TPSettingTypeRecommend:
            cell.textLabel.text = @"推荐我们";
            break;
        case TPSettingTypeFeedback:
            cell.textLabel.text = @"意见反馈";
            break;
        default:
            break;
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.settingTableView deselectRowAtIndexPath:indexPath animated:NO];
    
    switch (indexPath.row) {
        case TPSettingTypeAccount:
        {
            TPLoginViewController *login = [[TPLoginViewController alloc] init];
            __weak TPSettingViewController *weakSelf = self;
            login.handler = ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            };
            [self.navigationController pushViewController:login animated:YES];
        }
            break;
        case TPSettingTypeVersion:
        {
            TPAboutUsViewController *about = [[TPAboutUsViewController alloc] initWithNibName:@"TPAboutUsViewController" bundle:nil];
            [self.navigationController pushViewController:about animated:YES];
        }
            break;
        case TPSettingTypeRecommend:
        {
            if ([[TPSinaWeiboEngine sharedInstance] isLogon]) {
                UIImage *image=[UIImage imageNamed:@"tuijianwomen.png"];
                [[TPSinaWeiboEngine sharedInstance] postImageStatusWithText:@"#时光胶囊#选取想要的微博,贴上有趣的评论,加上个性主题背景,做成一条精美的长微博！想晒甜蜜,po个性?一次性满足你!APPStore下载:https://itunes.apple.com/us/app/shi-guang-jiao-nang/id621917638?ls=1&mt=8" Latitude:nil Longitude:nil Image:image];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"感谢你的推荐" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"你还没有登录新浪微博" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
            }
        }
            break;
        case TPSettingTypeFeedback:
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto://simonyy@foxmail.com"]];
        }
            break;
        default:
            break;
    }
}


#pragma mark private
-(void)showLeft:(id)Sender
{
    if ([[TPRevealViewController sharedInstance] isCentered]) {
        [[TPRevealViewController sharedInstance] showLeftViewControllerAnimated:YES];
    } else {
        [[TPRevealViewController sharedInstance] showRootViewControllerAnimated:YES];
    }
    
}

#pragma mark init
-(void)initNavigation
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 40, 40);
    [backButton setImage:[UIImage imageNamed:@"change.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(showLeft:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * button = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = button;
    
    self.title = @"设置";
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
