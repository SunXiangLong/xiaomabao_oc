//
//  @Author : <#Author#>
//  @Desc   : <#Desc#>
//
//  xiaomabao
//
//  Created by 张磊 on 15/4/26.
//  Copyright (c) 2015年 com.xiaomabao.www. All rights reserved.
//

#import "MBLoginViewController.h"
#import "MBLoginShareButton.h"
#import "MBRegisterFieldRightViewButton.h"
#import "NSString+BQ.h"
#import "MBSignaltonTool.h"
#import "AFNetworking.h"
#import "MBNetworking.h"
#import <ShareSDK/ShareSDK.h>
#import "MobClick.h"
#import "SFHFKeychainUtils.h"
#import "WXApi.h"
#import "ValidationView.h"
#import "MBLogOperation.h"
@interface MBLoginViewController ()
{
    ValidationView     *_view;
    UIView *_view1;
}
// 底部分享View
@property (weak,nonatomic) UIView *bottomShareView;
// IB
@property (weak, nonatomic) IBOutlet UITextField *accountField;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (nonatomic,copy) NSString *md5Encryption;
@end

@implementation MBLoginViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MBLogin"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MBLogin"];
}
- (UIView *)bottomShareView{
    if (!_bottomShareView) {
        UIView *bottomShareView = [[UIView alloc] init];
        bottomShareView.frame = CGRectMake(0, self.view.frame.size.height - 44, self.view.frame.size.width, 46);
        [self.view addSubview:bottomShareView];
        self.bottomShareView = bottomShareView;
        
        UIView *topView = [[UIView alloc] init];
        topView.frame = CGRectMake(0, 0, bottomShareView.ml_width, PX_ONE * 2);
        topView.backgroundColor = [UIColor colorWithHexString:@"d7d7d7"];
        [bottomShareView addSubview:topView];
    }
    return _bottomShareView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    // 账号/密码
    MBRegisterFieldRightViewButton *accountFieldLeftView = [[MBRegisterFieldRightViewButton alloc] init];
    MBRegisterFieldRightViewButton *pwdFieldLeftView = [[MBRegisterFieldRightViewButton alloc] init];
    
    accountFieldLeftView.frame = CGRectMake(0, 0, 75, 12);
    pwdFieldLeftView.frame = CGRectMake(0, 0, 75, 12);
    
    self.pwdField.leftView = pwdFieldLeftView;
    self.pwdField.leftViewMode = UITextFieldViewModeAlways;
    
    self.accountField.leftView = accountFieldLeftView;
    self.accountField.leftViewMode = UITextFieldViewModeAlways;
    [self.accountField becomeFirstResponder];
    self.accountField.text = @"";
    self.pwdField.text = @"";
    
    
    UIButton * btn = [[UIButton alloc] init];
    btn.frame = CGRectMake(self.view.ml_width-65, CGRectGetMaxY(self.pwdField.frame)+12, 60, 30);
    [btn setImage:[UIImage imageNamed:@"button_off"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"button_on.png"] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    btn.contentEdgeInsets = UIEdgeInsetsMake(0, 9, 0, 0);
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [self.view addSubview:btn];
    
    [accountFieldLeftView setImage:[UIImage imageNamed:@"icon_user"] forState:UIControlStateNormal];
    [pwdFieldLeftView setImage:[UIImage imageNamed:@"icon_lock"] forState:UIControlStateNormal];
    
    [accountFieldLeftView setTitle:@"账户" forState:UIControlStateNormal];
    [pwdFieldLeftView setTitle:@"登录密码" forState:UIControlStateNormal];
    
   
}

-(void)btnClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
    //密码是否显示
    if(btn.selected){
        self.pwdField.secureTextEntry = NO;
    }else{
        self.pwdField.secureTextEntry = YES;
    }
}

- (NSString *)titleStr{
    return @"登录";
}

- (void)initView{
    // 分享按钮Item
    [self setupShareItems];
}

