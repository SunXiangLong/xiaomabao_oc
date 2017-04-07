//
//  MBWelfareCardCollectionViewCell.m
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/3/20.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "MBWelfareCardCollectionViewCell.h"

@interface MBWelfareCardCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *goods_thumb;
@property (weak, nonatomic) IBOutlet YYLabel *goods_name;
@property (weak, nonatomic) IBOutlet YYLabel *goods_price;
@end
@implementation MBWelfareCardCollectionViewCell
-(void)awakeFromNib{
    [super awakeFromNib];
    _goods_name.displaysAsynchronously = true;
    _goods_price.displaysAsynchronously = true;
}
-(void)setModel:(MBWelfareCardModel *)model{
    _model = model;
    _goods_name.text = model.goods_name;
    _goods_price.text = model.goods_price;
  
    [_goods_thumb sd_setImageWithURL:model.goods_thumb placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];

}
@end
@interface MBElectronicCardOneCell ()
@property (weak, nonatomic) IBOutlet YYLabel *card_money;

@end
@implementation MBElectronicCardOneCell
-(void)awakeFromNib{
    [super awakeFromNib];
    self.layer.borderWidth = 0.5;
   
}
-(void)setModel:(MBElectronicCardModel *)model{
    _model = model;
    _card_money.text = model.card_money;
    if (model.isSelection) {
        self.layer.borderColor = UIcolor(@"e8465e").CGColor;
        self.card_money.textColor = UIcolor(@"e8465e");
    }else{
        self.layer.borderColor = UIcolor(@"555555").CGColor;
        self.card_money.textColor = UIcolor(@"555555");
    }
}
@end
@interface MBElectronicCardTwoCell ()<UITextFieldDelegate>
{
    UITextField *_goodsNumField;
    UIButton *_goodsMoreBtn;
    UIButton *_goodsLessBtn;

}
@property (weak, nonatomic) IBOutlet UILabel *card_money;

@end
@implementation MBElectronicCardTwoCell
-(void)awakeFromNib{
    [super awakeFromNib];
    [self layoutIfNeeded];
    
    
    UIView *view = [[UIView alloc] init];
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(85);
        make.height.mas_equalTo(25);
        make.top.equalTo(_card_money.mas_bottom).offset(12);
        make.centerX.equalTo(self.mas_centerX);
    }];
    UIButton *goodsLessBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [goodsLessBtn addTarget:self action:@selector(goodsCarless) forControlEvents:UIControlEventTouchUpInside];
    [goodsLessBtn setImage:[UIImage imageNamed:@"cart_less_btn_enable"]  forState:UIControlStateNormal];
    [goodsLessBtn setImage:[UIImage imageNamed:@"cart_less_btn_disable"]  forState:UIControlStateDisabled];
    [view addSubview:_goodsLessBtn =  goodsLessBtn];
    [goodsLessBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(25);
        
    }];
    
    
    UIButton *goodsNumeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [goodsNumeBtn setBackgroundImage:[UIImage imageNamed:@"syncart_middle_btn_enable"] forState:UIControlStateNormal];
    [view addSubview:goodsNumeBtn];
    [goodsNumeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.equalTo(goodsLessBtn.mas_right);
        make.width.mas_equalTo(35);
    }];
    
    UITextField *goodsNumField = [[UITextField alloc] init];
    goodsNumField.text = @"1";
    goodsNumField.keyboardType = UIKeyboardTypeNumberPad;
    goodsNumField.textColor = UIcolor(@"333333");
    goodsNumField.font = YC_YAHEI_FONT(12);
    goodsNumField.textAlignment = 1;
    goodsNumField.delegate = self;
    [view addSubview:_goodsNumField =  goodsNumField];
    
    [goodsNumField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(1);
        make.bottom.mas_equalTo(-1);
        make.left.equalTo(goodsLessBtn.mas_right).offset(1);
        make.width.mas_equalTo(33);
        
    }];
    
    UIButton *goodsMoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [goodsMoreBtn addTarget:self action:@selector(goodsCarMore) forControlEvents:UIControlEventTouchUpInside];
    [goodsMoreBtn setImage:[UIImage imageNamed:@"cart_more_btn_enable"]  forState:UIControlStateNormal];
    [goodsMoreBtn setImage:[UIImage imageNamed:@"cart_more_btn_disable"]  forState:UIControlStateDisabled];
    [view addSubview:_goodsMoreBtn =  goodsMoreBtn];
    [goodsMoreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.mas_equalTo(0);
        make.width.height.mas_equalTo(25);
    }];
    

}
-(void)setModel:(MBElectronicCardModel *)model{
    _model = model;
    _goodsNumField.text = s_Integer(model.count);
    _card_money.text =  [NSString stringWithFormat:@"￥%@ 面值",model.card_money];


}
//数量减1
- (void)goodsCarless{
    if (_model.count==1) {
        _goodsLessBtn.enabled = false;
        return;
    }
    _model.count --;
    _goodsNumField.text = s_Integer(_model.count);
    self.delete(_model);
    
    
    
}
//数量加1
- (void)goodsCarMore{
    _goodsLessBtn.enabled = true;
    _model.count ++;
    _goodsNumField.text = s_Integer(_model.count);
     self.delete(_model);
}
- (IBAction)deleateButton:(id)sender {
    
    _model.isSelection  = false;
    _model.count = 0;
    self.delete(_model);
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    _model.count = [textField.text integerValue];
    _goodsNumField.text = s_Integer(_model.count);
     self.delete(_model);
    
}
@end


@interface MBElectronicSubOrderCardCell ()
@property (weak, nonatomic) IBOutlet UIImageView *card_img;
@property (weak, nonatomic) IBOutlet UILabel *subtotal;
@property (weak, nonatomic) IBOutlet UILabel *card_cnt;

@property (weak, nonatomic) IBOutlet UILabel *card_name;
@end
@implementation MBElectronicSubOrderCardCell
-(void)awakeFromNib{
    [super awakeFromNib];
     
}
-(void)setModel:(MBElectronicCardModel *)model{
    _model = model;
    [_card_img sd_setImageWithURL:model.card_img];
    
    if (model.subtotal) {
        _subtotal.text =  string(@"￥ ", model.subtotal);
        _card_cnt.text = string(@"数量：", model.card_cnt);
    }else{
        _subtotal.text =  model.card_money;
        _card_cnt.text = string(@"数量：", model.card_number);
    }
    
    _card_name.text = model.card_name;
    
}
@end
