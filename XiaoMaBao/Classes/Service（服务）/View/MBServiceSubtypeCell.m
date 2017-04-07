//
//  MBServiceSubtypeCell.m
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/1/4.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "MBServiceSubtypeCell.h"
@interface MBServiceSubtypeCell()
@property (weak, nonatomic) IBOutlet UIImageView *product_img;
@property (weak, nonatomic) IBOutlet YYLabel *product_name;
@property (weak, nonatomic) IBOutlet YYLabel *product_shop_price;
@property (weak, nonatomic) IBOutlet YYLabel *product_market_price;

@end
@implementation MBServiceSubtypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.product_name.displaysAsynchronously = true;
    self.product_shop_price.displaysAsynchronously = true;
    self.product_market_price.displaysAsynchronously = true;
}
-(void)setModel:(ServiceProductsModel *)model{
    _model = model;
    self.product_name.text = model.product_name;
    [self.product_img sd_setImageWithURL:model.product_img placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
    self.product_shop_price.text = string(@"￥", model.product_shop_price);
    self.product_market_price.text = string(@"门市价：￥", model.product_market_price);
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
