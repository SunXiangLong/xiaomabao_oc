//
//  MBServiceHomeHeadView.m
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/1/3.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "MBServiceHomeHeadView.h"
@interface MBServiceHomeHeadView()
@property (weak, nonatomic) IBOutlet UIImageView *shop_logo;
@property (weak, nonatomic) IBOutlet YYLabel *shop_name;
@property (weak, nonatomic) IBOutlet YYLabel *shop_city;
@property (weak, nonatomic) IBOutlet YYLabel *shop_nearby_subway;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineHeight;


@end
@implementation MBServiceHomeHeadView
-(void)setModel:(ServiceShopModel *)model{
    _model = model;
    [self.shop_logo sd_setImageWithURL:model.shop_logo placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
    ;
    self.shop_name.text = model.shop_name;
    NSMutableAttributedString *shopAddresstext = [[NSMutableAttributedString alloc] init];
    UIImage *addressImage = [UIImage imageNamed:@"ditie"];
    NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:addressImage contentMode:UIViewContentModeCenter attachmentSize:CGSizeMake(12, 12) alignToFont:YC_YAHEI_FONT(11) alignment:YYTextVerticalAlignmentBottom];
    NSString *title = string(@"  ", model.shop_nearby_subway) ;
    [shopAddresstext appendAttributedString:attachText];
    [shopAddresstext appendAttributedString:[[NSAttributedString alloc] initWithString:title attributes:nil]];
    shopAddresstext.yy_color = UIcolor(@"666666");
    shopAddresstext.yy_font = YC_YAHEI_FONT(11);
    self.shop_nearby_subway.attributedText = shopAddresstext;
//    self.shop_nearby_subway.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    
    NSMutableAttributedString *shopCityText = [[NSMutableAttributedString alloc] init];
    UIImage *cityImage = [UIImage imageNamed:@"city_image"];
    NSMutableAttributedString *cityText = [NSMutableAttributedString yy_attachmentStringWithContent:cityImage contentMode:UIViewContentModeCenter attachmentSize:CGSizeMake(12, 12) alignToFont:YC_YAHEI_FONT(11) alignment:YYTextVerticalAlignmentBottom];
    NSString *cityTitle = string(@"  ",model.shop_city) ;
    [shopCityText appendAttributedString:cityText];
    
    [shopCityText appendAttributedString:[[NSAttributedString alloc] initWithString:cityTitle attributes:nil]];
    shopCityText.yy_color = UIcolor(@"666666");
    shopCityText.yy_font = YC_YAHEI_FONT(11);
    shopCityText.yy_alignment = NSTextAlignmentRight;
    self.shop_city.attributedText = shopCityText;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _shop_name.displaysAsynchronously = true;
    _shop_city.displaysAsynchronously = true;
    _shop_nearby_subway.displaysAsynchronously = true;
    _lineHeight.constant = 0;
    // Initialization code
    
}
+ (instancetype)instanceView{
    return [[[NSBundle mainBundle] loadNibNamed:@"MBServiceHomeHeadView" owner:nil options:nil] lastObject];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
