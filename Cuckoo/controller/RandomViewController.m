//
//  RandomViewController.m
//  Cuckoo
//
//  Created by Lucien Wei on 1/19/15.
//  Copyright (c) 2015 CuckooNest. All rights reserved.
//

#import "RandomViewController.h"

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
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_back.png"]];
    [self.view addSubview:imageview];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, self.view.bounds.size.width, 80)];
    label.textColor = [UIColor redColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"Coming soon...";
    label.font = [UIFont fontWithName:@"HelveticaNeue" size:26];
    [self.view addSubview:label];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
