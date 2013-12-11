//
//  TPKeyboardHeaderView.m
//  TPSinaWeiboSDK
//
//  Created by simon on 13-9-14.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "TPKeyboardHeaderView.h"

@implementation TPKeyboardHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
        
        [self setupButtons];
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"rectangle.png"]];
    }
    return self;
}

#pragma mark Init
-(void)setupButtons
{
    CGFloat buttonWidth = CGRectGetWidth(self.frame) / 5;
    CGFloat buttonHeight = CGRectGetHeight(self.frame);
    
    // 定位按钮
    self.locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.locationButton.frame = CGRectMake(0, 0, buttonWidth, buttonHeight);
    [self.locationButton setImage:[UIImage imageNamed:@"position.png"] forState:UIControlStateNormal];
    [self addSubview:self.locationButton];
    
    // 表情按钮
    self.emotionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.emotionButton.frame = CGRectMake(buttonWidth, 0, buttonWidth, buttonHeight);
    [self.emotionButton setImage:[UIImage imageNamed:@"motion.png"] forState:UIControlStateNormal];
    [self addSubview:self.emotionButton];
    
    // 照片按钮
    self.photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.photoButton.frame = CGRectMake(buttonWidth * 2, 0, buttonWidth, buttonHeight);
    [self.photoButton setImage:[UIImage imageNamed:@"photo.png"] forState:UIControlStateNormal];
    [self addSubview:self.photoButton];
    
    // 画板按钮
    self.paintingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.paintingButton.frame = CGRectMake(buttonWidth * 3, 0, buttonWidth, buttonHeight);
    [self.paintingButton setImage:[UIImage imageNamed:@"paint.png"] forState:UIControlStateNormal];
    [self addSubview:self.paintingButton];
    
    // 分享按钮
    self.shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.shareButton.frame = CGRectMake(buttonWidth * 4, 0, buttonWidth, buttonHeight);
    [self.shareButton setImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
    [self addSubview:self.shareButton];
}

#pragma mark Notification
-(void)KeyboardWillShowNotification:(NSNotification *)note
{
    CGRect  beginRect = [[note.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect  endRect = [[note.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat animDuration = [[note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    // 转换Rect相对于superView
    beginRect = [self fixKeyboardRect:beginRect];
    endRect = [self fixKeyboardRect:endRect];
        
//    CGRect selfBeginRect = CGRectMake(beginRect.origin.x,
//                                       beginRect.origin.y - self.frame.size.height,
//                                       beginRect.size.width,
//                                       self.frame.size.height);
    
    CGRect selfEndingRect = CGRectMake(endRect.origin.x,
                                       endRect.origin.y - self.frame.size.height,
                                       endRect.size.width,
                                       self.frame.size.height);
    
    // 开启上升动画
    //self.frame = selfBeginRect;
    [UIView beginAnimations:@"headerViewFlip" context:NULL];
    [UIView setAnimationDuration:animDuration];
    self.frame = selfEndingRect;
    [UIView commitAnimations];
}

-(void)KeyboardWillHideNotification:(NSNotification *)note
{
    CGRect  beginRect = [[note.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect  endRect = [[note.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat animDuration = [[note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    beginRect = [self fixKeyboardRect:beginRect];
    endRect = [self fixKeyboardRect:endRect];
    
//    CGRect selfBeginRect = CGRectMake(beginRect.origin.x,
//                                      beginRect.origin.y - self.frame.size.height,
//                                      beginRect.size.width,
//                                      self.frame.size.height);
    
    CGRect selfEndingRect = CGRectMake(endRect.origin.x,
                                       endRect.origin.y - self.frame.size.height,
                                       endRect.size.width,
                                       self.frame.size.height);
    // 开启下降动画
    //self.frame = selfBeginRect;
    [UIView beginAnimations:@"headerViewFlip" context:NULL];
    [UIView setAnimationDuration:animDuration];
    self.frame = selfEndingRect;
    [UIView commitAnimations];
}
#pragma mark - Private methods
- (CGRect) fixKeyboardRect:(CGRect)originalRect{
    
    // Get the UIWindow by going through the superviews
    UIView * referenceView = self.superview;
    while ((referenceView != nil) && ![referenceView isKindOfClass:[UIWindow class]]){
        referenceView = referenceView.superview;
    }
    
    // If we finally got a UIWindow
    CGRect newRect = originalRect;
    if ([referenceView isKindOfClass:[UIWindow class]]){
        //Convert the received rect using the window
        UIWindow * myWindow = (UIWindow*)referenceView;
        
        newRect = [myWindow convertRect:originalRect toView:self.superview];
    }
    
    // Return the new rect (or the original if we couldn't find the Window -> this should never happen if the view is present)
    // 新的矩形是相对于superview的
    return newRect;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
