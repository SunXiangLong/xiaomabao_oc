//
//  MBMyCircleController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/4/26.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBMyCircleController.h"

@interface MBMyCircleController ()<SDCycleScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation MBMyCircleController
-(void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    [MobClick beginLogPageView:@"MBMyCircleController"];
}
-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    [MobClick endLogPageView:@"MBMyCircleController"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.tableHeaderView = [self setHeaderView];
}
/**
 *  广告轮播图
 *
 *  @return
 */
- (UIView *)setHeaderView{
    UIView *view =[[UIView alloc] init];
    
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH,UISCREEN_WIDTH*33/75) delegate:self     placeholderImage:[UIImage imageNamed:@"placeholder_num3"]];
    cycleScrollView.imageURLStringsGroup =@[@"",@"",@""];
    cycleScrollView.autoScrollTimeInterval = 3.0f;
    [view addSubview:cycleScrollView];
    return view;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    NSLog(@"%ld",index);
    
}

@end
