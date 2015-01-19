//
//  MapRouteViewController.m
//  MapDemo
//
//  Created by Lucien Wei on 1/3/15.
//  Copyright (c) 2015 TestDemo. All rights reserved.
//

#import "MapRouteViewController.h"

#define MYBUNDLE_NAME @ "mapapi.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]

@interface MapRouteViewController ()
{
    BMKMapView* mMapView;
    BMKLocationService* locService;
    BMKGeoCodeSearch* geocodesearch;
    BMKRouteSearch* routesearch;
    CLLocationCoordinate2D myCoordinate2D;
    BMKPlanNode* mStart;
    BMKPlanNode* mEnd;
}
@end

#pragma mark -
#pragma mark RouteAnnotation
@interface RouteAnnotation : BMKPointAnnotation
{
    int _type; ///<0:起点 1：终点 2：公交 3：地铁 4:驾乘 5:途经点
    int _degree;
}

@property (nonatomic) int type;
@property (nonatomic) int degree;
@end

@implementation RouteAnnotation

@synthesize type = _type;
@synthesize degree = _degree;
@end

#pragma mark -
#pragma mark MapRouteViewController
@implementation MapRouteViewController
- (NSString*)getMyBundlePath1:(NSString *)filename
{
    
    NSBundle * libBundle = MYBUNDLE ;
    if ( libBundle && filename ){
        NSString * s=[[libBundle resourcePath ] stringByAppendingPathComponent : filename];
        return s;
    }
    return nil ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"路线";
    if ([UIDevice currentDevice].systemVersion.floatValue < 7) {
        self.navigationController.navigationBar.tintColor = [UIColor lightGrayColor];
    } else {
        self.navigationController.navigationBar.barTintColor = [UIColor lightGrayColor];
        self.navigationController.navigationBar.tintColor = [UIColor lightGrayColor];
        self.edgesForExtendedLayout=UIRectEdgeNone;
    }
    NSMutableDictionary*dict=[NSMutableDictionary dictionary];
    [dict setObject:[UIFont fontWithName:@"HelveticaNeue" size:17] forKey:NSFontAttributeName];
    [dict setObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [[UINavigationBar appearance] setTitleTextAttributes:dict];
    
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        self.navigationController.navigationBar.translucent = NO;
    }
    self.view.backgroundColor = [UIColor blackColor];
    mMapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
    [self.view addSubview:mMapView];
    mMapView.userTrackingMode = BMKUserTrackingModeFollow;//设置定位的状态
    mMapView.showsUserLocation = YES;//显示定位图层
    mMapView.zoomLevel=15;
    
    locService = [[BMKLocationService alloc]init];
    geocodesearch = [[BMKGeoCodeSearch alloc]init];
    routesearch = [[BMKRouteSearch alloc]init];
    [self initSearchRouteButtons];
}
-(void)initSearchRouteButtons{
    UIView*view = [[UIView alloc] initWithFrame:CGRectMake(0, 10, self.view.bounds.size.width, 30)];
    [self.view addSubview:view];
    
    NSArray*titleArray = [NSArray arrayWithObjects:@"公交", @"驾车", @"步行", nil];
    for (int i=0; i<3; i++) {
        UIButton*button = [[UIButton alloc] initWithFrame:CGRectMake(70 + i*60, 0, 58, 30)];
        button.backgroundColor = [UIColor grayColor];
        [button setTitle:[titleArray objectAtIndex:i] forState:UIControlStateNormal];
        if (i==0) {
            [button addTarget:self action:@selector(onClickBusSearch) forControlEvents:UIControlEventTouchUpInside];
        } else if (i==1) {
            [button addTarget:self action:@selector(onClickDriveSearch) forControlEvents:UIControlEventTouchUpInside];
        } else if (i==2) {
            [button addTarget:self action:@selector(onClickWalkSearch) forControlEvents:UIControlEventTouchUpInside];
        }
        [view addSubview:button];
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [mMapView viewWillAppear];
    mMapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    locService.delegate = self;
    geocodesearch.delegate = self;
    routesearch.delegate = self;
    CLLocationCoordinate2D pt = CLLocationCoordinate2DMake(30.576032, 104.064457);
    mEnd = [[BMKPlanNode alloc]init];
    mEnd.pt = pt;
    
    [locService startUserLocationService];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [locService stopUserLocationService];
    mMapView.showsUserLocation = NO;
    
    [mMapView viewWillDisappear];
    mMapView.delegate = nil; // 不用时，置nil
    locService.delegate = nil;
    geocodesearch.delegate = nil;
    routesearch.delegate = nil;
}
    
-(void)onClickBusSearch
{
    BMKTransitRoutePlanOption *transitRouteSearchOption = [[BMKTransitRoutePlanOption alloc]init];
    transitRouteSearchOption.city= @"成都市";
    transitRouteSearchOption.from = mStart;
    transitRouteSearchOption.to = mEnd;
    BOOL flag = [routesearch transitSearch:transitRouteSearchOption];
    if (!flag) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"暂未检索到合适路线 @_@ " delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

-(void)onClickDriveSearch
{
    BMKDrivingRoutePlanOption *drivingRouteSearchOption = [[BMKDrivingRoutePlanOption alloc]init];
    drivingRouteSearchOption.from = mStart;
    drivingRouteSearchOption.to = mEnd;
    BOOL flag = [routesearch drivingSearch:drivingRouteSearchOption];
    if (!flag) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"暂未检索到合适路线 @_@ " delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

-(void)onClickWalkSearch
{
    BMKWalkingRoutePlanOption *walkingRouteSearchOption = [[BMKWalkingRoutePlanOption alloc]init];
    walkingRouteSearchOption.from = mStart;
    walkingRouteSearchOption.to = mEnd;
    BOOL flag = [routesearch walkingSearch:walkingRouteSearchOption];
    if (!flag) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"暂未检索到合适路线 @_@ " delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
}
- (UIImage*)imageRotatedByDegrees:(UIImage*)image  degree:(CGFloat)degrees
{
    CGFloat width = CGImageGetWidth(image.CGImage);
    CGFloat height = CGImageGetHeight(image.CGImage);
    
    CGSize rotatedSize;
    
    rotatedSize.width = width;
    rotatedSize.height = height;
    
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    CGContextRotateCTM(bitmap, degrees * M_PI / 180);
    CGContextRotateCTM(bitmap, M_PI);
    CGContextScaleCTM(bitmap, -1.0, 1.0);
    CGContextDrawImage(bitmap, CGRectMake(-rotatedSize.width/2, -rotatedSize.height/2, rotatedSize.width, rotatedSize.height), image.CGImage);
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview viewForAnnotation:(RouteAnnotation*)routeAnnotation
{
    BMKAnnotationView* view = nil;
    switch (routeAnnotation.type) {
        case 0:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"start_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"start_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_start.png"]];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 1:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"end_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"end_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_end.png"]];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 2:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"bus_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"bus_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_bus.png"]];
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 3:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"rail_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"rail_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_rail.png"]];
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 4:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"route_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"route_node"];
                view.canShowCallout = TRUE;
            } else {
                [view setNeedsDisplay];
            }
            
            UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_direction.png"]];
            view.image = [self imageRotatedByDegrees:image degree:routeAnnotation.degree];
            view.annotation = routeAnnotation;
            
        }
            break;
        case 5:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"waypoint_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"waypoint_node"];
                view.canShowCallout = TRUE;
            } else {
                [view setNeedsDisplay];
            }
            
            UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_waypoint.png"]];
            view.image = [self imageRotatedByDegrees:image degree:routeAnnotation.degree];
            view.annotation = routeAnnotation;
        }
            break;
        default:
            break;
    }
    
    return view;
}

