//
//  MBUpdateBabyInforViewController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/2/16.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBUpdateBabyInforViewController.h"
#import "TGCameraViewController.h"
@interface MBUpdateBabyInforViewController () <UIAlertViewDelegate,UITextFieldDelegate,UIPickerViewDelegate,TGCameraDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    NSString *_birthdaytext;
    NSString *_babyGendertext;
    
}
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

@implementation MBUpdateBabyInforViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _birthdaytext = self.daty;
    _babyGendertext = self.xingbie;
    _headProfile = [[UIImageView alloc] init];
    _headProfile.frame = CGRectMake((self.view.ml_width - 80) * 0.5, TOP_Y + MARGIN_20, 80, 80);
    _headProfile.layer.cornerRadius = 40.0;
    if (self.image) {
        _headProfile.image = self.image;
    }else{
     [_headProfile sd_setImageWithURL:[NSURL URLWithString:self.imageUrl] placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
    }
   
    [_headProfile setUserInteractionEnabled:YES];
    [_headProfile addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(takePhotoTapped:)]];
    
    [self.view addSubview:_headProfile];
    
    NSArray *titles = @[
                        @"宝宝小名：",
                        @"宝宝生日：",
                        @"宝宝性别：",
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
            _nicknameText.placeholder = @"请输入宝宝小名";
            _nicknameText.text = self.name;
            _nicknameText.font = [UIFont systemFontOfSize:14];
            [fieldView addSubview:_nicknameText];
            _nicknameText.delegate = self;
        }else if(i == 1){
            _birthdayBtn = [[UIButton alloc] init];
            _birthdayBtn.frame = CGRectMake(CGRectGetMaxX(nameLbl.frame), nameLbl.ml_y, self.view.ml_width - CGRectGetMaxX(nameLbl.frame), nameLbl.ml_height);
            
            _birthdayBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            //            _birthdayBtn.titleLabel.frame.size.width = 100;
            [_birthdayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            _birthdayBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            _birthdayBtn.tag = i;
            [_birthdayBtn addTarget:self action:@selector(selectBirthday2:) forControlEvents:UIControlEventTouchUpInside];
            [_birthdayBtn setTitle:self.daty forState:UIControlStateNormal];
            [fieldView addSubview:_birthdayBtn];
            
        }else{
            _preProductBtn = [[UIButton alloc] init];
            _preProductBtn.frame = CGRectMake(CGRectGetMaxX(nameLbl.frame), nameLbl.ml_y, self.view.ml_width - CGRectGetMaxX(nameLbl.frame), nameLbl.ml_height);
            
            _preProductBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [_preProductBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            _preProductBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [_preProductBtn setTitle:self.xingbie forState:UIControlStateNormal];
            [_preProductBtn addTarget:self action:@selector(selectBabyGender:) forControlEvents:UIControlEventTouchUpInside];
            _preProductBtn.tag = i;
            [fieldView addSubview:_preProductBtn];
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
    
    [saveBtn addTarget:self action:@selector(update) forControlEvents:UIControlEventTouchUpInside];
    
    //读取服务器数据
    
    
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
                                           
                                               _babyGendertext =@"男";
                                           }else{
                                               sender.tag = 0;
                                               [sender setTitle:@"女" forState:UIControlStateNormal];
                                                _babyGendertext =@"女";
                                           }
                                       }
                                     cancelBlock:^(ActionSheetStringPicker *picker) {
                                         NSLog(@"Block Picker Canceled");
                                     }
                                          origin:sender];
    // You can also use self.view if you don't have a sender
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
                                         _birthdaytext = currentDateStr;
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
    else{
        if(buttonIndex == 2){
            //拍照
            TGCameraNavigationController *navigationController =
            [TGCameraNavigationController newWithCameraDelegate:self];
            
            [self presentViewController:navigationController animated:YES completion:nil];
        }else if(buttonIndex == 1){
            //从相册选择
            UIImagePickerController *pickerController =
            [TGAlbum imagePickerControllerWithDelegate:self];
            
            [self presentViewController:pickerController animated:YES completion:nil];
        }
    }
    
    
}

