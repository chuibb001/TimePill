//
//  TPRefreshTableView.h
//  TimePill
//
//  Created by yan simon on 13-9-16.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DisPlayDataSource <NSObject>

- (void)loadMoreData; // 加载更多

- (void)refreshData;   // 下拉更新

@end

@interface TPRefreshTableView : UITableView
{
    
@protected
    
    BOOL isDragging;
    BOOL isRefreshing;
    BOOL isLoadingMore;
    
    // had to store this because the headerView's frame seems to be changed somewhere during scrolling
    // and I couldn't figure out why >.<
    CGRect headerViewFrame;
}

@property (nonatomic, assign) id<DisPlayDataSource> disPlayDataSource;

// The view used for "pull to refresh"
@property (nonatomic, retain) UIView *headerView;

// The view used for "load more"
@property (nonatomic, retain) UIView *footerView;

@property (readonly) BOOL isDragging;
@property (readonly) BOOL isRefreshing;
@property (readonly) BOOL isLoadingMore;
@property (nonatomic) BOOL canLoadMore;

@property (nonatomic) BOOL pullToRefreshEnabled;

// Defaults to YES
@property (nonatomic) BOOL clearsSelectionOnViewWillAppear;

// Just a common initialize method
- (void) initialize;

#pragma mark - Pull to Refresh

// The minimum height that the user should drag down in order to trigger a "refresh" when
// dragging ends.
- (CGFloat) headerRefreshHeight;

// Will be called if the user drags down which will show the header view. Override this to
// update the header view (e.g. change the label to "Pull down to refresh").
- (void) willShowHeaderView:(UIScrollView *)scrollView;

// If the user is dragging, will be called on every scroll event that the headerView is shown.
// The value of willRefreshOnRelease will be YES if the user scrolled down enough to trigger a
// "refresh" when the user releases the drag.
- (void) headerViewDidScroll:(BOOL)willRefreshOnRelease scrollView:(UIScrollView *)scrollView;

// By default, will permanently show the headerView by setting the tableView's contentInset.
- (void) pinHeaderView;

// Reverse of pinHeaderView.
- (void) unpinHeaderView;

// Called when the user stops dragging and, if the conditions are met, will trigger a refresh.
- (void) willBeginRefresh;

// Override to perform fetching of data. The parent method [super refresh] should be called first.
// If the value is NO, -refresh should be aborted.
- (BOOL) refresh;

// Call to signal that refresh has completed. This will then hide the headerView.
- (void) refreshCompleted;

#pragma mark - Load More

// The value of the height starting from the bottom that the user needs to scroll down to in order
// to trigger -loadMore. By default, this will be the height of -footerView.
- (CGFloat) footerLoadMoreHeight;

// Override to perform fetching of next page of data. It's important to call and get the value of
// of [super loadMore] first. If it's NO, -loadMore should be aborted.
- (BOOL) loadMore;

// Called when all the conditions are met and -loadMore will begin.
- (void) willBeginLoadingMore;

// Call to signal that "load more" was completed. This should be called so -isLoadingMore is
// properly set to NO.
- (void) loadMoreCompleted;

// Helper to show/hide -footerView
- (void) setFooterViewVisibility:(BOOL)visible;


// 在Controller实现UIScrollViewDelegate,然后间接调用以下三个函数
-(void)beginScroll;

-(void)Scrolling:(UIScrollView *)scrollView;

-(void)endScroll:(UIScrollView *)scrollView ;

-(void)Stop;

@end

@interface TPRefreshTableHeaderView : UIView {
    
    UILabel *title;
    UIActivityIndicatorView *activityIndicator;
}

@property (nonatomic, retain) UILabel *title;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;

@end

@interface TPRefreshTableFooterView : UIView {
    
    UIActivityIndicatorView *activityIndicator;
    UILabel *infoLabel;
}

@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) UILabel *infoLabel;

@end