//
//  MBBaseTableViewController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/8/19.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBBaseTableViewController.h"

@interface MBBaseTableViewController ()
{
    
    MBProgressHUD *HUD;
    
}
@end

@implementation MBBaseTableViewController
- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [MobClick beginLogPageView:[NSString stringWithUTF8String:object_getClassName(self)]];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:[NSString stringWithUTF8String:object_getClassName(self)]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.navigationController) {
        [self setNavigationBar];
    }
   
}
- (void)setNavigationBar{
    self.navigationController.navigationBar.shadowImage  = [[UIImage alloc] init];
    [self.navigationController.navigationBar setBackgroundColor:UIcolor(@"ffffff")];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"mm_navGroundImage"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = UIcolor(@"ffffff");
    NSDictionary* dict= @{NSForegroundColorAttributeName:UIcolor(@"ffffff"),NSFontAttributeName:YC_RTWSYueRoud_FONT(17)};
    self.navigationController.navigationBar.titleTextAttributes= dict;

    
    UIButton *backBut = [UIButton  buttonWithType:UIButtonTypeCustom];
    backBut.frame = CGRectMake(0, 0, 44, 44);
    backBut.imageEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    [backBut addTarget:self action:@selector(popViewControllerAnimated) forControlEvents:UIControlEventTouchUpInside];
    [backBut setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBut];
}
- (void)popViewControllerAnimated{
    
//    [self.navigationController   popViewControllerAnimated:YES];
    [self.view endEditing:false];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
