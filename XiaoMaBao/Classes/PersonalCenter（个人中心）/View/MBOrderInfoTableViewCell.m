//
//  MBOrderInfoTableViewCell.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/8/18.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBOrderInfoTableViewCell.h"
#import "MBLogisticsViewController.h"
@implementation MBOrderInfoTableViewOneCell

-(void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    _address.text = dataDic[@"address"];
    _mobile.text = dataDic[@"mobile"];
    _consignee.text = dataDic[@"consignee"];
}

@end
@implementation MBOrderInfoTableViewTwoCell
-(void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    
    _order_sn.text = _dataDic[@"order_sn"];
    _add_time_formatted.text = _dataDic[@"add_time_formatted"];
    _shipping_fee_formatted.text = _dataDic[@"shipping_fee_formatted"];
    _goods_amount_formatted.text = _dataDic[@"total_fee_formatted"];
    _total_fee_formatted.text = _dataDic[@"goods_amount_formatted"];
    _card_fee_formatted.text = _dataDic[@"card_fee_formatted"];
    _discount_formatted.text = _dataDic[@"discount_formatted"];
    _coupus_formatted.text = _dataDic[@"coupus_formatted"];
    _bonus_formatted.text = _dataDic[@"bonus_formatted"];
    _bean_fee.text = string(@"￥", _dataDic[@"bean_fee"]);
    
}


@end
@implementation MBOrderInfoTableViewThreeCell

-(void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    [_imag sd_setImageWithURL:URL(dataDic[@"goods_img"]) placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
    _name.text = dataDic[@"goods_name"];
    _shop_price.text = [NSString stringWithFormat:@"%@ x %@",dataDic[@"goods_price_formatted"],dataDic[@"goods_number"]];
}

@end
@implementation MBOrderInfoTableViewFourCell
-(void)awakeFromNib{
    [super awakeFromNib];
_button.layer.borderWidth = PX_ONE;
}
-(void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    _shipping_name.text = dataDic[@"shipping_name"];
    _invoice_no.text = dataDic[@"invoice_no"];
}
- (IBAction)CheckLogistic:(UIButton *)sender {
    MBLogisticsViewController *VC = [[MBLogisticsViewController alloc] init];
    VC.type = _shipping_name.text;
    VC.postid = _invoice_no.text;
    VC.isOrderDetails = YES;
    
    MBNavigationViewController *nav = [[MBNavigationViewController alloc] initWithRootViewController:VC];
    [self.VC presentViewController:nav animated:YES completion:nil];
}

@end
