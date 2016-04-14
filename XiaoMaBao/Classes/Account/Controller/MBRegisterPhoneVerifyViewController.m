//
//  @Author : <#Author#>
//  @Desc   : <#Desc#>
//
//  XiaoMaBao
//
//  Created by 张磊 on 15/5/1.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "MBRegisterPhoneVerifyViewController.h"
#import "MBRegisterField.h"
#import "MBRegisterFieldRightViewButton.h"
#import "MBSettingPwdViewController.h"
#import "MBRegisterViewController.h"
#import "NSString+BQ.h"
#import "MobClick.h"
@interface MBRegisterPhoneVerifyViewController ()
@property (weak, nonatomic) IBOutlet MBRegisterField *verifyField;
@property (weak, nonatomic) IBOutlet UILabel *MBRegisterList;

- (IBAction)nextBtnClick;

@end

@implementation MBRegisterPhoneVerifyViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MBRegisterPhoneVerify"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MBRegisterPhoneVerify"];
}
- (void)setPhoneNumb:(NSString *)phoneNumb
{
    _phoneNumb = phoneNumb;
    self.MBRegisterList.text = [NSString stringWithFormat:@"请输入手机号%@收到的短信校验码",phoneNumb];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 输入验证码
    MBRegisterFieldRightViewButton *verifyFieldLeftView = [[MBRegisterFieldRightViewButton alloc] init];
    [verifyFieldLeftView setTitleColor:[UIColor colorWithHexString:@"b7bac1"] forState:UIControlStateNormal];
    [verifyFieldLeftView setTitle:@"校验码" forState:UIControlStateNormal];
    verifyFieldLeftView.frame = CGRectMake(0, 0, 60, 12);
    
    self.verifyField.leftView = verifyFieldLeftView;
    self.verifyField.leftViewMode = UITextFieldViewModeAlways;
    [self.verifyField becomeFirstResponder];
    self.verifyField.keyboardType =  UIKeyboardTypeNumberPad;
    // 拼接手机号码
    NSRange range = NSMakeRange(3, 4);
    NSString *newNumb = [_phoneNumb stringByReplacingCharactersInRange:range withString:@"****"];
    NSString *verifyStr = [NSString stringWithFormat:@"请输入手机号%@收到的短信校验码", newNumb];
    [self.MBRegisterList setText:verifyStr];
    
//    UILabel *msgLabel = [[UILabel alloc] init];
//    msgLabel.frame = CGRectMake(0, 0, 102, 12);
//    msgLabel.font = [UIFont systemFontOfSize:14];
//    msgLabel.text = @"38秒后重发";
//    msgLabel.backgroundColor = [UIColor clearColor];
//    
//    self.verifyField.rightView = msgLabel;
//    self.verifyField.rightViewMode = UITextFieldViewModeWhileEditing;
}

- (NSString *)titleStr{
    return @"填写验证码";
}

// 认证手机认证码
- (IBAction)nextBtnClick {
    
    
    
    if( self.verifyField.text !=nil && self.verifyField.text.length == 6){
        NSString *currentText = self.verifyField.text;
        NSString *encryptedMd5 = [currentText md5];
        
        
        if ([self.phoneVerifyCode isEqualToString:encryptedMd5]) {
        // 保存手机号
            MBUserDataSingalTon *user = [MBSignaltonTool getCurrentUserInfo];
            user.phoneNumber = self.phoneNumb;
            
            [self show:@"验证成功" time:1];
            [self performSegueWithIdentifier:@"pushMBSettingPwdViewController" sender:nil];
        }else{
            [self show:@"验证码有误,验证失败!" time:1];
            return;
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    
    
    if ([segue.identifier isEqualToString:@"pushMBSettingPwdViewController"]) {
        MBSettingPwdViewController *controller = segue.destinationViewController;
        controller.phoneCode = self.verifyField.text;
        
        
    }
}



@end
