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
@interface MBRegisterPhoneVerifyViewController ()
@property (weak, nonatomic) IBOutlet MBRegisterField *verifyField;
@property (weak, nonatomic) IBOutlet UILabel *MBRegisterList;

- (IBAction)nextBtnClick;

@end

@implementation MBRegisterPhoneVerifyViewController

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
    if ([_phoneNumb isValidPhone]) {
        NSRange range = NSMakeRange(3, 4);
        NSString *newNumb = [_phoneNumb stringByReplacingCharactersInRange:range withString:@"****"];
        NSString *verifyStr = [NSString stringWithFormat:@"请输入手机号%@收到的短信校验码", newNumb];
        [self.MBRegisterList setText:verifyStr];
    }
    
    
    
}

- (NSString *)titleStr{
    return @"填写验证码";
}

// 认证手机认证码
- (IBAction)nextBtnClick {
   
    
    if( self.verifyField.text !=nil && self.verifyField.text.length == 6){
        
        [self performSegueWithIdentifier:@"MBSettingPwdViewController" sender:nil];
        
        
    }else{
        [self show:@"验证码有误,验证失败!" time:1];
        
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    
    
    if ([segue.identifier isEqualToString:@"MBSettingPwdViewController"]) {
        MBSettingPwdViewController *controller = segue.destinationViewController;
        controller.phoneCode = self.verifyField.text;
        controller.phone = self.phoneNumb;
        controller.isRegistered = self.isRegistered;
       
        
        
    }
}



@end