-(void)setBirthday:(id)sender
{
    NSDate *selected = [_babyBirthdayDate date];
    NSLog(@"date: %@", selected);
}

- (void)saveProfile:(UIButton *)sender{
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    
    NSString * nick_name = self.nicknameText.text;
    NSString * child_birthday = self.birthdayBtn.titleLabel.text;
    NSString * expected_date = self.preProductBtn.titleLabel.text;
    NSString * child_sex = [NSString stringWithFormat:@"%ld",self.babyGender.tag];
    NSString * parent_sex = [NSString stringWithFormat:@"%ld",self.familyGender.tag];
    
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL,@"user/modInfo"] parameters:@{@"session":dict,@"nick_name":nick_name,@"child_birthday":child_birthday,@"expected_date":expected_date,@"child_sex":child_sex,@"parent_sex":parent_sex} constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSData * data =  [UIImage reSizeImageData:_headProfile.image maxImageSize:300 maxSizeWithKB:300];
        if(data != nil){
            [formData appendPartWithFileData:data name:@"header_img" fileName:@"header_img.jpg" mimeType:@"image/jpeg"];
        }
        
    } progress:^(NSProgress *progress) {
        NSLog(@"%f",progress.fractionCompleted);
    } success:^(NSURLSessionDataTask *task, MBModel *responseObject) {
        [self show:@"保存成功" time:1];
        [self popViewControllerAnimated:YES];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
        [self show:@"请求失败！" time:1];
    }];}
- (NSString *)titleStr{
    return @"修改宝宝信息";
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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"设置头像" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"从相册选择", @"拍照",nil];
    alert.tag = 101;
    [alert show];
    
}

#pragma mark - TGCameraDelegate optional

- (void)cameraWillTakePhoto
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)cameraDidSavePhotoAtPath:(NSURL *)assetURL
{
    // When this method is implemented, an image will be saved on the user's device
    NSLog(@"%s album path: %@", __PRETTY_FUNCTION__, assetURL);
}

- (void)cameraDidSavePhotoWithError:(NSError *)error
{
    NSLog(@"%s error: %@", __PRETTY_FUNCTION__, error);
}

#pragma mark - TGCameraDelegate required

- (void)cameraDidCancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cameraDidTakePhoto:(UIImage *)image
{
    _headProfile.image = image;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cameraDidSelectAlbumPhoto:(UIImage *)image
{
    _headProfile.image = image;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    _headProfile.image = [TGAlbum imageWithMediaInfo:info];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    
    if ([[UIScreen mainScreen] scale]==2.0) {
        UIGraphicsBeginImageContextWithOptions(newSize, NO, 2.0);
    }else{
        
        UIGraphicsBeginImageContext(newSize);
    }
    // Create a graphics image context
    
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}
-(void)update
{
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    [self showProgress];
    NSString *str = @"";
    if ([_babyGendertext isEqualToString:@"男"]) {
        str = @"0";
    }else{
        str = @"1";
        
    }
    
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/athena/babyadd"] parameters:@{@"session":sessiondict,@"nickname":_nicknameText.text,@"birthday":_birthdaytext,@"gender":str ,@"act":@"modify",@"id":self.ID} constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSData * data =  [UIImage reSizeImageData:_headProfile.image maxImageSize:300 maxSizeWithKB:300];
        if(data != nil){
            [formData appendPartWithFileData:data name:@"children" fileName:@"children.jpg" mimeType:@"image/jpeg"];
        }

    } progress:^(NSProgress *progress) {
        self.progress = progress.fractionCompleted;
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([[responseObject valueForKeyPath:@"status"]isEqualToNumber:@1]) {
            
            self.block(_nicknameText.text,str,_birthdaytext,_headProfile.image);
            
            
            [self popViewControllerAnimated:YES];
            [self show:@"修改成功" time:1];
            
        }else{
            
            [self show:@"保存失败" time:1];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
        [self show:@"请求失败！" time:1];
    }];
  
    
}



@end
