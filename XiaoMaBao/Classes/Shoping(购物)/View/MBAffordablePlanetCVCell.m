//
//  MBAffordablePlanetCVCell.m
//  XiaoMaBao
//
//  Created by xiaomabao on 2016/11/23.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBAffordablePlanetCVCell.h"

@implementation MBAffordablePlanetCVCell
- (void)awakeFromNib{
    [super awakeFromNib];
}
- (void)setModel:(CategoryModel *)model{
    _model = model;
    [_bandImageView sd_setImageWithURL:model.icon placeholderImage:[UIImage imageNamed:@"placeholder_num3"]];

}
- (void)setCountrieModel:(CountriesCategoryModel *)countrieModel{
    _countrieModel = countrieModel;
    [_bandImageView sd_setImageWithURL:countrieModel.c_img placeholderImage:[UIImage imageNamed:@"placeholder_num4"]];

}
@end

@implementation MBAffordablePlanetCVToCell
-(instancetype)initWithFrame:(CGRect)frame{
   self =  [super initWithFrame:frame];
    if (self) {
        _goodsPrice = [[YYLabel alloc] initWithFrame:CGRectMake(10, 140, 100, 15)];
        _goodsPrice.displaysAsynchronously = true;
//        _goodsPrice.ignoreCommonProperties = true;
        _goodsPrice.textAlignment = 1;
        _goodsPrice.textColor = UIcolor(@"b66263");
        _goodsPrice.font = [UIFont systemFontOfSize:10];
        [self.contentView addSubview:_goodsPrice];
        _goodsName = [[YYLabel alloc] initWithFrame:CGRectMake(10, 105, 100, 35)];
        _goodsName.displaysAsynchronously = true;
//        _goodsName.ignoreCommonProperties = true;
        _goodsName.textAlignment = 1;
        _goodsName.numberOfLines = 2;
        _goodsName.textColor = UIcolor(@"575757");
        _goodsName.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_goodsName];
        
        _goodsThumbImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 100, 100)];
        [self.contentView addSubview:_goodsThumbImageView];
        
    }
    
    return self;
}
- (void)setModel:(GoodModel *)model{
    _model = model;
    [_goodsThumbImageView sd_setImageWithURL:model.goods_thumb placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
    _goodsName.text = model.goods_name;
    
    _goodsPrice.text = string(@"￥",model.goods_price);
}
@end