#pragma mark -
#pragma mark BMKMapViewDelegate
-(void)mapview:(BMKMapView *)mapView onLongClick:(CLLocationCoordinate2D)coordinate
{
//    NSLog(@"选中位置坐标: (%f,%f)", coordinate.latitude, coordinate.longitude);
//    BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
//    item.coordinate = coordinate;
//    [mMapView addAnnotation:item];
//    [mMapView setCenterCoordinate:coordinate animated:YES];
//     CLLocationCoordinate2D pt = CLLocationCoordinate2DMake(30.576032, 104.064457);
//    mStart = [[BMKPlanNode alloc]init];
//    mStart.pt = locService.userLocation.location.coordinate;
//    mEnd = [[BMKPlanNode alloc]init];
//    mEnd.pt = coordinate;
}
//根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[RouteAnnotation class]]) {
        return [self getRouteAnnotationView:view viewForAnnotation:(RouteAnnotation*)annotation];
    }
    return nil;
}
- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:1];
        polylineView.strokeColor = [[UIColor greenColor] colorWithAlphaComponent:0.7];
        polylineView.lineWidth = 3.0;
        return polylineView;
    }
    return nil;
}

#pragma mark -
#pragma mark BMKRouteSearchDelegate
- (void)onGetTransitRouteResult:(BMKRouteSearch*)searcher result:(BMKTransitRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:mMapView.annotations];
    [mMapView removeAnnotations:array];
    array = [NSArray arrayWithArray:mMapView.overlays];
    [mMapView removeOverlays:array];
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKTransitRouteLine* plan = (BMKTransitRouteLine*)[result.routes objectAtIndex:0];
        // 计算路线方案中的路段数目
        int size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKTransitStep* transitStep = [plan.steps objectAtIndex:i];
            if(i==0){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"起点";
                item.type = 0;
                [mMapView addAnnotation:item]; // 添加起点标注
                
            }else if(i==size-1){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [mMapView addAnnotation:item]; // 添加起点标注
            }
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.instruction;
            item.type = 3;
            [mMapView addAnnotation:item];
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKTransitStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [mMapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
    }
}
- (void)onGetDrivingRouteResult:(BMKRouteSearch*)searcher result:(BMKDrivingRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:mMapView.annotations];
    [mMapView removeAnnotations:array];
    array = [NSArray arrayWithArray:mMapView.overlays];
    [mMapView removeOverlays:array];
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKDrivingRouteLine* plan = (BMKDrivingRouteLine*)[result.routes objectAtIndex:0];
        // 计算路线方案中的路段数目
        int size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:i];
            if(i==0){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"起点";
                item.type = 0;
                [mMapView addAnnotation:item]; // 添加起点标注
                
            }else if(i==size-1){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [mMapView addAnnotation:item]; // 添加起点标注
            }
            //添加annotation节点
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.entraceInstruction;
            item.degree = transitStep.direction * 30;
            item.type = 4;
            [mMapView addAnnotation:item];
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        // 添加途经点
        if (plan.wayPoints) {
            for (BMKPlanNode* tempNode in plan.wayPoints) {
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item = [[RouteAnnotation alloc]init];
                item.coordinate = tempNode.pt;
                item.type = 5;
                item.title = tempNode.name;
                [mMapView addAnnotation:item];
            }
        }
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [mMapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
    }
}

