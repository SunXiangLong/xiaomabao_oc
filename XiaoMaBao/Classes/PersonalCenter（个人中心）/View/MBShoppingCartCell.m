//
//  MBShoppingCartCell.m
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/2/28.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "MBShoppingCartCell.h"
@interface MBShoppingCartCell()<UITextFieldDelegate>
{
    
    
    UITextField *_goodsNumField;
    UIButton *_checkBtn;
    UIImageView *_goodsImageView;
    UILabel *_goodsNameLabel;
    UILabel *_goodsSpace;
    UILabel *_goodsPrice;
    UIButton *_goodsMoreBtn;
    UIButton *_goodsLessBtn;
}
@end
@implementation MBShoppingCartCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier model:(MBGood_ListModel *)model{
    if (self =[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSeparatorStyleNone;
        [self setUI];
        self.goodsModel = model;
    }
    return self;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

}
-(void)setGoodsModel:(MBGood_ListModel *)goodsModel{
    _goodsModel = goodsModel;

    if ([_goodsModel.flow_order integerValue] == 1) {
        _checkBtn.selected = true;
    }else{
        _checkBtn.selected = false;
    }
    
    [_goodsImageView sd_setImageWithURL:_goodsModel.goods_img placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
    
    _goodsNameLabel.text = _goodsModel.goods_name;
    _goodsSpace.text = _goodsModel.goods_attr;
    _goodsPrice.text = _goodsModel.goods_price_formatted;
    _goodsNumField.text = _goodsModel.goods_number;
    
    
    if ([_goodsModel.goods_number integerValue] == 1) {
        _goodsLessBtn.enabled = false;
    }else{
        _goodsLessBtn.enabled = true;
    }
    
}
- (void)setUI{
    UIButton *checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [checkBtn addTarget:self action:@selector(goodsCarClick) forControlEvents:UIControlEventTouchUpInside];
    [checkBtn setImage:[UIImage imageNamed:@"syncart_round_check"] forState:UIControlStateNormal];
    [checkBtn setImage:[UIImage imageNamed:@"syncart_round_check1"] forState:UIControlStateSelected];
    [self addSubview: _checkBtn =checkBtn];
    [checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(0);
        make.width.height.mas_equalTo(35);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    
    UIImageView *goodsImageView = [[UIImageView alloc] init];
    
    goodsImageView.layer.cornerRadius = 2;
    goodsImageView.layer.borderColor = [UIColor colorWithHexString:@"f0f0f0"].CGColor;
    goodsImageView.layer.borderWidth = 1;
    [self addSubview:_goodsImageView = goodsImageView];
    [goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(9);
        make.left.equalTo(checkBtn.mas_right).offset(9);
        make.bottom.mas_equalTo(-9);
        make.width.equalTo(goodsImageView.mas_height);
    }];
    
    
    UILabel *goodsNameLabel = [[UILabel  alloc] init];
    
    goodsNameLabel.numberOfLines = 2;
    goodsNameLabel.textColor = [UIColor colorWithHexString:@"444444"];
    goodsNameLabel.font =  SYSTEMFONT(14);
    [self addSubview: _goodsNameLabel = goodsNameLabel];
    [goodsNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(goodsImageView.mas_top);
        make.left.equalTo(goodsImageView.mas_right).offset(9);
        make.right.mas_equalTo(-9);
    }];
    
    UILabel *goodsSpace = [[UILabel  alloc] init];
    
    goodsSpace.numberOfLines = 1;
    goodsSpace.textColor = [UIColor colorWithHexString:@"9697a0"];
    goodsSpace.font =  SYSTEMFONT(12);
    [self addSubview:_goodsSpace = goodsSpace];
    [goodsSpace mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(goodsNameLabel.mas_bottom).offset(15);
        make.left.equalTo(goodsImageView.mas_right).offset(9);
        make.centerY.equalTo(goodsImageView.mas_centerY);
//        make.right.mas_equalTo(-9);
    }];
    UILabel *goodsPrice = [[UILabel  alloc] init];
    
    goodsPrice.numberOfLines = 1;
    goodsPrice.textColor = [UIColor colorWithHexString:@"f23030"];
    goodsPrice.font =  YC_YAHEI_FONT(16);
    [self addSubview:_goodsPrice = goodsPrice];
    [goodsPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(goodsImageView.mas_bottom).offset(-3);
        make.left.equalTo(goodsImageView.mas_right).offset(9);
    }];
    
    UIButton *goodsMoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [goodsMoreBtn addTarget:self action:@selector(goodsCarMore) forControlEvents:UIControlEventTouchUpInside];
    [goodsMoreBtn setImage:[UIImage imageNamed:@"cart_more_btn_enable"]  forState:UIControlStateNormal];
    [goodsMoreBtn setImage:[UIImage imageNamed:@"cart_more_btn_disable"]  forState:UIControlStateDisabled];
    [self addSubview:_goodsMoreBtn =  goodsMoreBtn];
    [goodsMoreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(goodsPrice.mas_bottom);
        make.right.mas_equalTo(-9);
        make.width.height.mas_equalTo(25);
    }];
    
    
    
    UIButton *goodsNumeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [goodsNumeBtn setBackgroundImage:[UIImage imageNamed:@"syncart_middle_btn_enable"] forState:UIControlStateNormal];
    [self addSubview:goodsNumeBtn];
    [goodsNumeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(goodsPrice.mas_bottom);
        make.right.equalTo(goodsMoreBtn.mas_left);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(35);
    }];
    
    UITextField *goodsNumField = [[UITextField alloc] init];
    goodsNumField.keyboardType = UIKeyboardTypeNumberPad;
    goodsNumField.textColor = UIcolor(@"333333");
    goodsNumField.font = YC_YAHEI_FONT(12);
    goodsNumField.textAlignment = 1;
    goodsNumField.delegate = self;
    
    
    [self addSubview:_goodsNumField =  goodsNumField];
    
    [goodsNumField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(goodsPrice.mas_bottom).offset(-1);
        make.right.equalTo(goodsMoreBtn.mas_left).offset(-1);
        make.height.mas_equalTo(23);
        make.width.mas_equalTo(33);
        
    }];
    
    UIButton *goodsLessBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [goodsLessBtn addTarget:self action:@selector(goodsCarless) forControlEvents:UIControlEventTouchUpInside];
    [goodsLessBtn setImage:[UIImage imageNamed:@"cart_less_btn_enable"]  forState:UIControlStateNormal];
    [goodsLessBtn setImage:[UIImage imageNamed:@"cart_less_btn_disable"]  forState:UIControlStateDisabled];
    [self addSubview:_goodsLessBtn =  goodsLessBtn];
    [goodsLessBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(goodsPrice.mas_bottom);
        make.right.equalTo(goodsNumeBtn.mas_left);
        make.width.height.mas_equalTo(25);
    }];
    
    UIView *lineView = [[UIView alloc] init];
