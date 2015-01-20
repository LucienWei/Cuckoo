//
//  AddMemberViewController.m
//  LinLang
//
//  Created by Lucien Wei on 12/24/14.
//  Copyright (c) 2014 wanan. All rights reserved.
//

#import "AddMemberViewController.h"
#import "UtilDefine.h"

#define UPLOAD_BUTTON_TAG 50
#define TEXTFIELD_TAG 60
#define IMAGE_VIEW_TAG  200
#define SHOP_TEXT_HOLDER @"请输入疯子描述, 50字以内"

@interface AddMemberViewController ()
{
}
@end

@implementation AddMemberViewController
@synthesize myScrollView;
@synthesize delegate;

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initNav];
    [self initScrollView];
    [self initLabelsAndTextFields];
    [self initImageView];
    [self initTap];
}

-(void)initNav{
    self.title=@"添加疯子";
    if ([UIDevice currentDevice].systemVersion.floatValue < 7) {
        self.navigationController.navigationBar.tintColor = MY_COLOR_ORANGE;
    } else {
        self.navigationController.navigationBar.barTintColor = MY_COLOR_ORANGE;
        self.navigationController.navigationBar.tintColor = MY_COLOR_ORANGE;
        self.navigationController.navigationBar.translucent = NO;
        self.edgesForExtendedLayout=UIRectEdgeNone;
    }
    UIBarButtonItem*leftBtn=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(dismissAddView)];
    leftBtn.tintColor = [UIColor grayColor];
    self.navigationItem.leftBarButtonItem=leftBtn;
    
    UIBarButtonItem*rightBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneBtnPress:)];
    rightBtn.tintColor = [UIColor grayColor];
    self.navigationItem.rightBarButtonItem=rightBtn;
}
-(void)initScrollView{
    myScrollView=[[UIScrollView alloc] initWithFrame:self.view.bounds];
    [myScrollView setScrollEnabled:YES];
    [myScrollView setContentSize:CGSizeMake(0, self.view.bounds.size.width)];
    myScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:myScrollView];
}
-(void)initLabelsAndTextFields{
    UITextField*nameField=[[UITextField alloc] initWithFrame:CGRectMake(20, 10, 280, 40)];
    nameField.delegate=self;
    nameField.keyboardType=UIKeyboardTypeDefault;
    nameField.returnKeyType=UIReturnKeyDone;
    nameField.textAlignment=NSTextAlignmentLeft;
    nameField.borderStyle = UITextBorderStyleLine;
    nameField.tag=TEXTFIELD_TAG;
    nameField.placeholder=@"请输入疯子昵称";
    [myScrollView addSubview:nameField];
    
    UILabel*label=[[UILabel alloc] initWithFrame:CGRectMake(20, 100, 280, 40)];
    label.textAlignment=NSTextAlignmentCenter;
    [label setBackgroundColor:[UIColor clearColor]];
    [label setFont:[UIFont fontWithName:@"Helvetica" size:17]];
    [label setTextColor:MY_COLOR_ORANGE];
    [myScrollView addSubview:label];
    label.text=@"疯子头像";
}
-(void)initImageView{
    UIImageView*bgImg=[[UIImageView alloc] initWithFrame:CGRectMake(110, 150, 100, 100)];
    UIImage *image = [UIImage imageNamed:@"none.png"];
    bgImg.image=image;
    [myScrollView addSubview:bgImg];
    
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageViews:)];
    UIImageView*imageView=[[UIImageView alloc] init];
    [imageView setFrame:bgImg.frame];
    imageView.tag = IMAGE_VIEW_TAG;
    imageView.userInteractionEnabled=YES;
    [imageView addGestureRecognizer:tap];
    imageView.image = nil;
    [myScrollView addSubview:imageView];
}
-(void)initTap{
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [myScrollView addGestureRecognizer:tap];
}
#pragma mark 其他方法
-(BOOL)validateTheAll{
    UITextField*textField=(UITextField*)[myScrollView viewWithTag:TEXTFIELD_TAG];
    NSString*string=textField.text;
    if (string==nil || string.length==0) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入疯子昵称!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [textField becomeFirstResponder];
        return NO;
    } else if (string.length>7) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"疯子昵称长度需要少于7位!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [textField becomeFirstResponder];
        return NO;
    }
    UIImageView*imgView=(UIImageView*)[myScrollView viewWithTag:IMAGE_VIEW_TAG];
    if (imgView.image == nil){
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请上传疯子头像!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [self dismissKeyboard];
        return NO;
    }
    return YES;
}
-(void)doneBtnPress:(UIButton*)button{
    if ([self validateTheAll]) {
        UITextField*textField = (UITextField*)[myScrollView viewWithTag:TEXTFIELD_TAG];
        NSString * name = textField.text;
        
        UIImageView * imgView = (UIImageView*)[myScrollView viewWithTag:IMAGE_VIEW_TAG];
        [delegate addMemberName:name image:imgView.image];
        [self dismissAddView];
    }
}
-(void)dismissKeyboard{
    UITextField*textField=(UITextField*)[myScrollView viewWithTag:TEXTFIELD_TAG];
    [textField resignFirstResponder];
}
-(void)tapImageViews:(UITapGestureRecognizer*)tap{
    UIImageView*imageView=(UIImageView*)tap.view;
    if (imageView.image == nil) {
        UIActionSheet*sheet=[[UIActionSheet alloc] initWithTitle:@"添加图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册",@"拍照", nil];
        [sheet showInView:self.view];
    } else {
        ShowImgFullViewController*view=[[ShowImgFullViewController alloc] initWithImgArray:@[imageView.image]];
        view.delegate=self;
        UINavigationController*nav=[[UINavigationController alloc] initWithRootViewController:view];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }
}
-(void)dismissAddView{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)takePhotoWithCamera{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES completion:nil];
}
-(void)takePhotoFromAlbum{
    UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
        
    }
    pickerImage.delegate = self;
    pickerImage.allowsEditing = NO;
    [self presentViewController:pickerImage animated:YES completion:nil];
}

#pragma mark TextField代理方法
-(void)textFieldDidBeginEditing:(UITextField *)textField{
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag==TEXTFIELD_TAG) {
        if (textField.text.length > 20) {
            textField.text = [textField.text substringToIndex:20];
        }
    }
}
#pragma mark 其他代理方法
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self takePhotoFromAlbum];
    } else if (buttonIndex == 1){
        [self takePhotoWithCamera];
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage*theImg=[info valueForKey:UIImagePickerControllerOriginalImage];
    float scale = 600/(theImg.size.width<theImg.size.height ? theImg.size.width:theImg.size.width);
    CGSize newSize = CGSizeMake(theImg.size.width*scale, theImg.size.height*scale);
    UIGraphicsBeginImageContext(newSize);
    [theImg drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    theImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self dismissViewControllerAnimated:YES completion:^(){
        UIImageView*imgView=(UIImageView*)[myScrollView viewWithTag:IMAGE_VIEW_TAG];
        imgView.image=theImg;}
     ];
}
-(void)cancalVC{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
-(void)deleteOneImg:(NSInteger)whichImgIndex{
    [self dismissViewControllerAnimated:YES completion:^(){
        UIImageView*imageView=(UIImageView*)[myScrollView viewWithTag:IMAGE_VIEW_TAG];
        imageView.image = nil;
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
