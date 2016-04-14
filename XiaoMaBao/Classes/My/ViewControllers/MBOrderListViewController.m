//
//  MBOrderListViewController.m
//  XiaoMaBao
//
//  Created by 张磊 on 15/6/8.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "MBOrderListViewController.h"
#import "MBOrderInfoViewController.h"
#import "MBSignaltonTool.h"
#import "MBNetworking.h"
#import "MBAfterServiceTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "MBPaymentViewController.h"
#import "MobClick.h"
#import "MBAfterServiceCell.h"
#import "MBOrderCell.h"
#import "MBEvaluationController.h"
#import "MBLogisticsViewController.h"
#import "MBShopingViewController.h"
@interface MBOrderListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIButton *_lastButton;
    UILabel *_promptLable;
}
@property (strong,nonatomic) UIView *menuView;
@property (weak,nonatomic) UIView *menuLineView;
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSArray *orderSections;
@property (strong,nonatomic) NSMutableArray *orderListArray;
@property (strong,nonatomic) NSMutableArray *goodListArray;
@property (strong,nonatomic) NSMutableArray *child_ordersListArray;
@property (strong,nonatomic) NSArray *types;
@property (strong,nonatomic) NSArray *titles;
@end

@implementation MBOrderListViewController

- (NSArray *)orderSections{
    if (!_orderSections) {
        _orderSections = @[];
    }
    return _orderSections;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MBOrderListViewController"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MBOrderListViewController"];
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

    [self setupMenuView];
    
    if(self.order_status_tag){
        [self tabMenuClick:_order_status_tag];
    }else{
        
        
        
        [self getOrderListInfo:@"all"];
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MBEvaluationController:) name:@"MBEvaluationController" object:nil];
    
}
- (void)MBEvaluationController:(NSNotification *)notificat{
//    NSLog(@"%@",notificat.userInfo);
    
    NSDictionary *dic = notificat.userInfo[@"dic"];
    NSInteger section = [notificat.userInfo[@"section"] integerValue];
    
    NSMutableArray *arr = _goodListArray[section];
    for (int i = 0; i<arr.count; i++) {
        NSDictionary *dict = arr[i];
        if ([dict[@"goods_id"]isEqualToString:dic[@"goods_id"]]) {
            arr[i] = dic;
        }
    }
//    NSLog(@"%@",arr);
    
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:section];
    
    [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(void)tabMenuClick:(NSInteger)tag{
    [UIView animateWithDuration:.25 animations:^{
        CGFloat width = self.view.ml_width / _titles.count;
        self.menuLineView.ml_x = tag * width;
        
        
        //重新请求服务器数据
        [self getOrderListInfo:_types[tag]];
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

-(void)getOrderListInfo:(NSString *)type
{
    
    
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    NSDictionary *paginationDict = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"page",@"100",@"count",nil];
    
    
    [self show];
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL,@"order/list"] parameters:@{@"session":sessiondict,@"pagination":paginationDict,@"type":type}success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"成功---responseObject%@",[responseObject valueForKeyPath:@"data"]);
        [self dismiss];
        
        
        _orderListArray =[NSMutableArray arrayWithArray: [responseObject valueForKeyPath:@"data"]];
        _goodListArray = [NSMutableArray array];
        
        
        
        for (NSDictionary*dict in _orderListArray) {
            NSMutableArray *arr = [NSMutableArray arrayWithArray:[dict valueForKeyPath:@"goods_list"]];
            [_goodListArray addObject:arr];
        }
        
        if (_goodListArray.count == 0) {
            _promptLable.hidden  = NO;
            _promptLable.text = [NSString stringWithFormat:@"还没有%@的订单",_lastButton.titleLabel.text];
           
        }else{
            _promptLable.hidden = YES;
        
        }

        
        [self setupTableView];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self show:@"请求失败" time:1];
        NSLog(@"%@",error);
    }];

}
- (void)setupTableView{
    if(!_tableView ){
       UITableView *tableView = [[UITableView alloc] init];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.dataSource = self,
        tableView.delegate = self;
        tableView.frame = CGRectMake(0,34 + TOP_Y, self.view.ml_width, self.view.ml_height - CGRectGetMaxY(_menuView.frame));
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
    
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, UISCREEN_WIDTH, 35);
    view.backgroundColor = [UIColor colorWithHexString:@"f2f3f7"];
    
    UIView *sectionView = [[UIView alloc] init];
    sectionView.frame = CGRectMake(0,5, self.view.ml_width, 30);
    sectionView.backgroundColor =  [UIColor whiteColor];
    [view addSubview:sectionView];
    //订单状态
    UILabel *sectionLbl = [[UILabel alloc] init];
    sectionLbl.backgroundColor  = [UIColor colorWithHexString:@"d66263"];
    sectionLbl.textColor = [UIColor whiteColor];
    sectionLbl.textAlignment=1;
    NSString *order_status = [_orderListArray[section] valueForKeyPath:@"order_status"];
    
    sectionLbl.text = [NSString stringWithFormat:@"%@",[self getOrderStatusName:order_status]];
    sectionLbl.frame = CGRectMake(0, 0,50, sectionView.ml_height);
    sectionLbl.font = [UIFont systemFontOfSize:12];
    [sectionView addSubview:sectionLbl];
    
    //订单号
    UILabel *section_order_sn = [[UILabel alloc] init];
    section_order_sn.textColor = [UIColor blackColor];
    NSString *order_sn = [_orderListArray[section] valueForKeyPath:@"order_sn"];
    section_order_sn.text = [NSString stringWithFormat:@"订单号：%@",order_sn];
    section_order_sn.frame = CGRectMake(58, 0, self.view.ml_width-100, sectionView.ml_height);
    section_order_sn.font = [UIFont systemFontOfSize:12];
    [sectionView addSubview:section_order_sn];
    
    UIImageView *imageview = [[UIImageView alloc] init];
    imageview.image = [UIImage imageNamed:@"next_image"];
    [sectionView addSubview:imageview];
    [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(8);
        make.bottom.mas_equalTo (-10);
        make.right.mas_equalTo(-8);
        make.width.mas_equalTo(14);
    }];
    
    UILabel *timeLable = [[UILabel alloc] init];
    NSString *order_time = [_orderListArray[section] valueForKeyPath:@"order_time"];
    timeLable.font = [UIFont systemFontOfSize:10];
    timeLable.textColor = [UIColor colorR:194 colorG:194 colorB:194];
    timeLable.text = [NSString stringWithFormat:@"%@",order_time];
    [sectionView addSubview:timeLable];
    [timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(sectionView.mas_centerY);
        make.right.equalTo(imageview.mas_left).offset(-5);
    }];
   [self addBottomLineView:sectionView];
    

    UITapGestureRecognizer *pinch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickGesture:)];
    sectionView.tag = section;
    [sectionView addGestureRecognizer:pinch];
    return view;
}

