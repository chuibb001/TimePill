//
//  TPTextView.m
//  TPSinaWeiboSDK
//
//  Created by simon on 13-9-14.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "TPTextView.h"

@implementation TPTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BeginEditingNotification:) name:UITextViewTextDidBeginEditingNotification object:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(EndEditingNotification:) name:UITextViewTextDidEndEditingNotification object:self];
        // 初始化Label
        const CGRect placeHolderLabelFrame = CGRectMake(10, 8, CGRectGetWidth(self.frame), 20);
        self.placeHolderLabel = [[UILabel alloc] initWithFrame:placeHolderLabelFrame];
        self.placeHolderLabel.backgroundColor = [UIColor clearColor];
        [self.placeHolderLabel setTextColor:[UIColor grayColor]];
        [self addSubview:self.placeHolderLabel];
        
        self.delegate = self;
    }
    return self;
}

-(void)setFont:(UIFont *)font
{
    super.font = font;
    self.placeHolderLabel.font = font;
}
-(void)setPlaceHolder:(NSString *)placeHolder
{
    _placeHolder = placeHolder;
    self.placeHolderLabel.text = placeHolder;
}

#pragma mark UITextViewDelegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
    {
        [self resignFirstResponder];
        return NO;
    }
    return YES;
}
-(void)textViewDidChange:(UITextView *)textView
{
    if(self.text.length == 0 || [self.text isEqualToString:@""] || self.text == nil)
    {
        self.placeHolderLabel.hidden = NO;
    }
    else
    {
        self.placeHolderLabel.hidden = YES;
    }
}
#pragma mark Notification
-(void)BeginEditingNotification:(NSNotification *)note
{
    if([self.text isEqualToString:self.placeHolder])
    {
        super.text = @"";
    }
}
-(void)EndEditingNotification:(NSNotification *)note
{
    
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
