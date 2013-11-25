//
//  TPRefreshTableView.m
//  TimePill
//
//  Created by yan simon on 13-9-16.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "TPRefreshTableView.h"

#define DEFAULT_HEIGHT_OFFSET 52.0f

@implementation TPRefreshTableView

@synthesize headerView;
@synthesize footerView;
@synthesize isDragging;
@synthesize isRefreshing;
@synthesize isLoadingMore;
@synthesize canLoadMore;
@synthesize pullToRefreshEnabled;
@synthesize clearsSelectionOnViewWillAppear;
@synthesize disPlayDataSource;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initialize];
        //[self initNotification];
    }
    return self;
}
- (void) initialize
{
    pullToRefreshEnabled = YES;
    
    canLoadMore = YES;
    
    clearsSelectionOnViewWillAppear = YES;
    
    TPRefreshTableHeaderView *aheaderView = [[TPRefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, 320.0, 50)];
    self.headerView = aheaderView;
    
    TPRefreshTableFooterView *afooterView = [[TPRefreshTableFooterView alloc] initWithFrame:CGRectMake(0, 0, 320.0, 50)];
    self.footerView = afooterView;
    
    self.backgroundColor = [UIColor colorWithRed:246./255. green:246./255. blue:246./255. alpha:1.0];
}


-(void)Stop
{
    /*处理视图复原*/
    if(isRefreshing)
        [self refreshCompleted];
    if(isLoadingMore)
        [self loadMoreCompleted];
}

#pragma mark 滚动视图
- (void) beginScroll
{
    if (isRefreshing || isLoadingMore)
        return;
    isDragging = YES;
}

- (void) Scrolling:(UIScrollView *)scrollView
{
    if (!isRefreshing && isDragging && scrollView.contentOffset.y < 0) {
        [self headerViewDidScroll:scrollView.contentOffset.y < 0 - [self headerRefreshHeight]
                       scrollView:scrollView];
        //NSLog(@"1");
    }
    else if (!isLoadingMore && canLoadMore) {
        //NSLog(@"2");
        CGFloat scrollPosition = scrollView.contentSize.height - scrollView.frame.size.height - scrollView.contentOffset.y;
        if (scrollPosition < [self footerLoadMoreHeight]) {
            [self loadMore];
            //NSLog(@"Scrolling");
        }
    }
}

- (void)endScroll:(UIScrollView *)scrollView
{
    if (isRefreshing)
        return;
    
    isDragging = NO;
    if (scrollView.contentOffset.y <= 0 - [self headerRefreshHeight]) {
        NSLog(@"end");
        if (pullToRefreshEnabled)
            [self refresh];
    }
}

#pragma mark - Pull to Refresh

/*setter*/
- (void) setHeaderView:(UIView *)aView
{
    
    if (!self)
        return;
    
    if (headerView && [headerView isDescendantOfView:self])
        [headerView removeFromSuperview];
    //[headerView release]; headerView = nil;
    headerView=nil;
    if (aView) {
        //headerView = [aView retain];
        headerView=aView;
        CGRect f = headerView.frame;
        headerView.frame = CGRectMake(f.origin.x, 0 - f.size.height, f.size.width, f.size.height);
        headerViewFrame = headerView.frame;
        
        [self addSubview:headerView];
    }
    
}

/*返回header的动态height*/
- (CGFloat) headerRefreshHeight
{
    if (!CGRectIsEmpty(headerViewFrame))
        return headerViewFrame.size.height;
    else
        return DEFAULT_HEIGHT_OFFSET;
}

- (void) willShowHeaderView:(UIScrollView *)scrollView
{
    
}

/*下拉step0*/
- (void) headerViewDidScroll:(BOOL)willRefreshOnRelease scrollView:(UIScrollView *)scrollView
{
    TPRefreshTableHeaderView *hv = (TPRefreshTableHeaderView *)self.headerView;
    if (willRefreshOnRelease)
        hv.title.text = @"松开即可刷新..";
    else
        hv.title.text = @"下拉可以刷新..";
}

/*下拉step1*/
- (BOOL) refresh
{
    /*
     加了一句！下拉的时候不可以下拉！
     */
    self.canLoadMore=NO;
    
    if (isRefreshing)
        return NO;
    /*一边转菊花*/
    [self willBeginRefresh];
    isRefreshing = YES;
    /*一边开始加载数据*/
    //[self performSelector:@selector(addItemsOnTop) withObject:nil afterDelay:0.0];
    //[self performSelector:@selector(addItemsOnTop)];
    [self addItemsOnTop];
    
    return YES;
}

/*下拉step2*/
- (void) willBeginRefresh
{
    if (pullToRefreshEnabled)
        [self pinHeaderView];
}

