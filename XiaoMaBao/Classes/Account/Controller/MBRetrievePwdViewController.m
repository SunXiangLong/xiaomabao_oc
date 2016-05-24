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
#import "MBNetworking.h"
#import "MBMessageCheckViewController.h"
#import "NSString+BQ.h"
#import "MobClick.h"
@interface MBRetrievePwdViewController () <UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet MBRegisterField *accountField;
@property (weak, nonatomic) IBOutlet MBRegisterField *verifyField;
@property (weak, nonatomic) IBOutlet PooCodeView *codeView;
- (IBAction)nextStep;

@end

@implementation MBRetrievePwdViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MBRetrievePwdViewController"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MBRetrievePwdViewController"];
}
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

    NSString *changeString = self.codeView.changeString;
    NSString *verifyString = self.verifyField.text;
    NSString *accountString = self.accountField.text;
    NSLog(@"%@",accountString);
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
    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,@"/user/signed"];
    NSString *userText = self.accountField.text;
    [self show];
    [MBNetworking POST:url parameters:@{@"name":userText,@"type":@"1"} success:^(NSURLSessionDataTask *asdf, MBModel *responseObject) {
        [self dismiss];
        NSDictionary *status = responseObject.status;
        
        
        if ([[status valueForKey:@"succeed"] integerValue]) {
      
            [self getsss:userText];
        }else{
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"亲，您的手机号码还未注册" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    } failure:^(NSURLSessionDataTask *asdfg, NSError *asdfgh) {
                 [self show:@"请求失败！" time:1];
    }];
    
   }
- (void)getsss:(NSString *)userText{
    NSString *url2 = [NSString stringWithFormat:@"%@%@",BASE_URL,@"/user/phoneCode"];
    [MBNetworking POST:url2 parameters:@{@"name":userText,@"type":@"1"} success:^(NSURLSessionDataTask *asd, MBModel *responseObject) {
        NSLog(@"---------%@-----------",responseObject.data);
        self.phoneCodeMd5 = [responseObject.data valueForKey:@"phoneCode"];
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message: [NSString stringWithFormat:@"已发短信至手机号:%@请注意查收", self.accountField.text] delegate:self cancelButtonTitle:@"下一步" otherButtonTitles:nil, nil];
        alert.tag = 1010;
        MBUserDataSingalTon *user = [MBSignaltonTool getCurrentUserInfo];
        user.phoneNumber = userText;
        [alert show];
        
    } failure:^(NSURLSessionDataTask *asdf, NSError *asdfg) {
        NSLog(@"%@",asdfg);
    }];


}
- (BOOL)checkTel:(NSString *)str
{
    if ([str length] == 0) {
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"请输入手机号码", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    
    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:str];
    
    if (!isMatch) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输正确的手机号码" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
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
