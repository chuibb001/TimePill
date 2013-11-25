//
//  TPFriendsViewController.m
//  TimePill
//
//  Created by simon on 13-9-28.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "TPFriendsViewController.h"

@interface TPFriendsViewController ()

@end

@implementation TPFriendsViewController

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
	// Do any additional setup after loading the view.
    [self initData];
    [self initTableView];
    [self initNavigation];
    [self loadFriends];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(FriendsNotification:) name:kTPSinaWeiboEngineFriendsNotification object:nil];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark UITableView
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.listData count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55.0;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TPFriendDataModel *dataModel = [self.listData objectAtIndex:indexPath.row];
    static NSString *CellIdentifier = @"TPFriendsTableViewCell";
    
    TPFriendsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[TPFriendsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell setDisplayData:dataModel];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.friendTableView deselectRowAtIndexPath:indexPath animated:YES];
    TPWeiboListViewController *weibo = [[TPWeiboListViewController alloc] init];
    TPFriendDataModel *dataModel = (TPFriendDataModel *)[self.listData objectAtIndex:indexPath.row];
    weibo.fromType = TPWeiboListViewControllerFromTypeFriends;
    weibo.userID = dataModel.userID;
    self.handler(dataModel);
    [self.navigationController pushViewController:weibo animated:YES];
}

#pragma mark- Display DataSource
-(void)refreshData
{
    type = TPFriendsUpDateTypeRefresh;
    self.nextCursor = @"0";
    currentRequestID = [[TPSinaWeiboEngine sharedInstance] requestFriendsWithUID:self.userID Count:[NSString stringWithFormat:@"%d",count] Cursor:self.nextCursor trimStatus:nil];
    
}

-(void)loadMoreData
{
    type = TPFriendsUpDateTypeLoadMore;
    currentRequestID = [[TPSinaWeiboEngine sharedInstance] requestFriendsWithUID:self.userID Count:[NSString stringWithFormat:@"%d",count] Cursor:self.nextCursor trimStatus:nil];
}


#pragma mark private
-(void)loadFriends
{
    [self.friendTableView refresh];
}
-(void)FriendsNotification:(NSNotification *)note
{
    NSDictionary *dic = note.object;
    NSError *error = dic[kTPSinaWeiboEngineErrorCodeKey];
    
    if(error.code == 200)
    {
        NSDictionary * responseDic = dic[kTPSinaWeiboEngineResponseDataKey];
        //NSLog(@"%@",responseDic);
        NSArray *statuses = [responseDic objectForKey:@"users"];
        self.nextCursor = [NSString stringWithFormat:@"%@",[responseDic objectForKey:@"next_cursor"]];
        if(type == TPFriendsUpDateTypeRefresh)
            [self.listData removeAllObjects];
        
        for(int i = 0;i<[statuses count] ;i++)
        {
            NSDictionary *status = [statuses objectAtIndex:i];
            TPFriendDataModel *dataModel = [[TPFriendDataModel alloc] initWithDictionary:status];
            [self.listData addObject:dataModel];
        }
        [self.friendTableView reloadData];
        [self.friendTableView Stop];
    }
    else
    {
        [self.friendTableView Stop];
    }
}

-(void)returnBack:(id)sender
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
    
    [[TPNetworkManager sharedInstance] cancelRequestWithID:currentRequestID];
    
    [[TPRevealViewController sharedInstance] showRightViewControllerAnimated:NO];
}

#pragma mark init
-(void)initData
{
    self.listData = [[NSMutableArray alloc] init];
    self.userID = nil;
    self.nextCursor = @"0";
    page = 1;
    count = 50;
}
-(void)initTableView
{
    self.friendTableView = [[TPRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44)];
    self.friendTableView.delegate = self;
    self.friendTableView.dataSource = self;
    self.friendTableView.disPlayDataSource = self;
    [self.view addSubview:self.friendTableView];
}
-(void)initNavigation
{
    self.title = @"我的小伙伴";
    
    //返回按钮
    UIButton *returnBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    returnBtn.frame=CGRectMake(0, 0, 40, 40);
    [returnBtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [returnBtn addTarget:self action:@selector(returnBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:returnBtn];
    self.navigationItem.leftBarButtonItem=leftBarButtonItem;
    
}
#pragma mark - UIScrollViewDelegate
- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.friendTableView beginScroll];
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.friendTableView Scrolling:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.friendTableView endScroll:scrollView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
