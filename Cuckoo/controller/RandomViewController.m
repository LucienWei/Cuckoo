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
}
@end

@implementation RandomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"抽奖";
    if ([UIDevice currentDevice].systemVersion.floatValue < 7) {
        self.navigationController.navigationBar.tintColor = MY_COLOR_ORANGE;
    } else {
        self.navigationController.navigationBar.barTintColor = MY_COLOR_ORANGE;
        self.navigationController.navigationBar.tintColor = MY_COLOR_ORANGE;
        self.navigationController.navigationBar.translucent = NO;
        self.edgesForExtendedLayout=UIRectEdgeNone;
    }
    self.view.backgroundColor = [UIColor blackColor];
    
    UIImageView *bgImageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_back.png"]];
    [self.view addSubview:bgImageview];

    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, self.view.bounds.size.width, 40)];
    label.textColor = [UIColor colorWithRed:206/255.0 green:176/255.0 blue:111/255.0 alpha:1.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"摇一摇开奖";
    label.font = [UIFont fontWithName:@"HelveticaNeue" size:20];
    [self.view addSubview:label];
    
    mRandomImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shake_image.png"]];
    mRandomImage.frame = CGRectMake(58, 60, 204, 204);
    [self.view addSubview:mRandomImage];
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
    NSInteger maxNum = 10;
    NSInteger num = (arc4random() % maxNum ) + 1;
    NSString * message = [NSString stringWithFormat:@"本次中奖的是:　第%d号 ", num];
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