/*下拉step3*/
- (void) pinHeaderView
{
    /*
     加多一句！下拉ing不可以再次触发下拉！
     */
    pullToRefreshEnabled=NO;
    
    [UIView animateWithDuration:0.3 animations:^(void) {
        self.contentInset = UIEdgeInsetsMake([self headerRefreshHeight], 0, 0, 0);
        //NSLog(@"headerRefreshHeight%f",[self headerRefreshHeight]);
        self.contentOffset=CGPointMake(0, -[self headerRefreshHeight]);
    }];
    
    // do custom handling for the header view
    TPRefreshTableHeaderView *hv = (TPRefreshTableHeaderView *)self.headerView;
    [hv.activityIndicator startAnimating];
    hv.title.text = @"加载中..";
}

/*下拉step4*/
- (void) addItemsOnTop
{
    /*从delegate执行数据刷新*/
    [disPlayDataSource refreshData];
}

/*下拉step5*/
- (void) refreshCompleted
{
    isRefreshing = NO;
    
    [self unpinHeaderView];
}

/*下拉step6*/
- (void) unpinHeaderView
{
    [UIView animateWithDuration:0.3 animations:^(void) {
        self.contentInset = UIEdgeInsetsZero;
        self.contentOffset=CGPointMake(0, 0);
    }];
    
    // do custom handling for the header view
    [[(TPRefreshTableHeaderView *)self.headerView activityIndicator] stopAnimating];
    
    /*
     加了一句！复原这两个标志位！
     */
    self.canLoadMore=YES;
    self.pullToRefreshEnabled=YES;  //NSLog(@"unpinHeaderView");
}

#pragma mark - Load More

/*setter*/
- (void) setFooterView:(UIView *)aView
{
    if (!self)
        return;
    
    self.tableFooterView = nil;
    //[footerView release]; footerView = nil;
    footerView=nil;
    if (aView) {
        //footerView = [aView retain];
        footerView=aView;
        self.tableFooterView = footerView;
    }
}

-(CGFloat)footerLoadMoreHeight
{
    if (footerView)
        return footerView.frame.size.height;
    else
        return DEFAULT_HEIGHT_OFFSET;
}

- (void) setFooterViewVisibility:(BOOL)visible
{
    if (visible && self.tableFooterView != footerView)
        self.tableFooterView = footerView;
    else if (!visible)
        self.tableFooterView = nil;
}

/*加载更多step1*/
- (BOOL) loadMore
{
    /*禁止上下拉*/
    pullToRefreshEnabled=NO;
    canLoadMore=NO;
    
    if (isLoadingMore)
        return NO;
    
    /*一边转菊花*/
    [self willBeginLoadingMore];
    isLoadingMore = YES;
    /*一边加载更多数据*/
    //[self performSelector:@selector(addItemsOnBottom) withObject:nil afterDelay:0.0];
    //[self performSelector:@selector(addItemsOnBottom)];
    [self addItemsOnBottom];
    return YES;
}

/*加载更多step2*/
- (void) willBeginLoadingMore
{
    TPRefreshTableFooterView *fv = (TPRefreshTableFooterView *)self.footerView;
    [fv.activityIndicator startAnimating];
}

/*加载更多step3*/
- (void) addItemsOnBottom
{
    /*调用delegate的加载更多*/
    [disPlayDataSource loadMoreData];
}

/*加载更多step4*/
- (void) loadMoreCompleted
{
    isLoadingMore = NO;
    
    TPRefreshTableFooterView *fv = (TPRefreshTableFooterView *)self.footerView;
    [fv.activityIndicator stopAnimating];
    
    /*if (!self.canLoadMore) {
     // Do something if there are no more items to load
     
     // We can hide the footerView by: [self setFooterViewVisibility:NO];
     
     // Just show a textual info that there are no more items to load
     fv.infoLabel.hidden = NO;
     }*/
    //NSLog(@"pullToRefreshEnabled");
    pullToRefreshEnabled=YES;
    canLoadMore=YES;
}
@end

@implementation TPRefreshTableHeaderView
@synthesize title,activityIndicator;

-(id)initWithFrame:(CGRect)frame
{
    if([super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor clearColor];
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(42, 17, 237, 21)];
        self.title.backgroundColor = [UIColor clearColor];
        self.title.font = [UIFont boldSystemFontOfSize:15.0];
        self.title.textColor = [UIColor grayColor];
        self.title.text = @"下拉可以刷新...";
        self.title.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.title];
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(15, 17, 20, 20)];
        [self addSubview:self.activityIndicator];
    }
    return self;
}

@end

@implementation TPRefreshTableFooterView
@synthesize infoLabel,activityIndicator;

-(id)initWithFrame:(CGRect)frame
{
    if([super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor clearColor];
//        self.infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 14, 280, 21)];
//        self.infoLabel.backgroundColor = [UIColor clearColor];
//        self.infoLabel.font = [UIFont boldSystemFontOfSize:15.0];
//        self.infoLabel.textColor = [UIColor grayColor];
//        self.infoLabel.text = @"没有更多可加载...";
//        self.infoLabel.textAlignment = NSTextAlignmentCenter;
//        [self addSubview:self.infoLabel];
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(150, 15, 20, 20)];
        [self addSubview:self.activityIndicator];
    }
    return self;
}

@end