- (void)onGetWalkingRouteResult:(BMKRouteSearch*)searcher result:(BMKWalkingRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:mMapView.annotations];
    [mMapView removeAnnotations:array];
    array = [NSArray arrayWithArray:mMapView.overlays];
    [mMapView removeOverlays:array];
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKWalkingRouteLine* plan = (BMKWalkingRouteLine*)[result.routes objectAtIndex:0];
        int size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKWalkingStep* transitStep = [plan.steps objectAtIndex:i];
            if(i==0){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"起点";
                item.type = 0;
                [mMapView addAnnotation:item]; // 添加起点标注
                
            }else if(i==size-1){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [mMapView addAnnotation:item]; // 添加起点标注
            }
            //添加annotation节点
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.entraceInstruction;
            item.degree = transitStep.direction * 30;
            item.type = 4;
            [mMapView addAnnotation:item];
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKWalkingStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [mMapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
    }
}

#pragma mark -
#pragma mark LocationServiceDelegate

- (void)willStartLocatingUser
{
}
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [mMapView updateLocationData:userLocation];
}
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [mMapView updateLocationData:userLocation];
    [locService stopUserLocationService];
    
    mStart = [[BMKPlanNode alloc]init];
    mStart.pt = locService.userLocation.location.coordinate;
    
    // 开始搜索路线
    [self onClickDriveSearch];
    
    NSLog(@"定位成功 关闭定位....  当前位置: (%f, %f)", userLocation.location.coordinate.longitude, userLocation.location.coordinate.latitude);
    
}
- (void)didStopLocatingUser
{
}
- (void)didFailToLocateUserWithError:(NSError *)error
{
}

#pragma mark -
#pragma mark BMKGeoCodeSearchDelegate
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    NSArray* array = [NSArray arrayWithArray:mMapView.annotations];
    [mMapView removeAnnotations:array];
    array = [NSArray arrayWithArray:mMapView.overlays];
    [mMapView removeOverlays:array];
    
    if (error == 0) {
        BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
        item.coordinate = result.location;
        item.title = result.address;
        [mMapView addAnnotation:item];
        mMapView.centerCoordinate = result.location;
    }
}

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    NSArray* array = [NSArray arrayWithArray:mMapView.annotations];
    [mMapView removeAnnotations:array];
    array = [NSArray arrayWithArray:mMapView.overlays];
    [mMapView removeOverlays:array];
    
    if (error == 0) {
        BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
        item.coordinate = result.location;
        item.title = result.address;
        [mMapView addAnnotation:item];
        mMapView.centerCoordinate = result.location;
    }
}

- (void)dealloc {
    if (mMapView) {
        mMapView = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
