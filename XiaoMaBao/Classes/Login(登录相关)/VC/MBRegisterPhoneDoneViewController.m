//
//  @Author : <#Author#>
//  @Desc   : <#Desc#>
//
//  XiaoMaBao
//
//  Created by 张磊 on 15/5/1.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "MBRegisterPhoneDoneViewController.h"

@interface MBRegisterPhoneDoneViewController ()
- (IBAction)complete;
@property (weak, nonatomic) IBOutlet UILabel *phone;

@end

@implementation MBRegisterPhoneDoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.phone.text = [self.phoneNumber stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)titleStr{
    return @"注册成功";
}
-(UIViewController *)popViewControllerAnimated:(BOOL)animated{
   [self.navigationController popToRootViewControllerAnimated:true];
    return nil;
}
- (IBAction)complete {
  [self.navigationController popToRootViewControllerAnimated:true];
}

@end
