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
    _shopName.displaysAsynchronously = YES;
//    _shopName.ignoreCommonProperties = YES;
    _shopDesc.displaysAsynchronously = YES;
//    _shopDesc.ignoreCommonProperties = YES;
    _shopCity.displaysAsynchronously = YES;
//    _shopCity.ignoreCommonProperties = YES;
    _shopAddress.displaysAsynchronously = YES;
//    _shopAddress.ignoreCommonProperties = YES;
}

-(void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    [self.shopLogo sd_setImageWithURL:[NSURL URLWithString:dataDic[@"shop_logo"]] placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
     ;
    
    self.shopName.text = dataDic[@"shop_name"];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:dataDic[@"shop_desc"]];
    text.yy_lineSpacing = 2;
    text.yy_font = YC_YAHEI_FONT(14);
    text.yy_color= UIcolor(@"8e8e8e");
    self.shopDesc.attributedText = text;
   
    NSMutableAttributedString *shopAddresstext = [[NSMutableAttributedString alloc] init];
     UIImage *addressImage = [UIImage imageNamed:@"ditie"];
    NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:addressImage contentMode:UIViewContentModeCenter attachmentSize:CGSizeMake(9, 10) alignToFont:YC_YAHEI_FONT(13) alignment:YYTextVerticalAlignmentBottom];
    NSString *title = string(@"  ", dataDic[@"shop_nearby_subway"]) ;
    [shopAddresstext appendAttributedString:attachText];
    [shopAddresstext appendAttributedString:[[NSAttributedString alloc] initWithString:title attributes:nil]];
    shopAddresstext.yy_color = UIcolor(@"575757");
    shopAddresstext.yy_font = YC_YAHEI_FONT(13);
    self.shopAddress.attributedText = shopAddresstext;
    self.shopAddress.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    
    NSMutableAttributedString *shopCityText = [[NSMutableAttributedString alloc] init];
    UIImage *cityImage = [UIImage imageNamed:@"city_image"];
    NSMutableAttributedString *cityText = [NSMutableAttributedString yy_attachmentStringWithContent:cityImage contentMode:UIViewContentModeCenter attachmentSize:CGSizeMake(9, 10) alignToFont:YC_YAHEI_FONT(13) alignment:YYTextVerticalAlignmentBottom];
    NSString *cityTitle = string(@"  ",dataDic[@"shop_city"]) ;
    [shopCityText appendAttributedString:cityText];
    
    [shopCityText appendAttributedString:[[NSAttributedString alloc] initWithString:cityTitle attributes:nil]];
    shopCityText.yy_color = UIcolor(@"575757");
    shopCityText.yy_font = YC_YAHEI_FONT(13);
    shopCityText.yy_alignment = NSTextAlignmentRight;
    self.shopCity.attributedText = shopCityText;

    
   
    
}
- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat totalHeight = 0;
    

    CGFloat strHeight = [self.shopDesc.text sizeWithFont:[UIFont systemFontOfSize:14] withMaxSize:CGSizeMake(UISCREEN_WIDTH-70, MAXFLOAT)].height;
    totalHeight += 80;
    totalHeight += strHeight;
    
    return CGSizeMake(size.width, totalHeight);
}

@end
