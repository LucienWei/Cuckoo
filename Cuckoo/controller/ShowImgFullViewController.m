//
//  ShowImgFullViewController.m
//  HomeBridge
//
//  Created by mac4st on 14-4-8.
//  Copyright (c) 2014年 keen. All rights reserved.
//
#import "ShowImgFullViewController.h"

@interface ShowImgFullViewController ()
{
    NSInteger whichIndex;
}
@end

@implementation ShowImgFullViewController
@synthesize myScrollView,imgList,delegate;
- (id)initWithImgArray:(NSArray*)imgArray
{
    self = [super init];
    if (self) {
        whichIndex=1;
        self.imgList=[NSMutableArray arrayWithArray:imgArray];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNav];
    [self initScrollView];
    [self initImgView];
}
-(void)initNav{
    self.title=[NSString stringWithFormat:@"1/%d",[self.imgList count]];
    if ([UIDevice currentDevice].systemVersion.floatValue < 7) {
        self.navigationController.navigationBar.tintColor = MY_COLOR_ORANGE;
    } else {
        self.navigationController.navigationBar.barTintColor = MY_COLOR_ORANGE;
        self.navigationController.navigationBar.tintColor = MY_COLOR_ORANGE;
        self.navigationController.navigationBar.translucent = NO;
        self.edgesForExtendedLayout=UIRectEdgeNone;
    }
    UIBarButtonItem*leftBtn=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop  target:self action:@selector(cancelIt)];
    leftBtn.tintColor = [UIColor grayColor];
    self.navigationItem.leftBarButtonItem=leftBtn;
    
    UIBarButtonItem*deleteBtn=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteOneImg)];
    deleteBtn.tintColor = [UIColor grayColor];
    self.navigationItem.rightBarButtonItem=deleteBtn;
}
-(void)initScrollView{
    CGFloat yPoint=0;
    CGFloat height=[[UIScreen mainScreen] bounds].size.height;
    if (systemVersionFloatValue<7) {
        yPoint=yPoint-self.navigationController.navigationBar.frame.size.height;
    }else{
        yPoint=yPoint-self.navigationController.navigationBar.frame.size.height-20;
    }
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkNavBar)];
    
    myScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, yPoint, self.view.frame.size.width, height)];
    myScrollView.backgroundColor = [UIColor whiteColor];;
    myScrollView.pagingEnabled=YES;
    CGFloat width=[self.imgList count]*self.view.frame.size.width;
    [myScrollView setContentSize:CGSizeMake(width, 0)];
    [myScrollView setShowsHorizontalScrollIndicator:NO];
    [myScrollView setBounces:NO];
    myScrollView.delegate=self;
    [self.view addSubview:myScrollView];
    [myScrollView addGestureRecognizer:tap];
}
-(void)initImgView{
    for (UIView*view in myScrollView.subviews) {
        [view removeFromSuperview];
    }
    CGFloat height=[[UIScreen mainScreen] bounds].size.height;
   
    for (int i=0; i<[imgList count]; i++) {
        UIImageView*imgView=[[UIImageView alloc] initWithFrame:CGRectMake(i*self.view.frame.size.width, 0, self.view.frame.size.width, height)];
        imgView.tag=i+1;
        UIImage*img=[self.imgList objectAtIndex:i];
        [imgView setImage:img];
        [myScrollView addSubview:imgView];
    }
}
-(void)cancelIt{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
-(void)checkNavBar{
    if (self.navigationController.navigationBar.hidden==YES) {
        self.navigationController.navigationBar.hidden=NO;
    }else{
        self.navigationController.navigationBar.hidden=YES;
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat width=scrollView.frame.size.width;
    CGFloat xpoint=scrollView.contentOffset.x;
    
    int a=(int)xpoint%(int)width;
    int b=(int)xpoint/(int)width;
    if (a==0) {
        whichIndex=b+1;
        self.title=[NSString stringWithFormat:@"%d/%d",whichIndex,[self.imgList count]];
    }
}
-(void)deleteOneImg{
    [delegate deleteOneImg:whichIndex];
    
    [self.imgList removeObjectAtIndex:whichIndex-1];
    self.title=[NSString stringWithFormat:@"%d/%d",whichIndex,[self.imgList count]];
    
    UIView*view1=[myScrollView viewWithTag:whichIndex];
    [UIView animateWithDuration:0.3 animations:^{
        view1.alpha=0;
    } completion:^(BOOL flag){
        [view1 removeFromSuperview];
        CGFloat width=[self.imgList count]*self.view.frame.size.width;
        [myScrollView setContentSize:CGSizeMake(width, 0)];
        [self initImgView];
    }];
    if([self.imgList count]==0){
        [self cancelIt];
    }
    
}
#pragma mark 内存管理
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
