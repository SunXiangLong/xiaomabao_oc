//
//  MBSignRoleView.m
//  XiaoMaBao
//
//  Created by 朱理哲 on 15/8/27.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#define kMargin 6
#import "MBSignRoleView.h"
@interface MBSignRoleView (){
    
}
@end

@implementation MBSignRoleView

-(instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = YES ;
        self.layer.cornerRadius = 4 ;
        //小麻包签到规则
        UILabel* titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        titleLabel.textColor = [UIColor colorWithHexString:@"63a3c6"];
        titleLabel.text = @"小麻包签到规则" ;
        [self addSubview:titleLabel];
        
        //分割线
        UIView* line = [[UIView alloc] init];
        line.backgroundColor = titleLabel.textColor;
        [self addSubview:line];
        
        //内容
        NSString* content = @"1. 坚持每天签到，则每天签到能领取1个麻豆。（1麻豆＝1元）\n2. 坚持签到十天，麻豆累计到十个，可兑换为10元优惠券（全场通用无门槛）\n3. 活动最终解释权给小麻包所有" ;
        UILabel* contentLabel = [[UILabel alloc] init];
        contentLabel.numberOfLines = 0 ;
        contentLabel.font = [UIFont systemFontOfSize:12.0f];
        contentLabel.text = content ;
        [self addSubview:contentLabel];
        
        
        UIView* baseline = [[UIView alloc] init];
        baseline.backgroundColor = [UIColor lightGrayColor];
        baseline.alpha = 0.1 ;
        [self addSubview:baseline];
        
        
        UIButton* btnSure = [[UIButton alloc] init];
        btnSure.enabled = NO ;
        [btnSure setTitle:@"确定" forState:UIControlStateNormal];
        [btnSure setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addSubview:btnSure];
       [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.top.right.mas_equalTo(kMargin);
           make.height.mas_equalTo(32);
       }];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(3);
            make.top.mas_equalTo(2);
        }];
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(2);
            make.left.right.mas_equalTo(kMargin);
            make.height.mas_equalTo(80);
        }];
        [baseline mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(kMargin);
            make.top.mas_equalTo(kMargin);
            make.height.mas_equalTo(2);
            
        }];
        [btnSure mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(kMargin);
            make.left.right.mas_equalTo(kMargin);
            make.bottom.mas_equalTo(0);
            
        }];

    }
    return self ;
}



@end
