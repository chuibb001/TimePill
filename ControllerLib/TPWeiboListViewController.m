//
//  TPWeiboListViewController.m
//  TPSinaWeiboSDK
//
//  Created by yan simon on 13-9-12.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "TPWeiboListViewController.h"

@interface TPWeiboListViewController ()

@end

@implementation TPWeiboListViewController

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
    [self loadWeibo];
    self.zoomImageView = [[TPZoomImageView alloc] init];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UserTimelineNotification:) name:kTPSinaWeiboEngineUserTimelineNotification object:nil];
    
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
    TPWeiboDataModel *dataModel = [self.listData objectAtIndex:indexPath.row];
    return dataModel.rowHeight;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TPWeiboDataModel *dataModel = [self.listData objectAtIndex:indexPath.row];
    switch (dataModel.type) {
        case TPWeiboDataTypeText:   // 0
        {
            static NSString *CellIdentifier = @"TPWeiboTableViewTextCell";
            
            TPWeiboTableViewTextCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[TPWeiboTableViewTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.commentButton.tag = [indexPath row];
                [cell.commentButton addTarget:self action:@selector(commentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            }
            [cell setDisplayData:dataModel];
            
            return cell;
        }
        break;
        case TPWeiboDataTypeTextWithImage:  // 1
        {
            static NSString *CellIdentifier = @"TPWeiboTableViewTextWithImageCell";
            
            TPWeiboTableViewTextWithImageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[TPWeiboTableViewTextWithImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.commentButton.tag = [indexPath row];
                [cell.commentButton addTarget:self action:@selector(commentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                // 手势
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(UserTaped:)];
                [cell.picImageView addGestureRecognizer:tap];
                cell.picImageView.userInteractionEnabled = YES;
            }
            cell.picImageView.tag = [indexPath row];
            [cell setDisplayData:dataModel];
            
            return cell;
        }
        break;
        case TPWeiboDataTypeRepostText:  // 2
        {
            static NSString *CellIdentifier = @"TPWeiboTableViewRepostTextCell";
            
            TPWeiboTableViewRepostTextCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[TPWeiboTableViewRepostTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.commentButton.tag = [indexPath row];
                [cell.commentButton addTarget:self action:@selector(commentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            }
            [cell setDisplayData:dataModel];
            
            return cell;
        }
        break;
        case TPWeiboDataTypeRepostTextWithImage:  // 3
        {
            static NSString *CellIdentifier = @"TPWeiboTableViewRepostTextWithImageCell";
            
            TPWeiboTableViewRepostTextWithImageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[TPWeiboTableViewRepostTextWithImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.commentButton.tag = [indexPath row];
                [cell.commentButton addTarget:self action:@selector(commentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                // 手势
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(UserTaped:)];
                [cell.picImageView addGestureRecognizer:tap];
                cell.picImageView.userInteractionEnabled = YES;
            }
            cell.picImageView.tag = [indexPath row];
            [cell setDisplayData:dataModel];
            
            return cell;
        }
            break;
            
        default:
        return nil;
            break;
        }
    return nil; 
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL selected = ((TPWeiboDataModel *)[self.listData objectAtIndex:indexPath.row]).isSelected;
    ((TPWeiboDataModel *)[self.listData objectAtIndex:indexPath.row]).isSelected = !selected;
    TPWeiboTableViewTextCell *cell=(TPWeiboTableViewTextCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell setRadioButtonSelected:!selected];
}

#pragma mark- Display DataSource
-(void)refreshData
{
    type = TPWeiboUpDateTypeRefresh;
    page = 1;
    currentRequestID = [[TPSinaWeiboEngine sharedInstance] requestUserTimelineWithUID:self.userID Count:[NSString stringWithFormat:@"%d",count] Page:[NSString stringWithFormat:@"%d",page] SinceId:nil trimUSer:nil];
}

-(void)loadMoreData
{
    type = TPWeiboUpDateTypeLoadMore;
    page ++;
    currentRequestID = [[TPSinaWeiboEngine sharedInstance] requestUserTimelineWithUID:self.userID Count:[NSString stringWithFormat:@"%d",count] Page:[NSString stringWithFormat:@"%d",page] SinceId:nil trimUSer:nil];
}


#pragma mark private
-(void)loadWeibo
{
    [self.weiboTableView refresh];
}
-(void)UserTimelineNotification:(NSNotification *)note
{
    NSDictionary *dic = note.object;
    NSError *error = dic[kTPSinaWeiboEngineErrorCodeKey];
    
    if(error.code == 200)
    {
        NSDictionary * responseDic = dic[kTPSinaWeiboEngineResponseDataKey];

        NSArray *statuses = [responseDic objectForKey:@"statuses"];
        if(type == TPWeiboUpDateTypeRefresh)
           [self.listData removeAllObjects];
        
        for(int i = 0;i<[statuses count] ;i++)
        {
            NSDictionary *status = [statuses objectAtIndex:i];
            TPWeiboDataModel *dataModel = [[TPWeiboDataModel alloc] initWithDictionary:status];
            [self.listData addObject:dataModel];       
        }
        [self.weiboTableView reloadData];
        [self.weiboTableView Stop];
        
        if(type == TPWeiboUpDateTypeRefresh) // 缓存
            [[TPUtil sharedInstance] saveWeiboList:self.listData UIN:self.userID];
        
    }
    else
    {
        [self.weiboTableView Stop];
    }
}

-(void)returnBack:(id)sender
{
    [[TPNetworkManager sharedInstance] cancelRequestWithID:currentRequestID];
    
    if(self.fromType == TPWeiboListViewControllerFromTypeMenu)
        [self.navigationController dismissModalViewControllerAnimated:YES];
    else
        [self.navigationController popViewControllerAnimated:YES];
    
    [[TPRevealViewController sharedInstance] showRightViewControllerAnimated:NO];
}

-(void)DoneClicked:(id)sender
{
    [[TPNetworkManager sharedInstance] cancelRequestWithID:currentRequestID];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for(TPWeiboDataModel *dataModel in self.listData)
    {
        if(dataModel.isSelected)
           [array addObject:dataModel];
    }
    
    [[TPRevealViewController sharedInstance] showRootViewControllerAnimated:NO];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kTPWeiboSelectedNotification object:array];
    
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

-(void)commentButtonClicked:(id)sender
{
    int index = ((UIButton *)sender).tag;
    NSString *weiboID = ((TPWeiboDataModel *)[self.listData objectAtIndex:index]).weiboId;
    TPWeiboDataModel *currentDataModel = (TPWeiboDataModel *)[self.listData objectAtIndex:index];
    TPCommentViewController *comment = [[TPCommentViewController alloc] init];
    comment.weiboID = weiboID;
    comment.selecteCcommentModelList = currentDataModel.commentArray;
    comment.fromType = TPCommentViewControllerFromTypeWeibo;
    
    TPWeiboTableViewTextCell *cell = (TPWeiboTableViewTextCell *)[self.weiboTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    
    comment.handler = ^(NSArray *array) // 回调
    {
        currentDataModel.commentArray = array;
        if([array count] > 0)
        {
            currentDataModel.isSelected = YES;
            [cell setRadioButtonSelected:YES];
        }
    };
    
    [self.navigationController pushViewController:comment animated:YES];
}
-(void)UserTaped:(UIGestureRecognizer *)sender
{
    int index = sender.view.tag;
    TPWeiboDataModel *dataModel = [self.listData objectAtIndex:index];
    
    [self.zoomImageView showWithBmiddleURL:dataModel.bmiddleImageURL ThumbnailImage:dataModel.thumbnailImage];
}

#pragma mark init
-(void)initData
{
    self.listData = [[TPUtil sharedInstance] weiboListForUIN:self.userID];
    if (self.listData) {
        [self.weiboTableView reloadData];
    }
    else
        self.listData = [[NSMutableArray alloc] init];
    page = 1;
    count = 50;
}
-(void)initTableView
{
    self.weiboTableView = [[TPRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44)];
    self.weiboTableView.delegate = self;
    self.weiboTableView.dataSource = self;
    self.weiboTableView.disPlayDataSource = self;
    self.weiboTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.weiboTableView];
}
-(void)initNavigation
{
    if(self.userID)
        self.title = @"微博库";
    else
        self.title = @"我的微博库";
    
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
#pragma mark - UIScrollViewDelegate
- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.weiboTableView beginScroll];
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.weiboTableView Scrolling:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.weiboTableView endScroll:scrollView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
