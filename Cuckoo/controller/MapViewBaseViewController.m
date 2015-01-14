//
//  MapViewBaseViewController.m
//  MapDemo
//
//  Created by Lucien Wei on 1/9/15.
//  Copyright (c) 2015 TestDemo. All rights reserved.
//

#import "MapViewBaseViewController.h"

@interface MapViewBaseViewController ()
{
    BMKMapView* mapView;
    BMKGeoCodeSearch* geocodesearch;

}
@end

@implementation MapViewBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"Map";
    if ([UIDevice currentDevice].systemVersion.floatValue < 7) {
        self.navigationController.navigationBar.tintColor = [UIColor lightGrayColor];
    } else {
        self.navigationController.navigationBar.barTintColor = [UIColor lightGrayColor];
        self.navigationController.navigationBar.tintColor = [UIColor lightGrayColor];
        self.navigationController.navigationBar.translucent = NO;
        self.edgesForExtendedLayout=UIRectEdgeNone;
    }

    self.view.backgroundColor = [UIColor cyanColor];
    mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
    self.view = mapView;
    mapView.userTrackingMode = BMKUserTrackingModeFollow;
    mapView.showsUserLocation = YES;
    mapView.zoomLevel = 16;
    geocodesearch = [[BMKGeoCodeSearch alloc]init];
}

-(void)viewWillAppear:(BOOL)animated {
    [mapView viewWillAppear];
    mapView.delegate = self;
    geocodesearch.delegate = self;
    
    // 锦城公园
    CLLocationCoordinate2D pt = CLLocationCoordinate2DMake(30.576032, 104.064457);
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = pt;
    [geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
}

-(void)viewWillDisappear:(BOOL)animated {
    [mapView viewWillDisappear];
    mapView.delegate = nil;
    geocodesearch.delegate = nil;
}

#pragma mark -
#pragma mark BMKMapViewDelegate
-(void)mapview:(BMKMapView *)mapView onLongClick:(CLLocationCoordinate2D)coordinate
{
    NSLog(@"%f,%f", coordinate.latitude, coordinate.longitude);
    
    CLLocationCoordinate2D pt = coordinate;
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = pt;
    [geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
}
-(BMKAnnotationView*)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation{
    if([annotation isKindOfClass:[BMKPointAnnotation class]]){
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotationView.animatesDrop = YES; // 设置该标注点动画显示
        return newAnnotationView;
    }
    return nil;
}
- (void)mapViewDidFinishLoading:(BMKMapView *)mapView {
    NSLog(@"%@", @"BMKMapView控件初始化完成");
}

- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate {
    NSLog(@"map view: click blank");
}

- (void)mapview:(BMKMapView *)mapView onDoubleClick:(CLLocationCoordinate2D)coordinate {
    NSLog(@"map view: double click");
}
#pragma mark -
#pragma mark BMKGeoCodeSearchDelegate
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    NSArray* array = [NSArray arrayWithArray:mapView.annotations];
    [mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:mapView.overlays];
    [mapView removeOverlays:array];
    
    if (error == 0) {
        BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
        item.coordinate = result.location;
        item.title = result.address;
        [mapView addAnnotation:item];
        [mapView setCenterCoordinate:result.location animated:YES];
    }
}

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    NSArray* array = [NSArray arrayWithArray:mapView.annotations];
    [mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:mapView.overlays];
    [mapView removeOverlays:array];
    
    if (error == 0) {
        BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
        item.coordinate = result.location;
        item.title = result.address;
        [mapView addAnnotation:item];
        [mapView setCenterCoordinate:result.location animated:YES];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
