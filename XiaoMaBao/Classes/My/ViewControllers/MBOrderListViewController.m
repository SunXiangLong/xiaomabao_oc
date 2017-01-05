//
//  MBOrderListViewController.m
//  XiaoMaBao
//
//  Created by 张磊 on 15/6/8.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "MBOrderListViewController.h"
#import "MBOrderInfoTableViewController.h"
#import "MBSignaltonTool.h"
#import "MBAfterServiceTableViewCell.h"
#import "MBPaymentViewController.h"
#import "MBAfterServiceCell.h"
#import "MBOrderCell.h"
#import "MBEvaluationController.h"
#import "MBLogisticsViewController.h"
#import "MBShopingViewController.h"
#import "WNXRefresgHeader.h"
#import "MBAfterSalesServiceViewController.h"
#import "MBDeliveryInformationViewController.h"
#import "MBRefundScheduleViewController.h"
#import "MBOrderInfoTableViewController.h"
#import "MBOrderModel.h"
@interface MBOrderListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIButton *_lastButton;
    UILabel *_promptLable;
    NSString *_type;
    NSInteger _page;
}
@property (strong,nonatomic) UIView *menuView;
@property (weak,nonatomic) UIView *menuLineView;
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSMutableArray *orderListArray;
@property (strong,nonatomic) NSArray *types;
@property (strong,nonatomic) NSArray *titles;
@end

@implementation MBOrderListViewController

- (NSMutableArray *)orderListArray{
    if (!_orderListArray) {
        _orderListArray = [NSMutableArray array];
    }
    return _orderListArray;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    _types = @[
               @"all",
               @"await_pay",
               @"await_ship",
               @"shipped",
               @"finished"
               ];
    
    _titles = @[
                @"全部",
                @"待付款",
                @"待发货",
                @"待收货",
                @"已完成"
                ];
    _page = 1;
    [self setupMenuView];
    [self setupTableView];
    [self setFootRefres];
    if(self.order_status_tag)
    {
        [self tabMenuClick:_order_status_tag];
    }else{
        _type = _types.firstObject;
        [self getOrderListInfo];
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MBEvaluationController:) name:@"MBEvaluationController" object:nil];
    
}

#pragma mark --上拉加载
- (void)setFootRefres{
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    MBRefreshGifFooter *footer = [MBRefreshGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(getOrderListInfo)];
    
    // 当上拉刷新控件出现50%时（出现一半），就会自动刷新。这个值默认是1.0（也就是上拉刷新100%出现时，才会自动刷新）
    //    footer.triggerAutomaticallyRefreshPercent = 0.5;
    
    // 隐藏刷新状态的文字
    footer.refreshingTitleHidden = YES;
    
    // 设置footer
    self.tableView.mj_footer = footer;
    
    
    
}

