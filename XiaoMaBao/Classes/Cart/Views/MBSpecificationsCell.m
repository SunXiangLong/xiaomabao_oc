//
//  MBSpecificationsCell.m
//  XiaoMaBao
//
//  Created by liulianqi on 15/12/22.
//  Copyright © 2015年 HuiBei. All rights reserved.
//

#import "MBSpecificationsCell.h"

@implementation MBSpecificationsCell
{
    UIButton *_oldButton;
    UIButton *_lastButton;
    CGFloat  _offtY;
}

-(void)setUI{

    UILabel *sepceLbl = [[UILabel alloc] init];
    sepceLbl.font = [UIFont systemFontOfSize:15];
    sepceLbl.textColor = [UIColor colorWithHexString:@"b2b2b2"];
    sepceLbl.text = _dic[@"attr_name"];
    
    
    [self addSubview:sepceLbl];
    [sepceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(10);
    }];
    
    UIView *view = [[UIView alloc] init];

    [self addSubview:view];
    NSArray *array = _dic[@"goods_attr_list"];
    NSUInteger count = array.count;
    CGFloat height = 30;
    for (NSInteger i = 0; i < count; i++) {
        NSString *conter = array[i][@"goods_attr_name"];
        CGFloat width = [conter sizeWithFont:[UIFont systemFontOfSize:12] withMaxSize:CGSizeMake(MAXFLOAT, 30)].width + 10;

        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        btn.selected = NO;
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = [UIColor colorWithHexString:@"ececec"].CGColor;
        btn.layer.cornerRadius = 2;
        [btn setTitle:array[i][@"goods_attr_name"] forState:UIControlStateNormal];
        if (!_lastButton) {
           btn.frame = CGRectMake(10, _offtY+10 , width, height);
        }else{
            CGFloat X = CGRectGetMaxX(_lastButton.frame) + 5;
            if (X+width>UISCREEN_WIDTH) {
                _offtY = CGRectGetMaxY(_lastButton.frame);
               btn.frame = CGRectMake( 10, _offtY+10 , width, height);
            }else{
            
            btn.frame = CGRectMake(CGRectGetMaxX(_lastButton.frame) + 5, _offtY+10 , width, height);
            }
          
        }
       
        btn.tag = i;
        [btn addTarget:self action:@selector(clickButn:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:_lastButton = btn];
        
        
    }
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(sepceLbl.mas_bottom).offset(0);
                make.left.mas_equalTo(0);
                make.right.mas_equalTo(0);
                make.bottom.equalTo(_lastButton.mas_bottom).offset(0);
                
                
            }];
    
    
    UIView *lineview = [[UIView alloc] init];
    lineview.backgroundColor = [UIColor colorWithHexString:@"dfe1e9"];
    [self addSubview:lineview];
    [lineview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-1);
        make.height.mas_equalTo(1);
        
    }];

}
- (void)clickButn:(UIButton *)button{
    if (button.selected) {
        return;
    }
    
    if (_oldButton) {
        _oldButton.selected = NO;
        _oldButton.backgroundColor = [UIColor whiteColor];
        _oldButton.layer.borderWidth = 1;
    }
    
    if (button.selected) {
        button.selected = NO;
        button.backgroundColor = [UIColor whiteColor];
    }else{
        button.selected = YES;
        button.backgroundColor = [UIColor colorWithHexString:@"e8465e"];
        button.layer.borderWidth = 0;
        
    }
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(getDic:)]) {
        NSString *row = [NSString stringWithFormat:@"%ld",self.row];
        NSDictionary *dic = @{@"row":row,@"tag":self.dic[@"goods_attr_list"][button.tag]};
        [self.delegate getDic:dic];
    }
    _oldButton = button;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
