//
//  MBSendAfterServiceViewController.m
//  XiaoMaBao
//
//  Created by 张磊 on 15/6/10.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "MBSendAfterServiceViewController.h"
#import "MBPersonalInformationViewController.h"
#import "MobClick.h"
@interface MBSendAfterServiceViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation MBSendAfterServiceViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MBSendAfterServiceViewController"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MBSendAfterServiceViewController"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
   
    
    UITableView *tableView = [[UITableView alloc] init];
    tableView.frame = CGRectMake(0, TOP_Y, self.view.ml_width, self.view.ml_height - TOP_Y);
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerNib:[UINib nibWithNibName:@"MBAfterServiceTableViewCell" bundle:nil] forCellReuseIdentifier:@"MBAfterServiceTableViewCell"];
    tableView.dataSource = self,tableView.delegate = self;
    [self.view addSubview:tableView];
    
    tableView.tableFooterView = [self footerView];
    
}

- (UIView *)footerView{
    
    UIView *footerView = [[UIView alloc] init];
    footerView.frame = CGRectMake(0, 0, self.view.ml_width, 300);
    
    
    NSArray *types = @[
                       @"申请类型",
                       @"申请数量",
                       @"申请凭证",
                       @"检测报告",
                       @"问题描述",
                       @"上传图片"
                       ];
    
    for (NSInteger i = 0; i < types.count; i++) {
        UIView *typeView = [[UIView alloc] init];
        typeView.frame = CGRectMake(0, CGRectGetMaxY([[[footerView subviews] lastObject] frame]) + MARGIN_5, self.view.ml_width, 55);
        [footerView addSubview:typeView];
        
        UILabel *applyLbl = [[UILabel alloc] init];
        applyLbl.frame = CGRectMake(MARGIN_8, 0, self.view.ml_width - MARGIN_20, 20);
        applyLbl.textColor = [UIColor colorWithHexString:@"323232"];
        applyLbl.font = [UIFont systemFontOfSize:15];
        applyLbl.text = types[i];
        [typeView addSubview:applyLbl];
        
        if (i == 0) {
            NSArray *titles = @[
                                @"维修",
                                @"换货",
                                @"退货"
                                ];
            for (NSInteger i = 0; i < titles.count; i++) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                [btn setTitleColor:[UIColor colorWithHexString:@"2ba390"] forState:UIControlStateNormal];
                btn.titleLabel.font = [UIFont systemFontOfSize:12];
                btn.frame = CGRectMake( (i * (45 + MARGIN_8) + MARGIN_8), CGRectGetMaxY(applyLbl.frame) + MARGIN_8, 45, 15);
                [btn setTitle:titles[i] forState:UIControlStateNormal];
                [typeView addSubview:btn];
                
                btn.layer.cornerRadius = 3.0;
                btn.layer.borderColor = [UIColor colorWithHexString:@"2ba390"].CGColor;
                btn.layer.borderWidth = PX_ONE;
            }
        }else if (i == 1){
            UIButton *minusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            minusBtn.frame = CGRectMake(MARGIN_8, CGRectGetMaxY(applyLbl.frame) + MARGIN_8, 15, 15);
            [minusBtn setImage:[UIImage imageNamed:@"minus"] forState:UIControlStateNormal];
            [typeView addSubview:minusBtn];
            
            UILabel *numberLbl = [[UILabel alloc] init];
            numberLbl.frame = CGRectMake(CGRectGetMaxX(minusBtn.frame) + MARGIN_5, CGRectGetMaxY(applyLbl.frame) + MARGIN_8, 12, 15);
            numberLbl.text = @"1";
            numberLbl.font = [UIFont systemFontOfSize:12];
            [typeView addSubview:numberLbl];
            
            UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            addBtn.frame = CGRectMake(CGRectGetMaxX(numberLbl.frame), CGRectGetMaxY(applyLbl.frame) + MARGIN_8, 15, 15);
            [addBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
            [typeView addSubview:addBtn];
        }else if (i == 2){
            
            UIButton *yesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            yesBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            yesBtn.titleEdgeInsets = UIEdgeInsetsMake(0, MARGIN_5, 0, 0);
            [yesBtn setImage:[UIImage imageNamed:@"pitch_no"] forState:UIControlStateNormal];
            [yesBtn setTitleColor:[UIColor colorWithHexString:@"323232"] forState:UIControlStateNormal];
            yesBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            yesBtn.frame = CGRectMake(MARGIN_8, CGRectGetMaxY(applyLbl.frame) + MARGIN_8, 100, 15);
            [yesBtn setTitle:@"有发票" forState:UIControlStateNormal];
            [typeView addSubview:yesBtn];
            
            UIButton *noBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            noBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            noBtn.titleEdgeInsets = UIEdgeInsetsMake(0, MARGIN_5, 0, 0);
            [noBtn setImage:[UIImage imageNamed:@"pitch_on"] forState:UIControlStateNormal];
            [noBtn setTitleColor:[UIColor colorWithHexString:@"323232"] forState:UIControlStateNormal];
            noBtn.frame = CGRectMake(CGRectGetMaxX(yesBtn.frame), CGRectGetMaxY(applyLbl.frame) + MARGIN_8, 100, 15);
            noBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            [noBtn setTitle:@"无发票" forState:UIControlStateNormal];
            [typeView addSubview:noBtn];
            
        }else if (i == 3){
            UIButton *yesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            yesBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            yesBtn.titleEdgeInsets = UIEdgeInsetsMake(0, MARGIN_5, 0, 0);
            [yesBtn setImage:[UIImage imageNamed:@"pitch_no"] forState:UIControlStateNormal];
            [yesBtn setTitleColor:[UIColor colorWithHexString:@"323232"] forState:UIControlStateNormal];
            yesBtn.frame = CGRectMake(MARGIN_8, CGRectGetMaxY(applyLbl.frame) + MARGIN_8, 100, 15);
            yesBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            [yesBtn setTitle:@"有检测报告" forState:UIControlStateNormal];
            [typeView addSubview:yesBtn];
            
            UIButton *noBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            noBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            noBtn.titleEdgeInsets = UIEdgeInsetsMake(0, MARGIN_5, 0, 0);
            [noBtn setImage:[UIImage imageNamed:@"pitch_on"] forState:UIControlStateNormal];
            [noBtn setTitleColor:[UIColor colorWithHexString:@"323232"] forState:UIControlStateNormal];
            noBtn.frame = CGRectMake(CGRectGetMaxX(yesBtn.frame), CGRectGetMaxY(applyLbl.frame) + MARGIN_8, 100, 15);
            noBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            [noBtn setTitle:@"无检测报告" forState:UIControlStateNormal];
            [typeView addSubview:noBtn];
        }else if (i == 4){
            UITextView *textView = [[UITextView alloc] init];
            textView.frame = CGRectMake(MARGIN_8, CGRectGetMaxY(applyLbl.frame) + MARGIN_5, self.view.ml_width - MARGIN_20, 75);
            textView.layer.cornerRadius = 3.0;
            textView.layer.borderColor = [UIColor colorWithHexString:@"b2b2b2"].CGColor;
            textView.layer.borderWidth = PX_ONE;
            [typeView addSubview:textView];
            
            typeView.ml_height = 110;
        }else if (i == 5){
            
        }
        
        [self addBottomLineView:typeView];
    }
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame = CGRectMake(35, CGRectGetMaxY([[footerView.subviews lastObject] frame]) + 25, self.view.ml_width - 70, 35);
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    nextBtn.backgroundColor = [UIColor colorWithHexString:@"2ba390"];
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    nextBtn.layer.cornerRadius = 17;
    [nextBtn addTarget:self action:@selector(goPersonalVc) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:nextBtn];
    
    footerView.ml_height = CGRectGetMaxY([[footerView.subviews lastObject] frame]);
    
    return footerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"MBAfterServiceTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (void)goPersonalVc{
    MBPersonalInformationViewController *personalVc = [[MBPersonalInformationViewController alloc] init];
    [self.navigationController pushViewController:personalVc animated:YES];
}

- (NSString *)titleStr{
    return @"申请售后服务";
}

@end
