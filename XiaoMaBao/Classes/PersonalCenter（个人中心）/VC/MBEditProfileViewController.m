//
//  MBEditProfileViewController.m
//  XiaoMaBao
//
//  Created by 张磊 on 15/6/8.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "MBEditProfileViewController.h"
#import "STPhotoKitController.h"
#import "UIImagePickerController+ST.h"
@interface MBEditProfileViewController () <UIAlertViewDelegate,UITextFieldDelegate,UIPickerViewDelegate,UINavigationControllerDelegate,STPhotoKitDelegate,UIImagePickerControllerDelegate>
@property (strong,nonatomic) UITextField *nicknameText;
@property (strong,nonatomic) UIButton *birthdayBtn;
@property (strong,nonatomic) UIButton *preProductBtn;
@property (strong,nonatomic) UITextField *preProductText;
@property (strong,nonatomic) UIDatePicker *babyBirthdayDate;
@property (strong,nonatomic) UIDatePicker *preProductDate;
@property (strong,nonatomic) UIButton *babyGender;
@property (strong,nonatomic) UIButton *familyGender;

@property (strong,nonatomic) UIDatePicker *birthdayDatepicker;
@property (strong,nonatomic) UIDatePicker *productDatepicker;

@property (strong,nonatomic) UIImageView *headProfile;

@property (strong,nonatomic) UIToolbar *accessoryView;

@end

@implementation MBEditProfileViewController
- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
   
    
    _headProfile = [[UIImageView alloc] init];
    _headProfile.frame = CGRectMake((self.view.ml_width - 80) * 0.5, TOP_Y + MARGIN_20, 80, 80);
    _headProfile.layer.cornerRadius = 40.0;
    _headProfile.backgroundColor = [UIColor randomColor];
    
    [_headProfile setUserInteractionEnabled:YES];
    [_headProfile addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(takePhotoTapped:)]];
    
    [self.view addSubview:_headProfile];
    
    NSArray *titles = @[
                        @"昵       称：",
                        @"家长性别："
                        ];
    
    
    for (NSInteger i = 0; i < titles.count; i++) {
        
        CGFloat height = 33;
        UIView *fieldView = [[UIView alloc] init];
        fieldView.frame = CGRectMake(0, CGRectGetMaxY(_headProfile.frame) + i * height + MARGIN_20, self.view.ml_width, height);
        [self.view addSubview:fieldView];
        
        UILabel * nameLbl = [[UILabel alloc] init];
        nameLbl.font = [UIFont systemFontOfSize:14];
        nameLbl.text = titles[i];
        nameLbl.frame = CGRectMake(MARGIN_8, 0, 80, height);
        
        [nameLbl addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectBirthday:)]];
        
        [fieldView addSubview:nameLbl];
        
        if(i == 0){
            _nicknameText = [[UITextField alloc] init];
            _nicknameText.frame = CGRectMake(CGRectGetMaxX(nameLbl.frame), nameLbl.ml_y, self.view.ml_width - CGRectGetMaxX(nameLbl.frame), nameLbl.ml_height);
            _nicknameText.borderStyle = UITextBorderStyleNone;
            _nicknameText.placeholder = @"请输入昵称";
            _nicknameText.font = [UIFont systemFontOfSize:14];
            [fieldView addSubview:_nicknameText];
            _nicknameText.delegate = self;
           
      }
        else{
            
            _familyGender = [[UIButton alloc] init];
            _familyGender.frame = CGRectMake(CGRectGetMaxX(nameLbl.frame), nameLbl.ml_y, self.view.ml_width - CGRectGetMaxX(nameLbl.frame), nameLbl.ml_height);
            [_familyGender setTitle:@"--请选择--" forState:UIControlStateNormal];
            _familyGender.titleLabel.font = [UIFont systemFontOfSize:14];
            [_familyGender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            _familyGender.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            
            [_familyGender addTarget:self action:@selector(selectFatherGender:) forControlEvents:UIControlEventTouchUpInside];
            _familyGender.tag = i;
            [fieldView addSubview:_familyGender];
            
        }
        
        
        [self addBottomLineView:fieldView];
    }
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(35, CGRectGetMaxY([[[self.view subviews] lastObject] frame]) + 25, self.view.ml_width - 70, 35);
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    saveBtn.backgroundColor = NavBar_Color;
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    saveBtn.layer.cornerRadius = 17;
    [self.view addSubview:saveBtn];
    
    [saveBtn addTarget:self action:@selector(saveProfile:) forControlEvents:UIControlEventTouchUpInside];
    
    //读取服务器数据
   
    [self getUserInfo];
}

