//
//  MBAffordableCell.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/6/21.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBAffordableCell.h"
@interface MBAffordableCell ()


@property (strong, nonatomic)  UILabel *shopName_text;
@property (strong, nonatomic)  UILabel *shopPrice_text;
@property (strong, nonatomic)  UIImageView *showImageView;
@end
@implementation MBAffordableCell
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUI];
    }

      return self;
}
- (void)setUI{
    
    [self.contentView addSubview:({
        
         _showImageView = [[UIImageView alloc] init];
        _showImageView.opaque = YES;
        _showImageView;
    
    })];
    [self.contentView addSubview:({
    
        _shopName_text = [[UILabel alloc] init];
        _shopName_text.textAlignment = 1;
        _shopName_text.numberOfLines = 2;
        _shopName_text.font = SYSTEMFONT(12);
        _shopName_text.textColor = UIcolor(@"575c65");
        _shopName_text.opaque = YES;
        _shopName_text;
        
    
    })];
    
    [self.contentView addSubview:({
    
        _shopPrice_text = [[UILabel alloc] init];
        _shopPrice_text.textAlignment = 1;
        _shopPrice_text.numberOfLines = 0;
        _shopPrice_text.font = SYSTEMFONT(10);
        _shopPrice_text.textColor = UIcolor(@"d66263");
        _shopPrice_text.opaque = YES;
        _shopPrice_text;
    
    
    })];

}
-(void)layoutSubviews{
    [super layoutSubviews];
    _showImageView.frame = CGRectMake(10, 0, 100, 100);
    
    _shopName_text.frame = CGRectMake(10, 106, 100, 30);
    
    _shopPrice_text.frame = CGRectMake(10, CGRectGetMaxY(_shopName_text.frame), 100, 15);
    
    

}
-(void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;

    [_showImageView sd_setImageWithURL:URL(dataDic[@"goods_thumb"]) placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
    _shopName_text.text  = dataDic[@"goods_name"];
    _shopPrice_text.text = string(@"¥", dataDic[@"goods_price"]);
}
@end
