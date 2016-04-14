//
//  MBSubmitPersonalInformationViewController.m
//  XiaoMaBao
//
//  Created by 张磊 on 15/6/10.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "MBSubmitPersonalInformationViewController.h"
#import "NSString+BQ.h"
#import "MobClick.h"
@interface MBSubmitPersonalInformationViewController ()

@end

@implementation MBSubmitPersonalInformationViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MBSubmitPersonalInformationViewController"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MBSubmitPersonalInformationViewController"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
 
    
    UILabel *submitLbl = [[UILabel alloc] init];
    submitLbl.textAlignment = NSTextAlignmentCenter;
    submitLbl.textColor = [UIColor colorWithHexString:@"323232"];
    submitLbl.font = [UIFont systemFontOfSize:15];
    submitLbl.text = @"提交成功！！！";
    submitLbl.frame = CGRectMake(0, TOP_Y + 60, self.view.ml_width, 30);
    [self.view addSubview:submitLbl];
    
    UILabel *descLbl = [[UILabel alloc] init];
    descLbl.textColor = [UIColor colorWithHexString:@"b2b2b2"];
    descLbl.font = [UIFont systemFontOfSize:10];
    descLbl.numberOfLines = 0;
    descLbl.text = @"后台系统正在审核，请注意查收稍后回执。XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
    CGSize size = [descLbl.text sizeWithFont:descLbl.font withMaxSize:CGSizeMake(self.view.ml_width * 0.5, MAXFLOAT)];
    descLbl.textAlignment = NSTextAlignmentLeft;
    descLbl.frame = CGRectMake(self.view.ml_width / 4, CGRectGetMaxY(submitLbl.frame) + MARGIN_10, self.view.ml_width * 0.5, size.height);
    [self.view addSubview:descLbl];
    
}

- (NSString *)titleStr{
    return @"提交完成";
}

@end
