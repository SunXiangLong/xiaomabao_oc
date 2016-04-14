//
//  MBSignRoleView.m
//  XiaoMaBao
//
//  Created by 朱理哲 on 15/8/27.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#define kMargin 6
#import "MBSignRoleView.h"
#import "PureLayout.h"

@interface MBSignRoleView (){
    
}

@property(weak,nonatomic)UILabel* titleLabel;
@property(weak,nonatomic)UIView* line;
@property(weak,nonatomic)UILabel* contentLabel;
@property(weak,nonatomic)UIView* baseline;
@property(weak,nonatomic)UIButton* btnSure;

@property(assign,nonatomic)BOOL didUpdateConstraints;


@end

@implementation MBSignRoleView

-(instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = YES ;
        self.layer.cornerRadius = 4 ;
        //小麻包签到规则
        UILabel* titleLabel = [UILabel newAutoLayoutView];
        titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        titleLabel.textColor = [UIColor colorWithHexString:@"63a3c6"];
        titleLabel.text = @"小麻包签到规则" ;
        [self addSubview:titleLabel];
        self.titleLabel = titleLabel ;
        //分割线
        UIView* line = [UIView newAutoLayoutView];
        line.backgroundColor = titleLabel.textColor;
        [self addSubview:line];
        self.line = line ;

        //内容
        NSString* content = @"1. 坚持每天签到，则每天签到能领取1个麻豆。（1麻豆＝1元）\n2. 坚持签到十天，麻豆累计到十个，可兑换为10元优惠券（全场通用无门槛）\n3. 活动最终解释权给小麻包所有" ;
        UILabel* contentLabel = [UILabel newAutoLayoutView];
        contentLabel.numberOfLines = 0 ;
        contentLabel.font = [UIFont systemFontOfSize:12.0f];
        contentLabel.text = content ;
        [self addSubview:contentLabel];
        self.contentLabel = contentLabel ;
        
        UIView* baseline = [UIView newAutoLayoutView];
        baseline.backgroundColor = [UIColor lightGrayColor];
        baseline.alpha = 0.1 ;
        [self addSubview:baseline];
        self.baseline = baseline ;
        
        UIButton* btnSure = [UIButton newAutoLayoutView];
        btnSure.enabled = NO ;
        [btnSure setTitle:@"确定" forState:UIControlStateNormal];
        [btnSure setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addSubview:btnSure];
        self.btnSure = btnSure ;
        
        [self updateConstraints];
    }
    return self ;
}


-(void)updateConstraints{
    if (!self.didUpdateConstraints) {
        [self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kMargin];
        [self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kMargin];
        [self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kMargin];
        [self.titleLabel autoSetDimension:ALDimensionHeight toSize:32];
        
        [self.line autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.titleLabel withOffset:kMargin/2];
        [self.line autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:0];
        [self.line autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:0];
        [self.line autoSetDimension:ALDimensionHeight toSize:2];
        
        [self.contentLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.titleLabel withOffset:kMargin];
        [self.contentLabel autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kMargin];
        [self.contentLabel autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kMargin];
        [self.contentLabel autoSetDimension:ALDimensionHeight toSize:80];
        
        [self.baseline autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.contentLabel withOffset:kMargin];
        [self.baseline autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kMargin];
        [self.baseline autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kMargin];
        [self.baseline autoSetDimension:ALDimensionHeight toSize:2];
        
        [self.btnSure autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.baseline withOffset:kMargin];
        [self.btnSure autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kMargin];
        [self.btnSure autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kMargin];
        [self.btnSure autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
        
        self.didUpdateConstraints = YES ;
    }
    [super updateConstraints];
}
@end