- (void)setupShareItems{
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi])
    {
        [self setupItemTitle:@"微信登录" icon:@"icon_weixin" selector:@selector(weixinLogin) showLine:YES];
    }
    
    [self setupItemTitle:@"QQ登录" icon:@"icon_qq" selector:@selector(qqLogin) showLine:YES];
    [self setupItemTitle:@"微博登录" icon:@"icon_weibo" selector:@selector(sinaLogin) showLine:NO];
}

- (void)setupItemTitle:(NSString *)title icon:(NSString *)icon selector:(SEL)selector showLine:(BOOL)showLine{
    CGFloat width = self.view.frame.size.width / 3;
    MBLoginShareButton *shareButton = [MBLoginShareButton buttonWithType:UIButtonTypeCustom];
    shareButton.showLine = showLine;
    [shareButton addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [shareButton setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    shareButton.frame = CGRectMake((self.bottomShareView.subviews.count - 1) * width, 8, width, self.bottomShareView.ml_height - 16);
    [shareButton setTitle:title forState:UIControlStateNormal];
    [self.bottomShareView addSubview:shareButton];
}

- (IBAction)login {
    
    // 排除重复登录
    NSString *loginUser = [MBSignaltonTool getCurrentUserInfo].uid;
    if(self.accountField.text == loginUser) return [ self show:@"当前用户已经登录" time:1];
    [self   show];
    [self login:@{@"name":self.accountField.text, @"password":self.pwdField.text}];
    
    
}

- (void)sinaLogin{
    [self show:@"正在验证..."];
    [ShareSDK getUserInfo:SSDKPlatformTypeSinaWeibo conditional:nil
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
               [self thirdLogin:state user:user sign_type:@"weibo"];
               
           }
     ];
    
}

-(void)weixinLogin{
    [self show:@"正在验证..."];
    [ShareSDK getUserInfo:SSDKPlatformTypeWechat conditional:nil
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
               [self thirdLogin:state user:user sign_type:@"wechat"];
           }];
}

-(void)qqLogin{
    [self show:@"正在验证..."];
    [ShareSDK getUserInfo:SSDKPlatformTypeQQ conditional:nil
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
               
               
               NSLog(@"%lu",(unsigned long)state);
               
               
               [self thirdLogin:state user:user sign_type:@"qq"];
           }];
}

-(void)thirdLogin:(SSDKResponseState) state user:(SSDKUser *)user sign_type:(NSString *)sign_type{
    if(state == SSDKResponseStateSuccess){
        NSString * name = user.uid;
        NSString * header_img = user.icon;
        NSString * nick_name = user.nickname;
        if (name&&header_img&&nick_name) {
            [self login:@{@"sign_type":sign_type, @"name":name,@"header_img":header_img,@"nick_name":nick_name}];

        }else{
            [self show:@"请求失败！" time:1];
        }
        
    }else{
        
        [self dismiss];
    }
}

