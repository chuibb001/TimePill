//
//  TPLeftMenuViewController.m
//  TimePill
//
//  Created by simon on 13-9-15.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "TPLeftMenuViewController.h"

@interface TPLeftMenuViewController ()

@end

@implementation TPLeftMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:45./255. green:45./255. blue:45./255. alpha:1.0];
    [self initData];
    [self initTableView];
    [self initInfoView];
}

-(void)changeTheme {
    [self.menuTableView reloadData];
}

#pragma mark UITableView
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return TPLeftMenuTypeCount;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}

#define TPMenuLabelTag 8
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TPMenuTableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(43, 10, 150, 30)];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithRed:191./255. green:191./255. blue:191./255. alpha:1.0];
        label.font = [UIFont boldSystemFontOfSize:16.0];
        label.tag = TPMenuLabelTag;
        [cell addSubview:label];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if(iOS7)
    {
        if(self.currentSelectedType == indexPath.row)
            cell.backgroundColor = [UIColor colorWithPatternImage:[TPTheme currentMenuBackgroundImage]];
        else
            cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"slideCellNomal.png"]];
    }
    else
    {
        if(self.currentSelectedType == indexPath.row)
            cell.imageView.image = [TPTheme currentMenuBackgroundImage];
        else
            cell.imageView.image = [UIImage imageNamed:@"slideCellNomal.png"];
    }
    
    UILabel *label = (UILabel *)[cell viewWithTag:TPMenuLabelTag];
    switch (indexPath.row) {
        case TPLeftMenuTypeTimeLine:
            [label setText:@"我的时间轴"];
            break;
        case TPLeftMenuTypeTimeHall:
            [label setText:@"时光画廊"];
            break;
        case TPLeftMenuTypeSetting:
            [label setText:@"设置"];
            break;
        default:
            break;
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    switch (indexPath.row) {
        case TPLeftMenuTypeTimeLine:
        {
            self.currentSelectedType = TPLeftMenuTypeTimeLine;
            [self.menuTableView reloadData];
            
            [[TPRevealViewController sharedInstance] changeRootViewController:self.timelineController];
            [[TPRevealViewController sharedInstance] setRightViewControllerEnable:YES];
            [[TPRevealViewController sharedInstance] setLeftViewControllerEnable:YES];
        }
            break;
        case TPLeftMenuTypeTimeHall:
        {
            if(!self.hallController)
            {
                self.hallController = [[TPTimeHallViewController alloc] init];
            }
            
            self.currentSelectedType = TPLeftMenuTypeTimeHall;
            [self.menuTableView reloadData];
            
            [[TPRevealViewController sharedInstance] changeRootViewController:self.hallController];
            [[TPRevealViewController sharedInstance] setRightViewControllerEnable:NO];
            [[TPRevealViewController sharedInstance] setLeftViewControllerEnable:NO];
        }
            break;
        case TPLeftMenuTypeSetting:
        {
            if(!self.settingController)
            {
                self.settingController = [[TPSettingViewController alloc] init];
            }
            
            self.currentSelectedType = TPLeftMenuTypeSetting;
            [self.menuTableView reloadData];
            
            [[TPRevealViewController sharedInstance] changeRootViewController:[[TPNavigationViewController alloc] initWithRootViewController:self.settingController]];
            [[TPRevealViewController sharedInstance] setRightViewControllerEnable:NO];
            [[TPRevealViewController sharedInstance] setLeftViewControllerEnable:NO];
        }
        default:
            break;
    }
}

#pragma mark init
-(void)initData
{
    self.listData = [[NSMutableArray alloc] init];
}
-(void)initTableView
{
    self.menuTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 180, 250.0)];
    self.menuTableView.delegate = self;
    self.menuTableView.dataSource = self;
    self.menuTableView.scrollEnabled = NO;
    self.menuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // footer & header
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320.0, 50.0)];
    footerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"slideCellNomalFooter.png"]];
    [self.menuTableView setTableFooterView:footerView];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320.0, 50.0)];
    headerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"slideCellNomalHeader.png"]];
    [self.menuTableView setTableHeaderView:headerView];
    [self.view addSubview:self.menuTableView];
    self.menuTableView.center = CGPointMake(180 / 2, self.view.frame.size.height / 2);
}
- (void)initInfoView
{
    //self.headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(60, 60, 110, 110)];
    //self.headImageView.image = [UIImage imageNamed:@"icon23.png"];
    //self.headImageView.layer.cornerRadius = 45.0;
    //self.headImageView.layer.masksToBounds = YES;
    //self.headImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    //self.headImageView.layer.borderWidth = 5.0;
    //[self.view addSubview:self.headImageView];
//    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 140, 230, 20)];
//    self.nameLabel.textColor = [UIColor whiteColor];
//    self.nameLabel.font = [UIFont boldSystemFontOfSize:17.0];
//    self.nameLabel.text = @"小宇宙是大坏蛋";
//    self.nameLabel.textAlignment = NSTextAlignmentCenter;
//    self.nameLabel.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:self.nameLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
