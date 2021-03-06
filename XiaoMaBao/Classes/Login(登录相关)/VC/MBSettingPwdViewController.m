//
//  @Author : <#Author#>
//  @Desc   : <#Desc#>
//
//  XiaoMaBao
//
//  Created by 张磊 on 15/5/1.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "MBSettingPwdViewController.h"
#import "MBRegisterField.h"
#import "MBSignaltonTool.h"
#import "MBRegisterPhoneDoneViewController.h"
#import "MBLogOperation.h"
@interface MBSettingPwdViewController ()
@property (weak, nonatomic) IBOutlet MBRegisterField *pwdField;
@property (weak, nonatomic) IBOutlet MBRegisterField *pwd2Field;
@property (weak, nonatomic) IBOutlet UIButton *next;
@end

@implementation MBSettingPwdViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *pwdLeftView = [[UIView alloc] init];
    pwdLeftView.frame = CGRectMake(0, 0, 12, 12);
    
    self.pwdField.leftView = pwdLeftView;
    self.pwdField.leftViewMode = UITextFieldViewModeAlways;
    
    self.pwdField.clearButtonMode = UITextFieldViewModeNever;
    self.pwd2Field.clearButtonMode = UITextFieldViewModeNever;
    
    UIButton *pwdRightView = [UIButton buttonWithType:UIButtonTypeCustom];
    pwdRightView.imageView.contentMode = UIViewContentModeScaleAspectFit;
    pwdRightView.frame = CGRectMake(0, 0, 40, 25);
    [pwdRightView setImage:[UIImage imageNamed:@"button_off"] forState:UIControlStateNormal];
    [pwdRightView setImage:[UIImage imageNamed:@"button_on"] forState:UIControlStateSelected];
    [pwdRightView addTarget:self action:@selector(clickButtonStatus:) forControlEvents:UIControlEventTouchUpInside];
    self.pwdField.rightView = pwdRightView;
    self.pwdField.rightViewMode = UITextFieldViewModeAlways;
    
    UIView *pwd2LeftView = [[UIView alloc] init];
    pwd2LeftView.frame = CGRectMake(0, 0, 12, 12);
    self.pwd2Field.leftView = pwd2LeftView;
    self.pwd2Field.leftViewMode = UITextFieldViewModeAlways;
}
- (IBAction)nextBtnClick {

    [self show];
    [self.pwdField resignFirstResponder];
    [self.pwd2Field resignFirstResponder];
    if (self.pwdField.text.length >= 6 && [self.pwdField.text isEqualToString:self.pwd2Field.text]) {

        NSString *userMd5 = self.pwdField.text;
        NSString *passwordMd5 = [userMd5 md5];
        NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/users/register"];
        NSDictionary *parameter = @{@"phoneCode":[_phoneCode md5],@"name":self.phone,@"password":passwordMd5,@"type":@"1"};
        if (!self.isRegistered) {
            url = [NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/users/modpassword"];
            parameter =  @{@"phoneCode":_phoneCode ,@"name":self.phone,@"password":passwordMd5,@"phoneCode":@"1"};
        }
        
       
        [MBNetworking POSTOrigin:url parameters:parameter  success:^(id responseObject) {
            [self dismiss];
//            MMLog(@"%@",responseObject);
            
            NSString *succeed = s_str(responseObject[@"status"][@"succeed"]);
            if ([succeed isEqualToString:@"1"]){
                NSDictionary *mDic = @{@"name":self.phone,@"password":self.pwdField.text};
                [User_Defaults setObject:mDic forKey:@"userInfo"];
                [User_Defaults synchronize];
                
                if (self.isRegistered) {
                    [self performSegueWithIdentifier:@"MBRegisterPhoneDoneViewController" sender:nil];
                    
                }else{
                    [self show:@"密码修改成功,请重新登录" time:1];
                    [self.navigationController popToRootViewControllerAnimated:true];
                   
                }
                
            }
            
        } failure:^(NSURLSessionDataTask *operation, NSError *error) {
            [self show:@"请求失败！" time:1];
            MMLog(@"%@",error);
        }];
        
    }else{
        [self show:@"密码不相等或密码长度最少为6位" time:1];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
     [super prepareForSegue:segue sender:sender];
    if ([segue.identifier isEqualToString:@"MBRegisterPhoneDoneViewController"]) {
        MBRegisterPhoneDoneViewController *vc = segue.destinationViewController;
        MBUserDataSingalTon *user = [MBSignaltonTool getCurrentUserInfo];
        vc.phoneNumber = user.phoneNumber;
    }
    
   
}

- (void)clickButtonStatus:(UIButton *)btn{
    btn.selected = !btn.isSelected;
}

- (NSString *)titleStr{
    return @"设置密码";
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self.pwdField resignFirstResponder];
    [self.pwd2Field resignFirstResponder];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
