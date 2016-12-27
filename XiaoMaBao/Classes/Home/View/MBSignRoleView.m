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
        NSString* content = @"1、每天签到能领取10个麻豆奖励，签到成功麻豆奖励直接放入您的账户中，可享受小麻包平台的所有麻豆优惠政策。\n2、如因不可抗力、大面积作弊等情况导致难以继续开展本活动，小麻包可觉得取消、修改或暂停本活动，法律法规许可范围内，小麻包有权对活动进行解释。" ;
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
            make.top.mas_equalTo(titleLabel.mas_bottom).offset(0);
        }];
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(line.mas_bottom).offset(2);
            make.left.right.mas_equalTo(kMargin);
            make.height.mas_equalTo(80);
        }];
        [baseline mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(kMargin);
            make.top.mas_equalTo(contentLabel.mas_bottom).offset(kMargin);
            make.height.mas_equalTo(2);
            
        }];
        [btnSure mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(baseline.mas_bottom).offset(kMargin);
            make.left.right.mas_equalTo(kMargin);
            make.bottom.mas_equalTo(0);
            
        }];

    }
    return self ;
}



@end