//#pragma mark --下拉刷新
//- (void)setHeadRefresh
//{
//    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
//    WNXRefresgHeader *header = [WNXRefresgHeader headerWithRefreshingTarget:self refreshingAction:@selector(setRefreshData)];
//    
//    // 隐藏时间
//    header.lastUpdatedTimeLabel.hidden = YES;
//    
//    // 隐藏状态
//    header.stateLabel.hidden = YES;
//    
//    // 马上进入刷新状态
//    [header beginRefreshing];
//    
//    // 设置header
//    self.tableView.mj_header = header;
//}
- (void)MBEvaluationController:(NSNotification *)notificat{
    

    NSInteger section = [notificat.userInfo[@"section"] integerValue];
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:section];
    [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(void)tabMenuClick:(NSInteger)tag{
    [UIView animateWithDuration:.25 animations:^{
        CGFloat width = self.view.ml_width / _titles.count;
        self.menuLineView.ml_x = tag * width;
        //重新请求服务器数据
        _type = _types[tag];
        [self getOrderListInfo];
    }];
}

-(void)setupMenuView{
    if(_menuView == nil){
        CGFloat width = self.view.ml_width / _titles.count;
        _menuView = [[UIView alloc] init];
        _menuView.backgroundColor = [UIColor whiteColor];
        _menuView.frame = CGRectMake(0, TOP_Y, self.view.ml_width, 34);
        
        [self.view addSubview:_menuView];
        
        for (NSInteger i = 0; i < _titles.count; i++) {
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitleColor:[UIColor colorWithHexString:@"313232"] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            btn.frame = CGRectMake(i * width, 0, width, 34);
            [btn setTitle:_titles[i] forState:UIControlStateNormal];
            [_menuView addSubview:btn];
            btn.tag = i;
            [self addBottomLineView:btn];
            [btn addTarget:self action:@selector(menuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            if (i==0) {
                [btn setTitleColor:[UIColor colorR:255 colorG:78 colorB:136] forState:UIControlStateNormal];
                _lastButton = btn;
            }
        }
        
        UIView *lineView = [[UIView alloc] init];
        lineView.frame = CGRectMake(0, _menuView.ml_height - 1, width, 1);
        lineView.backgroundColor = [UIColor colorR:255 colorG:78 colorB:136];
        [_menuView addSubview:_menuLineView = lineView];
    }
    
}
-(void)getOrderListInfo
{
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    NSDictionary *paginationDict = @{@"page":s_Integer(_page),@"count":@"10"};
    
    [self show];
    [MBNetworking POSTOrigin:string(BASE_URL_root, @"/order/order_list_new") parameters:@{@"session":sessiondict,@"pagination":paginationDict,@"type":_type} success:^(id responseObject) {
        [self dismiss];
        [self.tableView .mj_footer endRefreshing];
        MMLog(@"成功获取搜索退换货订单信息---responseObject%@",responseObject);
        if ([[responseObject valueForKeyPath:@"data"] count] > 0) {
            [self.orderListArray addObjectsFromArray:[NSArray modelDictionary:responseObject modelKey:@"data" modelClassName:@"MBOrderModel"]];
            
            _page++;
            [_tableView reloadData];
            
            
        }else{
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            if (self.orderListArray.count == 0) {
                _promptLable.hidden  = NO;
                _promptLable.text = [NSString stringWithFormat:@"还没有%@的订单",_lastButton.titleLabel.text];
                
            }
            return ;
        }
        if (self.orderListArray.count == 0) {
            _promptLable.hidden  = NO;
            _promptLable.text = [NSString stringWithFormat:@"还没有%@的订单",_lastButton.titleLabel.text];
            
        }else{
            _promptLable.hidden = YES;
            
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
         [self show:@"请求失败" time:1];
    }];

    
}
- (void)setupTableView{
    if(!_tableView ){
        UITableView *tableView = [[UITableView alloc] initWithFrame: CGRectMake(0,34 + TOP_Y, self.view.ml_width, self.view.ml_height - CGRectGetMaxY(_menuView.frame)) style:UITableViewStyleGrouped];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.dataSource = self,
        tableView.delegate = self;
        tableView.backgroundColor =   [UIColor colorWithHexString:@"f2f3f7"];
        [self.view addSubview:_tableView = tableView];
        
        
        _promptLable = [[UILabel alloc] init];
        _promptLable.textAlignment = 1;
        _promptLable.font = [UIFont systemFontOfSize:14];
        _promptLable.textColor = [UIColor colorR:146 colorG:147 colorB:148];
        [self.tableView addSubview:_promptLable];
        [_promptLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.tableView.mas_centerX);
            make.centerY.equalTo(self.tableView.mas_centerY);
        }];
    }else{
        [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
        [_tableView reloadData];
        
        
    }
    
    
}
-(NSString *)getOrderStatusName:(NSString *)order_status{
    if(order_status == nil || (NSNull *)order_status == [NSNull null] )
        return @"";
    if([order_status isEqualToString:@"await_pay"]){
        return @"待付款";
    }else if([order_status isEqualToString:@"await_ship"]){
        return @"待发货";
    }else if([order_status isEqualToString:@"shipped"]){
        return @"待收货";
    }else if([order_status isEqualToString:@"finished"]){
        return @"已完成";
    }else{
        return @"已取消";
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    MBOrderModel *orderModel = _orderListArray[section];
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, UISCREEN_WIDTH, 35);
    view.backgroundColor = [UIColor whiteColor];
    UIImageView *topImage = [[UIImageView alloc] init];
    topImage.backgroundColor = UIcolor(@"f2f3f7");
    [view addSubview:topImage];
    //订时间
    UILabel *order_time = [[UILabel alloc] init];
    order_time.textColor = UIcolor(@"2c2c2c");
    order_time.text = s_str(orderModel.order_time);
    order_time.font = [UIFont systemFontOfSize:13];
    [view addSubview:order_time];
    //订单状态
    UILabel *sectionLbl = [[UILabel alloc] init];
    sectionLbl.textColor = UIcolor(@"d66263");
    NSString *order_status = [self getOrderStatusName:orderModel.order_status];
    
    if (![order_status isEqualToString:@"待付款"]&&orderModel.childOrders.count > 0) {
        order_status = @"";
    }
    
    sectionLbl.text =  order_status;
    sectionLbl.font = [UIFont systemFontOfSize:14];
    [view addSubview:sectionLbl];
    [topImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.right.left.mas_equalTo(0);
        make.height.mas_equalTo(5);
    }];
    [order_time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(5);
        
    }];
    [sectionLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(5);
    }];
    
    [self addBottomLineView:view];
    
    
    
    return view;
}



- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    MBOrderModel *orderModel = _orderListArray[section];
    UIView *footerMainView = [[UIView alloc] init];
    footerMainView.backgroundColor = [UIColor whiteColor];
    footerMainView.frame = CGRectMake(0, 0, self.view.ml_width, 30);
    
    
    UILabel *footerLbl = [[UILabel alloc] init];
    footerLbl.textColor = [UIColor colorWithHexString:@"323232"];
    footerLbl.text = @"总计：";
    footerLbl.font = [UIFont systemFontOfSize:12];
    [footerMainView addSubview:footerLbl];
    
    UILabel *priceLbl = [[UILabel alloc] init];
    priceLbl.textColor = [UIColor colorWithHexString:@"da465a"];
    priceLbl.text = [NSString stringWithFormat:@"%@",orderModel.totalFee];
    priceLbl.font = [UIFont systemFontOfSize:12];
    [footerMainView addSubview:priceLbl];
    
    [footerLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(0);
    }];
    [priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footerLbl.mas_right).offset(0);
        make.centerY.mas_equalTo(0);
    }];
    //button
    UIButton *sendServiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendServiceBtn setTitleColor:UIcolor(@"555555") forState:UIControlStateNormal];
    sendServiceBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    sendServiceBtn.layer.cornerRadius = 3.0;
    sendServiceBtn.layer.borderColor = UIcolor(@"555555").CGColor;
    sendServiceBtn.layer.borderWidth = PX_ONE;
    sendServiceBtn.tag = section;
    
    UIButton *detailsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [detailsBtn setTitleColor:UIcolor(@"555555") forState:UIControlStateNormal];
    detailsBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    detailsBtn.layer.cornerRadius = 3.0;
    detailsBtn.layer.borderColor = UIcolor(@"555555").CGColor;
    detailsBtn.layer.borderWidth = PX_ONE;
    detailsBtn.tag = section;
    [detailsBtn setTitle:@"详情" forState:UIControlStateNormal];
    [detailsBtn addTarget:self action:@selector(details:) forControlEvents:UIControlEventTouchUpInside];
    // 退换货
    UIButton *logisticServiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [logisticServiceBtn setTitleColor:UIcolor(@"555555") forState:UIControlStateNormal];
    logisticServiceBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    logisticServiceBtn.layer.cornerRadius = 3.0;
    logisticServiceBtn.layer.borderColor = UIcolor(@"555555").CGColor;
    logisticServiceBtn.layer.borderWidth = PX_ONE;
    logisticServiceBtn.tag = section;
    //
    UIButton *logisticServiceBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [logisticServiceBtn1 setTitleColor:UIcolor(@"555555") forState:UIControlStateNormal];
    logisticServiceBtn1.titleLabel.font = [UIFont systemFontOfSize:12];
    logisticServiceBtn1.layer.cornerRadius = 3.0;
    logisticServiceBtn1.layer.borderColor = UIcolor(@"555555").CGColor;
    logisticServiceBtn1.layer.borderWidth = PX_ONE;
    logisticServiceBtn1.tag = section;
    
    
    
    
    NSString *order_status = orderModel.order_status;
    if(order_status != nil && (NSNull *)order_status != [NSNull null]){
        if([order_status isEqualToString:@"await_pay"]){
            [sendServiceBtn setTitle:@"去付款" forState:UIControlStateNormal];
            [sendServiceBtn addTarget:self action:@selector(payForMoney:) forControlEvents:UIControlEventTouchUpInside];
            [footerMainView addSubview:sendServiceBtn];
            [footerMainView addSubview:detailsBtn];
            
            [sendServiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-10);
                make.centerY.mas_equalTo(0);
                make.width.mas_equalTo(55);
            }];
            
            [detailsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(sendServiceBtn.mas_left).offset(-5);
                make.centerY.mas_equalTo(0);
                make.width.mas_equalTo(45);
            }];
            
        }else if([order_status isEqualToString:@"finished"]){
            
            BOOL isEvaluation = NO;
            for (MBGoodListModel *model in orderModel.goodsList) {
                if ([model.is_comment isEqualToString:@"0"]) {
                    isEvaluation = YES;
                }
            }
            if (isEvaluation) {
                [sendServiceBtn setTitle:@"发表评价" forState:UIControlStateNormal];
                [sendServiceBtn addTarget:self action:@selector(comment:) forControlEvents:UIControlEventTouchUpInside];
            }else{
                [sendServiceBtn setTitle:@"已评价" forState:UIControlStateNormal];
                
            }
            
            NSString *refund_status = s_str(orderModel.refund_status);
            NSString *status1;
           
            if ([refund_status isEqualToString:@"1"]) {
                status1 = @"申请退款/换货";
            }else if([refund_status isEqualToString:@"5"]){
                status1 = @"填写运单号";
            }else if([refund_status isEqualToString:@"3"]){
                status1 = @"重新申请";
            }else{
                status1 = @"进度查询";
            }
            [footerMainView addSubview:sendServiceBtn];
            [sendServiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-10);
                make.centerY.mas_equalTo(0);
                if ([sendServiceBtn.titleLabel.text isEqualToString:@"发表评价"]) {
                    make.width.mas_equalTo(60);
                }else{
                    make.width.mas_equalTo(55);
                }
                
            }];
            
                [logisticServiceBtn setTitle:status1 forState:UIControlStateNormal];
            
                [footerMainView addSubview:logisticServiceBtn];
            
            
            

            [logisticServiceBtn addTarget:self action:@selector(realTimeLogistic:) forControlEvents:UIControlEventTouchUpInside];
            
            [logisticServiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(sendServiceBtn.mas_left).offset(-5);
                make.centerY.mas_equalTo(0);
                if ([refund_status isEqualToString:@"1"]) {
                    make.width.mas_equalTo(85);
                }else if([refund_status isEqualToString:@"5"]) {
                    make.width.mas_equalTo(65);
                }else{
                    make.width.mas_equalTo(60);
                }
                
            }];
            
            
            [footerMainView addSubview:detailsBtn];
           
            
            [detailsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(logisticServiceBtn.mas_left).offset(-5);
                make.centerY.mas_equalTo(0);
                make.width.mas_equalTo(45);
            }];
            
        }else if([order_status isEqualToString:@"shipped"] ){
            [sendServiceBtn setTitle:@"确认收货" forState:UIControlStateNormal];
            [sendServiceBtn addTarget:self action:@selector(shipped:) forControlEvents:UIControlEventTouchUpInside];
            
            [logisticServiceBtn setTitle:@"查看物流" forState:UIControlStateNormal];
            [logisticServiceBtn addTarget:self action:@selector(realTimeLogistic:) forControlEvents:UIControlEventTouchUpInside];
           
            
            [footerMainView addSubview:sendServiceBtn];
            [footerMainView addSubview:logisticServiceBtn];
            [footerMainView addSubview:detailsBtn];
            
            
            [sendServiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-10);
                make.centerY.mas_equalTo(0);
                make.width.mas_equalTo(60);
                
            }];
            [logisticServiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(sendServiceBtn.mas_left).offset(-5);
                make.centerY.mas_equalTo(0);
                make.width.mas_equalTo(60);
            }];
            [detailsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(logisticServiceBtn.mas_left).offset(-5);
                make.centerY.mas_equalTo(0);
                make.width.mas_equalTo(45);
            }];

        }else{
            [footerMainView addSubview:detailsBtn];
            [detailsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-10);
                make.centerY.mas_equalTo(0);
                make.width.mas_equalTo(45);
            }];

        
        
        }
        
    }

    
    return footerMainView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.orderListArray.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    MBOrderModel *orderModel = _orderListArray[section];
    
    if (orderModel.childOrders.count == 0 ) {
        
        return orderModel.goodsList.count;
    }
    
    return orderModel.childOrders.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MBOrderModel *orderModel = _orderListArray[indexPath.section];
    if (orderModel.childOrders.count == 0) {
        return 75;
    }
    NSArray *goods_list = [orderModel.childOrders[indexPath.row] goodsList];
    return goods_list.count * 75+30;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 30;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MBOrderModel *orderModel = _orderListArray[indexPath.section];
    
    if (orderModel.childOrders.count > 0) {
        MBOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBOrderCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"MBOrderCell" owner:nil options:nil]firstObject];
        }
        cell.order_sn = [orderModel.childOrders[indexPath.row]  order_sn];
       
        NSString *order_status = [self getOrderStatusName:orderModel.childOrders[indexPath.row].order_status];
        if ([order_status isEqualToString:@"待付款"]) {
            order_status = @"";
        }
        cell.order_status =  order_status;
        
        cell.goods_listArray = [orderModel.childOrders[indexPath.row]  goodsList];
        
        cell.VC = self;
        return cell;
    }else{
       
        MBAfterServiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBAfterServiceTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"MBAfterServiceTableViewCell" owner:nil options:nil]firstObject];
        }
        cell.model = orderModel.goodsList[indexPath.row];
        return cell;
    }
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     MBOrderModel *orderModel = _orderListArray[indexPath.section];
    if (orderModel.childOrders.count == 0) {
        MBShopingViewController *VC = [[MBShopingViewController alloc] init];
        VC.GoodsId =  [orderModel.goodsList[indexPath.row] goods_id];

        [self pushViewController:VC Animated:YES];
    }
 
}

