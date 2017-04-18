//
//  MBDiscountCell.m
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/3/1.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "MBDiscountCell.h"
@interface MBDiscountCell() <UITextFieldDelegate>
{
    BOOL _next;
    UILabel *_nameLabel;
    UILabel *_priceLabel;
    UIImageView *_imageView;
    NSString *_name;
}
@end
@implementation MBDiscountCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setUpUI];
        
    }
    
    return self;
}

-(void)setPrice:(NSString *)price{
    _price = price;
    if (_isnote) {
        _textField.text = price;
    }else{
       _priceLabel.text = price;
    }
    
}
-(void)setName:(NSString *)name{
    _name = name;
    _nameLabel.text = _name;
}
-(void)setIsnext:(BOOL)isnext{
    _isnext=  isnext;
    _imageView.hidden = !isnext;
    
    if (_isnext) {

        [_priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
           make.right.equalTo(_imageView.mas_left).offset(-10);
        }];
    }else{
        [_priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.right.mas_equalTo(-10);
        }];
    
    }
}
-(void)setIsnote:(BOOL)isnote{
    _isnote = isnote;
    _textField.hidden = !_isnote;
}
- (void)setUpUI{
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = SYSTEMFONT(12);
    nameLabel.textColor = UIcolor(@"686868");
    [self addSubview:_nameLabel = nameLabel];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.mas_equalTo(10);
    }];
    
    
    UIImageView *imageview = [[UIImageView alloc ]initWithImage:[UIImage imageNamed:@"next"]];
    imageview.hidden = true;
    [self addSubview:_imageView = imageview];
    [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(16);
        make.width.mas_equalTo(16);
        
    }];
    
    UILabel *pricelabel =[[UILabel alloc] init];
    pricelabel.font = SYSTEMFONT(12);
    pricelabel.textColor = UIcolor(@"303030");
    [self addSubview:_priceLabel = pricelabel];
    
    [pricelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(imageview.mas_left).offset(-10);
        
        
    }];
    [_nameLabel  layoutIfNeeded];

    UITextField *textField = [[UITextField alloc] init];
    textField.placeholder   = @"请输入备注信息";
    textField.font =  SYSTEMFONT(14);
    [self addSubview:_textField = textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(_nameLabel.mas_right);
        make.width.mas_equalTo(UISCREEN_WIDTH - _nameLabel.right);
        make.height.mas_equalTo(40);
    }];
    
    
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
