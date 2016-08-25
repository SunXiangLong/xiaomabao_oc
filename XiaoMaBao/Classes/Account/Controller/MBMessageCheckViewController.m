//
//  @Author : <#Author#>
//  @Desc   : <#Desc#>
//
//  XiaoMaBao
//
//  Created by 张磊 on 15/5/4.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "MBMessageCheckViewController.h"
#import "MBRegisterField.h"
#import "NSString+BQ.h"
#import "MBResetPwdViewController.h"
#import "MobClick.h"
@interface MBMessageCheckViewController ()
@property (weak, nonatomic) IBOutlet MBRegisterField *verifyField;
@property (weak, nonatomic) IBOutlet UILabel *textPhone;
- (IBAction)nextStep;

@end

@implementation MBMessageCheckViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MBMessageCheckViewController"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MBMessageCheckViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *verifyFieldLeftView = [[UIView alloc] init];
    verifyFieldLeftView.frame = CGRectMake(0, 0, 12, 12);
    
    self.verifyField.leftView = verifyFieldLeftView;
    self.verifyField.leftViewMode = UITextFieldViewModeAlways;
    [self.verifyField becomeFirstResponder];
    [self.verifyField setKeyboardType:UIKeyboardTypeNumberPad];
    NSString *textPhone2 = self.textPhone.text;
    NSString *textPhone3 = [textPhone2 stringByReplacingCharactersInRange:NSMakeRange(6, 12) withString:self.phoneNumber];
    self.textPhone.text = [textPhone3 stringByReplacingCharactersInRange:NSMakeRange(9, 4) withString:@"****"];
}
- (NSString *)titleStr{
    return @"短信校验";
}

- (IBAction)nextStep {
    if (self.verifyField.text.length == 6) {
        NSString *Md5 = [self.verifyField.text md5];
        NSString *phoneMd5 = self.phoneMd5;
        
        NSLog(@"%@  == %@",Md5,phoneMd5);
        
        if ([phoneMd5 isEqualToString:Md5]) {
            
        [self performSegueWithIdentifier:@"PushMBResetPwdViewController" sender:nil];
            
        }else {
        
            UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"验证码输入错误" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [alerView show];
        }
    }
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"PushMBResetPwdViewController"]) {
        MBResetPwdViewController *controller = segue.destinationViewController;
        controller.code = self.verifyField.text;
        
    }
}
@end
