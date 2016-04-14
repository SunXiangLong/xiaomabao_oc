//
//  ValidationView.m
//  XiaoMaBao
//
//  Created by liulianqi on 15/12/16.
//  Copyright © 2015年 HuiBei. All rights reserved.
//

#import "ValidationView.h"
#import "MBRegisterFieldRightViewButton.h"
@implementation ValidationView

+ (instancetype)instanceXibView{
    
    return [[[NSBundle mainBundle]loadNibNamed:@"validationView" owner:nil options:nil] firstObject];
}

- (void)awakeFromNib{
    // 账号/密码
    MBRegisterFieldRightViewButton *accountFieldLeftView = [[MBRegisterFieldRightViewButton alloc] init];
    MBRegisterFieldRightViewButton *pwdFieldLeftView = [[MBRegisterFieldRightViewButton alloc] init];
    
    accountFieldLeftView.frame = CGRectMake(0, 0, 75, 12);
    pwdFieldLeftView.frame = CGRectMake(0, 0, 75, 12);
    
    self.verifcation.leftView = pwdFieldLeftView;
    self.verifcation.leftViewMode = UITextFieldViewModeAlways;
    
    self.photo.leftView = accountFieldLeftView;
    self.photo.leftViewMode = UITextFieldViewModeAlways;
    
  
    [accountFieldLeftView setImage:[UIImage imageNamed:@"icon_user"] forState:UIControlStateNormal];
    [pwdFieldLeftView setImage:[UIImage imageNamed:@"icon_lock"] forState:UIControlStateNormal];
    
    [accountFieldLeftView setTitle:@"手机" forState:UIControlStateNormal];
    [pwdFieldLeftView setTitle:@"验证码" forState:UIControlStateNormal];



}
@end
