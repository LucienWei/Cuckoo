//
//  MapRouteViewController.h
//  MapDemo
//
//  Created by Lucien Wei on 1/3/15.
//  Copyright (c) 2015 TestDemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"

@interface MapRouteViewController : UIViewController<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,BMKRouteSearchDelegate>

@end
