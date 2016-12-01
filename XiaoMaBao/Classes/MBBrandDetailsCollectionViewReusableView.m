//
//  MBBrandDetailsCollectionViewReusableView.m
//  XiaoMaBao
//
//  Created by xiaomabao on 16/9/19.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBBrandDetailsCollectionViewReusableView.h"

@implementation MBBrandDetailsCollectionViewReusableView
-(void)awakeFromNib{
    [super awakeFromNib];
    _brand_desc.displaysAsynchronously = YES;
//    _brand_desc.ignoreCommonProperties = YES;
    _brand_name.displaysAsynchronously = YES;
//    _brand_name.ignoreCommonProperties = YES;
}
- (void)setModel:(BrandModel *)model{
    _model = model;
    [_brand_logo sd_setImageWithURL:model.brand_logo placeholderImage:[UIImage imageNamed:@"placeholder_num3"]];
    _brand_name.text = model.brand_name;
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:model.brand_desc];
    text.yy_lineSpacing = 2;
    text.yy_font = YC_YAHEI_FONT(14);
    text.yy_color= UIcolor(@"8e8e8e");
    _brand_desc.attributedText = text;

}
@end
