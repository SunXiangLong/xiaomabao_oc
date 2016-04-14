//
//  MBClubStartsViewController.m
//  XiaoMaBao
//
//  Created by 张磊 on 15/6/15.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "MBClubStartsViewController.h"
#import "MBClubFollowerTableViewCell.h"
#import "MobClick.h"
@interface MBClubStartsViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation MBClubStartsViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MBClubStartsViewController"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MBClubStartsViewController"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor clearColor];
    [tableView registerNib:[UINib nibWithNibName:@"MBClubFollowerTableViewCell" bundle:nil] forCellReuseIdentifier:@"MBClubFollowerTableViewCell"];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.frame = CGRectMake(0, TOP_Y, self.view.ml_width, self.view.ml_height - TOP_Y);
    tableView.dataSource = self, tableView.delegate = self;
    [self.view addSubview:tableView];
    
    tableView.tableFooterView = [self footerView];
    
    UIView *searchView = [[UIView alloc] init];
    searchView.backgroundColor = [UIColor colorWithHexString:@"d9dfe5"];
    searchView.frame = CGRectMake(0, 0, self.view.ml_width, 40);
    
    UITextField *field = [[UITextField alloc] init];
    field.frame = CGRectMake(12, 10, self.view.ml_width - 24, 20);
    field.placeholder = @"    搜索...";
    field.backgroundColor = [UIColor whiteColor];
    field.font = [UIFont systemFontOfSize:14];
    field.layer.cornerRadius = 10;
    
    [searchView addSubview:field];
    
    tableView.tableHeaderView = searchView;
}

- (UIView *)footerView{
    UIView *footerView = [[UIView alloc] init];
    footerView.frame = CGRectMake(0, 0, self.view.ml_width, 120);
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"这里有更多的麻包达人,去看看吧~" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    btn.frame = CGRectMake(75, 75, self.view.ml_width - 150, 28);
    btn.backgroundColor = [UIColor colorWithHexString:@"63a3c6"];
    btn.layer.cornerRadius = 14;
    [footerView addSubview:btn];
    
    return footerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"MBClubFollowerTableViewCell";
    
    MBClubFollowerTableViewCell *cell = (MBClubFollowerTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell.isStart) {
        cell.isStart = YES;
    }
    if (![cell.contentView viewWithTag:'BOTTOM_LINE']) {
        [self addBottomLineView:cell.contentView];
    }
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 53;
}

- (NSString *)titleStr{
    return @"关 注";
}

@end
