//
//  MBBabyGenderViewController.m
//  XiaoMaBao
//
//  Created by xiaomabao on 2016/12/1.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBBabyGenderViewController.h"
#import "MBSetBabyInformationController.h"
@interface MBBabyGenderViewController ()

@end

@implementation MBBabyGenderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)btn:(UIButton *)sender {
    NSString *babyGender = @"1";//代表男
    if (sender.tag == 0) {
       babyGender = @"0";
    }
     [self performSegueWithIdentifier:@"BabyInformationController" sender:babyGender];
    
}
-(NSString *)titleStr{
    return @"宝宝性别";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MBSetBabyInformationController *VC = (MBSetBabyInformationController *)segue.destinationViewController;
    VC.babyGender = sender;
}


@end
