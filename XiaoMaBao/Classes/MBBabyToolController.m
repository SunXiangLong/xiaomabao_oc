//
//  MBBabyToolController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/6/2.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBBabyToolController.h"
#import "MBBabyToolCell.h"
@interface MBBabyToolController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation MBBabyToolController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MBBabyToolCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBBabyToolCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MBBabyToolCell"owner:nil options:nil]firstObject];
    }
    [self setUIEdgeInsetsZero:cell];
    
    return cell;
    
}
/**
 *  让cell地下的边线挨着左边界
 */
- (void)setUIEdgeInsetsZero:(UITableViewCell *)cell{
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins   = false;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}



@end
