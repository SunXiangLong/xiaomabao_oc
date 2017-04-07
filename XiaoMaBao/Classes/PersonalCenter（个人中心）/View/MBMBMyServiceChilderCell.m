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
@interface MBMBMyServiceChilderCell()
@property (weak, nonatomic) IBOutlet UIImageView *store_image;
@property (weak, nonatomic) IBOutlet UILabel *store_name;
@property (weak, nonatomic) IBOutlet UILabel *store_state;
@property (weak, nonatomic) IBOutlet UIImageView *service_image;
@property (weak, nonatomic) IBOutlet UILabel *service_num;
@property (weak, nonatomic) IBOutlet UILabel *service_price;
@property (weak, nonatomic) IBOutlet UIButton *button;
@end
@implementation MBMBMyServiceChilderCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
-(void)setModel:(MBSerViceOrderModel *)model{
    _model = model;
    
    [self.store_image sd_setImageWithURL:model.shop_logo placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
    [self.service_image   sd_setImageWithURL:model.product_img placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
    self.service_num.text = [NSString stringWithFormat:@"数量：%@",model.product_number];
    self.service_price.text = model.order_amount;
    self.store_name.text = model.product_name;
    self.store_state.text = model.order_status;
  
    switch (model.type) {
        case 0: { [self.button setTitle:@"付款" forState:UIControlStateNormal];
            
            break;}
        case 1:  {[self.button setTitle:@"查看卷码" forState:UIControlStateNormal];
            
        }break;
        case 2:  {[self.button setTitle:@"评价" forState:UIControlStateNormal];
            
        }break;
        default: {[self.button setTitle:@"申请退款" forState:UIControlStateNormal];
            
            
        }  break;
    }

}
- (IBAction)fukuang:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSString *str = button.titleLabel.text;
    if ([str isEqualToString:@"付款"]) {
        [MobClick event:@"ServiceOrder4"];
        MBPaymentViewController *VC = [[MBPaymentViewController alloc] init];
        VC.orderInfo = @{@"order_sn":self.model.product_sn,
                         @"order_amount":self.model.order_amount,
                         @"subject":@"北京小麻包信息技术有限公司",
                         @"desc":[NSString stringWithFormat:@"%@-麻包服务",self.model.product_name]
                         };
        VC.isOrderVC = true;
        VC.type = @"2";
        [self.vc pushViewController:VC Animated:YES];
    }else if ([str isEqualToString:@"查看卷码"]){
    [MobClick event:@"ServiceOrder5"];
        MBMaBaoVolumeController *VC  = [[MBMaBaoVolumeController alloc] init];
          VC.order_id = self.model.order_id;
        [self.vc pushViewController:VC Animated:YES];
    
    }else if ([str isEqualToString:@"评价"]){
        [MobClick event:@"ServiceOrder6"];
     MBServiceEvaluationController *VC  = [[MBServiceEvaluationController alloc] init];
     VC.order_id = self.model.order_id;
     VC.title = self.model.shop_name;
    [self.vc pushViewController:VC Animated:YES];
    
    }else if ([str isEqualToString:@"申请退款"] ){
        [MobClick event:@"ServiceOrder7"];
        MBServiceRefundController *VC = [[MBServiceRefundController alloc] init];
        VC.order_id = self.model.order_id;
        [self.vc pushViewController:VC Animated:YES];
    
    }
}



@end
