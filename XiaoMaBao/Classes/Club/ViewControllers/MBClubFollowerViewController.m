//
//  MBClubFollowerViewController.m
//  XiaoMaBao
//
//  Created by 张磊 on 15/6/15.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "MBClubFollowerViewController.h"
#import "MBClubFollowerTableViewCell.h"
#import "MBClubFollowerViewController.h"
#import "MobClick.h"
@interface MBClubFollowerViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation MBClubFollowerViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MBClubFollowerViewController"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MBClubFollowerViewController"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [tableView registerNib:[UINib nibWithNibName:@"MBClubFollowerTableViewCell" bundle:nil] forCellReuseIdentifier:@"MBClubFollowerTableViewCell"];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.frame = CGRectMake(0, TOP_Y, self.view.ml_width, self.view.ml_height - TOP_Y);
    tableView.dataSource = self, tableView.delegate = self;
    [self.view addSubview:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"MBClubFollowerTableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (![cell.contentView viewWithTag:'BOTTOM_LINE']) {
        [self addBottomLineView:cell.contentView];
    }
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 53;
}

- (NSString *)titleStr{
    return @"粉 丝";
}

@end
