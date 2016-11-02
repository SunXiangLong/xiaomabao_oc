//
//  MBServiceShopsOneCell.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/3/31.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBServiceShopsOneCell.h"

@implementation MBServiceShopsOneCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
-(void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    self.shop_name.text = dataDic[@"product_name"];
    self.price.text =  [NSString stringWithFormat:@"门市价：%@",dataDic[@"product_market_price"]];
    self.shop_price.text = [NSString stringWithFormat:@"¥ %@",dataDic[@"product_shop_price"]];
    [self.showImageViw sd_setImageWithURL:[NSURL URLWithString:dataDic[@"product_img"]] placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
}
- (CGSize)sizeThatFits:(CGSize)size {
    
    return CGSizeMake(size.width, 85);
}

@end
