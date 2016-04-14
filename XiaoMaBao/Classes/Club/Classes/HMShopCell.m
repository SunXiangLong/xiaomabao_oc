//
//  HMShopCell.m
//  04-瀑布流
//
//  Created by apple on 14/12/4.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HMShopCell.h"
#import "HMShop.h"

@interface HMShopCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@end

@implementation HMShopCell

- (void)setShop:(HMShop *)shop
{
    _shop = shop;
    
    // 1.图片
//    [self.imageView sd_setImageWithURL:[NSURL URLWithString:shop.img] placeholderImage:[UIImage imageNamed:@"loading"]];
    
    // 2.价格
    self.priceLabel.text = shop.price;
}
@end
