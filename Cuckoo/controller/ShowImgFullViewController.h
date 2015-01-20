//
//  ShowImgFullViewController.h
//  HomeBridge
//
//  Created by mac4st on 14-4-8.
//  Copyright (c) 2014年 keen. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "UtilDefine.h"
@protocol ShowImgFullViewDelegate
-(void)cancalVC;
-(void)deleteOneImg:(NSInteger)whichImgIndex;
@end
@interface ShowImgFullViewController : UIViewController<UIScrollViewDelegate>
@property(nonatomic,retain)UIScrollView*myScrollView;
@property(nonatomic,retain)NSMutableArray*imgList;
@property(nonatomic,retain)id<ShowImgFullViewDelegate>delegate;
- (id)initWithImgArray:(NSArray*)imgArray;
@end
