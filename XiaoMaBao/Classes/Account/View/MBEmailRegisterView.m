//
//  MBEmailRegisterView.m
//  XiaoMaBao
//
//  Created by 张磊 on 15/5/2.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "MBEmailRegisterView.h"
#import "MBRegisterField.h"
#import "MBRegisterFieldRightViewButton.h"
#import "MBRegisterEmailDoneViewController.h"

@interface MBEmailRegisterView ()
@property (weak, nonatomic) IBOutlet MBRegisterField *accountField;
@property (weak, nonatomic) IBOutlet MBRegisterField *emailField;
@property (weak, nonatomic) IBOutlet MBRegisterField *pwdField;
@property (weak, nonatomic) IBOutlet MBRegisterField *pwd2Field;
@property (weak, nonatomic) IBOutlet UIButton *agreeButton;

@end

@implementation MBEmailRegisterView

+ (instancetype)instanceXibView{
    return [[[UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil] instantiateWithOwner:nil options:nil] lastObject];
}

- (void)awakeFromNib{
    [super awakeFromNib];
    CGRect leftViewRect     = CGRectMake(0, 0, 75, 12);
    MBRegisterFieldRightViewButton *accountLeftView = [MBRegisterFieldRightViewButton buttonWithType:UIButtonTypeCustom];
    accountLeftView.frame   = leftViewRect;
    [accountLeftView setTitle:@"用户名" forState:UIControlStateNormal];
    [accountLeftView setImage:[UIImage imageNamed:@"icon_user"] forState:UIControlStateNormal];
    
    MBRegisterFieldRightViewButton *emailLeftView = [MBRegisterFieldRightViewButton buttonWithType:UIButtonTypeCustom];
    emailLeftView.frame     = leftViewRect;
    [emailLeftView setTitle:@"邮箱" forState:UIControlStateNormal];
    [emailLeftView setImage:[UIImage imageNamed:@"icon_mail"] forState:UIControlStateNormal];
    
    MBRegisterFieldRightViewButton *pwdLeftView   = [MBRegisterFieldRightViewButton buttonWithType:UIButtonTypeCustom];
    pwdLeftView.frame       = leftViewRect;
    [pwdLeftView setTitle:@"设置密码" forState:UIControlStateNormal];
    [pwdLeftView setImage:[UIImage imageNamed:@"icon_lock"] forState:UIControlStateNormal];
    
    MBRegisterFieldRightViewButton *pwd2LeftView = [MBRegisterFieldRightViewButton buttonWithType:UIButtonTypeCustom];
    pwd2LeftView.frame      = leftViewRect;
    [pwd2LeftView setTitle:@"确认密码" forState:UIControlStateNormal];
    [pwd2LeftView setImage:[UIImage imageNamed:@"icon_locked"] forState:UIControlStateNormal];
    
    self.accountField.leftView = accountLeftView;
    self.accountField.leftViewMode = UITextFieldViewModeAlways;
    self.emailField.leftView = emailLeftView;
    self.emailField.leftViewMode = UITextFieldViewModeAlways;
    self.pwdField.leftView = pwdLeftView;
    self.pwdField.leftViewMode = UITextFieldViewModeAlways;
    self.pwd2Field.leftView = pwd2LeftView;
    self.pwd2Field.leftViewMode = UITextFieldViewModeAlways;
    
    self.agreeButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.agreeButton setImage:[UIImage imageNamed:@"icon_true"] forState:UIControlStateNormal];
}

- (IBAction)next {
    if ([self.delegate respondsToSelector:@selector(registerEmailNextDone:)]) {
        [self.delegate registerEmailNextDone:self];
    }
}

@end