-(void)login:(NSDictionary *)params{
    
    [self.pwdField resignFirstResponder];
    [MBLogOperation loginAuthentication:params success:^{
        [self dismiss];
        
        if ([self.vcType isEqualToString:@"shop"]) {
            
            
            [self.navigationController popViewControllerAnimated:YES];
            
            
            
        }else if ([self.vcType isEqualToString:@"mabao"]){
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }else {
            UIViewController *mainVc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
            [UIApplication sharedApplication].keyWindow.rootViewController = mainVc;
        }
        
    
        
    } failure:^(NSString *error_desc, NSError *error) {
        if (error_desc) {
            if ([error_desc isEqualToString:@"登录成功,请验证手机"]) {
                [self EmailAddressVerification];
            }else{
                
                
                [self show:error_desc time:1];
            }
            
        }else{
            
            NSLog(@"%@",error);
            
            [self show:@"请求失败" time:1];
        }
    }];
    
    
}
#pragma mark --邮箱手机号验证
-(void)EmailAddressVerification{
    
    [self ListeningKeyboard];
    UIView* baseline = [[UIView alloc] initWithFrame:CGRectMake(0, TOP_Y, UISCREEN_WIDTH, UISCREEN_HEIGHT-TOP_Y )];
    baseline.backgroundColor = [UIColor blackColor];
    baseline.alpha = 0.5 ;
    [self.view addSubview: _view1 = baseline];
    _view=[ValidationView instanceXibView];
    _view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_view];
    _view.frame =CGRectMake(0, 0, UISCREEN_WIDTH-2*30, 275);
    _view.center = self.view.center;
    
    [_view.code addTarget:self action:@selector(getMessageAuthenticationCode) forControlEvents:UIControlEventTouchUpInside];
    [_view.submit addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    
    [_view.cancel addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
}

-(void)getMessageAuthenticationCode{
    
    
    BOOL isMatch = [_view.photo.text isValidPhone];
    
    if (!isMatch) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输正确的手机号码" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    
    
    NSString *postUrl = [NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/users/phonecode"];
    
    
    [self show];
    [MBNetworking POST:postUrl parameters:@{@"name":_view.photo.text,@"type":@"1"} success:^(NSURLSessionDataTask *asdf, MBModel *responseObject) {
        [self dismiss];
        
        
        
        NSDictionary * status = responseObject.status;
        
        
        if([status[@"succeed"] isEqualToNumber:@1]){
            
            NSDictionary * data = responseObject.data;
            self.md5Encryption = data[@"phoneCode"];
            
            NSLog(@"%@",self.md5Encryption);
            
            
        }else{
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:status[@"error_desc"] delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    } failure:^(NSURLSessionDataTask *asdfg, NSError *asdfgh) {
        [self dismiss];
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请求失败，请重试" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
    }];
    
    
}
- (void)submit{
    
    
    if (_view.verifcation.text<0) {
        [self show:@"请输入短信验证码" time:1];
        return;
    }
    
    if (![[_view.verifcation.text md5]isEqualToString:self.md5Encryption]) {
        [self show:@"请输入正确的短信验证码" time:1];
        return;
    }
    [self show];
    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/users/signup"];
    [MBNetworking POST:url parameters:@{@"phoneCode":[_view.verifcation.text md5],@"name":_view.photo.text,@"password":[self.pwdField.text md5],@"email":self.accountField.text,@"type":@"1"} success:^(NSURLSessionDataTask *operation, MBModel *responseObject) {
        
        [self dismiss];
        
        if ([responseObject.status[@"succeed"] isEqualToNumber:@1]) {
            [self  show:@"验证成功，正在登陆" time:1];
            [self cancel];
            [self login];
        }else{
            [self show:responseObject.status[@"error_desc"] time:1];
            
        }
        
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
        
        [self show:@"请求失败，请重试" time:1];
        NSLog(@"%@",error);
        
        
    }];
    
    
}
- (void)cancel{
    
    [_view removeFromSuperview];
    [_view1 removeFromSuperview ];
}
#pragma mark --注册监听键盘的通知
- (void)ListeningKeyboard{
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    
}
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    if (height ==0) {
        return;
    }
    
    CGRect rect = _view.frame;
    rect.origin.y = UISCREEN_HEIGHT-height-275;
    [UIView animateWithDuration:.2f animations:^{
        _view.frame = rect;
    }];
}
//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    [UIView animateWithDuration:.5f animations:^{
        _view.frame = CGRectMake(0, 0, UISCREEN_WIDTH-2*30, 275);
        _view.center = self.view.center;
    }];
}




-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_accountField resignFirstResponder];
    [_pwdField resignFirstResponder];
}
-(NSString *)rightStr{
    
    if ([self.vcType isEqualToString:@"mabao"]) {
        return @"取消";
    }
    
    return @"";
}
-(void)rightTitleClick{
    
    
    if ([self.vcType isEqualToString:@"mabao"]) {
        [_accountField resignFirstResponder];
        [_pwdField resignFirstResponder];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}
@end