//    lineView.frame = CGRectMake(0, PX_ONE, [UIScreen mainScreen].bounds.size.width, PX_ONE);
    lineView.backgroundColor = [UIColor colorWithHexString:@"dfe1e9"];
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.right.left.mas_equalTo(0);
        make.height.mas_equalTo(PX_ONE);
    }];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
//数量减1
- (void)goodsCarless{
    [MobClick event:@"ShoppingCart4"];
    if ([_goodsModel.flow_order integerValue] == 0) {
        return;
    }
    
    //数量减1
    NSString *number = _goodsNumField.text;
    NSInteger goodNumber = [number integerValue];
    goodNumber--;
    NSString * goods_number = [NSString stringWithFormat:@"%ld",goodNumber ];
    NSDictionary *reduceNumber =  @{@"model":_goodsModel,@"num":goods_number};
    
    if (self.delegate &&[self.delegate respondsToSelector:@selector(goodsNumberChange:)]) {
        [self.delegate  goodsNumberChange:reduceNumber];
    }
   
    
}
//数量加1
- (void)goodsCarMore{
    MMLog(@"2222222222");
    [MobClick event:@"ShoppingCart3"];
    if ([_goodsModel.flow_order integerValue] == 0) {
        _goodsMoreBtn.enabled = NO;
        return;
    }
 
    //数量加1
    NSString *number = _goodsNumField.text;
    NSInteger goodNumber = [number integerValue];
    goodNumber++;
    NSString * goods_number = [NSString stringWithFormat:@"%ld",goodNumber ];
    NSDictionary *reduceNumber =  @{@"model":_goodsModel,@"num":goods_number};
    if (self.delegate &&[self.delegate respondsToSelector:@selector(goodsNumberChange:)]) {
        [self.delegate  goodsNumberChange:reduceNumber];
    }
    
    
}
- (void)goodsCarClick{
    
    [MobClick event:@"ShoppingCart0"];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(click:)]) {
        [self.delegate click:_goodsModel];
    }
    
    
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (!_goodsModel) {
        return ;
    }
    NSDictionary *reduceNumber =  @{@"model":_goodsModel,@"num":_goodsNumField.text};
    if (self.delegate &&[self.delegate respondsToSelector:@selector(goodsNumberChange:)]) {
        [self.delegate  goodsNumberChange:reduceNumber];
    }
  
}

@end
