//
//  MBRefundHomeController.m
//  XiaoMaBao
//
//  Created by liulianqi on 15/11/25.
//  Copyright © 2015年 HuiBei. All rights reserved.
//

#import "MBRefundHomeController.h"
#import "MBAfterServiceTableViewCell.h"
#import "MBAfterSalesServiceViewController.h"
#import "UIImageView+WebCache.h"
#import "MBDeliveryInformationViewController.h"
#import "MobClick.h"
#import "MBRefundScheduleViewController.h"
#import "MBOrderInfoTableViewController.h"
@interface MBRefundHomeController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_titles;
    UIView *_menuView;//全部订单／已申请view
    UIView *_menuLineView;//线view
    NSMutableArray *_orderArray;//全部订单
    BOOL _isState;
  
    NSString *_refund_status;
    int _page;//当前页数
    int _size;//每页数据量
    UIButton *_lastButton;
    
    UILabel *_promptLable;
}
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topDistance;

@end

@implementation MBRefundHomeController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MBRefundHomeController"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MBRefundHomeController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topDistance.constant = TOP_Y+10;
    _page = 1;
    _orderArray = [NSMutableArray array];

    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setUI];
    [self setupMenuView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RefundStatus:) name:@"Refund_status" object:nil];
    
}
- (void)RefundStatus:(NSNotification *)notificat{
    _refund_status = [notificat userInfo][@"refund"];
    NSString *section = [notificat userInfo][@"section"];
    NSInteger sect = [section  integerValue];
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:sect];

    NSDictionary *dic = _orderArray[sect];
    NSArray *arr = [dic allKeys];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    for (NSString *str in arr) {
        id sss = [dic objectForKey:str];
        if ([str isEqualToString:@"refund_status"]) {
            [dict  setObject:@2 forKey:str];
        }else{
        
            [dict setObject:sss forKey:str];
        }
    }
    
    [_orderArray replaceObjectAtIndex:sect withObject:dict];
    
    
    [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];

}
#pragma mark --界面布局
- (void)setUI{
    self.titleStr = @"退换货";
   
    
    UIView *searchLeftView = [[UIView alloc] init];
    searchLeftView.frame = CGRectMake(0, 0, 35, _searchTextField.frame.size.height);
    
    UIImageView *searchImageView = [[UIImageView alloc] init];
    searchImageView.image = [UIImage imageNamed:@"search_icon"];
    searchImageView.contentMode = UIViewContentModeScaleAspectFit;
    searchImageView.frame = CGRectMake(10, (_searchTextField.frame.size.height - 20) * 0.5, 20, 20);
    [searchLeftView addSubview:searchImageView];
    _searchTextField.returnKeyType = UIReturnKeySearch;
    _searchTextField.leftView = searchLeftView;
    _searchTextField.delegate = self;
    _searchTextField.leftViewMode = UITextFieldViewModeAlways;
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    
  
    if (_orderArray.count>0) {
        
        if (_tableView.superview == nil) {
            [self.view addSubview:_tableView];
        }else{
            //[self.collectionView reloadData];
        }
    }else{
        
        if (_isState) {
            [self applyData];
        }else{
        
         [self requestData];
        }
       
    }
     __unsafe_unretained __typeof(self) weakSelf = self;
    // 上拉刷新
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
     
        if (_isState) {
            [self applyData];
        }else{

            [self requestData];
        }
       
            [weakSelf.tableView.mj_footer endRefreshing];
     
    }];
    // 默认先隐藏footer
    self.tableView.mj_footer.hidden = YES;

    _promptLable = [[UILabel alloc] init];
    _promptLable.textAlignment = 1;
    _promptLable.font = [UIFont systemFontOfSize:14];
    _promptLable.textColor = [UIColor colorR:146 colorG:147 colorB:148];
    _promptLable.hidden = YES;
    [self.view addSubview:_promptLable];
    
    [_promptLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
    }];



}
-(void)setupMenuView{
    
    _titles = @[
                @"全部订单",
                @"已申请"
                ];

    if(_menuView == nil){
        CGFloat width = UISCREEN_WIDTH / _titles.count;
        _menuView = [[UIView alloc] init];
        _menuView.backgroundColor = [UIColor whiteColor];
        _menuView.frame = CGRectMake(0, CGRectGetMaxY(self.searchTextField.frame)+10, UISCREEN_WIDTH, 40);
        [self.view addSubview:_menuView];
        
        for (NSInteger i = 0; i < _titles.count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitleColor:[UIColor colorWithHexString:@"313232"] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            btn.frame = CGRectMake(i * width, 0, width, 34);
            [btn setTitle:_titles[i] forState:UIControlStateNormal];
            [_menuView addSubview:btn];
            btn.tag = i;
            
            [btn addTarget:self action:@selector(orderMenuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            if (i==0) {
                 [btn setTitleColor:NavBar_Color forState:UIControlStateNormal];
                _lastButton = btn;
            }
        }
        
        UIView *lineView = [[UIView alloc] init];
        lineView.frame = CGRectMake(0, _menuView.ml_height - 1, width, 2);
        lineView.backgroundColor = NavBar_Color;
        [_menuView addSubview:_menuLineView = lineView];
    }
    
}
- (void)orderMenuBtnClick:(UIButton *)btn{
    [_searchTextField resignFirstResponder];
    [btn setTitleColor:NavBar_Color forState:UIControlStateNormal];
    [_lastButton setTitleColor:[UIColor colorWithHexString:@"313232"] forState:UIControlStateNormal];
    _lastButton = btn;
    [UIView animateWithDuration:.25 animations:^{
        _menuLineView.ml_x = btn.tag * btn.ml_width;
        
    }];
    
    
    if ([btn.titleLabel.text isEqualToString:@"全部订单"]) {
       
        [_orderArray removeAllObjects];
        [_tableView.mj_footer resetNoMoreData];
          [_tableView reloadData];
        _isState = NO;
        _page =1;
       
        [self requestData];
        
    }else{
   
        [_orderArray removeAllObjects];
         [_tableView.mj_footer resetNoMoreData];
            [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
           [_tableView reloadData];
        _isState = YES;
        _page =1;
        [self applyData];
    }
}
/**
 *  判断是否存在数据
 */
- (void)isData{
    
    if (_orderArray.count == 0) {
        _promptLable.hidden  = NO;
        if ([_lastButton.titleLabel.text isEqualToString:@"已申请"]) {
            _promptLable.text = [NSString stringWithFormat:@"您还没有%@退换货的订单",_lastButton.titleLabel.text];
        }else{
            _promptLable.text = @"您还没有可退换货的订单";
        }
        
        
    }else{
      
        
        _promptLable.hidden = YES;
        
    }

}
#pragma mark --请求全部订单数据
- (void)requestData{
   
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
     NSString *page = [NSString stringWithFormat:@"%d",_page];
    [self show];
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL,@"refund/list"] parameters:@{@"session":sessiondict,@"page":page,@"size":@"5"}success:^(NSURLSessionDataTask *operation, id responseObject) {
         [self dismiss];
       // MMLog(@"成功获取全部可退换货订单---responseObject%@",[responseObject valueForKeyPath:@"data"]);
    
        
        NSArray * arr =  [responseObject valueForKeyPath:@"data"];
        if (arr.count>0) {
            [_orderArray addObjectsFromArray:arr];
        }else{
            [_tableView.mj_footer endRefreshingWithNoMoreData];
                   [self isData];
            return ;
        
        }
  
            _page += 1;
      
       [self isData];
    
        [_tableView reloadData];
  
        
    
       }failure:^(NSURLSessionDataTask *operation, NSError *error) {
                 [self show:@"请求失败！" time:1];
                   MMLog(@"%@",error);
                   
               }
     ];



}
#pragma mark --搜索订单数据
- (void)searchData:(NSString *)str{

      [_orderArray removeAllObjects];
    [self show];
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL,@"refund/search"] parameters:@{@"session":sessiondict,@"order_sn":str}success:^(NSURLSessionDataTask *operation, id responseObject) {
        [self dismiss];
        //MMLog(@"成功获取搜索退换货订单信息---responseObject%@",[responseObject valueForKeyPath:@"data"]);
        NSArray *arr = [responseObject valueForKeyPath:@"data"];
        
        [_orderArray addObjectsFromArray:arr];
        
             [self isData];
        [_tableView reloadData];
     
        
        
    }failure:^(NSURLSessionDataTask *operation, NSError *error) {
   [self show:@"请求失败！" time:1];
        MMLog(@"%@",error);
        
    }
     ];
    
}
#pragma mark --请求已申请数据
-(void)applyData{
   
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
         NSString *page = [NSString stringWithFormat:@"%d",_page];
    [self show];
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL,@"refund/applyList"] parameters:@{@"session":sessiondict,@"page":page,@"size":@"5"}success:^(NSURLSessionDataTask *operation, id responseObject) {
        [self dismiss];
        //MMLog(@"成功获取全部已申请退换货订单---responseObject%@",[responseObject valueForKeyPath:@"data"]);
       
        NSArray * arr =  [responseObject valueForKeyPath:@"data"];
        if (arr.count>0) {
            [_orderArray addObjectsFromArray:arr];
        }else{
            [_tableView.mj_footer endRefreshingWithNoMoreData];
               [self isData];
            return ;
        }
        
        _page += 1;
         [self isData];
        [_tableView reloadData];
        
        
    }failure:^(NSURLSessionDataTask *operation, NSError *error) {
    [self show:@"请求失败！" time:1];
        MMLog(@"%@",error);
        
    }
     ];


}

