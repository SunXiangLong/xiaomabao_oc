//
//  @Author : <#Author#>
//  @Desc   : <#Desc#>
//
//  XiaoMaBao
//
//  Created by 张磊 on 15/5/2.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "MBRegisterEmailDoneViewController.h"
#import "MobClick.h"
@interface MBRegisterEmailDoneViewController ()

@end

@implementation MBRegisterEmailDoneViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MBRegisterEmailDoneViewController.m"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MBRegisterEmailDoneViewController.m"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (NSString *)titleStr{
    return @"邮箱验证";
}

@end
