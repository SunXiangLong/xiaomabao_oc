//
//  MBMBMyServiceChilderCell.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/4/5.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBMBMyServiceChilderCell.h"
#import "MBServiceEvaluationController.h"
#import "MBMaBaoVolumeController.h"
#import "MBPaymentViewController.h"
#import "MBServiceRefundController.h"
#import "MBServiceShopsViewController.h"
#import "MBServiceDetailsViewController.h"
@implementation MBMBMyServiceChilderCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.service_image.contentMode =  UIViewContentModeScaleAspectFill;
//    self.service_image.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//    self.service_image.clipsToBounds  = YES;
//    
//    self.service_image.contentMode =  UIViewContentModeScaleAspectFill;
//    self.service_image.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//    self.service_image.clipsToBounds  = YES;
}

- (IBAction)tiaozhuandianbu:(id)sender {
    
    MBServiceShopsViewController *VC = [[MBServiceShopsViewController alloc] init];
    VC.shop_id =  self.dataDic[@"shop_id"];
    VC.title =  self.dataDic[@"shop_name"];
    [self.vc pushViewController:VC Animated:YES];
}

- (IBAction)tiaozhuanfuwu:(id)sender {
    MBServiceDetailsViewController *VC = [[MBServiceDetailsViewController alloc] init];
    VC.product_id =  self.dataDic[@"product_id"];
    [self.vc pushViewController:VC Animated:YES];
    
}
- (IBAction)fukuang:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSString *str = button.titleLabel.text;
    if ([str isEqualToString:@"付款"]) {
        [MobClick event:@"ServiceOrder4"];
        MBPaymentViewController *VC = [[MBPaymentViewController alloc] init];
        VC.orderInfo = @{@"order_sn":self.dataDic[@"product_sn"],
                         @"order_amount":self.dataDic[@"order_amount"],
                         @"subject":@"北京小麻包信息技术有限公司",
                         @"desc":[NSString stringWithFormat:@"%@-麻包服务",self.dataDic[@"product_name"]]
                         };
        VC.isOrderVC = true;
        VC.type = @"2";
        [self.vc pushViewController:VC Animated:YES];
    }else if ([str isEqualToString:@"查看卷码"]){
    [MobClick event:@"ServiceOrder5"];
        MBMaBaoVolumeController *VC  = [[MBMaBaoVolumeController alloc] init];
          VC.order_id = self.dataDic[@"order_id"];
        [self.vc pushViewController:VC Animated:YES];
    
    }else if ([str isEqualToString:@"评价"]){
        [MobClick event:@"ServiceOrder6"];
    MBServiceEvaluationController *VC  = [[MBServiceEvaluationController alloc] init];
     VC.order_id = self.dataDic[@"order_id"];
     VC.title = self.dataDic[@"shop_name"];
    [self.vc pushViewController:VC Animated:YES];
    
    }else if ([str isEqualToString:@"申请退款"] ){
        [MobClick event:@"ServiceOrder7"];
        MBServiceRefundController *VC = [[MBServiceRefundController alloc] init];
        VC.order_id = self.dataDic[@"order_id"];
        [self.vc pushViewController:VC Animated:YES];
    
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

   
}

@end
