//
//  @Author : <#Author#>
//  @Desc   : <#Desc#>
//
//  XiaoMaBao
//
//  Created by 张磊 on 15/5/4.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "MBResetPwdViewController.h"
#import "MBRegisterField.h"
#import "MBNetworking.h"
#import "NSString+BQ.h"
#import "MobClick.h"
@interface MBResetPwdViewController ()
@property (weak, nonatomic) IBOutlet MBRegisterField *pwdField;
@property (weak, nonatomic) IBOutlet MBRegisterField *pwd2Field;
- (IBAction)nextStep;

@end

@implementation MBResetPwdViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MBResetPwdViewController"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MBResetPwdViewController"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *pwdFieldleftView = [[UIView alloc] init];
    UIView *pwdField2LeftView = [[UIView alloc] init];
    
    pwdFieldleftView.frame = CGRectMake(0, 0, 12, 12);
    pwdField2LeftView.frame = CGRectMake(0, 0, 12, 12);
    
    self.pwdField.leftView = pwdFieldleftView;
    self.pwdField.leftViewMode = UITextFieldViewModeAlways;
    
    self.pwd2Field.leftView = pwdField2LeftView;
    self.pwd2Field.leftViewMode = UITextFieldViewModeAlways;
    
}

- (NSString *)titleStr{
    return @"重置登录密码";
}

- (IBAction)nextStep {
    
    if ([self.pwdField.text isEqualToString:self.pwd2Field.text] && self.pwdField.text.length >= 6) {
        
        NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/users/modpassword"];
        MBUserDataSingalTon *user = [MBSignaltonTool getCurrentUserInfo];
        NSString *passwordMd5 = [self.pwdField.text md5] ;
        
        
        [MBNetworking POST:url parameters:@{@"name":user.phoneNumber,@"password":passwordMd5,@"phoneCode":_code} success:^(NSURLSessionDataTask *asd, MBModel *responseObject) {
            
            NSDictionary *dic = responseObject.status;
            
            
            if ([dic[@"succeed"]isEqualToNumber:@1]) {
                
                [self show:@"密码修改成功,正在跳转首页" time:1];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    UIViewController *mainVc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
                    [UIApplication sharedApplication].keyWindow.rootViewController = mainVc;
                });

            }else{
                [self show:dic[@"error_desc"] time:1];
            }
                    } failure:^(NSURLSessionDataTask *asdf, NSError *asdfg) {
            [self show:@"请求失败！" time:1];
        }];
    }else{
        
        [self show:@"密码修改失败" time:1];
    }
}
@end
