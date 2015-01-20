//
//  AddMemberViewController.h
//  LinLang
//
//  Created by Lucien Wei on 12/24/14.
//  Copyright (c) 2014 wanan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShowImgFullViewController.h"
@protocol AddMemberDelegate
-(void)addMemberName:(NSString*)name image:(UIImage*)image;
@end
@interface AddMemberViewController : UIViewController<UIActionSheetDelegate,UITextFieldDelegate, UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ShowImgFullViewDelegate>
@property(nonatomic,strong)UIScrollView*myScrollView;
@property(nonatomic,retain)id<AddMemberDelegate>delegate;

@end