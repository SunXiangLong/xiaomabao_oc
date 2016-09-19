//
//  MBBrandDetailsCollectionViewCell.m
//  XiaoMaBao
//
//  Created by xiaomabao on 16/9/19.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBBrandDetailsCollectionViewCell.h"

@implementation MBBrandDetailsCollectionViewCell
-(void)setDataDic:(NSDictionary *)dataDic{
    _goods_name.text = dataDic[@"goods_name"];
    _goods_price.text = dataDic[@"goods_price"];
    _market_price.text = string(@"市场价：",dataDic[@"market_price"] );
    [_goods_thumb sd_setImageWithURL:URL(dataDic[@"goods_thumb"]) placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
}
@end
