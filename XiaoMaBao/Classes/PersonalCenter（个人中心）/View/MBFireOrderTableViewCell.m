//
//  MBFireOrderTableViewCell.m
//  XiaoMaBao
//
//  Created by 张磊 on 15/6/2.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "MBFireOrderTableViewCell.h"
@interface MBFireOrderTableViewCell()

@end
@implementation MBFireOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
-(void)setModel:(MBGood_ListModel *)model{
    _model = model;
    self.countNumber.text = [NSString stringWithFormat:@"X %@",model.goods_number];
    self.countprice.text = string(@"￥",model.subtotal);
    self.desribe.text = model.goods_name;
    [self.showimageview sd_setImageWithURL:model.goods_thumb placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
    self.discount_name.text = model.goods_attr;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
