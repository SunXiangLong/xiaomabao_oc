//
//  MBMyCollectionTableViewCell.m
//  XiaoMaBao
//
//  Created by 张磊 on 15/6/8.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "MBMyCollectionTableViewCell.h"
@interface MBMyCollectionTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *showimageview;
@property (weak, nonatomic) IBOutlet UILabel *decribe;
@property (weak, nonatomic) IBOutlet UILabel *goods_price;
@end
@implementation MBMyCollectionTableViewCell

-(void)setModel:(MBGoodsModel *)model{
    _model = model;
    
    self.decribe.text =model.goods_name;
    self.goods_price.text = model.shop_price_formatted;
    [self.showimageview sd_setImageWithURL:model.goods_thumb placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
}


@end
