//
//  TPTimelineViewController.m
//  TimePill
//
//  Created by simon on 13-9-15.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "TPTimelineViewController.h"

@interface TPTimelineViewController ()

@end

@implementation TPTimelineViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WeiboSelectedNotification:) name:kTPWeiboSelectedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DiaryPublishNotification:) name:kTPDiaryPublishNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ApplicationWillResignActiveNotification:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UserInfoNotification:) name:kTPSinaWeiboEngineUserInfoNotification object:nil];
    
    [self initBackground];
    [self initHeadView];
    [self initData];
    [self initTableView];
    [self initNavigation];
    [self loadUserInfo];
    
    [TPRevealViewController sharedInstance].delegate = self;
}
-(void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [super viewDidUnload];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([self.listData count] > 0) {
        if (!self.menuButtonBar) {
            [self initMenuButtonBar];
        }
        [[self view] addSubview:self.menuButtonBar];
    } else {
        [self.menuButtonBar removeFromSuperview];
        if (!self.defaultImageView) {
            [self initDefaultImageView];
        }
        [self.timelineTableView addSubview:self.defaultImageView];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
#pragma mark UITableView
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.listData count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TPTimelineDataModel *timelineData = [self.listData objectAtIndex:indexPath.row];
    TPTimelineDataModelType type = timelineData.type;
    switch (type) {
        case TPTimelineDataModelTypeWeibo:  // 微博Cell
        {
            TPWeiboDataModel *dataModel = timelineData.weiboDataModel;
            if(dataModel.commentArray && [dataModel.commentArray count] > 0)
                return dataModel.rowHeight - 5;
            else
                return dataModel.rowHeight - 20;
        }
            break;
        case TPTimelineDataModelTypeDiary:  // 日记Cell
        {
            TPDiaryDataModel *dataModel = timelineData.diaryDataModel;
            return dataModel.rowHeight;
        }
            break;
        default:
            break;
    }
    return 0.0;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{   
    TPTimelineDataModel *timelineData = [self.listData objectAtIndex:indexPath.row];
    TPTimelineDataModelType type = timelineData.type;
    switch (type) {
        case TPTimelineDataModelTypeWeibo:  // 微博Cell
            return [self tableView:tableView weiboCellForRowAtIndexPath:indexPath];
            break;
        case TPTimelineDataModelTypeDiary:  // 日记Cell
            return [self tableView:tableView diaryCellForRowAtIndexPath:indexPath];
            break;
        default:
            break;
    }
    return nil;
}
- (UITableViewCell *) tableView:(UITableView *)tableView weiboCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TPTimelineDataModel *timelineData = [self.listData objectAtIndex:indexPath.row];
    TPWeiboDataModel *dataModel = timelineData.weiboDataModel;
    
    switch (dataModel.type) {
        case TPWeiboDataTypeText:   // 0
        {
            static NSString *CellIdentifier = @"TPTimelineTableViewTextCell";
            
            TPTimelineTableViewTextCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[TPTimelineTableViewTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                [cell.addButton addTarget:self action:@selector(addButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            }
            cell.addButton.tag = indexPath.row;
            [cell setDisplayData:dataModel];
            [cell beginAddViewAnimation:timelineData.isAddViewOpen];
            [cell setAddButtonHidden:shouldHideAddButton];
            return cell;
        }
            break;
        case TPWeiboDataTypeTextWithImage:  // 1
        {
            static NSString *CellIdentifier = @"TPTimelineTableViewTextWithImageCell";
            
            TPTimelineTableViewTextWithImageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[TPTimelineTableViewTextWithImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                [cell.addButton addTarget:self action:@selector(addButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            }
            cell.addButton.tag = indexPath.row;
            [cell setDisplayData:dataModel];
            [cell beginAddViewAnimation:timelineData.isAddViewOpen];
            [cell setAddButtonHidden:shouldHideAddButton];
            return cell;
        }
            break;
        case TPWeiboDataTypeRepostText:  // 2
        {
             NSString *CellIdentifier = @"TPTimelineTableViewRepostTextCell";
            
            TPTimelineTableViewRepostTextCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[TPTimelineTableViewRepostTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                [cell.addButton addTarget:self action:@selector(addButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            }
            cell.addButton.tag = indexPath.row;
            [cell setDisplayData:dataModel];
            [cell beginAddViewAnimation:timelineData.isAddViewOpen];
            [cell setAddButtonHidden:shouldHideAddButton];
            return cell;
        }
            break;
        case TPWeiboDataTypeRepostTextWithImage:  // 3
        {
            NSString *CellIdentifier = @"TPTimelineTableViewRepostTextWithImageCell";
            
            TPTimelineTableViewRepostTextWithImageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[TPTimelineTableViewRepostTextWithImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                [cell.addButton addTarget:self action:@selector(addButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            }
            cell.addButton.tag = indexPath.row;
            [cell setDisplayData:dataModel];
            [cell beginAddViewAnimation:timelineData.isAddViewOpen];
            [cell setAddButtonHidden:shouldHideAddButton];
            return cell;
            
        }
            break;
            
        default:
            return nil;
            break;
    }
    return nil;
}
- (UITableViewCell *) tableView:(UITableView *)tableView diaryCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TPTimelineDataModel *timelineData = [self.listData objectAtIndex:indexPath.row];
    TPDiaryDataModel *dataModel = timelineData.diaryDataModel;
    
    static NSString *CellIdentifier = @"TPDiaryTableViewCell";
    
    TPDiaryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[TPDiaryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell.addButton addTarget:self action:@selector(addButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        cell.addButton.tag = indexPath.row;
    }
    [cell setDisplayData:dataModel];
    [cell beginAddViewAnimation:timelineData.isAddViewOpen];
    [cell setAddButtonHidden:shouldHideAddButton];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
#pragma mark Notification
- (void)WeiboSelectedNotification:(NSNotification *)note
{
    NSMutableArray *array = note.object;
    for(TPWeiboDataModel *dataModel in array)
    {
        [dataModel computeNewSize];
        TPTimelineDataModel *timelineData = [[TPTimelineDataModel alloc] init];
        timelineData.weiboDataModel = dataModel;
        timelineData.type = TPTimelineDataModelTypeWeibo;
        [self.listData addObject:timelineData];
    }
    
    if ([self.listData count] > 0) {
        
        if (!self.menuButtonBar) {
            [self initMenuButtonBar];
        }
        
        [self.defaultImageView removeFromSuperview];
        [self.view addSubview:self.menuButtonBar];
    }
    
    NSArray *sortedArray = [self.listData sortedArrayUsingSelector:@selector(timeComparator:)];
    [self.listData removeAllObjects];
    [self.listData addObjectsFromArray:sortedArray];
    
    [self.timelineTableView reloadData];
}
- (void)DiaryPublishNotification:(NSNotification *)note
{
    TPDiaryDataModel *dataModel = note.object;
    
    // 构造Timeline Data Model
    TPTimelineDataModel *timelineData = [[TPTimelineDataModel alloc] init];
    timelineData.type = TPTimelineDataModelTypeDiary;
    timelineData.diaryDataModel = dataModel;
    
    [self.listData addObject:timelineData];
    
    if ([self.listData count] > 0) {

        if (!self.menuButtonBar) {
            [self initMenuButtonBar];
        }
        
        [self.defaultImageView removeFromSuperview];
        [self.view addSubview:self.menuButtonBar];
    }
    
    NSArray *sortedArray = [self.listData sortedArrayUsingSelector:@selector(timeComparator:)];
    [self.listData removeAllObjects];
    [self.listData addObjectsFromArray:sortedArray];
    
    [self.timelineTableView reloadData];
}
- (void)ApplicationWillResignActiveNotification:(NSNotification *)note
{
    [[TPUtil sharedInstance] saveTimelineList:self.listData];
    [[TPUtil sharedInstance] saveUserInfo:[TPUserInfoModel sharedInstance]];
}
-(void)UserInfoNotification:(NSNotification *)note
{
    NSDictionary *dic = note.object;
    NSError *error = dic[kTPSinaWeiboEngineErrorCodeKey];
    
    if(error.code == 200)
    {
        NSDictionary * responseDic = dic[kTPSinaWeiboEngineResponseDataKey];
            
        userInfoModel.userID = [responseDic objectForKey:@"id"];
        userInfoModel.name = [responseDic objectForKey:@"screen_name"];
        userInfoModel.profileImageURL = [responseDic objectForKey:@"profile_image_url"];
        
        if(!userInfoModel.isPersonallySet) {
            [self.headView.headImageView setImageWithURL:[NSURL URLWithString:userInfoModel.profileImageURL]];
        }
    }
    
}

#pragma mark Button Clicked
-(void)showLeft:(id)Sender
{
    if ([[TPRevealViewController sharedInstance] isCentered]) {
        [[TPRevealViewController sharedInstance] showLeftViewControllerAnimated:YES];
    } else {
        [[TPRevealViewController sharedInstance] showRootViewControllerAnimated:YES];
    }
    
}
-(void)showRight:(id)Sender
{
    if ([[TPRevealViewController sharedInstance] isCentered]) {
        [[TPRevealViewController sharedInstance] showRightViewControllerAnimated:YES];
    } else {
        [[TPRevealViewController sharedInstance] showRootViewControllerAnimated:YES];
    }
}

-(void)addButtonClicked:(id)sender
{
    UIButton *addButton = (UIButton *)sender;
    int row = addButton.tag;
    
    lastAddViewIndexPath = currentAddViewIndexPath;
    currentAddViewIndexPath = [NSIndexPath indexPathForRow:row inSection:0];
    
    TPTimelineDataModel *dataModel = ((TPTimelineDataModel *)[self.listData objectAtIndex:row]);
    BOOL isAddViewOpen = dataModel.isAddViewOpen;
    ((TPTimelineDataModel *)[self.listData objectAtIndex:row]).isAddViewOpen = !isAddViewOpen;
    
    if(dataModel.type == TPTimelineDataModelTypeWeibo)
    {
        TPTimelineTableViewTextCell *cell = (TPTimelineTableViewTextCell *)[self.timelineTableView cellForRowAtIndexPath:currentAddViewIndexPath];
        [cell beginAddViewAnimation:!isAddViewOpen];
        [cell.addDeleteButton addTarget:self action:@selector(addDeleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.addCommentButton addTarget:self action:@selector(addCommentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        TPDiaryTableViewCell *cell = (TPDiaryTableViewCell *)[self.timelineTableView cellForRowAtIndexPath:currentAddViewIndexPath];
        [cell beginAddViewAnimation:!isAddViewOpen];
        [cell.addDeleteButton addTarget:self action:@selector(addDeleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if(lastAddViewIndexPath && ![lastAddViewIndexPath isEqual:currentAddViewIndexPath] &&lastAddViewIndexPath.row < [self.listData count])  // 互斥
    {
        TPTimelineDataModel *lastDataModel = ((TPTimelineDataModel *)[self.listData objectAtIndex:lastAddViewIndexPath.row]);
        BOOL isAddViewOpen = lastDataModel.isAddViewOpen;
        if(isAddViewOpen)  // 关掉
        {
            ((TPTimelineDataModel *)[self.listData objectAtIndex:lastAddViewIndexPath.row]).isAddViewOpen = !isAddViewOpen;
            
            if(dataModel.type == TPTimelineDataModelTypeWeibo)
            {
                TPTimelineTableViewTextCell *cell = (TPTimelineTableViewTextCell *)[self.timelineTableView cellForRowAtIndexPath:lastAddViewIndexPath];
                [cell beginAddViewAnimation:!isAddViewOpen];
            }
            else
            {
                TPDiaryTableViewCell *cell = (TPDiaryTableViewCell *)[self.timelineTableView cellForRowAtIndexPath:lastAddViewIndexPath];
                [cell beginAddViewAnimation:!isAddViewOpen];
            }
        }
    }
}
-(void)addDeleteButtonClicked:(id)sender
{
    [self.listData removeObjectAtIndex:currentAddViewIndexPath.row];
    [self.timelineTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:currentAddViewIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.timelineTableView reloadData];
    if ([self.listData count] == 0) {
        if (!self.defaultImageView) {
            [self initDefaultImageView];
        }

        [self.view addSubview:self.defaultImageView];
        [self.menuButtonBar removeFromSuperview];
    }
}
-(void)addCommentButtonClicked:(id)sender
{
    TPWeiboDataModel *currentDataModel = ((TPTimelineDataModel *)[self.listData objectAtIndex:currentAddViewIndexPath.row]).weiboDataModel;
    NSString *weiboID = currentDataModel.weiboId;
    TPCommentViewController *comment = [[TPCommentViewController alloc] init];
    comment.weiboID = weiboID;
    comment.selecteCcommentModelList = currentDataModel.commentArray;
    comment.fromType = TPCommentViewControllerFromTypeTimeline;
    
    __weak TPTimelineViewController *weakSelf = self;
    comment.handler = ^(NSArray *array) // 回调
    {
        currentDataModel.commentArray = array;
        [currentDataModel computeNewCommenTableViewSize];
        [weakSelf.timelineTableView reloadRowsAtIndexPaths:@[currentAddViewIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    };
    
    [self presentModalViewController:[[TPNavigationViewController alloc] initWithRootViewController:comment] animated:YES];
}
-(void)headImafeViewdidTap
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"更换头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
    [sheet showInView:self.view];
}
- (void)saveToAlbum
{
    [self.menuButtonBar hideButtonsAnimated:YES];
    [SVProgressHUD showWithStatus:@"正在生成,请稍后…" maskType:SVProgressHUDMaskTypeClear];
    [self makeLongWeibo];
    UIImageWriteToSavedPhotosAlbum(self.longWeiboImage, nil, nil, nil);
    [SVProgressHUD showSuccessWithStatus:@"成功保存到相册"];
    
    [[TPLongWeiboManager sharedInstance] saveLongWeibo:self.longWeiboImage completionHandler:^(BOOL success){}];
    
}
- (void)shareToWeibo
{
    [self.menuButtonBar hideButtonsAnimated:YES];
    [SVProgressHUD showWithStatus:@"正在生成,请稍后…" maskType:SVProgressHUDMaskTypeClear];
    [self makeLongWeibo];
    TPCreateDiaryViewController *create = [[TPCreateDiaryViewController alloc] init];
    create.longWeiboImage = self.longWeiboImage;
    [SVProgressHUD dismiss];
    [self presentModalViewController:[[TPNavigationViewController alloc] initWithRootViewController:create] animated:YES];
}
- (void)clearTimeline
{
    [self.menuButtonBar hideButtonsAnimated:YES];
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"你将清空当前的时间轴,确定要继续?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1:
            [self.listData removeAllObjects];
            [self.timelineTableView reloadData];
            if ([self.listData count] == 0) {
                if (!self.defaultImageView) {
                    [self initDefaultImageView];
                }
                [self.view addSubview:self.defaultImageView];
                [self.menuButtonBar removeFromSuperview];
            }
            break;
            
        default:
            break;
    }
}

#pragma mark Scroll
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(currentAddViewIndexPath && currentAddViewIndexPath.row < [self.listData count])   // 滚动时关掉它
    {
        BOOL isAddViewOpen = ((TPTimelineDataModel *)[self.listData objectAtIndex:currentAddViewIndexPath.row]).isAddViewOpen;
        if(isAddViewOpen)
        {
            ((TPTimelineDataModel *)[self.listData objectAtIndex:currentAddViewIndexPath.row]).isAddViewOpen = !isAddViewOpen;
            
            TPTimelineTableViewTextCell *cell = (TPTimelineTableViewTextCell *)[self.timelineTableView cellForRowAtIndexPath:currentAddViewIndexPath];
            [cell beginAddViewAnimation:!isAddViewOpen];
        }
    }
    
    
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    
    switch (buttonIndex) {
        case 0:
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera ;
                [self presentModalViewController:imagePicker animated:YES];
            }
            break;
        case 1:
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
            {
                imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentModalViewController:imagePicker animated:YES];
            }
            break;
            
        default:
            break;
    }
}
#pragma mark UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    self.headView.headImageView.image = image;
    
    userInfoModel.profileImage = image;
    userInfoModel.isPersonallySet = YES;
    
    [self dismissModalViewControllerAnimated:YES];
}
#pragma mark Theme
-(void)changeTheme
{
    self.view.backgroundColor = [UIColor colorWithPatternImage:[TPTheme currentBackgroundImage]];
    self.headView.backgroundColor = [UIColor colorWithPatternImage:[TPTheme currentHeadImage]];
    [self.timelineTableView reloadData];
}

#pragma mark Theme TPRevealViewControllerDelegate
-(void)revealViewController:(TPRevealViewController *)controller didShowControllerWithType:(TPRevealViewControllerType)type {
    if (type == TPRevealViewControllerCenter) {
        [self enaleUserInterface:YES];
    } else {
        [self enaleUserInterface:NO];
    }
}
#pragma mark private
-(void)makeLongWeibo
{
    // 长微博
    self.menuButtonBar.hidden = YES;
    
    // 备份Frame数据
    CGRect originViewRect = self.view.frame;
    CGRect origineTableRect = self.timelineTableView.frame;
    CGRect longRect = CGRectMake(0, 0, self.view.frame.size.width,self.timelineTableView.contentSize.height);
    
    // 更新长Frame
    self.view.frame = longRect;
    self.timelineTableView.frame = longRect;
    shouldHideAddButton = YES;
    [self.timelineTableView reloadData];
    
    CFRunLoopRunInMode(kCFRunLoopDefaultMode, 1.0, FALSE);  // 先休眠一下 因为load图是在另一个线程
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.view.frame.size.width, self.timelineTableView.contentSize.height), NO, 0.0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    [self.timelineTableView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    // 得到长微博
    UIImage * longImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // 还原Frame
    self.timelineTableView.frame = origineTableRect;
    self.view.frame = originViewRect;
    shouldHideAddButton = NO;
    [self.timelineTableView reloadData];
    self.longWeiboImage = longImage;
    self.menuButtonBar.hidden = NO;
}

-(void)loadUserInfo
{
    if([[TPSinaWeiboEngine sharedInstance] isLogon])
    {
        [[TPSinaWeiboEngine sharedInstance] requestUserInfoWithUID:nil];
    }
}

-(void)enaleUserInterface:(BOOL)enable
{
    self.timelineTableView.scrollEnabled = enable;
    self.menuButtonBar.userInteractionEnabled = enable;
    self.headView.userInteractionEnabled = enable;
    NSArray *array = [self.timelineTableView visibleCells];
    
    for (id cell in array) {
        [cell setAddButtonEnable:enable];
    }
}

#pragma mark init
-(void)initBackground
{
    self.view.backgroundColor = [UIColor colorWithPatternImage:[TPTheme currentBackgroundImage]];
}
-(void)initData
{
    self.listData = [[TPUtil sharedInstance] TimelineList];
    
    if(!self.listData)
        self.listData = [[NSMutableArray alloc] init];
    
    shouldUpdateCell = YES;
    shouldHideAddButton = NO;
}
-(void)initHeadView
{
    self.headView = [[TPTimelineHeaderView alloc] initWithFrame:CGRectMake(0, 0, 320,153.5)];
    [self.headView.headImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headImafeViewdidTap)]];
    userInfoModel = [TPUserInfoModel sharedInstance];
    if(userInfoModel.profileImage)
        self.headView.headImageView.image = userInfoModel.profileImage;
}
-(void)initTableView
{
    self.timelineTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.timelineTableView.delegate = self;
    self.timelineTableView.dataSource = self;
    self.timelineTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.timelineTableView.bounces = NO;
    self.timelineTableView.backgroundColor = [UIColor clearColor];
    [self.timelineTableView setTableHeaderView:self.headView];
    [self.view addSubview:self.timelineTableView];
}
-(void)initNavigation
{
    //导航bar
    UINavigationBar *navBar = nil;
    //[navBar setBackgroundImage:[UIImage imageNamed:@"nav-bar.png"] forBarMetrics:UIBarMetricsDefault];
    
    if(iOS7)
    {
        navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
        [navBar setBackgroundImage:[UIImage imageNamed:@"nav-bar128.png"] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
    }
    else
    {
        navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        [navBar setBackgroundImage:[UIImage imageNamed:@"nav-bar.png"] forBarMetrics:UIBarMetricsDefault];
    }
   
    navBar.titleTextAttributes = @{UITextAttributeTextColor : [UIColor whiteColor],UITextAttributeFont:[UIFont fontWithName: @"ShiShangZhongHeiJianTi" size:20.0],UITextAttributeTextShadowOffset:[NSValue valueWithUIOffset:UIOffsetMake(0.8, 0.8)]};
    
    //导航item
    UINavigationItem *item=[[UINavigationItem alloc] initWithTitle:nil];
    [navBar pushNavigationItem:item animated:YES];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setBackgroundColor:[UIColor clearColor]];
    rightButton.frame = CGRectMake(0, 0, 40, 40);
    [rightButton setImage:[UIImage imageNamed:@"addData.png"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(showRight:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    item.rightBarButtonItem = button;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 40, 40);
    [backButton setImage:[UIImage imageNamed:@"change.png"] forState:UIControlStateNormal];
    //[backButton setImage:[UIImage imageNamed:@"timeclick.png"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(showLeft:) forControlEvents:UIControlEventTouchUpInside];
    button = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    item.leftBarButtonItem = button;
    
    item.title = @"我的时间轴";
    
    [self.view addSubview:navBar];
    
}

-(void)initMenuButtonBar
{
    UIImage *image = [UIImage imageNamed:@"jiahao.png"];
    UIImage *selectedImage = [UIImage imageNamed:@"jiahao.png"];
    UIImage *toggledImage = [UIImage imageNamed:@"jiahao.png"];
    UIImage *toggledSelectedImage = [UIImage imageNamed:@"jiahao.png"];
    
    CGPoint center = CGPointMake(40.0f, self.view.frame.size.height - 55.0);
    
    NSArray *buttons;
    CGRect buttonFrame = CGRectMake(0, 0, 60.0f, 60.0f);
    UIButton *b1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [b1 setFrame:buttonFrame];
    [b1 setImage:[UIImage imageNamed:@"saveToAlbum.png"] forState:UIControlStateNormal];
    [b1 addTarget:self action:@selector(saveToAlbum) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *b2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [b2 setImage:[UIImage imageNamed:@"publishToWeibo.png"] forState:UIControlStateNormal];
    [b2 setFrame:buttonFrame];
    [b2 addTarget:self action:@selector(shareToWeibo) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *b3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [b3 setImage:[UIImage imageNamed:@"deleteTimeline.png"] forState:UIControlStateNormal];
    [b3 setFrame:buttonFrame];
    [b3 addTarget:self action:@selector(clearTimeline) forControlEvents:UIControlEventTouchUpInside];
    
    buttons = [NSArray arrayWithObjects:b1, b2, b3, nil];
    
    self.menuButtonBar = [[ExpandingButtonBar alloc] initWithImage:image selectedImage:selectedImage toggledImage:toggledImage toggledSelectedImage:toggledSelectedImage buttons:buttons center:center];
    [self.menuButtonBar setHorizontal:YES];
    [self.menuButtonBar setDelay:0.00];
    [self.menuButtonBar setExplode:YES];
    [self.menuButtonBar setSpin:YES];
}
-(void)initDefaultImageView
{
    self.defaultImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-10, CGRectGetHeight(self.view.frame) / 2 - 110, 320,320)];
    self.defaultImageView.image = [UIImage imageNamed:@"timelineDefault.png"];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
