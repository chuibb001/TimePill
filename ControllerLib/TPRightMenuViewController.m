//
//  TPRightMenuViewController.m
//  TimePill
//
//  Created by simon on 13-9-15.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "TPRightMenuViewController.h"

@interface TPRightMenuViewController ()

@end

@implementation TPRightMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:45./255. green:45./255. blue:45./255. alpha:1.0];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ApplicationWillResignActiveNotification:) name:UIApplicationWillResignActiveNotification object:nil];
    [self initData];
    [self initTableView];
}

#pragma mark UITableView
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == TPRightMenuTypeChangeTheme)
    {
        if(self.isThemeOpen)
            return 1;
        else
            return 0;
    }
    else if (section == TPRightMenuTypeMyFriends)
    {
        return [self.listData count];
    }

    return 0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return TPRightMenuTypeCount;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 3)
        return 50.0;
    else if(indexPath.section == 2)
        return 80.0;
    else
        return 0.0;
}

#define kSectionHeaderButtonBaseTag 1000
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case TPRightMenuTypeCreateDiary:   
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, 0, 320, 50);
            [button setBackgroundImage:[UIImage imageNamed:@"slideCellNomal.png"] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"slideCellClick.png"] forState:UIControlStateHighlighted];
            button.tag = kSectionHeaderButtonBaseTag + section;
            [button addTarget:self action:@selector(ButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(140, 14, 20, 20)];
            imageView.image = [UIImage imageNamed:@"write.png"];
            [button addSubview:imageView];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(175, 10, 150, 30)];
            label.backgroundColor = [UIColor clearColor];
            label.textColor = [UIColor colorWithRed:191./255. green:191./255. blue:191./255. alpha:1.0];
            label.font = [UIFont boldSystemFontOfSize:16.0];
            label.text = @"写日记";
            [button addSubview:label];
            return button;
        }
            break;
            case TPRightMenuTypeMyWeibo:
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, 0, 320, 50);
            [button setBackgroundImage:[UIImage imageNamed:@"slideCellNomal.png"] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"slideCellClick.png"] forState:UIControlStateHighlighted];
            button.tag = kSectionHeaderButtonBaseTag + section;
            [button addTarget:self action:@selector(ButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(140, 14, 20, 20)];
            imageView.image = [UIImage imageNamed:@"weiboKit.png"];
            [button addSubview:imageView];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(175, 10, 150, 30)];
            label.backgroundColor = [UIColor clearColor];
            label.textColor = [UIColor colorWithRed:191./255. green:191./255. blue:191./255. alpha:1.0];
            label.font = [UIFont boldSystemFontOfSize:16.0];
            label.text = @"我的微博库";
            [button addSubview:label];
            return button;
        }
            break;
            case TPRightMenuTypeChangeTheme:
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, 0, 320, 50);
            [button setBackgroundImage:[UIImage imageNamed:@"slideCellNomal.png"] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"slideCellClick.png"] forState:UIControlStateHighlighted];
            button.tag = kSectionHeaderButtonBaseTag + section;
            [button addTarget:self action:@selector(ButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(140, 14, 20, 20)];
            imageView.image = [UIImage imageNamed:@"theme.png"];
            [button addSubview:imageView];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(175, 10, 150, 30)];
            label.backgroundColor = [UIColor clearColor];
            label.textColor = [UIColor colorWithRed:191./255. green:191./255. blue:191./255. alpha:1.0];
            label.font = [UIFont boldSystemFontOfSize:16.0];
            label.text = @"更换主题";
            [button addSubview:label];
            return button;
        }
            break;
            case TPRightMenuTypeMyFriends:
        {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
            view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"slideSectionCell.png"]];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(140, 5, 150, 20)];
            label.backgroundColor = [UIColor clearColor];
            
            label.textColor = [UIColor colorWithRed:191./255. green:191./255. blue:191./255. alpha:1.0];
            label.font = [UIFont boldSystemFontOfSize:15.0];
            label.text = @"小伙伴";
            [view addSubview:label];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(270, 0, 30, 30);
            [button setImage:[UIImage imageNamed:@"addButton.png"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(ButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = kSectionHeaderButtonBaseTag + section;
            [view addSubview:button];
            return view;
        }
        default:
            break;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 3)
        return 30.0;
    else
        return 50.0;
}