- (void)menuBtnClick:(UIButton *)btn{
    [UIView animateWithDuration:.25 animations:^{
        self.menuLineView.ml_x = btn.tag * btn.ml_width;
        
        if (_lastButton!=btn) {
            [_lastButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorR:255 colorG:78 colorB:136] forState:UIControlStateNormal];
            _lastButton = btn;
        }
        [_orderListArray removeAllObjects];
        [self.tableView reloadData];
        //重新请求服务器数据
        _page = 1;
        _type = _types[btn.tag];
        [self getOrderListInfo];
    }];
}


- (NSString *)titleStr{
    return @"我的订单";
}

-(void)payForMoney:(UIButton *)btn{
    
    [self getOrderInfo:btn.tag];
}
- (void)details:(UIButton *)btn{
    NSInteger section = btn.tag;
     MBOrderModel *orderModel = _orderListArray[section];
    UINavigationController  *nav =  [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MBOrderInfoTableViewController"];
    MBOrderInfoTableViewController *infoVc = (MBOrderInfoTableViewController *)nav.viewControllers.firstObject;

    if (orderModel.childOrders.count > 0) {
        infoVc.parent_order_sn =  orderModel.parent_order_sn;
        
    }else{
        infoVc.parent_order_sn = orderModel.parent_order_sn;
        infoVc.order_id = orderModel.order_id;
    }

    [self.navigationController presentViewController:nav animated:YES completion:nil];
    
    
}
- (void)getOrderInfo:(NSInteger)row{
    MBOrderModel *orderModel = _orderListArray[row];
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    [self show];
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/order/pay_info"] parameters:@{@"session":dict,@"order_sn":orderModel.parent_order_sn} success:^(NSURLSessionDataTask *operation, MBModel *model) {
        [self dismiss];
        if([model.status[@"succeed"] isEqualToNumber:@1]){
             MMLog(@"%@",model.data);
            MBPaymentViewController *payVc = [[MBPaymentViewController alloc] init];
            
            payVc.orderInfo = model.data;
            payVc.order_sn = model.data[@"parent_order_sn"];
            [self pushViewController:payVc Animated:YES];
            
        }else{
            
            [self show:model.status[@"error_desc"] time:1];
        }
        
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
        MMLog(@"%@",error);
        [self show:@"请求失败" time:1];
        
        
    }];
}
-(void)comment:(UIButton *)button{
    
    
    MBOrderModel *orderModel = _orderListArray[button.tag];
    NSArray *goodListArr = orderModel.goodsList;
    NSMutableArray *goodListArray = [NSMutableArray array];
    for (MBGoodListModel *model in goodListArr) {
        if ([model.is_comment isEqualToString:@"0"]) {
            [goodListArray addObject:model];
        }
    }
    
    
    MBEvaluationController *VC = [[MBEvaluationController alloc] init];
    VC.order_id = orderModel.order_id;
    VC.goodListArray =  [NSMutableArray arrayWithArray:goodListArray];
    VC.section = button.tag;
    [self.navigationController pushViewController:VC animated:YES];
    
}
- (void)realTimeLogistic:(UIButton *)button{
    
     MBOrderModel *orderModel = _orderListArray[button.tag];
    
    if ([button.titleLabel.text isEqualToString:@"申请退款/换货"]) {
        MBAfterSalesServiceViewController *VC = [[MBAfterSalesServiceViewController alloc] init] ;
        VC.type = @"1";
        VC.section = button.tag;
        VC.order_sn = orderModel.order_sn;
        VC.order_id =  orderModel.order_id;
        VC.orderModel = orderModel;
        [self.navigationController pushViewController:VC animated:YES];
       
    }else if ([button.titleLabel.text isEqualToString:@"进度查询"]){
        MBRefundScheduleViewController *VC = [[MBRefundScheduleViewController alloc] init];
        VC.orderid = orderModel.order_id;
        VC.order_sn = orderModel.order_sn;
        [self.navigationController pushViewController:VC animated:YES];
        
    }else if ([button.titleLabel.text isEqualToString:@"重新申请"]){
        
        
        MBAfterSalesServiceViewController *VC = [[MBAfterSalesServiceViewController alloc] init];
        VC.type = @"0";
        VC.section = button.tag;
        VC.order_sn = orderModel.order_sn;
        VC.order_id =  orderModel.order_id;
        
        VC.orderModel = orderModel;
        [self.navigationController pushViewController:VC animated:YES];
        
    }else if([button.titleLabel.text isEqualToString:@"填写运单号"]){
        MBDeliveryInformationViewController *VC = [[MBDeliveryInformationViewController alloc] init];
        VC.back_tax = orderModel.back_tax;
        VC.order_sn = orderModel.order_sn;
        VC.order_id =  orderModel.order_id;
        VC.section = button.tag;
        [self.navigationController pushViewController:VC animated:YES];
       
    }

    
}
- (void)shipped:(UIButton *)button{
    
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    
    NSString *order_id = [_orderListArray[button.tag] order_id];
    
    [self show];
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/order/order_receive"] parameters:@{@"session":sessiondict,@"order_id":order_id}success:^(NSURLSessionDataTask *operation, id responseObject) {
        
        NSDictionary *dic = [responseObject valueForKeyPath:@"status"];
        
        if ([dic[@"succeed"]isEqualToNumber:@1]) {
            [self dismiss];
      
            [_orderListArray removeObjectAtIndex:button.tag];
            [_tableView reloadData];
            
            
        }else{
            [self show:dic[@"error_desc"] time:1];
            
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        MMLog(@"%@",error);
        [self show:@"请求失败" time:1];
    }];

}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
