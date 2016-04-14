//
//  MBRegisterViewController.m
//  XiaoMaBao
//
//  Created by 张磊 on 15/4/30.
//  Copyright (c) 2015年 com.xiaomabao.www. All rights reserved.
//

#import "MBRegisterViewController.h"
#import "MBRegisterTabButton.h"
#import "MBRegisterPhoneVerifyViewController.h"
#import "MBEmailRegisterView.h"
#import "MBRegisterFieldRightViewButton.h"
#import "MBRegisterField.h"
#import <PureLayout.h>
#import "MBSignaltonTool.h"
#import "MBNetworking.h"
#import "MobClick.h"
#import "MBServiceProvisionViewController.h"
@interface MBRegisterViewController () <UIAlertViewDelegate,MBEmailRegisterViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *photoRegisterView;
@property (weak,nonatomic) MBEmailRegisterView *emailRegisterView;
@property (weak,nonatomic) MBRegisterTabButton *phoneBtn;
@property (weak,nonatomic) MBRegisterTabButton *emailBtn;
- (IBAction)nextBtnClick;
@property (weak, nonatomic) IBOutlet MBRegisterField *countryField;
@property (weak, nonatomic) IBOutlet MBRegisterField *PhoneField;
@property (weak, nonatomic) IBOutlet UIButton *agreeButton;

@property (strong, nonatomic) UIButton *checkBoxBtn;

@end

@implementation MBRegisterViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MBRegister"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MBRegister"];
}
- (MBEmailRegisterView *)emailRegisterView{
    if (!_emailRegisterView) {
        MBEmailRegisterView *emailRegisterView = [MBEmailRegisterView instanceXibView];
        emailRegisterView.delegate = self;
        emailRegisterView.frame = self.photoRegisterView.frame;
        emailRegisterView.hidden = YES;
        [self.view addSubview:emailRegisterView];
        _emailRegisterView = emailRegisterView;
    }
    return _emailRegisterView;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 国家地区/手机号
    MBRegisterFieldRightViewButton *accountFieldLeftView = [[MBRegisterFieldRightViewButton alloc] init];
    MBRegisterFieldRightViewButton *pwdFieldLeftView = [[MBRegisterFieldRightViewButton alloc] init];
    
    accountFieldLeftView.frame = CGRectMake(0, 0, 75, 12);
    pwdFieldLeftView.frame = CGRectMake(0, 0, 75, 12);
    
    [accountFieldLeftView setImage:[UIImage imageNamed:@"icon_world"] forState:UIControlStateNormal];
    [pwdFieldLeftView setImage:[UIImage imageNamed:@"icon_phone"] forState:UIControlStateNormal];
    
    [accountFieldLeftView setTitle:@"国家地区" forState:UIControlStateNormal];
    [pwdFieldLeftView setTitle:@"手机号" forState:UIControlStateNormal];
    
    self.countryField.leftView = accountFieldLeftView;
    self.countryField.leftViewMode = UITextFieldViewModeAlways;
    
    UIButton *pushCountryCityButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [pushCountryCityButton addTarget:self action:@selector(pushCountryCityVc) forControlEvents:UIControlEventTouchUpInside];
    pushCountryCityButton.backgroundColor = [UIColor clearColor];
    pushCountryCityButton.frame = self.countryField.bounds;
    [self.countryField addSubview:pushCountryCityButton];
 
    self.PhoneField.leftView = pwdFieldLeftView;
    self.PhoneField.leftViewMode = UITextFieldViewModeAlways;
    [self.PhoneField becomeFirstResponder];
    self.PhoneField.keyboardType = UIKeyboardTypeNumberPad;
    [self.agreeButton removeFromSuperview];
    
    
    _checkBoxBtn = [[UIButton alloc] init];
    _checkBoxBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    _checkBoxBtn.frame = CGRectMake(15, 170,25, 25);
    [_checkBoxBtn setImage:[UIImage imageNamed:@"pitch_no"] forState:UIControlStateNormal];
    [_checkBoxBtn setImage:[UIImage imageNamed:@"pitch_on.png"] forState:UIControlStateSelected];
    [_checkBoxBtn addTarget:self action:@selector(checkboxClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_checkBoxBtn];
    _checkBoxBtn.selected = YES;
    
    UILabel *_totalLbl = [[UILabel alloc] init];
    _totalLbl.font = [UIFont systemFontOfSize:12];
    _totalLbl.frame = CGRectMake(40, 170,30,25);

    _totalLbl.text = @"同意";
    [self.view addSubview:_totalLbl];
    
    UILabel *_totalLbl2 = [[UILabel alloc] init];
    _totalLbl2.font = [UIFont systemFontOfSize:12];
    _totalLbl2.frame = CGRectMake(30 + _totalLbl.ml_width, 170, self.view.ml_width-40-_totalLbl.ml_width,25);
    _totalLbl2.textColor = [UIColor redColor];
    _totalLbl2.text = @"《小麻包注册协议》";
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(30 + _totalLbl.ml_width, 170, self.view.ml_width-40-_totalLbl.ml_width,25)];
    [button addTarget:self action:@selector(xieyi) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:_totalLbl2];
    [self.view addSubview:button];
    
}

