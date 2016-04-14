//
//  MBPersonalInformationViewController.m
//  XiaoMaBao
//
//  Created by 张磊 on 15/6/10.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "MBPersonalInformationViewController.h"
#import "MBSubmitPersonalInformationViewController.h"
#import "MobClick.h"
@interface MBPersonalInformationViewController ()

@end

@implementation MBPersonalInformationViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"PageOne"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"PageOne"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
   
    
    UIView *typeView = [[UIView alloc] init];
    typeView.frame = CGRectMake(0, TOP_Y + MARGIN_8, self.view.ml_width, 60);
    [self.view addSubview:typeView];
    
    UILabel *applyLbl = [[UILabel alloc] init];
    applyLbl.frame = CGRectMake(MARGIN_8, 0, self.view.ml_width - MARGIN_20, 20);
    applyLbl.textColor = [UIColor colorWithHexString:@"323232"];
    applyLbl.font = [UIFont systemFontOfSize:15];
    applyLbl.text = @"商品返回方式";
    [typeView addSubview:applyLbl];
    
    NSArray *titles = @[
                        @"送货至自提点",
                        @"快递到小麻包",
                        @"上门取件"
                        ];
    for (NSInteger i = 0; i < titles.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitleColor:[UIColor colorWithHexString:@"2ba390"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        btn.frame = CGRectMake( (i * (85 + MARGIN_8) + MARGIN_8), CGRectGetMaxY(applyLbl.frame) + MARGIN_8, 85, 15);
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [typeView addSubview:btn];
        
        btn.layer.cornerRadius = 3.0;
        btn.layer.borderColor = [UIColor colorWithHexString:@"2ba390"].CGColor;
        btn.layer.borderWidth = PX_ONE;
    }
    
    [self addBottomLineView:typeView];
    
    NSArray *fieldTitles = @[
                             @"联  系  人：",
                             @"联系电话：",
                             @"收货地址：",
                             @""
                             ];
    for (NSInteger i = 0; i < fieldTitles.count; i++) {
        UILabel *titleLbl = [[UILabel alloc] init];
        titleLbl.font = [UIFont systemFontOfSize:13];
        titleLbl.text = fieldTitles[i];
        titleLbl.frame = CGRectMake(MARGIN_8, CGRectGetMaxY([[[self.view subviews] lastObject] frame]) + MARGIN_8, 70, 15);
        [self.view addSubview:titleLbl];
        
        UITextField *textFld = [[UITextField alloc] init];
        textFld.frame = CGRectMake(CGRectGetMaxX(titleLbl.frame) + MARGIN_5, titleLbl.ml_y, 150, 20);
        textFld.layer.cornerRadius = 3.0;
        textFld.layer.borderColor = [UIColor colorWithHexString:@"b2b2b2"].CGColor;
        textFld.layer.borderWidth = PX_ONE;
        textFld.font = [UIFont systemFontOfSize:12];
        [self.view addSubview:textFld];
    }
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame = CGRectMake(35, CGRectGetMaxY([[self.view.subviews lastObject] frame]) + 25, self.view.ml_width - 70, 35);
    [nextBtn setTitle:@"提交" forState:UIControlStateNormal];
    nextBtn.backgroundColor = [UIColor colorWithHexString:@"2ba390"];
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    nextBtn.layer.cornerRadius = 17;
    [nextBtn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
    
}

- (void)submit{
    MBSubmitPersonalInformationViewController *infoVc = [[MBSubmitPersonalInformationViewController alloc] init];
    [self.navigationController pushViewController:infoVc animated:YES];
}

- (NSString *)titleStr{
    return @"填写个人信息";
}

@end
