//
//  RandomViewController.m
//  Cuckoo
//
//  Created by Lucien Wei on 1/19/15.
//  Copyright (c) 2015 CuckooNest. All rights reserved.
//

#import "RandomViewController.h"
#import <AudioToolbox/AudioToolbox.h>
static SystemSoundID shake_sound_male_id = 0;

@interface RandomViewController ()

@end

@implementation RandomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"抽奖";
    if ([UIDevice currentDevice].systemVersion.floatValue < 7) {
        self.navigationController.navigationBar.tintColor = [UIColor lightGrayColor];
    } else {
        self.navigationController.navigationBar.barTintColor = [UIColor lightGrayColor];
        self.navigationController.navigationBar.tintColor = [UIColor lightGrayColor];
        self.navigationController.navigationBar.translucent = NO;
        self.edgesForExtendedLayout=UIRectEdgeNone;
    }
    self.view.backgroundColor = [UIColor blackColor];
    
    NSMutableDictionary*dict=[NSMutableDictionary dictionary];
    [dict setObject:[UIFont fontWithName:@"HelveticaNeue" size:17] forKey:NSFontAttributeName];
    [dict setObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [[UINavigationBar appearance] setTitleTextAttributes:dict];
    
    UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_back.png"]];
    [self.view addSubview:imageview];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, self.view.bounds.size.width, 80)];
    label.textColor = [UIColor redColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"Coming soon...";
    label.font = [UIFont fontWithName:@"HelveticaNeue" size:26];
    [self.view addSubview:label];
    

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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UIEventSubtypeMotionShake
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
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"本次中奖的是:　@_@ " delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alertView show];
}
@end