#define kTPNameLabelTag 8
#define kTPHeadImageViewTag 9
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if(indexPath.section == 2 && indexPath.row == 0)
    {
        static NSString *CellIdentifier = @"TPMenuTableViewCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.imageView.image = [UIImage imageNamed:@"slideThemeCell.png"];
        if(!self.themeScrollView)
        {
            self.themeScrollView = [self ThemeScrollView];
            UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(197, 62, 20, 15)];
            pageControl.numberOfPages = 2;
            pageControl.currentPage = 0;
            pageControl.alpha = 0.8;
            [pageControl addTarget:self action:@selector(showChanges) forControlEvents:UIControlEventValueChanged];
            [cell addSubview:pageControl];
        }
        [cell addSubview:self.themeScrollView];
        return cell;
    }
    else if(indexPath.section == 3)
    {
        static NSString *CellIdentifier = @"TPMenuTableViewCell2";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            UILabel * nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(175, 16, 180, 20)];
            nameLabel.backgroundColor = [UIColor clearColor];
            nameLabel.textColor = [UIColor colorWithRed:191./255. green:191./255. blue:191./255. alpha:1.0];
            nameLabel.font = [UIFont boldSystemFontOfSize:16.0];
            nameLabel.tag = kTPNameLabelTag;
            [cell addSubview:nameLabel];
            
            UIImageView * headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(130, 10, 30, 30)];
            headImageView.layer.cornerRadius = 3.0;
            headImageView.layer.masksToBounds = YES;
            headImageView.tag = kTPHeadImageViewTag;
            [cell addSubview:headImageView];
            
            if(iOS7)
            {
                cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"slideCellNomal.png"]];
            }
            else
            {
                cell.imageView.image = [UIImage imageNamed:@"slideCellNomal.png"]; 
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        TPFriendDataModel *dataModel = [self.listData objectAtIndex:indexPath.row];
        UILabel * nameLabel = (UILabel *)[cell viewWithTag:kTPNameLabelTag];
        nameLabel.text = dataModel.name;
        UIImageView *headImageView = (UIImageView *)[cell viewWithTag:kTPHeadImageViewTag];
        // 加载图片
        [headImageView setImageWithURL:[NSURL URLWithString:dataModel.profileImageURL] placeholderImage:nil];
        return cell;
    }
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.section == 3)
    {
        int row = [indexPath row];
        NSString *userID = ((TPFriendDataModel *)[self.listData objectAtIndex:row]).userID;
        TPRevealViewController *reveal = [TPRevealViewController sharedInstance];
        TPWeiboListViewController *diary = [[TPWeiboListViewController alloc] init];
        diary.fromType = TPWeiboListViewControllerFromTypeMenu;
        diary.userID = userID;
        [reveal presentModalViewController:[[TPNavigationViewController alloc] initWithRootViewController:diary] animated:YES];
    }
}
#pragma mark Button Clicked
- (void)ButtonClicked:(id)sender
{
    int tag = ((UIButton *)sender).tag;
    
    switch (tag) {
        case kSectionHeaderButtonBaseTag:   // 写日记
        {
            TPRevealViewController *reveal = [TPRevealViewController sharedInstance];
            TPCreateDiaryViewController *diary = [[TPCreateDiaryViewController alloc] init];
            [reveal presentModalViewController:[[TPNavigationViewController alloc] initWithRootViewController:diary] animated:YES];
        }
            break;
        case kSectionHeaderButtonBaseTag + 1:   // 我的微博
        {
            TPRevealViewController *reveal = [TPRevealViewController sharedInstance];
            if ([[TPSinaWeiboEngine sharedInstance] isLogon]) {
                TPWeiboListViewController *diary = [[TPWeiboListViewController alloc] init];
                diary.fromType = TPWeiboListViewControllerFromTypeMenu;
                [reveal presentModalViewController:[[TPNavigationViewController alloc] initWithRootViewController:diary] animated:YES];
            }
            else {
                TPLoginViewController *login = [[TPLoginViewController alloc] init];
                [reveal presentModalViewController:[[TPNavigationViewController alloc] initWithRootViewController:login] animated:YES];
            }
            
        }
            break;
        case kSectionHeaderButtonBaseTag + 2:   // 换主题
            if(!self.isThemeOpen)
            {
                self.isThemeOpen = YES;
                [self.menuTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:2]] withRowAnimation:UITableViewRowAnimationNone];
            }
            else
            {
                self.isThemeOpen = NO;
                [self.menuTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:2]] withRowAnimation:UITableViewRowAnimationNone];
            }
            break;
        case kSectionHeaderButtonBaseTag + 3:   // 小伙伴
        {
            TPFriendsViewController * f = [[TPFriendsViewController alloc] init];
            TPRevealViewController *reveal = [TPRevealViewController sharedInstance];
            __weak TPRightMenuViewController *weakSelf = self;
            f.handler = ^(TPFriendDataModel *dataModel)
            {
                if([weakSelf.listData count] == 0)
                    [weakSelf.listData addObject:dataModel];
                else 
                {
                    // 排重
                    BOOL contains = NO;
                    for(TPFriendDataModel *model in self.listData)
                    {
                        if([model.userID isEqualToString:dataModel.userID])
                            contains = YES;
                    }
                    if(!contains)
                    {
                        [weakSelf.listData insertObject:dataModel atIndex:0];
                        if([weakSelf.listData count] > 3)
                        {
                            [weakSelf.listData removeObjectAtIndex:3];
                        }
                    }
                    
                }
                
                [weakSelf.menuTableView reloadData];
            };
            [reveal presentModalViewController:[[TPNavigationViewController alloc] initWithRootViewController:f] animated:YES];
        }
        default:
            break;
    }
}