#pragma make --- tableViewheadView上的点击手势
- (void)pickGesture:(UITapGestureRecognizer *)pinch
{

    NSInteger section = pinch.view.tag;
    MBOrderInfoViewController *infoVc = [[MBOrderInfoViewController alloc] init];
    //单号和时间
    NSString *order_id = [_orderListArray[section] valueForKeyPath:@"order_id"];
    infoVc.order_id = order_id;
    [self.navigationController pushViewController:infoVc animated:YES];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = BG_COLOR;
    footerView.frame = CGRectMake(0, 0, self.view.ml_width, 30);
    
    UIView *footerMainView = [[UIView alloc] init];
    footerMainView.backgroundColor = [UIColor whiteColor];
    footerMainView.frame = CGRectMake(0, 0, self.view.ml_width, 30);
    [footerView addSubview:footerMainView];
    
    UILabel *footerLbl = [[UILabel alloc] init];
    footerLbl.textColor = [UIColor colorWithHexString:@"323232"];
    footerLbl.text = @"总计：";
    footerLbl.frame = CGRectMake(8, 0, 40, footerView.ml_height);
    footerLbl.font = [UIFont systemFontOfSize:12];
    [footerMainView addSubview:footerLbl];
    
    UILabel *priceLbl = [[UILabel alloc] init];
    priceLbl.textColor = [UIColor colorWithHexString:@"da465a"];
    NSString *order_amount = [_orderListArray[section] valueForKeyPath:@"totalFee"];
    priceLbl.text = [NSString stringWithFormat:@"%@",order_amount];
    priceLbl.frame = CGRectMake(CGRectGetMaxX(footerLbl.frame), 0, 150, footerView.ml_height);
    priceLbl.font = [UIFont systemFontOfSize:12];
    [footerMainView addSubview:priceLbl];
    
    //订单时间
    UIButton *sendServiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *logisticServiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    logisticServiceBtn.tag = section;
    sendServiceBtn.tag = section;
    BOOL show = NO;
    int w = 0;
    
    NSString *order_status = [_orderListArray[section] valueForKeyPath:@"order_status"];
    
    
    if(order_status != nil && (NSNull *)order_status != [NSNull null]){
        if([order_status isEqualToString:@"await_pay"]){
            [sendServiceBtn setTitle:@"去付款" forState:UIControlStateNormal];
            sendServiceBtn.tag = section;
            [sendServiceBtn addTarget:self action:@selector(payForMoney:) forControlEvents:UIControlEventTouchUpInside];
            show = YES;
        }else if([order_status isEqualToString:@"finished"]){
            NSArray *arr =_goodListArray[section];
            BOOL isEvaluation = NO;
            for (NSDictionary *dic in arr) {
                if ([dic[@"is_comment"]isEqualToString:@"0"]) {
                    isEvaluation = YES;
                }
            }
            if (isEvaluation) {
                [sendServiceBtn setTitle:@"发表评价" forState:UIControlStateNormal];
                [sendServiceBtn addTarget:self action:@selector(comment:) forControlEvents:UIControlEventTouchUpInside];
            }else{
                [sendServiceBtn setTitle:@"已评价" forState:UIControlStateNormal];
                //[sendServiceBtn addTarget:self action:@selector(comment:) forControlEvents:UIControlEventTouchUpInside];
                
            }
            [logisticServiceBtn setTitle:@"查看物流" forState:UIControlStateNormal];
            [logisticServiceBtn addTarget:self action:@selector(realTimeLogistic:) forControlEvents:UIControlEventTouchUpInside];
            show = YES;
        }else if([order_status isEqualToString:@"shipped"] ){
            [sendServiceBtn setTitle:@"确认收货" forState:UIControlStateNormal];
            [sendServiceBtn addTarget:self action:@selector(shipped:) forControlEvents:UIControlEventTouchUpInside];
            
            [logisticServiceBtn setTitle:@"查看物流" forState:UIControlStateNormal];
            [logisticServiceBtn addTarget:self action:@selector(realTimeLogistic:) forControlEvents:UIControlEventTouchUpInside];
            show = YES;
        
        }
        
    }
    if(show){
        w = 60;
        sendServiceBtn.frame = CGRectMake(self.view.ml_width - 8 - w, (footerView.ml_height - 25) * 0.5, w, 25);
        
        [sendServiceBtn setTitleColor:[UIColor colorR:255 colorG:78 colorB:136] forState:UIControlStateNormal];
        sendServiceBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        sendServiceBtn.layer.cornerRadius = 3.0;
        sendServiceBtn.layer.borderColor = [UIColor colorR:255 colorG:78 colorB:136].CGColor;
        sendServiceBtn.layer.borderWidth = PX_ONE;
        
        logisticServiceBtn.frame = CGRectMake(self.view.ml_width - 8 - w-5-w, (footerView.ml_height - 25) * 0.5, w, 25);
        [logisticServiceBtn setTitleColor:[UIColor colorR:255 colorG:78 colorB:136] forState:UIControlStateNormal];
        logisticServiceBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        logisticServiceBtn.layer.cornerRadius = 3.0;
        logisticServiceBtn.layer.borderColor = [UIColor colorR:255 colorG:78 colorB:136].CGColor;
        logisticServiceBtn.layer.borderWidth = PX_ONE;
        
        [footerMainView addSubview:sendServiceBtn];
        
        if ([sendServiceBtn.titleLabel.text isEqualToString:@"去付款"]) {
            

        }else{
            
            [footerMainView addSubview:logisticServiceBtn];

        }
    }
    [self addBottomLineView:footerView];
        return footerView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _orderListArray.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = [_orderListArray[section] valueForKeyPath:@"child_orders"];
    
    if (arr.count>0) {
        return arr.count ;
    }
    
        return [_orderListArray[section][@"goods_list"]  count];
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *arr = [_orderListArray[indexPath.section] valueForKeyPath:@"child_orders"];
 
    if (arr.count>0) {
        NSArray *array = arr[indexPath.row][@"goods_list"];
        
        return array.count *75+25;
    }
    return 75;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 30;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *arr = [_orderListArray[indexPath.section] valueForKeyPath:@"child_orders"];
    if (arr.count>0) {
            MBOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBOrderCell"];
                    if (!cell) {
                        cell = [[[NSBundle mainBundle]loadNibNamed:@"MBOrderCell" owner:nil options:nil]firstObject];
                    }
         NSArray *arr = [_orderListArray[indexPath.section] valueForKeyPath:@"child_orders"];
        cell.order_sn = arr[indexPath.row][@"order_sn"];
        cell.array = arr[indexPath.row][@"goods_list"];
        cell.imageUrlArray  = [_orderListArray[indexPath.section] valueForKeyPath:@"goods_list"];
        cell.VC = self;
        cell.selectionStyle =  UITableViewCellSelectionStyleNone;

        return cell;
    }else{
        MBAfterServiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBAfterServiceTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"MBAfterServiceTableViewCell" owner:nil options:nil]firstObject];
        }
  
                //第几组对应的goods_list
                NSArray *array = [_orderListArray[indexPath.section] valueForKeyPath:@"goods_list"];
        
        
                NSDictionary *dict = array[indexPath.row];
                //图片
                NSString *urlstr = [dict valueForKeyPath:@"img"];
                NSURL *url = [NSURL URLWithString:urlstr];
                [cell.showImageview sd_setImageWithURL:url];
                //名字描述
                NSString *name1 = [dict valueForKeyPath:@"name"];
                cell.describe.text = name1;
                //数量以及价格
                NSString *goods_number = [dict valueForKeyPath:@"goods_number"];
                NSString *formated_shop_price = [dict valueForKeyPath:@"shop_price_formatted"];
        
                cell.priceAndNumber.text = [NSString stringWithFormat:@"%@ X %@",formated_shop_price,goods_number];
                cell.selectionStyle =  UITableViewCellSelectionStyleNone;

                return cell;

    
    }

    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *arr = [_orderListArray[indexPath.section] valueForKeyPath:@"child_orders"];
    if (arr.count<=0) {
          NSArray *array = [_orderListArray[indexPath.section] valueForKeyPath:@"goods_list"];
        NSDictionary *dic = array[indexPath.row];
        MBShopingViewController *VC = [[MBShopingViewController alloc] init];
        VC.GoodsId = dic[@"goods_id"];
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
        //重新请求服务器数据
        [self getOrderListInfo:_types[btn.tag]];
    }];
}
#pragma mark ---让tabview的headview跟随cell一起滑动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView == self.tableView)
    {
        UITableView *tableview = (UITableView *)scrollView;
        CGFloat sectionHeaderHeight = 35;
        CGFloat sectionFooterHeight = 30;
        CGFloat offsetY = tableview.contentOffset.y;
        if (offsetY >= 0 && offsetY <= sectionHeaderHeight)
        {
            tableview.contentInset = UIEdgeInsetsMake(-offsetY, 0, -sectionFooterHeight, 0);
        }else if (offsetY >= sectionHeaderHeight && offsetY <= tableview.contentSize.height - tableview.frame.size.height - sectionFooterHeight)
        {
            tableview.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, -sectionFooterHeight, 0);
        }else if (offsetY >= tableview.contentSize.height - tableview.frame.size.height - sectionFooterHeight && offsetY <= tableview.contentSize.height - tableview.frame.size.height)
        {
            tableview.contentInset = UIEdgeInsetsMake(-offsetY, 0, -(tableview.contentSize.height - tableview.frame.size.height - sectionFooterHeight), 0);
        }
        
    }
    _tableView.editing = NO;
    
}

