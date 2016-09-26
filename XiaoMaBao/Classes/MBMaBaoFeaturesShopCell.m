//
//  MBMaBaoFeaturesShopCell.m
//  XiaoMaBao
//
//  Created by xiaomabao on 16/9/19.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBMaBaoFeaturesShopCell.h"

@implementation MBMaBaoFeaturesShopCell
-(void)awakeFromNib{
    [super awakeFromNib];
    _height.constant = 0.5;
    _goods_thumb.contentMode =  UIViewContentModeScaleAspectFill;
    _goods_thumb.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _goods_thumb.clipsToBounds  = YES;
}
-(void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;

    [_goods_thumb sd_setImageWithURL:URL(_dataDic[@"goods_thumb"]) placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
    _goods_name.text = _dataDic[@"goods_name"];
    _goods_price.text = _dataDic[@"goods_price"];
    _market_price.text = string(@"市场价：",_dataDic[@"market_price"] );
    
    
}

- (IBAction)event:(UIButton *)sender {
    
}
@end