-(void)ThemeButtonClicked:(id)sender
{
    UIButton *button = (UIButton *)sender;
    int tag = button.tag;
    switch (tag) {
        case 0:
        {
            [TPTheme changeTheme:TPThemeTypeBlue];
            
        }
            break;
        case 1:
        {
            [TPTheme changeTheme:TPThemeTypeYellow];
        }
            break;
        case 2:
        {
            [TPTheme changeTheme:TPThemeTypeGray];
        }
            break;
        case 3:
        {
            [TPTheme changeTheme:TPThemeTypeDefault];
        }
            break;
            
        default:
            break;
    }
    
    TPRevealViewController *reveal = [TPRevealViewController sharedInstance];
    TPTimelineViewController *controler =  (TPTimelineViewController *)reveal.rootViewController;
    [controler changeTheme];
    TPLeftMenuViewController *left = (TPLeftMenuViewController *)reveal.leftViewController;
    [left changeTheme];
    
}

- (void)ApplicationWillResignActiveNotification:(NSNotification *)note
{
    [[TPUtil sharedInstance] saveFriendList:self.listData];
}
#pragma mark init
-(void)initData
{
    self.listData = [[TPUtil sharedInstance] FriendList];
    if(!self.listData)
        self.listData = [[NSMutableArray alloc] init];
    self.isThemeOpen = NO;
}
-(void)initTableView
{
    self.menuTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.menuTableView.delegate = self;
    self.menuTableView.dataSource = self;
    self.menuTableView.scrollEnabled = NO;
    self.menuTableView.backgroundColor = [UIColor clearColor];
    self.menuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // footer & header
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320.0, 50.0)];
    footerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"slideCellNomalFooter.png"]];
    [self.menuTableView setTableFooterView:footerView];
    
    UIView *headerView = nil;
    if (iOS7) {
        headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320.0, 64.0)];
        headerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"slideCellNomalHeader128.png"]];
    }
    else {
        headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320.0, 44.0)];
        headerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"slideCellNomalHeader88.png"]];
    }
    
    [self.menuTableView setTableHeaderView:headerView];
    [self.view addSubview:self.menuTableView];
}

#define kThemeButtonBaseTag 2000
- (UIScrollView *)ThemeScrollView
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(90 , 0, 230.0, 80.0)];
    scrollView.pagingEnabled = YES;  //是否自动滑到边缘的关键
    scrollView.contentSize = CGSizeMake(230.0 * 2, 80.0);
    scrollView.showsHorizontalScrollIndicator = NO;
    //self.emotionScrollView.delegate=self;
    NSArray *imageArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"darkBlueTheme.png"],[UIImage imageNamed:@"darkGreenTheme.png"],[UIImage imageNamed:@"darkGrayTheme.png"],[UIImage imageNamed:@"darkYellowTheme.png"], nil];
    NSArray *textArray = [NSArray arrayWithObjects:[NSString stringWithFormat:@"蓝色"],[NSString stringWithFormat:@"黄色"],[NSString stringWithFormat:@"灰色"],[NSString stringWithFormat:@"黄色"], nil];
    
    for(int i = 0;i<3;i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(30 + 64*i, 15, 43, 43);
        button.tag = kThemeButtonBaseTag + i;
        [button setBackgroundImage:imageArray[i] forState:UIControlStateNormal];
        //button.backgroundColor = [colorArray objectAtIndex:i];
        button.layer.cornerRadius = 5.0;
        button.layer.masksToBounds = YES;
        button.tag = i;
        [button addTarget:self action:@selector(ThemeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:button];
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40 + 64*i, 45, 50, 20)];
//        label.backgroundColor = [UIColor clearColor];
//        label.textColor = [UIColor whiteColor];
//        label.font = [UIFont boldSystemFontOfSize:11.0];
//        label.text = [textArray objectAtIndex:i];
//        [scrollView addSubview:label];
    }
    
    for(int i = 0;i<1;i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(230 + 30 + 64*i, 15, 43, 43);
        button.tag = kThemeButtonBaseTag + i;
        [button setBackgroundImage:imageArray[i+3] forState:UIControlStateNormal];
        //button.backgroundColor = [colorArray objectAtIndex:i + 3];
        button.layer.cornerRadius = 5.0;
        button.layer.masksToBounds = YES;
        button.tag = i+3;
        [button addTarget:self action:@selector(ThemeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:button];
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(230 + 40 + 64*i, 45, 50, 20)];
//        label.backgroundColor = [UIColor clearColor];
//        label.textColor = [UIColor whiteColor];
//        label.font = [UIFont boldSystemFontOfSize:11.0];
//        label.text = [textArray objectAtIndex:i + 3];
//        [scrollView addSubview:label];
    }
    
    return scrollView;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
