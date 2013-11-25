//
//  TPPaintingViewController.h
//  TimePill
//
//  Created by yan simon on 13-9-18.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPPalette.h"
#import <QuartzCore/QuartzCore.h>

typedef void(^TPPaintingHandler)(UIImage *image);

@interface TPPaintingViewController : UIViewController
{
    // 绘图
    TPPalette *PaintingBoard;
    CGPoint MyBeganpoint;
	CGPoint MyMovepoint;
    
    // 颜色栏
    UIView *colorView;
    Boolean isSelectingColor;
    int selectedColor;
    NSArray *colorImageArray;
    
    // 铅笔栏
    UIView *pencilView;
    NSArray *pencilImageArray;
    NSArray *pencilButtonArray;
    
    // flag
    Boolean isSelectingPencil;  //点击铅笔按钮铅笔选项的弹出与收起
    int lastPencilcount;  //上次选择的是几号铅笔
    int currentPencilcount;  //当前选择的铅笔
    Boolean pencilEnable;
    int priousColor;
    Boolean isFirstSelectPencil;  //第一次点击铅笔按钮不弹出铅笔选项
    
    // share
    int selectedPencil;   //铅笔和橡皮的公用变量，传到画板决定画笔大小
    
    // 橡皮栏
    UIView *eraserView;
    Boolean eraserEnable;
    NSArray *eraserButtonArray;
    Boolean isSelectingEraser;  //点击铅笔按钮铅笔选项的弹出与收起
    int lastErasercount;  //上次选择的是几号铅笔
    int currentErasercount;  //当前选择的铅笔
    Boolean isFirstSelectEraser;  //第一次点击铅笔按钮不弹出铅笔选项
}


@property (retain, nonatomic) UIView *headerPic;
@property (retain, nonatomic) UIView *toolBar;
@property (retain, nonatomic) UIButton *btn_color;
@property (retain, nonatomic) UIButton *btn_pencil;
@property (retain, nonatomic) UIButton *btn_eraser;
@property (retain, nonatomic) UIButton *btn_undo;
@property (retain, nonatomic) UIButton *btn_trash;
@property (strong, nonatomic) TPPaintingHandler handler;

- (void)SelectColor:(id)sender;
- (void)SelectPecil:(id)sender;
- (void)SelectEraser:(id)sender;
- (void)SelectUndo:(id)sender;
- (void)SelectTrash:(id)sender;

@end
