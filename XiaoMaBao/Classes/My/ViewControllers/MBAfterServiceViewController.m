//
//  MBAfterServiceViewController.m
//  XiaoMaBao
//
//  Created by 张磊 on 15/6/9.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "MBAfterServiceViewController.h"
#import "MBSendAfterServiceViewController.h"
#import "MobClick.h"
@interface MBAfterServiceViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak,nonatomic) UIView *lineView;
@property (weak,nonatomic) UITableView *tableView;
@end

@implementation MBAfterServiceViewController

- (UITableView *)tableView{
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, TOP_Y + 68 + MARGIN_10, self.view.ml_width, self.view.ml_height - TOP_Y - 78) style:UITableViewStyleGrouped];
        tableView.contentInset = UIEdgeInsetsMake(MARGIN_8, 0, 0, 0);
        tableView.backgroundColor = [UIColor clearColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView registerNib:[UINib nibWithNibName:@"MBAfterServiceTableViewCell" bundle:nil] forCellReuseIdentifier:@"MBAfterServiceTableViewCell"];
        tableView.dataSource = self,tableView.delegate = self;
        tableView.tableFooterView = [[UIView alloc] init];
        [self.view addSubview:_tableView = tableView];
    }
    return _tableView;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MBAfterServiceViewController"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MBAfterServiceViewController"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIView *serviceView = [[UIView alloc] init];
    serviceView.frame = CGRectMake(0, TOP_Y, self.view.ml_width, 58);
    serviceView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:serviceView];
    
    UIView *searchView = [[UIView alloc] init];
    searchView.frame = CGRectMake((self.view.ml_width - 200) * 0.5, TOP_Y + MARGIN_20, 200, 20);
    [self.view addSubview:searchView];
    
    UITextField *searchFieldVc = [[UITextField alloc] init];
    searchFieldVc.frame = CGRectMake(8,0,searchView.ml_width - 8, searchView.ml_height);
    searchFieldVc.placeholder = @"点击搜素...";
    searchFieldVc.font = [UIFont systemFontOfSize:12];
    [searchView addSubview:searchFieldVc];
    
    searchView.backgroundColor = [UIColor colorWithHexString:@"d7d7d7"];
    searchView.layer.cornerRadius = 10;
    
    NSArray *titles = @[
                        @"全部订单",
                        @"已申请"
                        ];
    CGFloat width = self.view.ml_width / titles.count;
    
    UIView *menuView = [[UIView alloc] init];
    menuView.backgroundColor = [UIColor whiteColor];
    menuView.frame = CGRectMake(0, CGRectGetMaxY(searchView.frame) + MARGIN_10, self.view.ml_width, 25);
    [self.view addSubview:menuView];
    
    for (NSInteger i = 0; i < titles.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        [btn setTitleColor:[UIColor colorWithHexString:@"313232"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        btn.frame = CGRectMake(i * width, 0, width, 25);
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
        [menuView addSubview:btn];
        if (i == 0) {
            [self clickItem:btn];
        }
    }
    
    UIView *lineView = [[UIView alloc] init];
    lineView.frame = CGRectMake(0, menuView.ml_height - 1, width, 1);
    lineView.backgroundColor = [UIColor colorWithHexString:@"2ba390"];
    [menuView addSubview:_lineView = lineView];
    
    
}

- (void)clickItem:(UIButton *)btn{
    if (btn.tag == 0) {
        [self.tableView reloadData];
    }
    [UIView animateWithDuration:.25 animations:^{
        self.lineView.ml_x = btn.tag * self.view.ml_width * 0.5;
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"MBAfterServiceTableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *sectionView = [[UIView alloc] init];
    sectionView.frame = CGRectMake(0, 0, self.view.ml_width, 15);
    sectionView.backgroundColor = [UIColor colorWithHexString:@"2ba390"];
    
    UILabel *sectionLbl = [[UILabel alloc] init];
    sectionLbl.textColor = [UIColor whiteColor];
    sectionLbl.text = @"订单号：100100100100";
    sectionLbl.frame = CGRectMake(8, 0, self.view.ml_width - 16, sectionView.ml_height);
    sectionLbl.font = [UIFont systemFontOfSize:12];
    [sectionView addSubview:sectionLbl];
    
    return sectionView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = BG_COLOR;
    footerView.frame = CGRectMake(0, 0, self.view.ml_width, 20);
    
    UIView *footerMainView = [[UIView alloc] init];
    footerMainView.backgroundColor = [UIColor whiteColor];
    footerMainView.frame = CGRectMake(0, 0, self.view.ml_width, 20);
    [footerView addSubview:footerMainView];
    
    UILabel *footerLbl = [[UILabel alloc] init];
    footerLbl.textColor = [UIColor colorWithHexString:@"323232"];
    footerLbl.text = @"总计：";
    footerLbl.frame = CGRectMake(8, 0, 50, footerView.ml_height);
    footerLbl.font = [UIFont systemFontOfSize:12];
    [footerMainView addSubview:footerLbl];
    
    UILabel *priceLbl = [[UILabel alloc] init];
    priceLbl.textColor = [UIColor colorWithHexString:@"da465a"];
    priceLbl.text = @"￥1900";
    priceLbl.frame = CGRectMake(CGRectGetMaxX(footerLbl.frame), 0, 150, footerView.ml_height);
    priceLbl.font = [UIFont systemFontOfSize:12];
    [footerMainView addSubview:priceLbl];
    
    UIButton *sendServiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendServiceBtn.frame = CGRectMake(self.view.ml_width - 8 - 60, (footerView.ml_height - 15) * 0.5, 60, 15);
    [sendServiceBtn setTitleColor:[UIColor colorWithHexString:@"2ba390"] forState:UIControlStateNormal];
    sendServiceBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [sendServiceBtn setTitle:@"申请售后" forState:UIControlStateNormal];
    sendServiceBtn.layer.cornerRadius = 3.0;
    [sendServiceBtn addTarget:self action:@selector(tapAfterServiceVc) forControlEvents:UIControlEventTouchUpInside];
    sendServiceBtn.layer.borderColor = [UIColor colorWithHexString:@"2ba390"].CGColor;
    sendServiceBtn.layer.borderWidth = PX_ONE;
    [footerMainView addSubview:sendServiceBtn];
    
    return footerView;
}

- (void)tapAfterServiceVc{
    MBSendAfterServiceViewController *serviceVc = [[MBSendAfterServiceViewController alloc] init];
    [self.navigationController pushViewController:serviceVc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 30;
}

- (NSString *)titleStr{
    return @"售后服务";
}

@end
