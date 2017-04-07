//
//  MBAfterServiceTableViewCell.m
//  XiaoMaBao
//
//  Created by 张磊 on 15/6/9.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "MBAfterServiceTableViewCell.h"
@interface MBAfterServiceTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *showImageview;
@property (weak, nonatomic) IBOutlet UILabel *describe;
@property (weak, nonatomic) IBOutlet UILabel *priceAndNumber;
@end
@implementation MBAfterServiceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
-(void)setModel:(MBGoodListModel *)model{
    _model = model;
    
    [self.showImageview sd_setImageWithURL:model.goods_img placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
    self.describe.text = model.name;
    self.priceAndNumber.text = [NSString stringWithFormat:@"%@ X %@",model.shop_price_formatted,model.goods_number];

}
-(void)setRefundGoodsModel:(MBRefundGoodsModel *)refundGoodsModel{
    _refundGoodsModel = refundGoodsModel;
     [self.showImageview sd_setImageWithURL:refundGoodsModel.goods_thumb placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
    self.describe.text = refundGoodsModel.goods_name;
    self.priceAndNumber.text = [NSString stringWithFormat:@"%@ X %@",refundGoodsModel.goods_price,refundGoodsModel.goods_number];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
