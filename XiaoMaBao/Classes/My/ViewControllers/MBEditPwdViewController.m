//
//  MBEditPwdViewController.m
//  XiaoMaBao
//
//  Created by 张磊 on 15/6/8.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "MBEditPwdViewController.h"
#import "MBNetworking.h"
#import "MBSignaltonTool.h"
#import "NSString+BQ.h"
#import "MobClick.h"
#import "SFHFKeychainUtils.h"
@interface MBEditPwdViewController ()
@property (weak,nonatomic) UITextField *oldFld;
@property (weak,nonatomic) UITextField *pwd1;
@property (weak,nonatomic) UITextField *pwd2;
@end

@implementation MBEditPwdViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MBEditPwdViewController"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MBEditPwdViewController"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    NSArray *titles = @[
                        @"旧   密   码：",
                        @"新   密   码：",
                        @"新密码确认："
                        ];
    
    for (NSInteger i = 0; i < titles.count; i++) {
        
        CGFloat height = 33;
        UIView *fieldView = [[UIView alloc] init];
        fieldView.frame = CGRectMake(0, TOP_Y + i * height, self.view.ml_width, height);
        [self.view addSubview:fieldView];
        
        UILabel *nameLbl = [[UILabel alloc] init];
        nameLbl.font = [UIFont systemFontOfSize:14];
        nameLbl.text = titles[i];
        nameLbl.frame = CGRectMake(MARGIN_8, 0, 85, height);
        [fieldView addSubview:nameLbl];
        
        UITextField *textField = [[UITextField alloc] init];
        textField.frame = CGRectMake(CGRectGetMaxX(nameLbl.frame), nameLbl.ml_y, self.view.ml_width - CGRectGetMaxX(nameLbl.frame), nameLbl.ml_height);
        textField.borderStyle = UITextBorderStyleNone;
        textField.placeholder = @"请输入密码";
        textField.font = [UIFont systemFontOfSize:14];
        [fieldView addSubview:textField];
        [textField setSecureTextEntry:YES];
        
        if (i == 0) {
            _oldFld = textField;
        }else if (i == 1){
            _pwd1 = textField;
        }else if (i == 2){
            _pwd2 = textField;
        }
        
        [self addBottomLineView:fieldView];
    }
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(35, CGRectGetMaxY([[[self.view subviews] lastObject] frame]) + 25, self.view.ml_width - 70, 35);
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    saveBtn.backgroundColor = [UIColor colorWithHexString:@"2ba390"];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    saveBtn.layer.cornerRadius = 17;
    [saveBtn addTarget:self action:@selector(editPwd) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];
}

- (void)editPwd{
    if ([self.oldFld.text length] == 0 || [self.pwd2.text length] == 0) {
        
        [self show:@"密码不能为空！" time:1];
        return;
    }

    if (![self.pwd1.text isEqualToString:self.pwd2.text]){
        [self show:@"两次密码不一致" time:1];
        return;
    }
    [self.pwd2 resignFirstResponder];
    [self.pwd1 resignFirstResponder];
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    [self show];
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/users/modpassword"]
        parameters:@{@"session":sessiondict,@"old_password":[self.oldFld.text md5],@"new_password":[self.pwd1.text md5]}
        success:^(NSURLSessionDataTask *operation, MBModel *responseObject) {
            NSDictionary * status_dict = [responseObject valueForKey:@"status"];
            NSLog(@"success:%@",status_dict);
            [self dismiss];
            if([[status_dict valueForKeyPath:@"succeed"] isEqualToNumber:@0]){
                [self show:[status_dict valueForKeyPath:@"error_desc"] time:1];
            }else{
                [self show:@"修改密码成功" time:1];
                
                [self SavePassword:_pwd2.text];
                //退出并跳转到登录页
                
                MBUserDataSingalTon *user = [MBSignaltonTool getCurrentUserInfo];
                [user clearUserInfo];
                
                //获取storyboard: 通过bundle根据storyboard的名字来获取我们的storyboard,
                UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                //由storyboard根据myView的storyBoardID来获取我们要切换的视图
                UIViewController *myView = [story instantiateViewControllerWithIdentifier:@"MBLoginViewController"];
                //由navigationController推向我们要推向的view
                [self.navigationController pushViewController:myView animated:YES];
            }
            
            
        }failure:^(NSURLSessionDataTask *operation, NSError *error) {
            [self show:@"请求失败" time:1];
        }];

}

- (NSString *)titleStr{
    return @"修改密码";
}

#pragma mark --   保存密码账号到本地
- (void )SavePassword:(NSString *)password{
    NSError *errors;
    
    BOOL pass = [SFHFKeychainUtils storeUsername:@"Password" andPassword:password forServiceName:@"com.xiaomabao.Password" updateExisting:YES error:&errors];
    
    if (!pass) {
        NSLog(@"❌Keychain保存密码时出错：%@",errors);
    }else{
        NSLog(@"✅Keychain保存密码成功！");
    }
    
}
@end