-(void)checkboxClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
}
-(void)xieyi{
    MBServiceProvisionViewController *evaluateVc = [[MBServiceProvisionViewController alloc] init];
    [self.navigationController pushViewController:evaluateVc animated:YES];


}

- (IBAction)pushCountryCityVc{
//    [self performSegueWithIdentifier:@"pushMBCountryCityViewController" sender:nil];
}

- (void)photoBtnClick:(MBRegisterTabButton *)btn{
    self.emailBtn.selectedStatus = NO;
    self.photoRegisterView.hidden = NO;
    self.emailRegisterView.hidden = YES;
    btn.selectedStatus = YES;
}

- (void)emailBtnClick:(MBRegisterTabButton *)btn{
    self.phoneBtn.selectedStatus = NO;
    self.photoRegisterView.hidden = YES;
    self.emailRegisterView.hidden = NO;
    btn.selectedStatus = YES;
}

- (NSString *)titleStr{
    return @"注册";
}

- (void)registerEmailNextDone:(MBEmailRegisterView *)emailRegisterView{
    [self performSegueWithIdentifier:@"pushMBRegisterEmailDoneViewController" sender:nil];
}

/**
 *  注册下一步
 */
- (IBAction)nextBtnClick {
    [self.PhoneField resignFirstResponder];
    NSString *phoneText = self.PhoneField.text;
    [self checkTel:phoneText];
}

- (BOOL)checkTel:(NSString *)str
{
    if(!_checkBoxBtn.selected){
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"请同意小麻包注册协议！", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    
    if ([str length] == 0) {
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"请输入手机号码！", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    
    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,3-9]))\\d{8}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:str];
    
    if (!isMatch) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的手机号码" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    
    NSString *postUrl = [NSString stringWithFormat:@"%@%@",BASE_URL,@"user/valid"];
    
    
    [self show];
    [MBNetworking POST:postUrl parameters:@{@"name":str,@"type":@"1"} success:^(AFHTTPRequestOperation *asdf, MBModel *responseObject) {
        [self dismiss];
        NSDictionary * status = responseObject.status;
        
        
        if([status[@"succeed"] isEqualToNumber:@1]){
            
            NSDictionary * data = responseObject.data;
            self.md5Encryption = data[@"phoneCode"];
            
            NSLog(@"%@",self.md5Encryption);
            
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确认验证码" message:[NSString stringWithFormat:@"我们已向您的手机：%@ 发送了验证码，请查收",self.PhoneField.text] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"下一步", nil];
            alertView.delegate = self;
            
            [alertView show];
        }else{
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:status[@"error_desc"] delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    } failure:^(AFHTTPRequestOperation *asdfg, NSError *asdfgh) {
        [self dismiss];
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请求失败，请重试" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
    }];
    
    return YES;
}


#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        
        // 认证手机号是否已登录
        NSString *registNumber = [MBSignaltonTool getCurrentUserInfo].uid;
        if([self.PhoneField.text isEqualToString:registNumber])
            return [self show:@"此号码已经登录" time:1 ];
        
//         //跳转短信验证控制器
//        NSString *phoneNumber = self.PhoneField.text;
//        NSString *phoneRegex = @"^(0|86|17951)?(13[0-9]|15[012356789]|17[6789]|18[0-9]|14[57])[0-9]{8}$";  
//        NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
//        BOOL matches = [test evaluateWithObject:phoneNumber];
//        if (matches) {
//            [KVNProgress showWithStatus:@"正在验证..."];
//            [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL,@"/user/phoneCode"] parameters:@{@"name":phoneNumber, @"type":@"1",@"requesttype":@"100"} success:^(AFHTTPRequestOperation *operation, MBModel *responseObject) {
//                [KVNProgress dismiss];
//                
//                self.md5Encryption = [responseObject.data valueForKey:@"phoneCode"];
//                [self performSegueWithIdentifier:@"pushMBRegisterPhoneVerifyViewController" sender:nil];
//            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                [KVNProgress showErrorWithStatus:@"验证失败"];
//            }];
//        }
        
        [self performSegueWithIdentifier:@"pushMBRegisterPhoneVerifyViewController" sender:nil];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    MBRegisterPhoneVerifyViewController *controller = segue.destinationViewController;
    controller.phoneVerifyCode = self.md5Encryption;
    controller.phoneNumb = self.PhoneField.text;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [_PhoneField resignFirstResponder];
}
@end