-(void)getUserInfo
{
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    [self show];
    [MBNetworking POSTOrigin:string(BASE_URL_root, @"/users/info") parameters:@{@"session":sessiondict} success:^(id responseObject) {
        [self dismiss];
        if (![self charmResponseObject:responseObject]) {
            return ;
        }
        if (responseObject) {
            [_headProfile sd_setImageWithURL:responseObject[@"data"][@"header_img"]];
            _nicknameText.text = responseObject[@"data"][@"nick_name"];
            _familyGender.tag = [responseObject[@"data"][@"parent_sex"] intValue];
            if(_familyGender.tag == 1){
                [_familyGender setTitle:@"粑粑" forState:UIControlStateNormal];
            }else{
                [_familyGender setTitle:@"麻麻" forState:UIControlStateNormal];
            }
            
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [self show:@"请求失败！" time:1];
    }];
   

}

-(void)selectBabyGender:(UIButton *)sender{
    // Inside a IBAction method:
    
    // Create an array of strings you want to show in the picker:
    NSArray *genders = [NSArray arrayWithObjects:@"男",@"女",nil];
    
    [ActionSheetStringPicker showPickerWithTitle:@"请选择性别"
                                            rows:genders
                                initialSelection:0
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                           if(selectedIndex == 0){
                                               sender.tag = 1;
                                               [sender setTitle:@"男" forState:UIControlStateNormal];
                                           }else{
                                               sender.tag = 0;
                                               [sender setTitle:@"女" forState:UIControlStateNormal];
                                           }
                                       }
                                     cancelBlock:^(ActionSheetStringPicker *picker) {
                                         MMLog(@"Block Picker Canceled");
                                     }
                                          origin:sender];
    // You can also use self.view if you don't have a sender
}

-(void)selectFatherGender:(UIButton *)sender{
    // Inside a IBAction method:
        [_nicknameText resignFirstResponder];
    // Create an array of strings you want to show in the picker:
    NSArray *genders = [NSArray arrayWithObjects:@"粑粑",@"麻麻",nil];
    
    [ActionSheetStringPicker showPickerWithTitle:@"请选择性别"
                                            rows:genders
                                initialSelection:0
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                           if(selectedIndex == 0){
                                               sender.tag = 1;
                                               [sender setTitle:@"粑粑" forState:UIControlStateNormal];
                                           }else{
                                               sender.tag = 0;
                                               [sender setTitle:@"麻麻" forState:UIControlStateNormal];
                                           }
                                       }
                                     cancelBlock:^(ActionSheetStringPicker *picker) {
                                         MMLog(@"Block Picker Canceled");
                                     }
                                          origin:sender];
    
}

- (BOOL)isiOS8OrAbove {
    NSComparisonResult order = [[UIDevice currentDevice].systemVersion compare: @"8.0"
                                                                       options: NSNumericSearch];
    return (order == NSOrderedSame || order == NSOrderedDescending);
}

-(void)selectBirthday2:(UIButton *)sender{
    [_nicknameText resignFirstResponder];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:sender.titleLabel.text];
    if(date == nil)
        date = [NSDate date];
    [ActionSheetDatePicker showPickerWithTitle:nil datePickerMode:UIDatePickerModeDate selectedDate:date
                                     doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
                                         //实例化一个NSDateFormatter对象
                                         NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                                         //设定时间格式,这里可以设置成自己需要的格式
                                         [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                                         //用[NSDate date]可以获取系统当前时间
                                         NSString *currentDateStr = [dateFormatter stringFromDate:selectedDate];
                                         [sender setTitle:currentDateStr forState:UIControlStateNormal];
                                     } cancelBlock:^(ActionSheetDatePicker *picker) {
                                         
                                     } origin:sender];
    
}

-(void)selectBirthday:(UIButton *)sender{
       [_nicknameText resignFirstResponder];
    if([self isiOS8OrAbove]){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIDatePicker *picker = [[UIDatePicker alloc] init];
        [picker setDatePickerMode:UIDatePickerModeDate];
        [alertController.view addSubview:picker];
        [alertController addAction:({
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                //实例化一个NSDateFormatter对象
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                //设定时间格式,这里可以设置成自己需要的格式
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                //用[NSDate date]可以获取系统当前时间
                NSString *currentDateStr = [dateFormatter stringFromDate:picker.date];
                [sender setTitle:currentDateStr forState:UIControlStateNormal];
            }];
            action;
        })];
        UIPopoverPresentationController *popoverController = alertController.popoverPresentationController;
        popoverController.sourceView = sender;
        popoverController.sourceRect = [sender bounds];
        [self presentViewController:alertController  animated:YES completion:nil];
    }else{
        [self selectBirthdayOnIos8Below:sender];
    }
    
}

