//
//  MBBeanUseViewController.m
//  XiaoMaBao
//
//  Created by xiaomabao on 2016/12/26.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBBeanUseViewController.h"

@interface MBBeanUseViewController ()
@property (weak, nonatomic) IBOutlet UILabel *beanNumber;
@property (weak, nonatomic) IBOutlet UITextField *beanNumTextField;
@property (weak, nonatomic) IBOutlet UILabel *beanLable;

@end

@implementation MBBeanUseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _beanNumTextField.placeholder = _number;
    _beanNumber.text  = _number;
    _beanLable.text = [NSString stringWithFormat:@"(可抵扣￥%.2f)",[_number doubleValue]/100];
    
}
- (NSString *)titleStr{
   
    return @"使用麻豆";
    
}
- (IBAction)config:(id)sender {
    if (_beanNumTextField.text.length == 0) {
        [self show:@"请输入要使用的麻豆数量" time:.8];
        return;
    }
    if ([_beanNumTextField.text integerValue] > [_number integerValue]) {
        [self show:[NSString stringWithFormat:@"最多可使用%@个麻豆",_number] time:.8];
        _beanNumTextField.text = _number;
        return;
    }
    self.block(_beanNumTextField.text);
    [self popViewControllerAnimated:true];
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
