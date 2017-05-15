//
//  MBShopAddressTableViewCell.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/3/24.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBShopAddressTableViewCell.h"
#import "MBNewAddressViewController.h"

@interface MBShopAddressTableViewCell()
{
  BOOL _isDefault;
}
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *photo;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UIButton *is_default;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height;
@end
@implementation MBShopAddressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self uiedgeInsetsZero];
    self.height.constant = 0.5f;
}
-(void)setModel:(MBConsigneeModel *)model{
    _model = model;
    
    _name.text = model.consignee;
    _photo.text = model.mobile;
    _address.text = [NSString stringWithFormat:@"%@-%@-%@-%@",model.province_name,model.city_name,model.district_name,model.address];
    if ([model.is_default intValue] == 1) {
        _isDefault = true;
        [_is_default setImage:[UIImage imageNamed:@"pitch_on"] forState:UIControlStateNormal];
    }
   
    
}
- (IBAction)default:(id)sender {
    if (!_isDefault) {
        self.editAddress(_model, MBSetTheDefaultAddress);
    }
}

- (IBAction)editor:(id)sender {
    self.editAddress(_model, MBModifyTheAddress);
 
}
- (IBAction)delete:(id)sender {
    
    self.editAddress(_model, MBDeleteTheAddress);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

   
}

@end
