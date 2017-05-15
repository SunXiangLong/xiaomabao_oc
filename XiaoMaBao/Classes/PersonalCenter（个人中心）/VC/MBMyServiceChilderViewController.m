//
//  MBMyServiceChilderViewController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/4/5.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBMyServiceChilderViewController.h"
#import "MBMBMyServiceChilderCell.h"
#import "WNXRefresgHeader.h"
#import "MBServiceOrderController.h"

@interface MBMyServiceChilderViewController ()
{
    NSInteger _page;
    UILabel *_promptLable;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,copy) NSMutableArray<MBSerViceOrderModel *> *dataModel;
@property (nonatomic,strong) UILabel *promptLable;
@end

@implementation MBMyServiceChilderViewController
-(NSMutableArray<MBSerViceOrderModel *> *)dataModel{
    if (!_dataModel) {
        _dataModel = [NSMutableArray array];
    }
    return _dataModel;
    
}
-(UILabel *)promptLable{
    if (!_promptLable) {
        _promptLable = [[UILabel alloc] init];
        _promptLable.textAlignment = 1;
        _promptLable.font = [UIFont systemFontOfSize:14];
        _promptLable.textColor = [UIColor colorR:146 colorG:147 colorB:148];
        _promptLable.frame  = CGRectMake(0, 0, 180, 20);
        _promptLable.center = CGPointMake(UISCREEN_WIDTH/2, (UISCREEN_HEIGHT - 150)/2);
    }
    return _promptLable;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setHeadRefresh];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navBar removeFromSuperview];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.backgroundColor = [UIColor    colorWithHexString:@"ecedf1"];
    [self.tableView addSubview:self.promptLable];
    
    
}
#pragma mark --上拉加载
- (void)setFootRefres{
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    MBRefreshGifFooter *footer = [MBRefreshGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(setheadData)];
    footer.refreshingTitleHidden = YES;
    
    // 设置footer
    self.tableView.mj_footer = footer;
    
    
    
}

#pragma mark --下拉刷新
- (void)setHeadRefresh
{
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    WNXRefresgHeader *header = [WNXRefresgHeader headerWithRefreshingTarget:self refreshingAction:@selector(setRefreshData)];
    
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    
    // 隐藏状态
    header.stateLabel.hidden = YES;
    
    // 马上进入刷新状态
    [header beginRefreshing];
    
    // 设置header
    self.tableView.mj_header = header;
}
#pragma mark -- 上拉加载
- (void)setheadData{
    
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    [self show];

    [MBNetworking   POSTOrigin:string(BASE_URL_root, @"/service/my_product") parameters:@{@"session":sessiondict,@"type":self.strType,@"page":s_Integer(_page)} success:^(id responseObject) {
        [self.tableView.mj_header endRefreshing];
        [self dismiss];
        NSArray *modelArray =  [NSArray modelDictionary:responseObject modelKey:@"data" modelClassName:@"MBSerViceOrderModel"];
        if (modelArray.count > 0) {
            [_dataModel addObjectsFromArray:modelArray];
            [self.tableView reloadData];
            _page++;
        }else{
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [self show:@"请求失败 " time:1];
       
    }];
    
    
}
#pragma mark --刷新数据
- (void)setRefreshData{

    _page = 1;
    [self.dataModel removeAllObjects];
    [self.tableView.mj_footer resetNoMoreData];
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    
    [MBNetworking   POSTOrigin:string(BASE_URL_root, @"/service/my_product") parameters:@{@"session":sessiondict,@"type":self.strType,@"page":s_Integer(_page)} success:^(id responseObject) {
        [self.tableView .mj_header endRefreshing];
        [_dataModel addObjectsFromArray:[NSArray modelDictionary:responseObject modelKey:@"data" modelClassName:@"MBSerViceOrderModel"]];
        if (_dataModel.count >0) {
            _promptLable.hidden = YES;
            _page++;
            [self setFootRefres];
        }else{
            NSString *str;
            switch (self.type) {
                case 0:  str = @"待付款";break;
                case 1:  str = @"待使用";break;
                case 2:  str = @"待评价";break;
                default: str = @"售后";break;
            }
            _promptLable.hidden  = NO;
            _promptLable.text = [NSString stringWithFormat:@"没有%@的服务订单",str];
        }
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [self show:@"请求失败 " time:1];
        [self.tableView .mj_header endRefreshing];
    }];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataModel.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    if (self.type == 3) {
        return 166;
    }
      return 213;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MBMBMyServiceChilderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBMBMyServiceChilderCell" forIndexPath:indexPath];
    MBSerViceOrderModel *model = _dataModel[indexPath.row];
    model.type = self.type;
    cell.vc  = self;
    cell.model = model;
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.type != 0) {
        [MobClick event:@"ServiceOrder8"];
        
        MBServiceOrderController *VC = [[MBServiceOrderController alloc] init];
        VC.order_id = _dataModel[indexPath.row].order_id;
        [self pushViewController:VC Animated:YES];
    }
    
}



@end
