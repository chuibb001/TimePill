//
//  TPPaintingViewController.m
//  TimePill
//
//  Created by yan simon on 13-9-18.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "TPPaintingViewController.h"

@interface TPPaintingViewController ()

@end

@implementation TPPaintingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
    /*----------------------------------------背景----------------------------------------*/
//    self.headerPic = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 88)];
//    self.headerPic.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"painting_bg.png"]];
//    [self.view addSubview:self.headerPic];
    
    if (iOS7) {
        PaintingBoard=[[TPPalette alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.bounds.size.height - 40 - 44 - 20)];
    } else {
        PaintingBoard=[[TPPalette alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.bounds.size.height - 40 - 44)];
    }
    
    PaintingBoard.tag = 1;
    PaintingBoard.backgroundColor=[UIColor whiteColor];
    //[self.view insertSubview:PaintingBoard belowSubview:self.headerPic];
    [self.view addSubview:PaintingBoard];
    
    /*----------------------------------------工具栏----------------------------------------*/
    self.toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - 40 - 44 - 30, 320, 40)];
    self.toolBar.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.toolBar];
    self.toolBar.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"rectangle1.png"]];
    
    self.btn_color = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn_color.frame = CGRectMake(0, 0, 64, 40);
    [self.btn_color setImage:[UIImage imageNamed:@"black.png"] forState:UIControlStateNormal];
    [self.btn_color addTarget:self action:@selector(SelectColor:) forControlEvents:UIControlEventTouchUpInside];
    [self.toolBar addSubview:self.btn_color];
    
    self.btn_pencil = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn_pencil.frame = CGRectMake(64, 0, 64, 40);
    [self.btn_pencil setImage:[UIImage imageNamed:@"pencilclick.png"] forState:UIControlStateNormal];
    [self.btn_pencil addTarget:self action:@selector(SelectPecil:) forControlEvents:UIControlEventTouchUpInside];
    [self.toolBar addSubview:self.btn_pencil];
    
    self.btn_eraser = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn_eraser.frame = CGRectMake(128, 0, 64, 40);
    [self.btn_eraser setImage:[UIImage imageNamed:@"eraser.png"] forState:UIControlStateNormal];
    [self.btn_eraser addTarget:self action:@selector(SelectEraser:) forControlEvents:UIControlEventTouchUpInside];
    [self.toolBar addSubview:self.btn_eraser];
    
    self.btn_undo = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn_undo.frame = CGRectMake(192, 0, 64, 40);
    [self.btn_undo setImage:[UIImage imageNamed:@"undo.png"] forState:UIControlStateNormal];
    [self.btn_undo addTarget:self action:@selector(SelectUndo:) forControlEvents:UIControlEventTouchUpInside];
    [self.toolBar addSubview:self.btn_undo];
    
    self.btn_trash = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn_trash.frame = CGRectMake(256, 0, 64, 40);
    [self.btn_trash setImage:[UIImage imageNamed:@"trash.png"] forState:UIControlStateNormal];
    [self.btn_trash addTarget:self action:@selector(SelectTrash:) forControlEvents:UIControlEventTouchUpInside];
    [self.toolBar addSubview:self.btn_trash];
    
    /*----------------------------------------导航栏----------------------------------------*/
    //返回按钮
    UIButton *returnBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    returnBtn.frame=CGRectMake(0, 0, 40, 40);
    [returnBtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [returnBtn setImage:[UIImage imageNamed:@"backclick.png"] forState:UIControlStateHighlighted];
    [returnBtn addTarget:self action:@selector(ReturnTo) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:returnBtn];
    self.navigationItem.leftBarButtonItem=leftBarButtonItem;
    //发送按钮
    UIButton *publishBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    publishBtn.frame=CGRectMake(0, 0, 40, 40);
    [publishBtn setImage:[UIImage imageNamed:@"done.png"] forState:UIControlStateNormal];
    [publishBtn setImage:[UIImage imageNamed:@"doneclick.png"] forState:UIControlStateHighlighted];
    [publishBtn addTarget:self action:@selector(PublishTo) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:publishBtn];
    self.navigationItem.rightBarButtonItem=rightBarButtonItem;
    self.navigationController.navigationBar.translucent = NO;
    NSLog(@"%f",self.view.frame.size.height);
    
    /*----------------------------------------颜色栏----------------------------------------*/
    colorImageArray=[[NSArray alloc] initWithObjects:@"red.png",@"yellow.png",@"pink.png",@"green.png",@"blue.png",@"brown.png",@"black.png", nil];
    isSelectingColor=NO;
    selectedColor=6;
    colorView=[[UIView alloc] initWithFrame:CGRectMake(320, self.view.bounds.size.height-80 - 44, 320, 40)];
    colorView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"colorbg.png"]];
    for(int i=0;i<7;i++)
    {
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(17+43*i, 7, 26, 26 );
        button.tag=i+2;
        [button setImage:[UIImage imageNamed:[colorImageArray objectAtIndex:i]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(ColorSelected:) forControlEvents:UIControlEventTouchUpInside];
        [colorView addSubview:button];
    }
    [self.view insertSubview:colorView aboveSubview:PaintingBoard];
    
    /*----------------------------------------铅笔栏----------------------------------------*/
    pencilImageArray=[[NSArray alloc] initWithObjects:@"10px.png",@"20px.png",@"30px.png",@"10pxclick.png",@"20pxclick.png",@"30pxclick.png", nil];
    //三个铅笔大小的按钮
    UIButton *button1=[UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *button2=[UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *button3=[UIButton buttonWithType:UIButtonTypeCustom];
    pencilButtonArray=[[NSArray alloc] initWithObjects:button1,button2,button3, nil];
    //flag
    isFirstSelectPencil=NO;
    isSelectingPencil=NO;
    selectedPencil=3;
    lastPencilcount=1;
    currentPencilcount=1;
    pencilEnable=YES;
    priousColor=6;
    pencilView=[[UIView alloc] initWithFrame:CGRectMake(73, self.view.bounds.size.height-40, 40, 110)];
    for(int i=0;i<3;i++)
    {
        UIButton *button=[pencilButtonArray objectAtIndex:i];
        button.frame=CGRectMake(5, 5+35*i, 30 , 30 );
        button.tag=i+2+7;
        [button setImage:[UIImage imageNamed:[pencilImageArray objectAtIndex:i]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:[pencilImageArray objectAtIndex:i+3]] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(PencilSelected:) forControlEvents:UIControlEventTouchUpInside];
        [pencilView addSubview:button];
    }
    [self.view insertSubview:pencilView aboveSubview:PaintingBoard];
    //修改toolBar的frame，不要挡住铅笔条
    if (iOS7) {
        self.toolBar.frame=CGRectMake(0, self.view.bounds.size.height - 40 - 44 - 20, 320, 40);
    } else {
        self.toolBar.frame=CGRectMake(0, self.view.bounds.size.height - 40 - 44, 320, 40);
    }
    [self.view insertSubview:self.toolBar aboveSubview:pencilView];
    
    /*----------------------------------------橡皮栏----------------------------------------*/
    UIButton *button4=[UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *button5=[UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *button6=[UIButton buttonWithType:UIButtonTypeCustom];
    eraserButtonArray=[[NSArray alloc] initWithObjects:button4,button5,button6, nil];
    eraserEnable=NO;
    isSelectingEraser=NO;  //表示橡皮选项未弹出
    lastErasercount=1;
    currentErasercount=1;
    isFirstSelectEraser=YES;  //界面初始化是铅笔被选中，所以对于橡皮，它即将是第一次被选中
    eraserView=[[UIView alloc] initWithFrame:CGRectMake(135, self.view.bounds.size.height-40, 40, 110)];
    for(int i=0;i<3;i++)
    {
        UIButton *button=[eraserButtonArray objectAtIndex:i];
        button.frame=CGRectMake(5, 5+35*i, 30 , 30 );
        button.tag=i+2+7+3;
        [button setImage:[UIImage imageNamed:[pencilImageArray objectAtIndex:i]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:[pencilImageArray objectAtIndex:i+3]] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(EraserSelected:) forControlEvents:UIControlEventTouchUpInside];
        [eraserView addSubview:button];
    }
    [self.view insertSubview:eraserView aboveSubview:PaintingBoard];
    //    //修改toolBar的frame，不要挡住铅笔条
    //    toolBar.frame=CGRectMake(0, 420, 320, 40);
    //    [self.view insertSubview:toolBar aboveSubview:eraserView];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.title = @"绘图" ;
}

#pragma mark 颜色栏
-(void)ColorSelected:(id)sender
{
    UIButton *button=sender;
    int tag=button.tag;
    selectedColor=tag-2; //选择的颜色号码
    priousColor=selectedColor;

    //退出颜色栏
    isSelectingColor=NO;
    [UIView animateWithDuration:0.1618f animations:^(void){
        colorView.frame=CGRectMake(320, self.view.bounds.size.height-80, 320, 40);
    }];
    [self.btn_color setImage:[UIImage imageNamed:[colorImageArray objectAtIndex:tag-2]] forState:UIControlStateNormal];
}

#pragma mark 铅笔栏
-(void)PencilSelected:(id)sender
{
    UIButton *button=sender;
    int tag=button.tag;
    lastPencilcount=currentPencilcount;
    currentPencilcount=tag-2-7; //选择的铅笔号码
    if(currentPencilcount==0)
        selectedPencil=1;
    else if(currentPencilcount==1)
        selectedPencil=3;
    else if(currentPencilcount==2)
        selectedPencil=6;

    //退出铅笔栏
    isSelectingPencil=NO;
    [UIView animateWithDuration:0.1618f animations:^(void){
        pencilView.frame=CGRectMake(73, self.view.bounds.size.height-40, 40, 110);
    }];
}

#pragma mark 橡皮栏
-(void)EraserSelected:(id)sender
{
    UIButton *button=sender;
    int tag=button.tag;
    lastErasercount=currentErasercount;
    currentErasercount=tag-2-7-3; //选择的橡皮号码
    if(currentErasercount==0)
        selectedPencil=1;
    else if(currentErasercount==1)
        selectedPencil=3;
    else if(currentErasercount==2)
        selectedPencil=6;
    
    //退出橡皮栏
    isSelectingEraser=NO;
    [UIView animateWithDuration:0.1618f animations:^(void){
        eraserView.frame=CGRectMake(135, self.view.bounds.size.height-40, 40, 110);
    }];
}

#pragma mark 导航栏
-(void)ReturnTo
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)PublishTo
{
    // 截屏
    UIGraphicsBeginImageContext(PaintingBoard.bounds.size);
    [PaintingBoard.layer renderInContext:UIGraphicsGetCurrentContext()];
    //[self.headerPic.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);
    // 回调
    self.handler(viewImage);
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 覆写Controller的触摸函数
//手指开始触屏开始
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //先收起铅笔栏
    isSelectingPencil=NO;
    [UIView animateWithDuration:0.1618f animations:^(void){
        pencilView.frame=CGRectMake(70, self.view.bounds.size.height-40, 40, 110);
    }];
    
    //收起橡皮栏
    isSelectingEraser=NO;
    [UIView animateWithDuration:0.1618f animations:^(void){
        eraserView.frame=CGRectMake(135, self.view.bounds.size.height-40, 40, 110);
    }];
    
    //预处理画板
	UITouch* touch=[touches anyObject];
	MyBeganpoint=[touch locationInView:[self.view viewWithTag:1]];
	
    if(pencilEnable==YES)
        [(TPPalette*)[self.view viewWithTag:1] addColors:selectedColor];
    else
        [(TPPalette*)[self.view viewWithTag:1] addColors:7];
	[(TPPalette*)[self.view viewWithTag:1] addWidths:selectedPencil];
	[(TPPalette*)[self.view viewWithTag:1] initAllPoints];
	[(TPPalette*)[self.view viewWithTag:1] addPoints:MyBeganpoint];
	
}
//手指移动时候发出
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	NSArray* MovePointArray=[touches allObjects];
	MyMovepoint=[[MovePointArray objectAtIndex:0] locationInView:[self.view viewWithTag:1]];
	[(TPPalette*)[self.view viewWithTag:1] addPoints:MyMovepoint];
	[[self.view viewWithTag:1] setNeedsDisplay];
}
//当手指离开屏幕时候
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[(TPPalette*)[self.view viewWithTag:1] addLines];
	[[self.view viewWithTag:1] setNeedsDisplay];
}
- (void)viewDidUnload
{
    [self setHeaderPic:nil];
    [self setToolBar:nil];
    [self setBtn_color:nil];
    [self setBtn_pencil:nil];
    [self setBtn_eraser:nil];
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark 工具栏按钮函数
- (void)SelectColor:(id)sender {
    if(isSelectingColor==NO)
    {
        isSelectingColor=YES;
        [UIView animateWithDuration:0.1618f animations:^(void){
            colorView.frame=CGRectMake(0, self.view.bounds.size.height-80, 320, 40);
        }];
    }
    else {
        isSelectingColor=NO;
        [UIView animateWithDuration:0.1618f animations:^(void){
            colorView.frame=CGRectMake(320, self.view.bounds.size.height-80, 320, 40);
        }];
    }
}

- (void)SelectPecil:(id)sender {
    //铅笔和铅笔擦的图片修改
    [self.btn_pencil setImage:[UIImage imageNamed:@"pencilclick.png"] forState:UIControlStateNormal];
    [self.btn_eraser setImage:[UIImage imageNamed:@"eraser.png"] forState:UIControlStateNormal];
    pencilEnable=YES;
    eraserEnable=NO;
    selectedColor=priousColor;
    isFirstSelectEraser=YES;  //下一次点击橡皮，就不会弹出铅笔选项了
    
    //恢复铅笔大小
    if(currentPencilcount==0)
        selectedPencil=1;
    else if(currentPencilcount==1)
        selectedPencil=3;
    else if(currentPencilcount==2)
        selectedPencil=6;
    
    //设置当前选中铅笔的图片
    [[pencilButtonArray objectAtIndex:currentPencilcount] setImage:[UIImage imageNamed:[pencilImageArray objectAtIndex:currentPencilcount+3]] forState:UIControlStateNormal];
    if(currentPencilcount!=lastPencilcount)
        [[pencilButtonArray objectAtIndex:lastPencilcount] setImage:[UIImage imageNamed:[pencilImageArray objectAtIndex:lastPencilcount]] forState:UIControlStateNormal];
    
    //控制铅笔选项的弹出和收起
    if(isFirstSelectPencil==NO)
    {
        if(isSelectingPencil==NO)
        {
            isSelectingPencil=YES;
            [UIView animateWithDuration:0.1618f animations:^(void){
                pencilView.frame=CGRectMake(73, self.view.bounds.size.height-150, 40, 110);
            }];
        }
        else {
            isSelectingPencil=NO;
            [UIView animateWithDuration:0.1618f animations:^(void){
                pencilView.frame=CGRectMake(73, self.view.bounds.size.height-40, 40, 110);
            }];
        }
    }
    isFirstSelectPencil=NO;
    
    if(isSelectingEraser)  //如果这时，橡皮选项是弹出的，把他收起
    {
        isSelectingEraser=NO;
        [UIView animateWithDuration:0.1618f animations:^(void){
            eraserView.frame=CGRectMake(135, self.view.bounds.size.height-40, 40, 110);
        }];
    }
}

- (void)SelectEraser:(id)sender {
    //铅笔和铅笔擦的图片修改
    [self.btn_pencil setImage:[UIImage imageNamed:@"pencil.png"] forState:UIControlStateNormal];
    [self.btn_eraser setImage:[UIImage imageNamed:@"eraserclick.png"] forState:UIControlStateNormal];
    pencilEnable=NO;
    eraserEnable=YES;
    selectedColor=7;
    isFirstSelectPencil=YES;  //下一次点击铅笔，就不会弹出铅笔选项了
    
    //恢复橡皮大小
    if(currentErasercount==0)
        selectedPencil=1;
    else if(currentErasercount==1)
        selectedPencil=3;
    else if(currentErasercount==2)
        selectedPencil=6;
    
    //设置当前选中橡皮的图片
    [[eraserButtonArray objectAtIndex:currentErasercount] setImage:[UIImage imageNamed:[pencilImageArray objectAtIndex:currentErasercount+3]] forState:UIControlStateNormal];
    if(currentErasercount!=lastErasercount)
        [[eraserButtonArray objectAtIndex:lastErasercount] setImage:[UIImage imageNamed:[pencilImageArray objectAtIndex:lastErasercount]] forState:UIControlStateNormal];
    
    //控制橡皮选项的弹出和收起
    if(isFirstSelectEraser==NO)
    {
        if(isSelectingEraser==NO)
        {
            isSelectingEraser=YES;
            [UIView animateWithDuration:0.1618f animations:^(void){
                eraserView.frame=CGRectMake(135, self.view.bounds.size.height-150, 40, 110);
            }];
        }
        else {
            isSelectingEraser=NO;
            [UIView animateWithDuration:0.1618f animations:^(void){
                eraserView.frame=CGRectMake(135, self.view.bounds.size.height-40, 40, 110);
            }];
        }
    }
    isFirstSelectEraser=NO;
    
    if(isSelectingPencil)  //如果这时，铅笔选项是弹出的，把他收起
    {
        isSelectingPencil=NO;
        [UIView animateWithDuration:0.1618f animations:^(void){
            pencilView.frame=CGRectMake(73, self.view.bounds.size.height-40, 40, 110);
        }];
    }
}

- (void)SelectUndo:(id)sender {
    [(TPPalette*)[self.view viewWithTag:1] RemoveLine];
}

- (void)SelectTrash:(id)sender {
    [(TPPalette*)[self.view viewWithTag:1] clearAllLines];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
