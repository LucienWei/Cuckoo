//
//  MainViewController.m
//  MapDemo
//
//  Created by Lucien Wei on 1/9/15.
//  Copyright (c) 2015 TestDemo. All rights reserved.
//

#import "MainViewController.h"
#import "UtilDefine.h"
#import "MapViewBaseViewController.h"
#import "MapRouteViewController.h"
#import "RandomViewController.h"
#import "GestureViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    MapViewBaseViewController*baseView = [[MapViewBaseViewController alloc] init];
    UINavigationController*nav1 = [[UINavigationController alloc] initWithRootViewController:baseView];
    
    MapRouteViewController*routeView = [[MapRouteViewController alloc] init];
    UINavigationController*nav2 = [[UINavigationController alloc] initWithRootViewController:routeView];

    RandomViewController*randomView = [[RandomViewController alloc] init];
    UINavigationController*nav3 = [[UINavigationController alloc] initWithRootViewController:randomView];
    
    GestureViewController*gestureView = [[GestureViewController alloc] init];
    UINavigationController*nav4 = [[UINavigationController alloc] initWithRootViewController:gestureView];
    
    if ([UIDevice currentDevice].systemVersion.floatValue<7) {
        baseView.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"位置" image:nil tag:1];
        [baseView.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tb_map.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"tb_map.png"]];
        
        routeView.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"路线" image:nil tag:2];
        [routeView.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tb_route.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"tb_route.png"]];
        
        randomView.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"开奖" image:nil tag:3];
        [randomView.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"shaizi.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"shaizi.png"]];
        
        gestureView.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"翻页" image:nil tag:4];
        [gestureView.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tb_end.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"tb_end.png"]];
    } else {
        baseView.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"位置" image:[UIImage imageNamed:@"tb_map.png"] selectedImage:[[UIImage imageNamed:@"tb_map.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

        routeView.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"路线" image:[UIImage imageNamed:@"tb_route.png"] selectedImage:[[UIImage imageNamed:@"tb_route.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
        randomView.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"开奖" image:[UIImage imageNamed:@"shaizi.png"] selectedImage:[[UIImage imageNamed:@"shaizi.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
        gestureView.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"翻页" image:[UIImage imageNamed:@"tb_end.png"] selectedImage:[[UIImage imageNamed:@"tb_end.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

    }
    [[UITabBarItem appearance] setTitleTextAttributes:@{UITextAttributeTextColor:[UIColor blackColor]} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{UITextAttributeTextColor:[UIColor whiteColor]} forState:UIControlStateSelected];
    [self.tabBar setBarTintColor:MY_COLOR_ORANGE];
    [self.tabBar setBackgroundColor:MY_COLOR_ORANGE];
    NSArray*views = @[nav1, nav2, nav3, nav4];
    self.viewControllers = views;
    
}
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
