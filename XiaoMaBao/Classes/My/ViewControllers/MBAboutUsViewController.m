//
//  MBAboutUsViewController.m
//  XiaoMaBao
//
//  Created by 张磊 on 15/6/8.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "MBAboutUsViewController.h"
#import "MobClick.h"
@interface MBAboutUsViewController ()

@end

@implementation MBAboutUsViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MBAboutUsViewController"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MBAboutUsViewController"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
 
    
    UILabel *titleLbl = [[UILabel alloc] init];
    titleLbl.font = [UIFont systemFontOfSize:15];
    titleLbl.textColor = [UIColor colorWithHexString:@"323232"];
    titleLbl.frame = CGRectMake(8, MARGIN_20 + TOP_Y, self.view.ml_width - 16, 15);
    titleLbl.text = @"麻包介绍";
    [self.view addSubview:titleLbl];
    
    UILabel *descLbl = [[UILabel alloc] init];
    descLbl.numberOfLines = 0;
    descLbl.font = [UIFont systemFontOfSize:12];
    descLbl.textColor = [UIColor colorWithHexString:@"b2b2b2"];
    descLbl.frame = CGRectMake(8, CGRectGetMaxY(titleLbl.frame) + MARGIN_10, self.view.ml_width - 16, 110);
    descLbl.text = @"小麻包平台理念\n以“进口母婴品牌”为定位；\n以“一站式购物体验”为基础；\n以“专业的育儿咨询方式进行导购和运营”为服务理念；\n以“线上购物、线下体验”的新型购物模式；\n以“限时购物，妈妈精品团，会员特惠”等特有模式进行营销；\n以“最大展示机会给品牌商和设计师，和最大优惠给每个家庭”为销售理念。";
    [self.view addSubview:descLbl];
}

- (NSString *)titleStr{
    return @"关于麻包";
}

@end
