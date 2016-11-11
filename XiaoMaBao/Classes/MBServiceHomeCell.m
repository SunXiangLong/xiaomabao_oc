//
//  MBServiceHomeCell.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/3/31.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBServiceHomeCell.h"

@implementation MBServiceHomeCell

- (void)awakeFromNib {
    [super awakeFromNib];

}
-(void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    [self.shop_logo sd_setImageWithURL:[NSURL URLWithString:dataDic[@"shop_logo"]] placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
    self.shop_name.text = dataDic[@"shop_name"];
    self.shop_desc.text = dataDic[@"shop_desc"];
    self.shop_address.text = dataDic[@"shop_nearby_subway"];
    self.shop_city.text  = dataDic[@"shop_city"];
//    self.shop_desc.rowspace = 6;
}
- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat totalHeight = 0;
    
    totalHeight += [self.shop_name sizeThatFits:size].height;
//    totalHeight += [self.shop_desc sizeThatFits:size].height;
    totalHeight += [self.shop_city sizeThatFits:size].height;
    totalHeight += 40;
    CGFloat strHeight = [self.shop_desc.text sizeWithFont:[UIFont systemFontOfSize:14] withMaxSize:CGSizeMake(UISCREEN_WIDTH-70, MAXFLOAT)].height;
    totalHeight += strHeight;
    
    return CGSizeMake(size.width, totalHeight);
}

@end
