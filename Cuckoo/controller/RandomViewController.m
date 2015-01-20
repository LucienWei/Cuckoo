//
//  RandomViewController.m
//  Cuckoo
//
//  Created by Lucien Wei on 1/19/15.
//  Copyright (c) 2015 CuckooNest. All rights reserved.
//

#import "RandomViewController.h"
#import "UtilDefine.h"
#import <AudioToolbox/AudioToolbox.h>

static SystemSoundID shake_sound_male_id = 0;

@interface RandomViewController ()
{
    UIImageView * mRandomImage;
    NSMutableArray * mMemberArray;
    NSMutableArray * mResultArray;
    UIScrollView * mScrollView;
}
@end

@implementation RandomViewController
- (id)init
{
    self = [super init];
    if (self) {
        mMemberArray = [[NSMutableArray alloc] init];
        mResultArray = [[NSMutableArray alloc] init];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"开奖";
    if ([UIDevice currentDevice].systemVersion.floatValue < 7) {
        self.navigationController.navigationBar.tintColor = MY_COLOR_ORANGE;
    } else {
        self.navigationController.navigationBar.barTintColor = MY_COLOR_ORANGE;
        self.navigationController.navigationBar.tintColor = MY_COLOR_ORANGE;
        self.navigationController.navigationBar.translucent = NO;
        self.edgesForExtendedLayout=UIRectEdgeNone;
    }
    self.view.backgroundColor = [UIColor blackColor];
    
    UIBarButtonItem*leftBtn=[[UIBarButtonItem alloc] initWithTitle:@"Reset" style:UIBarButtonItemStylePlain target:self action:@selector(resetBtnPress:)];
    leftBtn.tintColor = [UIColor grayColor];
    self.navigationItem.leftBarButtonItem=leftBtn;
    
    UIBarButtonItem*rightBtn=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addMemberBtnPress:)];
    rightBtn.tintColor = [UIColor grayColor];
    self.navigationItem.rightBarButtonItem=rightBtn;
    
    UIImageView *bgImageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_back.png"]];
    [self.view addSubview:bgImageview];

    UIButton*resultBtn=[[UIButton alloc] init];
    [resultBtn setFrame:CGRectMake(260, 0, 57, 62)];
    [resultBtn setImage:[UIImage imageNamed:@"result.png"] forState:UIControlStateNormal];
    [resultBtn addTarget:self action:@selector(showResult:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:resultBtn];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, self.view.bounds.size.width, 40)];
    label.textColor = [UIColor colorWithRed:206/255.0 green:176/255.0 blue:111/255.0 alpha:1.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"摇一摇开奖";
    label.font = [UIFont fontWithName:@"HelveticaNeue" size:20];
    [self.view addSubview:label];
    
    mRandomImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shake_image.png"]];
    mRandomImage.frame = CGRectMake(58, 60, 204, 204);
    [self.view addSubview:mRandomImage];
    
    UIView*view = [[UIView alloc] initWithFrame:CGRectMake(0, 270, self.view.bounds.size.width, 100)];
    view.backgroundColor=[UIColor grayColor];
    view.alpha = 0.19;
    [self.view addSubview:view];
    
    mScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 270, self.view.bounds.size.width, 100)];
    [mScrollView setScrollEnabled:YES];
    mScrollView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:mScrollView];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:YES];
    [self becomeFirstResponder];
    [self createSystemSound];
}
- (void)viewDidDisappear:(BOOL)animated{
    [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:NO];
    [self resignFirstResponder];
    [super viewDidDisappear:animated];
}
-(void)resetBtnPress:(UIButton*)button{
    [mMemberArray removeAllObjects];
    [self refreshMemberList];
}
-(void)showResult:(UIButton*)button{
    NSMutableString * message = [[NSMutableString alloc] init];
    if (mResultArray.count<=0) {
        message = [[NSMutableString alloc] initWithString:@"暂未有开奖结果, 请开奖后再查看!"];
    } else {
        message = [[NSMutableString alloc] initWithString:@"本次中奖的疯子是:\n"];
        for (NSDictionary*dict in mResultArray) {
            [message appendFormat:@"%@\n", [dict valueForKey:@"name"]];
        }
    }
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alertView show];
}
-(void)addMemberBtnPress:(UIButton*)button{
    AddMemberViewController*addView=[[AddMemberViewController alloc] init];
    addView.delegate = self;
    UINavigationController*nav=[[UINavigationController alloc] initWithRootViewController:addView];
    [self presentViewController:nav animated:YES completion:nil];
}
-(void)refreshMemberList{
    NSInteger memberCount = mMemberArray.count;
    float imageViewsWidth = memberCount*80;
    [mScrollView setContentSize:CGSizeMake(imageViewsWidth, 70)];
    for (UIView*view in [mScrollView subviews]) {
        [view removeFromSuperview];
    }
    for (int i=0; i<mMemberArray.count; i++) {
        NSDictionary* item = [mMemberArray objectAtIndex:i];
        UIImageView*imgView=[[UIImageView alloc] initWithFrame:CGRectMake(10 + i*80, 10, 60, 60)];
        imgView.image = [item valueForKey:@"image"];
        [mScrollView addSubview:imgView];
        
        UILabel*label=[[UILabel alloc] initWithFrame:CGRectMake(10 + i*80, 65, 60, 30)];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextColor:[UIColor colorWithRed:206/255.0 green:176/255.0 blue:111/255.0 alpha:1.0]];
        [label setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
        label.text = [item valueForKey:@"name"];
        [mScrollView addSubview:label];
    }
}
#pragma mark -
#pragma mark AddMemberDelegate
-(void)addMemberName:(NSString *)name image:(UIImage *)image {
    NSLog(@"%@", name);
    NSDictionary*dict = [NSDictionary dictionaryWithObjectsAndKeys:name, @"name", image, @"image", nil];
    
    [mMemberArray addObject:dict];
    [self refreshMemberList];
}
#pragma mark -
#pragma mark UIEventTypeMotion
- (BOOL)canBecomeFirstResponder{
    return YES;
}
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    if (motion == UIEventSubtypeMotionShake && event.type == UIEventTypeMotion) {
        NSLog(@"开始摇动");
    }
}
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    if (motion == UIEventSubtypeMotionShake && event.type == UIEventTypeMotion) {
        NSLog(@"摇动结束");
        AudioServicesPlaySystemSound(shake_sound_male_id);
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        [self shakeImageView];
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(showShakeResult) userInfo:nil repeats:NO];
    }
}
- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event{
}
-(void)createSystemSound{
    //注册声音到系统
    NSString *path = [[NSBundle mainBundle] pathForResource:@"glass" ofType:@"wav"];
    if (path) {
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&shake_sound_male_id);
    }
}
-(void)showShakeResult{
    NSString * message;
    NSInteger maxNum = mMemberArray.count;
    NSInteger index = (arc4random() % maxNum);
    if (mMemberArray.count<2) {
        message = @"人数过少, 不便开奖!";
        
    } else {
        NSDictionary*dict = [mMemberArray objectAtIndex:index];
        message = [NSString stringWithFormat:@"本次中奖的疯子是:%@", [dict valueForKey:@"name"]];
        [mResultArray addObject:dict];
        [mMemberArray removeObject:dict];
        [self refreshMemberList];
    }
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alertView show];
}
- (void)shakeImageView{
    CABasicAnimation* shake = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    shake.fromValue = [NSNumber numberWithFloat:-M_PI/10];
    shake.toValue   = [NSNumber numberWithFloat:+M_PI/10];
    shake.duration = 0.1;
    shake.autoreverses = YES;
    shake.repeatCount = 6;
    [mRandomImage.layer addAnimation:shake forKey:@"shakeAnimation"];
    
    // 渐变消失
    /*
     mRandomImage.alpha = 1.0;
     [UIView animateWithDuration:2.0 delay:0.0 options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionAllowUserInteraction
     animations:^{
     mRandomImage.alpha = 0.0;
     } completion:nil];
     */
}
#pragma mark -
#pragma mark Other methods
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
