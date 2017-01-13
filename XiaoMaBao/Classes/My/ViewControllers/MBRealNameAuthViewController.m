//
//  MBRealNameAuthViewController.m
//  XiaoMaBao
//
//  Created by 张磊 on 15/6/9.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "MBRealNameAuthViewController.h"
@interface MBRealNameAuthViewController ()
{
    UITextField *_name;
    UITextField *_id;
}
@end

@implementation MBRealNameAuthViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
  
    
    
    NSArray *titles = @[
                        @"真 实 姓 名：",
                        @"身份证号码："
                        ];
    
    for (NSInteger i = 0; i < titles.count; i++) {
        
        CGFloat height = 33;
        UIView *fieldView = [[UIView alloc] init];
        fieldView.frame = CGRectMake(0, TOP_Y + i * height, self.view.ml_width, height);
        [self.view addSubview:fieldView];
        
        UILabel *nameLbl = [[UILabel alloc] init];
        nameLbl.font = [UIFont systemFontOfSize:14];
        nameLbl.text = titles[i];
        nameLbl.frame = CGRectMake(MARGIN_8, 0, 90, height);
        [fieldView addSubview:nameLbl];
        
        UITextField *textField = [[UITextField alloc] init];
        textField.frame = CGRectMake(CGRectGetMaxX(nameLbl.frame), nameLbl.ml_y, self.view.ml_width - CGRectGetMaxX(nameLbl.frame), nameLbl.ml_height);
        textField.borderStyle = UITextBorderStyleNone;
       
        textField.font = [UIFont systemFontOfSize:14];
        [fieldView addSubview:textField];
        if (i==0) {
            _name =textField;
          textField.placeholder = @"请输入姓名";
        }else{
            _id = textField;
         textField.placeholder = @"请输入身份证号";
        }
        [self addBottomLineView:fieldView];
    }
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(35, CGRectGetMaxY([[[self.view subviews] lastObject] frame]) + 25, self.view.ml_width - 70, 35);
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    saveBtn.backgroundColor = [UIColor colorWithHexString:@"2ba390"];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    saveBtn.layer.cornerRadius = 17;
    [self.view addSubview:saveBtn];
    [saveBtn addTarget:self action:@selector(authentication) forControlEvents: UIControlEventTouchUpInside];
    UILabel *msgLbl = [[UILabel alloc] init];
    msgLbl.numberOfLines = 0;
    msgLbl.frame = CGRectMake(MARGIN_8, CGRectGetMaxY(saveBtn.frame) + MARGIN_10, self.view.ml_width - MARGIN_8, 30);
    msgLbl.textColor = [UIColor colorWithHexString:@"323232"];
    msgLbl.font = [UIFont systemFontOfSize:10];
    msgLbl.text = @"1、由于免税店、直邮商品需要办理入境申报，请您配合进行使实名认证\n2、小麻包承诺所传身份证明只用于直邮商品的清关手续，不作其他用途使用，其他任何人均无法查看";
    [self.view addSubview:msgLbl];
}

- (NSString *)titleStr{
    return @"实名认证";
}
- (void)authentication{
    [_id resignFirstResponder];
 
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSString *url = @"http://api.xiaomabao.com/mobile/?url=/user/realname";
    NSDictionary * params = @{};
     NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    params = @{@"real_name":_name.text, @"identity_card":_id.text,@"uid":uid,@"sid":sid,@"session":sessiondict};
       [self show];
    [MBNetworking POST:url parameters:params success:^(NSURLSessionDataTask *operation, MBModel *responseObject) {
                  
                   [self dismiss];
                   NSString *str = [responseObject valueForKeyPath:@"msg"];
                   if ([str isEqualToString:@"修改成功"]) {
                       [self show:str time:1];
                       [self.navigationController popViewControllerAnimated:YES];
                   }else{
                   
                      [self  show:str time:1];
                   
                   }
        
                
               } failure:^(NSURLSessionDataTask *operation, NSError *error) {
                   
                   
                   MMLog(@"%@",error);
                   
                   [self show:@"请求失败" time:1];
                   
               }
     ];
 
}

@end