- (NSString *)titleStr{
    return @"我的订单";
}

-(void)payForMoney:(UIButton *)btn{
    MBPaymentViewController *payVc = [[MBPaymentViewController alloc] init];
    payVc.pay_id = @"3";//支付宝
    payVc.shipping_id = @"4";//默认配送方式
    //获取订单详情
    NSInteger section = btn.tag;
    NSString *order_id = [_orderListArray[section] valueForKeyPath:@"order_id"];
    
    payVc.order_id = order_id;
    payVc.isOrderDetail = @"yes";
    if (![[_orderListArray[btn.tag]valueForKeyPath:@"is_cross_border"] isEqualToString:@"0"] ) {
        payVc.is_cross_border = [NSNumber numberWithLong:1];
    }
    [self.navigationController pushViewController:payVc animated:YES];
    
}

-(void)comment:(UIButton *)button{
    
    NSArray *arr = _goodListArray[button.tag];
    NSLog(@"%@",arr);
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in arr) {
        if ([dic[@"is_comment"]isEqualToString:@"0"]) {
            [array addObject:dic];
        }
    }
    
    
    MBEvaluationController *VC = [[MBEvaluationController alloc] init];
    NSString *order_id = [_orderListArray[button.tag] valueForKeyPath:@"order_id"];
    VC.order_id = order_id;
    VC.array =  array;
    VC.section = button.tag;
    [self.navigationController pushViewController:VC animated:YES];
    
}
- (void)realTimeLogistic:(UIButton *)button{

    
    MBLogisticsViewController *VC = [[MBLogisticsViewController alloc] init];
    
    VC.type =[_orderListArray[button.tag] valueForKeyPath:@"shipping_name"];
    VC.postid =[_orderListArray[button.tag] valueForKeyPath:@"invoice_no"];
    [self pushViewController:VC Animated:YES];

}
- (void)shipped:(UIButton *)button{
    NSLog(@"%ld",(long)button.tag);
    
    
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
   
    NSString *order_id = _orderListArray[button.tag][@"order_id"];
    
    [self show];
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL,@"order/affirm_received"] parameters:@{@"session":sessiondict,@"order_id":order_id}success:^(AFHTTPRequestOperation *operation, id responseObject) {
 
        NSDictionary *dic = [responseObject valueForKeyPath:@"status"];

        if ([dic[@"succeed"]isEqualToNumber:@1]) {
            [self dismiss];
            
            [_orderListArray removeObjectAtIndex:button.tag];

            [_tableView reloadData];
//            NSIndexSet *indexSet = [[NSIndexSet alloc ]initWithIndex:button.tag];
//            [_tableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
          
            
        }else{
            [self show:dic[@"error_desc"] time:1];
        
        }
       
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
         [self show:@"请求失败" time:1];
    }];


}
@end
