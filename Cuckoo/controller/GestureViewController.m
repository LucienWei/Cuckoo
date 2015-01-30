//
//  GestureViewController.m
//  Cuckoo
//
//  Created by Lucien Wei on 1/22/15.
//  Copyright (c) 2015 CuckooNest. All rights reserved.
//

#import "GestureViewController.h"
#import "UtilDefine.h"
#import "AFNetworking.h"

@interface GestureViewController ()

@end

@implementation GestureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNav];
}

-(void)initNav{
    self.title=@"翻页测试";
    if ([UIDevice currentDevice].systemVersion.floatValue < 7) {
        self.navigationController.navigationBar.tintColor = MY_COLOR_ORANGE;
    } else {
        self.navigationController.navigationBar.barTintColor = MY_COLOR_ORANGE;
        self.navigationController.navigationBar.tintColor = MY_COLOR_ORANGE;
        self.navigationController.navigationBar.translucent = NO;
        self.edgesForExtendedLayout=UIRectEdgeNone;
    }
//    UIBarButtonItem*leftBtn=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(dismissAddView)];
//    leftBtn.tintColor = [UIColor grayColor];
//    self.navigationItem.leftBarButtonItem=leftBtn;
//    
//    UIBarButtonItem*rightBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneBtnPress:)];
//    rightBtn.tintColor = [UIColor grayColor];
//    self.navigationItem.rightBarButtonItem=rightBtn;
    UIImageView*imageView = [[UIImageView alloc] initWithFrame:CGRectMake(40, 40, 240, 240)];
    imageView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:imageView];
    
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageViews:)];
    imageView.userInteractionEnabled=YES;
    [imageView addGestureRecognizer:tap];
    
    UISwipeGestureRecognizer *swipeGesture;
    swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [swipeGesture setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [imageView addGestureRecognizer:swipeGesture];
    
    swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [swipeGesture setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [imageView addGestureRecognizer:swipeGesture];
}
-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    UIImageView*imageView=(UIImageView*)recognizer.view;
    UISwipeGestureRecognizerDirection direction = recognizer.direction;
    
    if (direction == UISwipeGestureRecognizerDirectionRight) {
        CATransition *animation = [CATransition animation];
        animation.duration = 0.5f;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.type = kCATransitionPush;
        animation.type = @"pageCurl";
        animation.subtype = kCATransitionFromTop;
        [imageView.layer addAnimation:animation forKey:@"animationID"];
    } else if (direction == UISwipeGestureRecognizerDirectionLeft) {
        CATransition *animation = [CATransition animation];
        animation.duration = 0.5f;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.type = kCATransitionPush;
        animation.type = @"pageUnCurl";
        animation.subtype = kCATransitionFromTop;
        [imageView.layer addAnimation:animation forKey:@"animationID"];
    } else if (direction == UISwipeGestureRecognizerDirectionUp) {
        
    } else if (direction == UISwipeGestureRecognizerDirectionDown) {
        
    }
}
-(void)tapImageViews:(UITapGestureRecognizer*)tap{
    UIImageView*imageView=(UIImageView*)tap.view;
    BOOL isShow = imageView.frame.origin.x==5;
    if (isShow) {
        imageView.frame = CGRectMake(5, 5, 10, 10);
    } else {
        imageView.frame = CGRectMake(20, 20, 200, 200);
    }
    [UIView beginAnimations:@"animationID" context:nil];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationRepeatAutoreverses:NO];
    if (isShow) {
        imageView.frame = CGRectMake(20, 20, 200, 200);
    } else {
        imageView.frame = CGRectMake(5, 5, 10, 10);
    }
    [UIView commitAnimations];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
