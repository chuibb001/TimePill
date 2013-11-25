//
//  TPRevealViewController.m
//  TPRevealController
//
//  Created by yan simon on 13-9-10.
//  Copyright (c) 2013年 yan simon. All rights reserved.
//

#import "TPRevealViewController.h"

typedef enum
{
    TPRevealSwipeDirectionLeft,
    TPRevealSwipeDirectionRight
}
TPRevealSwipeDirection;

@interface TPRevealViewController ()

@property (nonatomic,assign) CGRect baseRect; // current frame of rootViewcontroller
@property (nonatomic,assign) CGFloat leftBorder;
@property (nonatomic,assign) CGFloat rightBorder;
@property (nonatomic,strong) UIPanGestureRecognizer *pan;
@property (nonatomic,strong) UITapGestureRecognizer *tap;
@property (nonatomic,assign) const CGRect leftRect; // left frame of rootViewcontroller
@property (nonatomic,assign) const CGRect centerRect; // center frame of rootViewcontroller
@property (nonatomic,assign) const CGRect rightRect; // right frame of rootViewcontroller
@property (nonatomic,assign) CGPoint velocity; // swipe speed
@property (nonatomic,assign) TPRevealSwipeDirection direction; // swipe direction
@property (nonatomic,assign) TPRevealViewControllerType upperController;
@property (nonatomic,assign) BOOL canSwipe;
@end

@implementation TPRevealViewController

static TPRevealViewController *instance;

+ (id)sharedInstance
{
    if(!instance)
        instance = [[TPRevealViewController alloc] init];
    return instance;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setupData];
    [self setupViewController];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark Gesture Recognizer
