//
//  MBRedeemedCashViewController.m
//  XiaoMaBao
//
//  Created by xiaomabao on 2016/12/19.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBRedeemedCashViewController.h"

@interface MBRedeemedCashViewController ()

@end

@implementation MBRedeemedCashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBar.rightButton.ml_width = 100;
    self.navBar.rightButton.ml_x = UISCREEN_WIDTH - 100;
    self.navBar.rightButton.titleLabel.textAlignment = 2;
}
-(NSString *)titleStr{
return @"兑换现金";
}
-(NSString *)rightStr{
  return @"绑定银行卡";
}
-(void)rightTitleClick{
    [self performSegueWithIdentifier:@"MBTiedCardViewController" sender:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
