//
//  TPCommentViewController.m
//  TimePill
//
//  Created by simon on 13-9-19.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "TPCommentViewController.h"

@interface TPCommentViewController ()

@end

@implementation TPCommentViewController

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
    self.view.backgroundColor = [UIColor whiteColor];
    [self initData];
    [self initTableView];
    [self initNavigation];
    [self loadComment];
    [self initDefaultImageView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CommentsNotification:) name:kTPSinaWeiboEngineCommentsNotification object:nil];
    
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
    TPCommentDataModel *dataModel = [self.listData objectAtIndex:indexPath.row];
    return dataModel.rowHeight;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TPCommentDataModel *dataModel = [self.listData objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"TPCommentTableViewCell";
    
    TPCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[TPCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell setDisplayData:dataModel];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(isEditing)
    {
        BOOL selected = ((TPCommentDataModel *)[self.listData objectAtIndex:indexPath.row]).isSelected;
        ((TPCommentDataModel *)[self.listData objectAtIndex:indexPath.row]).isSelected = !selected;
        TPCommentTableViewCell *cell=(TPCommentTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        [cell setRadioButtonSelected:!selected];
        
    }
}

#pragma mark- Display DataSource
-(void)refreshData
{
    type = TPCommentUpDateTypeRefresh;
    page = 1;
    currenRequestID = [[TPSinaWeiboEngine sharedInstance] requestCommentsWithWeiboId:self.weiboID Count:[NSString stringWithFormat:@"%d",count] Page:[NSString stringWithFormat:@"%d",page]];
}

-(void)loadMoreData
{
    type = TPCommentUpDateTypeLoadMore;
    page ++;
    currenRequestID = [[TPSinaWeiboEngine sharedInstance] requestCommentsWithWeiboId:self.weiboID Count:[NSString stringWithFormat:@"%d",count] Page:[NSString stringWithFormat:@"%d",page]];
}


#pragma mark private
-(void)loadComment
{
    [self.commentTableView refresh];
}
-(void)CommentsNotification:(NSNotification *)note
{
    NSDictionary *dic = note.object;
    NSError *error = dic[kTPSinaWeiboEngineErrorCodeKey];
    
    if(error.code == 200)
    {
        NSDictionary * responseDic = dic[kTPSinaWeiboEngineResponseDataKey];
        //NSLog(@"%@",responseDic);
        NSArray *comments = [responseDic objectForKey:@"comments"];
        if(type == TPCommentUpDateTypeRefresh)
            [self.listData removeAllObjects];
        
        for(int i = 0;i<[comments count] ;i++)
        {
            NSDictionary *comment = [comments objectAtIndex:i];
            TPCommentDataModel *dataModel = [[TPCommentDataModel alloc] initWithDictionary:comment];
            // 判断该评论是否已选择过了
            if ([idset containsObject:dataModel.commentId]) {
                dataModel.isSelected = YES;
            }
            [self.listData addObject:dataModel];
        }
        
        if ([self.listData count] > 0) {
            [self.defaultImageView removeFromSuperview];
        }
        [self.commentTableView reloadData];
        [self.commentTableView Stop];
    }
    else
    {
        [self.commentTableView Stop];
    }
}

-(void)LeftButtonClicked
{
    if(isEditing == NO)
    {
        isEditing = YES;
        [[TPNetworkManager sharedInstance] cancelRequestWithID:currenRequestID];
        
        if(self.fromType == TPCommentViewControllerFromTypeTimeline)
           [self dismissModalViewControllerAnimated:YES];
        else
            [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        isEditing = NO;

        // 回复原状
        [UIView animateWithDuration:0.25f animations:^(void)
         {
             self.commentTableView.frame=CGRectMake(-50, self.commentTableView.frame.origin.y, self.commentTableView.frame.size.width, self.commentTableView.frame.size.height);
         }];
        [self.rightButton setImage:[UIImage imageNamed:@"addtotucao.png"] forState:UIControlStateNormal];
        // 改变navBar
        self.title = @"评论";
        [self resetHeaderViewPosition:NO];
    }
}

-(void)RightButtonClicked
{
    if(isEditing == NO)
    {
        isEditing = YES;
        // TableView右移
        [UIView animateWithDuration:0.25f animations:^(void)
         {
             self.commentTableView.frame=CGRectMake(0, self.commentTableView.frame.origin.y, self.commentTableView.frame.size.width, self.commentTableView.frame.size.height);
         }];
        // 设置右按钮样式
        [self.rightButton setImage:[UIImage imageNamed:@"done.png"] forState:UIControlStateNormal];
        
        // 改变navBar
        self.title = @"添加至时间轴";
        [self resetHeaderViewPosition:YES];
    }
    else {
        isEditing = NO;
        if(self.rightButton.enabled == YES)
        {
            NSMutableArray *returnArray = [[NSMutableArray alloc] init];
            for(TPCommentDataModel *dataModel in [self.listData objectEnumerator])
            {
                if(dataModel.isSelected)
                   [returnArray addObject:dataModel];
            }
            
            self.handler(returnArray);
            if(self.fromType == TPCommentViewControllerFromTypeTimeline)
                [self dismissModalViewControllerAnimated:YES];
            else
                [self.navigationController popViewControllerAnimated:YES];
        }
        
        
    }
}
-(void)resetHeaderViewPosition:(BOOL)isOpen  // isOpen是radioButton有没打开
{
    if(isOpen)
    {
        self.commentTableView.headerView.frame = CGRectMake(0, CGRectGetMinY(self.commentTableView.headerView.frame), CGRectGetWidth(self.commentTableView.headerView.frame), CGRectGetHeight(self.commentTableView.headerView.frame));
        self.commentTableView.footerView.frame = CGRectMake(0, CGRectGetMinY(self.commentTableView.footerView.frame), CGRectGetWidth(self.commentTableView.footerView.frame), CGRectGetHeight(self.commentTableView.footerView.frame));
        self.commentTableView.bounces = NO;
        self.commentTableView.canLoadMore = NO;
    }
    else
    {
        self.commentTableView.headerView.frame = CGRectMake(50, CGRectGetMinY(self.commentTableView.headerView.frame), CGRectGetWidth(self.commentTableView.headerView.frame), CGRectGetHeight(self.commentTableView.headerView.frame));
        self.commentTableView.footerView.frame = CGRectMake(50, CGRectGetMinY(self.commentTableView.footerView.frame), CGRectGetWidth(self.commentTableView.footerView.frame), CGRectGetHeight(self.commentTableView.footerView.frame));
        self.commentTableView.bounces = YES;
        self.commentTableView.canLoadMore = YES;
    }
    
}

#pragma mark init
-(void)initData
{
    self.listData = [[NSMutableArray alloc] init];
    page = 1;
    count = 50;
    isEditing = NO;
    
    if(self.selecteCcommentModelList)  // 初始化已选择的ID集合
    {
        idset = [[NSMutableSet alloc] init];
        for(TPCommentDataModel *dataModel in [self.selecteCcommentModelList objectEnumerator])
        {
            [idset addObject:dataModel.commentId];
        }
    }
}
-(void)initTableView
{
    self.commentTableView = [[TPRefreshTableView alloc] initWithFrame:CGRectMake(-50, 0, 320+50, self.view.frame.size.height)];
    self.commentTableView.delegate = self;
    self.commentTableView.dataSource = self;
    self.commentTableView.disPlayDataSource = self;
    self.commentTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:self.commentTableView];
    [self resetHeaderViewPosition:NO];
}
-(void)initNavigation
{
    //导航bar
    self.title = @"评论";
    
    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rightButton setBackgroundColor:[UIColor clearColor]];
    self.rightButton.frame = CGRectMake(0, 0, 40, 40);
    [self.rightButton setImage:[UIImage imageNamed:@"addtotucao.png"] forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(RightButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    
    self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.leftButton setBackgroundColor:[UIColor clearColor]];
    self.leftButton.frame = CGRectMake(0, 0, 40, 40);
    [self.leftButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [self.leftButton addTarget:self action:@selector(LeftButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftButton];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
}
-(void)initDefaultImageView
{
    self.defaultImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) / 2 - 250, 320,320)];
    self.defaultImageView.image = [UIImage imageNamed:@"noComments.png"];
    [self.view addSubview:self.defaultImageView];
}

#pragma mark - UIScrollViewDelegate
- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.commentTableView beginScroll];
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.commentTableView Scrolling:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.commentTableView endScroll:scrollView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
