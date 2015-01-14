//
//  MainViewController.m
//  MapDemo
//
//  Created by Lucien Wei on 1/9/15.
//  Copyright (c) 2015 TestDemo. All rights reserved.
//

#import "MainViewController.h"
#import "MapViewBaseViewController.h"
#import "MapRouteViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    MapViewBaseViewController*baseView=[[MapViewBaseViewController alloc] init];
    UINavigationController*nav1=[[UINavigationController alloc] initWithRootViewController:baseView];
    
    MapRouteViewController*routeView=[[MapRouteViewController alloc] init];
    UINavigationController*nav2=[[UINavigationController alloc] initWithRootViewController:routeView];
    
    if ([UIDevice currentDevice].systemVersion.floatValue<7) {
        baseView.tabBarItem=[[UITabBarItem alloc] initWithTitle:@"地图" image:nil tag:1];
        [baseView.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"pin_green.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"pin_red.png"]];
        
        routeView.tabBarItem=[[UITabBarItem alloc] initWithTitle:@"路线" image:nil tag:2];
        [routeView.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"icon_nav_start.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"icon_nav_end.png"]];
    } else {
        baseView.tabBarItem=[[UITabBarItem alloc] initWithTitle:@"地图" image:[UIImage imageNamed:@"pin_green.png"] selectedImage:[[UIImage imageNamed:@"pin_red.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        routeView.tabBarItem=[[UITabBarItem alloc] initWithTitle:@"路线" image:[UIImage imageNamed:@"icon_nav_start.png"] selectedImage:[[UIImage imageNamed:@"icon_nav_end.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    }
    [[UITabBarItem appearance] setTitleTextAttributes:@{UITextAttributeTextColor:[UIColor blackColor]} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{UITextAttributeTextColor:[UIColor blueColor]} forState:UIControlStateSelected];
    [self.tabBar setBackgroundColor:[UIColor grayColor]];
    
    NSArray*views=@[nav1,nav2];
    self.viewControllers=views;
}
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