-(void)selectBirthdayOnIos8Below:(UIButton *)sender{
       [_nicknameText resignFirstResponder];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    _birthdayDatepicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(10, alert.bounds.size.height, 320, 216)];
    [_birthdayDatepicker setDatePickerMode:UIDatePickerModeDate];
    [alert addSubview:_birthdayDatepicker];
    alert.bounds = CGRectMake(0, 0, 320 + 20, alert.bounds.size.height + 216 + 20);
    [alert setValue:_birthdayDatepicker forKey:@"accessoryView"];
    [alert show];
    
    alert.tag = sender.tag;
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
      [_nicknameText resignFirstResponder];
     if(alertView.tag < 100){
         if(buttonIndex == 1){
             
             NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
             formatter.dateFormat = @"yyyy-MM-dd";
             if(alertView.tag == 1){
                 NSString * text = [formatter stringFromDate:_birthdayDatepicker.date];
                 [self.birthdayBtn setTitle:text forState:UIControlStateNormal];
             }else{
                 NSString * text = [formatter stringFromDate:_birthdayDatepicker.date];
                 [self.preProductBtn setTitle:text forState:UIControlStateNormal];
             }
             
         }
     }
//     else{
//         if(buttonIndex == 2){
//             //拍照
//             TGCameraNavigationController *navigationController =
//            [TGCameraNavigationController newWithCameraDelegate:self];
//             
//            [self presentViewController:navigationController animated:YES completion:nil];
//         }else if(buttonIndex == 1){
//             //从相册选择
//             UIImagePickerController *pickerController =
//             [TGAlbum imagePickerControllerWithDelegate:self];
//             
//             [self presentViewController:pickerController animated:YES completion:nil];
//         }
//     }
    
    
}
#pragma mark - --- event response 事件相应 ---
- (void)editImageSelected
{
    UIAlertController *alertController = [[UIAlertController alloc]init];
    
    UIAlertAction *action0 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *controller = [UIImagePickerController imagePickerControllerWithSourceType:UIImagePickerControllerSourceTypeCamera];
        
        if ([controller isAvailableCamera] && [controller isSupportTakingPhotos]) {
            [controller setDelegate:self];
            [self presentViewController:controller animated:YES completion:nil];
        }else {
            MMLog(@"%s %@", __FUNCTION__, @"相机权限受限");
        }
    }];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"从相册获取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *controller = [UIImagePickerController imagePickerControllerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [controller setDelegate:self];
        if ([controller isAvailablePhotoLibrary]) {
            [self presentViewController:controller animated:YES completion:nil];
        }    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alertController addAction:action0];
    [alertController addAction:action1];
    [alertController addAction:action2];
    
    [self presentViewController:alertController animated:YES completion:nil];
}
-(void)setBirthday:(id)sender
{
    NSDate *selected = [_babyBirthdayDate date];
    MMLog(@"date: %@", selected);
}

- (void)saveProfile:(UIButton *)sender{
    
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    NSString * nick_name = self.nicknameText.text;
    [self show];
    NSString * parent_sex = [NSString stringWithFormat:@"%ld",self.familyGender.tag];
    
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/users/modinfo"] parameters:@{@"session":dict,@"nick_name":nick_name,@"parent_sex":parent_sex} constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSData * data =  [UIImage reSizeImageData:_headProfile.image maxImageSize:300 maxSizeWithKB:300];
        if(data != nil){
            [formData appendPartWithFileData:data name:@"header_img" fileName:@"header_img.jpg" mimeType:@"image/jpeg"];
        }
    } progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        [self dismiss];
        MMLog(@"%@",responseObject);
        [self show:@"保存成功" time:1];
        [self popViewControllerAnimated:YES];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        MMLog(@"%@",error);
        [self show:@"请求失败！" time:1];
    }];

}

- (NSString *)titleStr{
    return @"个人信息";
}

//当用户按下return键或者按回车键，keyboard消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

- (void)takePhotoTapped:(UIImageView *)sender
{
    [self editImageSelected];
}
- (void)photoKitController:(STPhotoKitController *)photoKitController resultImage:(UIImage *)resultImage
{
    _headProfile.image = resultImage;

}
#pragma mark - 2.UIImagePickerController的委托

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *imageOriginal = [info objectForKey:UIImagePickerControllerOriginalImage];
        STPhotoKitController *photoVC = [[STPhotoKitController alloc] init];
        [photoVC setDelegate:self];
        [photoVC setImageOriginal:imageOriginal];
        
        [photoVC setSizeClip:CGSizeMake(300, 300)];
        
        [self presentViewController:photoVC animated:YES completion:nil];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
        
    }];
}

@end
