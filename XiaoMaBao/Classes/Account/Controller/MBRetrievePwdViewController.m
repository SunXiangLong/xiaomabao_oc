//
//  @Author : <#Author#>
//  @Desc   : <#Desc#>
//
//  XiaoMaBao
//
//  Created by 张磊 on 15/5/2.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "MBRetrievePwdViewController.h"
#import "MBRegisterFieldRightViewButton.h"
#import "MBRegisterField.h"
#import "PooCodeView.h"
#import "MBMessageCheckViewController.h"
@interface MBRetrievePwdViewController () <UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet MBRegisterField *accountField;
@property (weak, nonatomic) IBOutlet MBRegisterField *verifyField;
@property (weak, nonatomic) IBOutlet PooCodeView *codeView;
- (IBAction)nextStep;

@end

@implementation MBRetrievePwdViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 账户
    MBRegisterFieldRightViewButton *accountFieldLeftView = [[MBRegisterFieldRightViewButton alloc] init];
    accountFieldLeftView.frame = CGRectMake(0, 0, 55, 12);
    [accountFieldLeftView setImage:[UIImage imageNamed:@"icon_user"] forState:UIControlStateNormal];
    [accountFieldLeftView setTitle:@"账户" forState:UIControlStateNormal];
    _accountField.keyboardType = UIKeyboardTypeNumberPad;
    [_accountField becomeFirstResponder];
    self.accountField.leftView = accountFieldLeftView;
    self.accountField.leftViewMode = UITextFieldViewModeAlways;
    
    // 输入验证码
    MBRegisterFieldRightViewButton *verifyFieldLeftView = [[MBRegisterFieldRightViewButton alloc] init];
    verifyFieldLeftView.frame = CGRectMake(0, 0, 12, 12);
    self.verifyField.leftView = verifyFieldLeftView;
    self.verifyField.leftViewMode = UITextFieldViewModeAlways;
    self.verifyField.keyboardType = UIKeyboardTypeNamePhonePad;
}

- (NSString *)titleStr{
    return @"找回密码";
}

- (IBAction)nextStep {
    [self.accountField resignFirstResponder];
    [self.verifyField resignFirstResponder];
    NSString *changeString = self.codeView.changeString;
    NSString *verifyString = self.verifyField.text;
    NSString *accountString = self.accountField.text;
    if ([self checkTel:accountString]) {
    
        if ([changeString caseInsensitiveCompare:verifyString] == NSOrderedSame) {
        [self phoneVerification];
        }else {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"验证码错误，请重试！" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}

- (void)phoneVerification
{
    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/users/checkuser"];
    NSString *userText = self.accountField.text;
    [self show];
    [MBNetworking POST:url parameters:@{@"name":userText,@"type":@"1"} success:^(NSURLSessionDataTask *asdf, MBModel *responseObject) {
        
        NSDictionary *status = responseObject.status;
        
        
        if ([[status valueForKey:@"succeed"] integerValue]) {
      
            [self getsss:userText];
        }else{
            [self dismiss];
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[status valueForKey:@"error_desc"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    } failure:^(NSURLSessionDataTask *asdfg, NSError *error) {
        NSLog(@"%@",error);
        [self show:@"请求失败！" time:1];
    }];
    
   }
- (void)getsss:(NSString *)userText{
    NSString *url2 = [NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/users/phoneCode"];
    [MBNetworking POST:url2 parameters:@{@"name":userText,@"type":@"1"} success:^(NSURLSessionDataTask *asd, MBModel *responseObject) {
        [self dismiss];
        NSLog(@"%@",responseObject.data);
        self.phoneCodeMd5 = [responseObject.data valueForKey:@"phoneCode"];
        if ([responseObject.status[@"succeed"] integerValue] == 1) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message: [NSString stringWithFormat:@"已发短信至手机号:%@请注意查收", self.accountField.text] delegate:self cancelButtonTitle:@"下一步" otherButtonTitles:nil, nil];
            alert.tag = 1010;
            MBUserDataSingalTon *user = [MBSignaltonTool getCurrentUserInfo];
            user.phoneNumber = userText;
            [alert show];
        }else{
        
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message: responseObject.data[@"info"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        
        
    } failure:^(NSURLSessionDataTask *asdf, NSError *asdfg) {
      [self dismiss];
        
    }];


}
- (BOOL)checkTel:(NSString *)str
{
    if ([str length] == 0) {
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"请输入手机号码", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    
    return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1010) {
        [self performSegueWithIdentifier:@"PushMBMessageCheckViewController" sender:nil];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"PushMBMessageCheckViewController"]) {
        MBMessageCheckViewController *controller = segue.destinationViewController;
        controller.phoneNumber = self.accountField.text;
        controller.phoneMd5 = self.phoneCodeMd5;
        NSLog(@"%@",self.phoneCodeMd5);
    }
}

@end
