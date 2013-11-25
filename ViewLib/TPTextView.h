//
//  TPTextView.h
//  TPSinaWeiboSDK

//  支持PlaceHolder

//  Created by simon on 13-9-14.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPTextView : UITextView<UITextViewDelegate>

@property (nonatomic,strong) NSString *placeHolder;
@property (nonatomic,strong) UILabel *placeHolderLabel;

@end
