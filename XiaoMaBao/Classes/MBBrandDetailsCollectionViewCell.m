//
//  MBBrandDetailsCollectionViewCell.m
//  XiaoMaBao
//
//  Created by xiaomabao on 16/9/19.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBBrandDetailsCollectionViewCell.h"

@implementation MBBrandDetailsCollectionViewCell
-(void)awakeFromNib{
    [super awakeFromNib];
    
    _goods_name.displaysAsynchronously = YES;
//    _goods_name.ignoreCommonProperties = YES;
    _goods_price.displaysAsynchronously = YES;
//    _goods_price.ignoreCommonProperties = YES;
    _market_price.displaysAsynchronously = YES;
//    _market_price.ignoreCommonProperties = YES;
    
    
    
}
-(void)setModel:(GoodModel *)model{
    _model = model;
    _goods_name.text = model.goods_name;
    _goods_price.text = model.goods_price;
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:string(@"市场价：",model.market_price)];
    YYTextDecoration *textDec = [[YYTextDecoration alloc] init];
    textDec.color  = UIcolor(@"999999");
    text.yy_color = UIcolor(@"999999");
    text.yy_textStrikethrough = textDec;
    _market_price.attributedText = text;
        [_goods_thumb sd_setImageWithURL:model.goods_thumb placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
}

@end
