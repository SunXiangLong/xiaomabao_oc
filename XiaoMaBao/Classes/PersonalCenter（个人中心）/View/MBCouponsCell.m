//
//  MBCouponsCell.m
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/3/30.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "MBCouponsCell.h"
@interface MBCouponsCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *user_name;
@property (weak, nonatomic) IBOutlet UILabel *coupon_type;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UIView *nullDataView;

@end
@implementation MBCouponsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}
-(void)setModel:(MBCounponModel *)model{
    _model = model;
    _nullDataView.hidden = true;
    [_iconImage sd_setImageWithURL:model.header_img placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
    _user_name.text = model.user_name;
    _coupon_type.text = model.coupon_type ;
    _status.text = model.status;
    if ([model.status isEqualToString:@"未入账"]) {
        _status.textColor = UIcolor(@"555555");
    }else{
     _status.textColor = UIcolor(@"aaaaaa");
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