#pragma mark -- 申请事件
-(void)comment:(UIButton *)button{
    
    if ([button.titleLabel.text isEqualToString:@"申请退款/换货"]) {
        MBAfterSalesServiceViewController *VC = [[MBAfterSalesServiceViewController alloc] init] ;
        VC.type = @"1";
        VC.section = button.tag;
        VC.order_sn = _orderArray[button.tag][@"order_sn"];
        VC.order_id =  _orderArray[button.tag][@"order_id"];
        [self.navigationController pushViewController:VC animated:YES];
        MMLog(@"申请退款/换货");
    }else if ([button.titleLabel.text isEqualToString:@"进度查询"]){
        MBRefundScheduleViewController *VC = [[MBRefundScheduleViewController alloc] init];
        VC.orderid = _orderArray[button.tag][@"order_id"];
        VC.order_sn = _orderArray[button.tag][@"order_sn"];
        [self.navigationController pushViewController:VC animated:YES];
        MMLog(@"进度查询");
    }else if ([button.titleLabel.text isEqualToString:@"重新申请"]){
        
        MMLog(@"重新申请");
        MBAfterSalesServiceViewController *VC = [[MBAfterSalesServiceViewController alloc] init];
        VC.type = @"0";
        VC.section = button.tag;
        
        
        
        VC.order_sn = _orderArray[button.tag][@"order_sn"];
        VC.order_id =  _orderArray[button.tag][@"order_id"];
        
    
        [self.navigationController pushViewController:VC animated:YES];
        
    }else if([button.titleLabel.text isEqualToString:@"填写运单号"]){
        MBDeliveryInformationViewController *VC = [[MBDeliveryInformationViewController alloc] init];
        VC.back_tax = _orderArray[button.tag][@"back_tax"];
        VC.order_id = _orderArray[button.tag][@"order_id"];
        VC.order_sn = _orderArray[button.tag][@"order_sn"];
        VC.section = button.tag;
        [self.navigationController pushViewController:VC animated:YES];
        MMLog(@"填写运单号");
        
    }
    
}
#pragma mark -UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_orderArray>0) {
         return _orderArray.count;
    }else{
        return 0;
    }
   
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    
    if (_orderArray>0) {
        NSArray *arr = _orderArray[section][@"goods_detail"];
        return arr.count;
    }else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
        return 75;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *sectionView = [[UIView alloc] init];
    sectionView.frame = CGRectMake(0, 0, UISCREEN_WIDTH, 25);
    sectionView.backgroundColor = NavBar_Color;
    
    //日期
    UILabel *sectionLbl = [[UILabel alloc] init];
    sectionLbl.textColor = [UIColor whiteColor];
    sectionLbl.textAlignment = 2;
    sectionLbl.text = _orderArray[section][@"add_time"];
    sectionLbl.frame = CGRectMake(UISCREEN_WIDTH -320 , 0,300, sectionView.ml_height);
    sectionLbl.font = [UIFont systemFontOfSize:12];
    [sectionView addSubview:sectionLbl];
    
    //订单号
    UILabel *section_order_sn = [[UILabel alloc] init];
    section_order_sn.textColor = [UIColor whiteColor];
    if (_orderArray) {
        NSString *order_sn =  _orderArray[section][@"order_sn"];
        section_order_sn.text = [NSString stringWithFormat:@"订单号：%@",order_sn];
    }
    
    section_order_sn.frame = CGRectMake(8, 0,150, sectionView.ml_height);
    section_order_sn.font = [UIFont systemFontOfSize:12];
    [sectionView addSubview:section_order_sn];
    
    
    UILabel *lable = [[UILabel alloc] init];
    lable.text = @"已完成" ;
    lable.textColor = [UIColor redColor];
    lable.frame = CGRectMake(CGRectGetMaxX(section_order_sn.frame), 0, 100, sectionView.ml_height);
    lable.font = [UIFont systemFontOfSize:10];
    if (_orderArray.count>0) {
        NSNumber *refund_status = _orderArray[section][@"refund_status"];
        if ([refund_status  isEqualToNumber:@4]) {
            [sectionView addSubview:lable];
        }
    }
    
    return sectionView;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = BG_COLOR;
    footerView.frame = CGRectMake(0, 0, UISCREEN_WIDTH, 30);
    
    UIView *footerMainView = [[UIView alloc] init];
    footerMainView.backgroundColor = [UIColor whiteColor];
    footerMainView.frame = CGRectMake(0, 0, self.view.ml_width, 30);
    [footerView addSubview:footerMainView];
    
    UILabel *footerLbl = [[UILabel alloc] init];
    footerLbl.textColor = NavBar_Color;
    footerLbl.text = @"总计：";
    footerLbl.frame = CGRectMake(8, 0, 40, footerView.ml_height);
    footerLbl.font = [UIFont systemFontOfSize:12];
    [footerMainView addSubview:footerLbl];
    
    UILabel *priceLbl = [[UILabel alloc] init];
    priceLbl.textColor = [UIColor colorWithHexString:@"da465a"];
    if (_orderArray.count>0) {
        NSString *str = _orderArray[section][@"order_total_money"];
        priceLbl.text = [NSString stringWithFormat:@"¥%@",str];;
    }
    
    priceLbl.frame = CGRectMake(CGRectGetMaxX(footerLbl.frame), 0, 150, footerView.ml_height);
    priceLbl.font = [UIFont systemFontOfSize:12];
    [footerMainView addSubview:priceLbl];
    
    
    UIButton *sendServiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *sendServiceBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *sendServiceBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    sendServiceBtn.tag = section;
    sendServiceBtn1.tag = section;
    sendServiceBtn2.tag = section;
    
    NSNumber *refund_status = _orderArray[section][@"refund_status"];
   
    
    
    if([refund_status isEqualToNumber:@1]){
       
    [sendServiceBtn setTitle:@"申请退款/换货" forState:UIControlStateNormal];
        [sendServiceBtn addTarget:self action:@selector(comment:) forControlEvents:UIControlEventTouchUpInside];
    sendServiceBtn.frame = CGRectMake(UISCREEN_WIDTH - 8-80 , (footerView.ml_height - 20) * 0.5, 80, 20);
    [sendServiceBtn setTitleColor:NavBar_Color forState:UIControlStateNormal];
    sendServiceBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    sendServiceBtn.layer.cornerRadius = 3.0;
    sendServiceBtn.layer.borderColor = NavBar_Color.CGColor;
    sendServiceBtn.layer.borderWidth = PX_ONE;
        
    }else if([refund_status isEqualToNumber:@5]){
    
        [sendServiceBtn1 setTitle:@"进度查询" forState:UIControlStateNormal];
        [sendServiceBtn1 addTarget:self action:@selector(comment:) forControlEvents:UIControlEventTouchUpInside];
        sendServiceBtn1.frame = CGRectMake(UISCREEN_WIDTH - 8-60 , (footerView.ml_height - 20) * 0.5, 60, 20);
        [sendServiceBtn1 setTitleColor:NavBar_Color forState:UIControlStateNormal];
        sendServiceBtn1.titleLabel.font = [UIFont systemFontOfSize:12];
        sendServiceBtn1.layer.cornerRadius = 3.0;
        sendServiceBtn1.layer.borderColor = NavBar_Color.CGColor;
        sendServiceBtn1.layer.borderWidth = PX_ONE;
        
        
        [sendServiceBtn2 setTitle:@"填写运单号" forState:UIControlStateNormal];
        [sendServiceBtn2 addTarget:self action:@selector(comment:) forControlEvents:UIControlEventTouchUpInside];
        sendServiceBtn2.frame = CGRectMake(CGRectGetMinX(sendServiceBtn1.frame)-60-8 , (footerView.ml_height - 20) * 0.5, 60, 20);
        [sendServiceBtn2 setTitleColor:NavBar_Color forState:UIControlStateNormal];
        sendServiceBtn2.titleLabel.font = [UIFont systemFontOfSize:12];
        sendServiceBtn2.layer.cornerRadius = 3.0;
        sendServiceBtn2.layer.borderColor = NavBar_Color.CGColor;
        sendServiceBtn2.layer.borderWidth = PX_ONE;
    }else if([refund_status isEqualToNumber:@3]){
        [sendServiceBtn1 setTitle:@"进度查询" forState:UIControlStateNormal];
        [sendServiceBtn1 addTarget:self action:@selector(comment:) forControlEvents:UIControlEventTouchUpInside];
        sendServiceBtn1.frame = CGRectMake(UISCREEN_WIDTH - 8-60 , (footerView.ml_height - 20) * 0.5, 60, 20);
        [sendServiceBtn1 setTitleColor:NavBar_Color forState:UIControlStateNormal];
        sendServiceBtn1.titleLabel.font = [UIFont systemFontOfSize:12];
        sendServiceBtn1.layer.cornerRadius = 3.0;
        sendServiceBtn1.layer.borderColor = NavBar_Color.CGColor;
        sendServiceBtn1.layer.borderWidth = PX_ONE;
        
        
        [sendServiceBtn2 setTitle:@"重新申请" forState:UIControlStateNormal];
        [sendServiceBtn2 addTarget:self action:@selector(comment:) forControlEvents:UIControlEventTouchUpInside];
        sendServiceBtn2.frame = CGRectMake(CGRectGetMinX(sendServiceBtn1.frame)-60-8 , (footerView.ml_height - 20) * 0.5, 60, 20);
        [sendServiceBtn2 setTitleColor:NavBar_Color forState:UIControlStateNormal];
        sendServiceBtn2.titleLabel.font = [UIFont systemFontOfSize:12];
        sendServiceBtn2.layer.cornerRadius = 3.0;
        sendServiceBtn2.layer.borderColor = NavBar_Color.CGColor;
        sendServiceBtn2.layer.borderWidth = PX_ONE;
    
    }else{
    
        [sendServiceBtn1 setTitle:@"进度查询" forState:UIControlStateNormal];
        [sendServiceBtn1 addTarget:self action:@selector(comment:) forControlEvents:UIControlEventTouchUpInside];
        sendServiceBtn1.frame = CGRectMake(UISCREEN_WIDTH - 8-60 , (footerView.ml_height - 20) * 0.5, 60, 20);
        [sendServiceBtn1 setTitleColor:NavBar_Color forState:UIControlStateNormal];
        sendServiceBtn1.titleLabel.font = [UIFont systemFontOfSize:12];
        sendServiceBtn1.layer.cornerRadius = 3.0;
        sendServiceBtn1.layer.borderColor = NavBar_Color.CGColor;
        sendServiceBtn1.layer.borderWidth = PX_ONE;

    
    }
    
    [footerMainView addSubview:sendServiceBtn];
    [footerMainView addSubview:sendServiceBtn1];
    [footerMainView addSubview:sendServiceBtn2];
    
    
    return footerView;
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
        
        MBAfterServiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBAfterServiceTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"MBAfterServiceTableViewCell" owner:self options:nil]firstObject];
        }
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_orderArray.count>0) {
        NSDictionary *dic = _orderArray[indexPath.section][@"goods_detail"][indexPath.row];
        cell.describe.text= dic[@"goods_name"];
        NSString *str1 = dic[@"goods_price"];
        NSString *str2= dic[@"goods_number"];
        
        cell.priceAndNumber.text = [NSString stringWithFormat:@"￥%@x%@",str1,str2];
        NSURL *url = [NSURL URLWithString:dic[@"goods_thumb"]];
        [cell.showImageview  sd_setImageWithURL:url ];
    }
     cell.selectionStyle =  UITableViewCellSelectionStyleNone;

        return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MMLog(@"点我");
    
    UINavigationController  *nav =  [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MBOrderInfoTableViewController"];
    MBOrderInfoTableViewController *infoVc = (MBOrderInfoTableViewController *)nav.viewControllers.firstObject;
   
    
    //单号和时间
    NSString *order_id = [_orderArray[indexPath.section] valueForKeyPath:@"parent_order_sn"];
    infoVc.parent_order_sn = order_id;
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

#pragma mark --UITextFideldDelegate（点击键盘搜索触发事件）
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
   
    NSString *regex = @"^\\d{13}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isValid = [predicate evaluateWithObject:textField.text];
    if (isValid) {
        [self searchData:textField.text];
    }else{
        UIAlertView *alview = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入13位数字的订单号" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        [alview show];
    }
    
    [_searchTextField resignFirstResponder];
    return YES;
    
   
}
- (UIViewController *)popViewControllerAnimated:(BOOL)animated{
    
    NSNotification *notification =[NSNotification notificationWithName:@"HYTPopViewControllerNotification" object:nil userInfo:nil];
    
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    
    return [self.navigationController popViewControllerAnimated:animated];
}

#pragma mark ---让tabview的headview跟随cell一起滑动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_searchTextField resignFirstResponder];
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

- ( void )scrollViewDidEndDecelerating:( UIScrollView *)scrollView{


}
@end