- (void)gestureRecognizerDidPan:(UIPanGestureRecognizer*)panGesture
{
    /**
     *  what to do in the finger down state is to change root viewcontroller's frame
     */
    if(panGesture.state == UIGestureRecognizerStateChanged)
    {
        // record swipe speed
        self.velocity = [self.pan velocityInView:self.view];
        // relative coordinate
        CGPoint point = [panGesture translationInView:self.view];
        // record swipe direction
        if(point.x > 0)
            self.direction = TPRevealSwipeDirectionRight;
        else
            self.direction = TPRevealSwipeDirectionLeft;
        

        if(self.baseRect.origin.x + point.x < self.rightBorder && self.baseRect.origin.x + point.x > self.leftBorder && fabsf(point.x) > 3.0 && self.canSwipe)
        {
            self.rootViewController.view.frame = CGRectMake(self.baseRect.origin.x + point.x, self.rootViewController.view.frame.origin.y, self.rootViewController.view.frame.size.width, self.rootViewController.view.frame.size.height);
            // ajust the order between left and right viewcontroller
            if(self.leftViewController && self.rightViewController)
            {
                if (self.rootViewController.view.frame.origin.x > 0 && self.upperController != TPRevealSwipeDirectionLeft) {
                    [self.view exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
                    self.upperController = TPRevealSwipeDirectionLeft;
                }
                else if (self.rootViewController.view.frame.origin.x < 0 && self.upperController != TPRevealSwipeDirectionRight)
                {
                    [self.view exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
                    self.upperController = TPRevealSwipeDirectionRight;
                }
            }
        }
    }
    /**
     *  When finger up , determine which position is the end
     */
    else if(panGesture.state == UIGestureRecognizerStateEnded)
    {
        CGFloat minX = CGRectGetMinX(self.rootViewController.view.frame);
        CGFloat maxX = CGRectGetMaxX(self.rootViewController.view.frame);
        CGRect endRect = CGRectZero;
        
        BOOL shouldQuickSwipe = NO;
        if(self.velocity.x > 200.0 || self.velocity.x < -200.0) // quick swipe
        {
            shouldQuickSwipe = YES;
            
        }
        
        if (minX > 0) {
            if (!shouldQuickSwipe) {
                if (minX < self.leftOffSet / 2) {
                    endRect = self.centerRect;
                } else {
                    endRect = self.rightRect;
                }
            } else {
                switch (self.direction) {
                    case TPRevealSwipeDirectionLeft:
                        endRect = self.centerRect;
                        break;
                    case TPRevealSwipeDirectionRight:
                        endRect = self.rightRect;
                        break;
                    default:
                        break;
                }
            }
            
        } else if (minX < 0) {
            if (!shouldQuickSwipe) {
                CGFloat mid = (320 + 320 - self.rightOffSet) / 2;
                if (maxX < mid) {
                    endRect = self.leftRect;
                } else {
                    endRect = self.centerRect;
                }
            } else {
                switch (self.direction) {
                    case TPRevealSwipeDirectionLeft:
                        endRect = self.leftRect;
                        break;
                    case TPRevealSwipeDirectionRight:
                        endRect = self.centerRect;
                        break;
                    default:
                        break;
                }
            }
            
        }
        
        // animation time
        CGFloat timeInterval =fabsf(320.0 / self.velocity.x);
        timeInterval = (timeInterval < 0.2)?timeInterval:0.2;
        
        // start animation
        if(!CGRectEqualToRect(endRect, CGRectZero))
        {
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView animateWithDuration:timeInterval animations:^{
                self.rootViewController.view.frame = endRect;
            } completion:^(BOOL Finished){
                self.rootViewController.view.frame = endRect;
                self.baseRect = endRect;
            }];
        }
    }
    
}
- (void)gestureRecognizerDidTap:(UIPanGestureRecognizer*)panGesture
{
    [self showRootViewControllerAnimated:YES];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (touch.view.tag == 1000) {
        return NO;
    }
    return YES;
}
#pragma mark animation
-(void)showRootViewControllerAnimated:(BOOL)animate
{
    if(!self.rootViewController)
        return ;
    
    if(animate)
    {
        [UIView beginAnimations:@"ShowRootView" context:nil];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        self.rootViewController.view.frame = self.centerRect;
        self.baseRect = self.centerRect;
        [UIView commitAnimations];
    }
    else
    {
        self.rootViewController.view.frame = self.centerRect;
        self.baseRect = self.centerRect;
    }
}

-(void)showLeftViewControllerAnimated:(BOOL)animate
{
    if(!self.leftViewController)
        return ;
    
    if(self.upperController != TPRevealSwipeDirectionLeft) {
        [self.view exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
        self.upperController = TPRevealSwipeDirectionLeft;
    }
    
    if(animate)
    {
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView animateWithDuration:0.3f animations:^{
            self.rootViewController.view.frame = self.rightRect;
        } completion:^(BOOL Finished){
            self.rootViewController.view.frame = self.rightRect;
            self.baseRect = self.rightRect;
        }];
    }
    else
    {
        self.rootViewController.view.frame = self.rightRect;
        self.baseRect = self.rightRect;
    }
}

-(void)showRightViewControllerAnimated:(BOOL)animate
{
    if(!self.rightViewController)
        return ;
    
    if(self.upperController != TPRevealSwipeDirectionRight) {
        [self.view exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
        self.upperController = TPRevealSwipeDirectionRight;
    }
    
    if(animate)
    {
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView animateWithDuration:0.3f animations:^{
            self.rootViewController.view.frame = self.leftRect;
        } completion:^(BOOL Finished){
            self.rootViewController.view.frame = self.leftRect;
            self.baseRect = self.leftRect;
        }];
    }
    else
    {
        self.rootViewController.view.frame = self.leftRect;
        self.baseRect = self.leftRect;
    }
}

// 在Left和Right都有的情况下隐藏左边。必须在视图加载后才可调用,因为ViewDidLoad会先Setup一次数据。
-(void)setLeftViewControllerEnable:(BOOL)enable  
{
    if(!(self.leftViewController && self.rightViewController))
        return ;
    
    if(!enable)  // 通过改变边界值来限制滑动
    {
        self.rightBorder = 0.0;
    }
    else
    {
        self.rightBorder = self.leftOffSet;
    }
}
// 在Left和Right都有的情况下隐藏右边。
-(void)setRightViewControllerEnable:(BOOL)enable
{
    if(!(self.leftViewController && self.rightViewController))
        return ;
    
    if(!enable)  // 通过改变边界值来限制滑动
    {
        self.leftBorder = 0.0 ;
    }
    else
    {
        self.leftBorder = - self.rightOffSet;
    }
}
-(void)changeRootViewController:(UIViewController *) rootController
{
    [self.rootViewController.view removeFromSuperview];
    CGRect oldRect = self.rootViewController.view.frame;
    self.rootViewController = rootController;
    
    rootController.view.frame = oldRect;  // Frame
    if(rootController.view.layer.shadowOpacity == 0.0)    // Shadow
        [self addShadowToRootView];
    if([self.view.gestureRecognizers count] == 0)       // pan & tap
        [self addGestureToRootView];
    
    [self.view addSubview:self.rootViewController.view];
    rootController.view.frame = oldRect;
    [self showRootViewControllerAnimated:YES];
}

-(BOOL)isCentered {
    if (CGRectEqualToRect(self.baseRect, self.centerRect)) {
        return YES;
    }
    return NO;
}

#pragma mark init
-(void)setupData
{
    self.leftOffSet = 150.0;
    self.rightOffSet = 230.0;

    self.rootViewController.view.frame = CGRectMake(0, 0, 320.0, self.view.bounds.size.height + 0);
    self.leftViewController.view.frame = CGRectMake(0, 0, 320.0, self.view.bounds.size.height + 0);
    self.rightViewController.view.frame = CGRectMake(0, 0, 320.0, self.view.bounds.size.height + 0);
    self.baseRect = self.rootViewController.view.frame;
    self.leftRect = CGRectMake(- self.rightOffSet, self.baseRect.origin.y, self.baseRect.size.width, self.baseRect.size.height);
    self.centerRect = CGRectMake(0.0, self.baseRect.origin.y, self.baseRect.size.width, self.baseRect.size.height);
    self.rightRect = CGRectMake(self.leftOffSet, self.baseRect.origin.y, self.baseRect.size.width, self.baseRect.size.height);
    self.canSwipe = YES;
    
    if(self.leftViewController && self.rightViewController)
    {
        self.leftBorder = - self.rightOffSet;
        self.rightBorder = self.leftOffSet;
    }
    else if(self.leftViewController && !self.rightViewController)
    {
        self.leftBorder = 0.0;
        self.rightBorder = self.leftOffSet;
    }
    else if(!self.leftViewController && self.rightViewController)
    {
        self.leftBorder = - self.rightOffSet;
        self.leftBorder = 0.0;
    }
    else
    {
        self.leftBorder = 0.0;
        self.rightBorder = 0.0;
    }
    
    
}
- (void)setLeftOffSet:(CGFloat)leftOffSet
{
    _leftOffSet = leftOffSet;
    self.rightRect = CGRectMake(leftOffSet, self.baseRect.origin.y, self.baseRect.size.width, self.baseRect.size.height);
}

-(void)setupViewController
{
    if(self.rightViewController) {
        [self addChildViewController:self.rightViewController];
        [self.view addSubview:self.rightViewController.view];
    }
    if(self.leftViewController) {
        [self addChildViewController:self.leftViewController];
        [self.view addSubview:self.leftViewController.view];
    }
    if(self.rootViewController)
    {
        [self addChildViewController:self.rootViewController];
        [self.view addSubview:self.rootViewController.view];
        [self addShadowToRootView];
        [self addGestureToRootView];
    }
    
    if(self.leftViewController && self.rightViewController)
        self.upperController = TPRevealSwipeDirectionLeft;
    
}
-(void)addGestureToRootView
{
    self.pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(gestureRecognizerDidPan:)];
    self.pan.cancelsTouchesInView = NO;
    [self.rootViewController.view addGestureRecognizer:self.pan];
    
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureRecognizerDidTap:)];
    self.tap.delegate = self;
    [self.rootViewController.view addGestureRecognizer:self.tap];
}
-(void)addShadowToRootView
{
    self.rootViewController.view.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.rootViewController.view.bounds].CGPath;
    self.rootViewController.view.layer.shadowOffset = CGSizeMake(0, 3);
    self.rootViewController.view.layer.shadowRadius = 7.0;
    self.rootViewController.view.layer.shadowColor = [UIColor blackColor].CGColor;
    self.rootViewController.view.layer.shadowOpacity = 0.8;
    self.rootViewController.view.layer.masksToBounds = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
