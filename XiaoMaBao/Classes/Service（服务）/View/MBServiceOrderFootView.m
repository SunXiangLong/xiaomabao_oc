//
//  MBServiceOrderFootView.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/4/6.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBServiceOrderFootView.h"
#import "MBServiceRefundController.h"
#import "MBMaBaoVolumeController.h"
#import "MBServiceEvaluationController.h"
#import "MBPaymentViewController.h"
@implementation MBServiceOrderFootView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)instanceView{
    return [[[NSBundle mainBundle] loadNibNamed:@"MBServiceOrderFootView" owner:nil options:nil] lastObject];
}

- (IBAction)button:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSString *str = button.titleLabel.text;
    if ([str isEqualToString:@"付款"]) {
        MBPaymentViewController *VC = [[MBPaymentViewController alloc] init];
        VC.orderInfo = VC.orderInfo = @{@"order_sn":self.dataDic[@"product_sn"],
                                        @"order_amount":self.dataDic[@"order_amount"],
                                        @"subject":@"北京小麻包信息技术有限公司",
                                        @"desc":self.dataDic[@"desc"]
                                        };
        VC.type = MBServiceOrder;
        VC.isOrderVC = true;
        [self.vc pushViewController:VC Animated:YES];
    }else if ([str isEqualToString:@"查看卷码"]){
        
        MBMaBaoVolumeController *VC  = [[MBMaBaoVolumeController alloc] init];
        VC.order_id = self.order_id;
        [self.vc pushViewController:VC Animated:YES];
        
    }else if ([str isEqualToString:@"评价"]){
        
        MBServiceEvaluationController *VC  = [[MBServiceEvaluationController alloc] init];
        VC.order_id = self.order_id;
        VC.title = self.dataDic[@"shop_name"];
        [self.vc pushViewController:VC Animated:YES];
        
    }else if ([str isEqualToString:@"申请退款"] ){
        MBServiceRefundController *VC = [[MBServiceRefundController alloc] init];
        VC.order_id = self.order_id;
        [self.vc pushViewController:VC Animated:YES];
        
    }

    
}
@end
