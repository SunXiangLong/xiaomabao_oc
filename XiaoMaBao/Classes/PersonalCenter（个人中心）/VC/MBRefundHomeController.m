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
#import "MBDeliveryInformationViewController.h"
#import "MBRefundScheduleViewController.h"
#import "MBOrderInfoTableViewController.h"
#import "MBRefundModel.h"
@interface MBRefundHomeController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    BOOL _isToApple;
    
    NSInteger _allOrderPage;
    NSInteger _toApplyPage;
    
    UIButton *_lastButton;
    UILabel *_promptLable;
}
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITableView *tableViewTo;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstraint;
@property (weak, nonatomic) IBOutlet UIButton *allOrderButton;
@property (weak, nonatomic) IBOutlet UIButton *toApplyButton;
@property (weak, nonatomic) IBOutlet UIView *mentLineView;
@property (strong, nonatomic) MBRefundModel *searchRefundModel;
@property (copy, nonatomic) NSMutableArray<MBRefundModel *> *allOrderData;
@property (copy, nonatomic) NSMutableArray<MBRefundModel *> *toApplyOrderData;
@end

@implementation MBRefundHomeController

-(NSMutableArray *)allOrderData{
    if (!_allOrderData) {
        _allOrderData = [NSMutableArray array];
    }
    return _allOrderData;
}
-(NSMutableArray *)toApplyOrderData{
    if (!_toApplyOrderData) {
        _toApplyOrderData = [NSMutableArray array];
    }
    return _toApplyOrderData;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _allOrderPage = 1;
    _toApplyPage = 1;
    _tableViewTo.tableFooterView = [[UIView alloc] init];
    _tableView.tableFooterView =  [[UIView alloc] init];
    _lastButton = _allOrderButton;
    
    [self requestData];
    [self setUI];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RefundStatus:) name:@"Refund_status" object:nil];
    
}
- (void)RefundStatus:(NSNotification *)notificat{
    
    NSString *section = [notificat userInfo][@"section"];
    NSInteger sect = [section  integerValue];
    MBRefundModel *model = _allOrderData[sect];
    model.refund_status = @(2);
    [_tableView reloadData];
    
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
- (IBAction)orderMenuBtnClick:(UIButton *)sender {
    if (_lastButton != sender) {
        _searchRefundModel = nil;
        [sender setTitleColor:NavBar_Color forState:UIControlStateNormal];
        [_lastButton setTitleColor:[UIColor colorWithHexString:@"313232"] forState:UIControlStateNormal];
        [UIView animateWithDuration:.25 animations:^{
            _leftConstraint.constant    = sender.tag*((UISCREEN_WIDTH - 1)/2+1);
            [_mentLineView setNeedsLayout];
        }];
        _lastButton = sender;
        switch (sender.tag) {
            case 0:{
                _isToApple = false;
                [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            }break;
                
            default:{
                _isToApple = true;
                [_scrollView setContentOffset:CGPointMake(UISCREEN_WIDTH, 0) animated:YES];
                if (!_toApplyOrderData) {
                    
                    [self requestData];
                }
            }break;
        }
    }
    
}


/***  判断是否存在数据*/
- (void)isData{

    switch (_lastButton.tag) {
        case 0:{
            if (_allOrderData.count == 0  ) {
                _promptLable.hidden  = NO;
                _promptLable.text = @"您还没有可退换货的订单";
                self.tableView.mj_footer.hidden = YES;
            }
        }break;
        default:{
            
            if (_toApplyOrderData.count == 0  ) {
                _promptLable.hidden  = NO;
                _promptLable.text = @"您还没有已申请退换货的订单";
                self.tableViewTo.mj_footer.hidden = YES;
            }
            
        
        }break;
    }
    
}

#pragma mark --请求退换货订单数据（_isToApple 为yes为已申请的数据，否则就是全部数据）
- (void)requestData{
    
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    NSString *url = string(BASE_URL_root, @"/refund/refund_list");
    NSDictionary *parameter = @{@"session":sessiondict,@"page":s_Integer(_allOrderPage)};
    if (_isToApple) {
        url =  string(BASE_URL_root, @"/refund/apply_list");
        parameter = @{@"session":sessiondict,@"page":s_Integer(_toApplyPage)};
    }
    
    [self show];
    
    [MBNetworking POSTOrigin:url parameters:parameter success:^(id responseObject) {
        [self dismiss];
        if (![self checkData:responseObject]) {
            return ;
        }
        //        MMLog(@"%@",responseObject);
        if (_isToApple) {
            
            if (_toApplyPage == 1) {
                self.tableViewTo.mj_footer = [MBRefreshGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
                
            }else{
                [_tableViewTo.mj_footer endRefreshingWithNoMoreData];
            }
            [self.toApplyOrderData addObjectsFromArray:[NSArray modelDictionary:responseObject modelKey:@"data" modelClassName:@"MBRefundModel"]];
            if (_toApplyPage == 1) {
                [self isData];
            }
            [_tableViewTo reloadData];
            _toApplyPage++;
            
        }else{
            if (_allOrderPage == 1) {
                self.tableView.mj_footer = [MBRefreshGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
                
            }else{
                [_tableView.mj_footer endRefreshingWithNoMoreData];
            }
            
            [self.allOrderData addObjectsFromArray:[NSArray modelDictionary:responseObject modelKey:@"data" modelClassName:@"MBRefundModel"]];
            if (_allOrderPage == 1) {
                [self isData];
            }
            
            
            [_tableView reloadData];
            _allOrderPage++;
            
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [self show:@"请求失败！" time:1];
         MMLog(@"%@",error);
    }];
    
    
}
#pragma mark --搜索订单数据
- (void)searchData:(NSString *)str{
    
    [self show];
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    [MBNetworking POSTOrigin:string(BASE_URL_root, @"/refund/refund_search") parameters:@{@"session":sessiondict,@"order_sn":str} success:^(id responseObject){
        [self dismiss];
        if (![self checkData:responseObject]) {
            return ;
        }
        MMLog(@"%@",responseObject);
        if ([responseObject[@"data"] count] >0) {
            _searchRefundModel = [MBRefundModel yy_modelWithDictionary:responseObject[@"data"][0]];
            switch (_lastButton.tag) {
                case 0:[_tableView reloadData];  break;
                    
                default:[_tableViewTo reloadData]; break;
            }
        }else{
            [self show:@"搜不到该订单，请检查订单号是否正确" time:.5];
        
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [self show:@"请求失败！" time:.5];
        MMLog(@"%@",error);
    }];
}


#pragma mark -- 申请事件
-(void)comment:(UIButton *)button{
    MBRefundModel *model = nil;
    if (_lastButton.tag == 0) {
        model = _allOrderData[button.tag];
    }
    if (_lastButton.tag == 1) {
        model = _toApplyOrderData[button.tag];
    }
    if (_searchRefundModel) {
        model = _searchRefundModel;
    }
   
    
    if ([button.titleLabel.text isEqualToString:@"申请退款/换货"]) {
        
        
        MBAfterSalesServiceViewController *VC = [[MBAfterSalesServiceViewController alloc] init] ;
        VC.type = @"1";
        VC.section = button.tag;
        VC.order_sn = model.order_sn;
        VC.order_id = model.order_id;
        [self.navigationController pushViewController:VC animated:YES];
        
    }else if ([button.titleLabel.text isEqualToString:@"进度查询"]){
        MBRefundScheduleViewController *VC = [[MBRefundScheduleViewController alloc] init];
        VC.order_sn = model.order_sn;
        VC.orderid = model.order_id;
        [self.navigationController pushViewController:VC animated:YES];
        MMLog(@"进度查询");
    }else if ([button.titleLabel.text isEqualToString:@"重新申请"]){
        
        MMLog(@"重新申请");
        MBAfterSalesServiceViewController *VC = [[MBAfterSalesServiceViewController alloc] init];
        VC.type = @"0";
        VC.section = button.tag;
        VC.order_sn = model.order_sn;
        VC.order_id = model.order_id;
        [self.navigationController pushViewController:VC animated:YES];
        
    }else if([button.titleLabel.text isEqualToString:@"填写运单号"]){
        MBDeliveryInformationViewController *VC = [[MBDeliveryInformationViewController alloc] init];
        VC.back_tax = model.back_tax;
        VC.order_sn = model.order_sn;
        VC.order_id = model.order_id;
        VC.section = button.tag;
        [self.navigationController pushViewController:VC animated:YES];
        
    }
    
}
#pragma mark -UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    
    switch (_lastButton.tag) {
        case 0 :return _searchRefundModel?1:_allOrderData.count;
        default:return _searchRefundModel?1:_toApplyOrderData.count;
    }
    
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (_lastButton.tag) {
        case 0 :return _searchRefundModel?_searchRefundModel.goodsDetail.count:_allOrderData[section].goodsDetail.count;
        default:return _searchRefundModel?_searchRefundModel.goodsDetail.count:_toApplyOrderData[section].goodsDetail.count;
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
    MBRefundModel *model = nil;
    if (_lastButton.tag == 0) {
        model = _allOrderData[section];
    }
    if (_lastButton.tag == 1) {
        model = _toApplyOrderData[section];
    }
    if (_searchRefundModel) {
        model = _searchRefundModel;
    }
    UIView *sectionView = [[UIView alloc] init];
    sectionView.frame = CGRectMake(0, 0, UISCREEN_WIDTH, 25);
    sectionView.backgroundColor = NavBar_Color;
    
    //日期
    UILabel *sectionLbl = [[UILabel alloc] init];
    sectionLbl.textColor = [UIColor whiteColor];
    sectionLbl.textAlignment = 2;
    sectionLbl.text = model.add_time;
    sectionLbl.frame = CGRectMake(UISCREEN_WIDTH -320 , 0,300, sectionView.ml_height);
    sectionLbl.font = [UIFont systemFontOfSize:12];
    [sectionView addSubview:sectionLbl];
    
    //订单号
    UILabel *section_order_sn = [[UILabel alloc] init];
    section_order_sn.textColor = [UIColor whiteColor];
    section_order_sn.text = [NSString stringWithFormat:@"订单号：%@",model.order_sn];
    section_order_sn.frame = CGRectMake(8, 0,150, sectionView.ml_height);
    section_order_sn.font = [UIFont systemFontOfSize:12];
    [sectionView addSubview:section_order_sn];
    
    
    UILabel *lable = [[UILabel alloc] init];
    lable.text = @"已完成" ;
    lable.textColor = [UIColor redColor];
    lable.frame = CGRectMake(CGRectGetMaxX(section_order_sn.frame), 0, 100, sectionView.ml_height);
    lable.font = [UIFont systemFontOfSize:10];
    if ([model.refund_status integerValue] == 4) {
        [sectionView addSubview:lable];
    }
    
    return sectionView;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    MBRefundModel *model = nil;
    if (_lastButton.tag == 0) {
        model = _allOrderData[section];
    }
    if (_lastButton.tag == 1) {
        model = _toApplyOrderData[section];
    }
    if (_searchRefundModel) {
        model = _searchRefundModel;
    }
    
    
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
    priceLbl.text = [NSString stringWithFormat:@"¥%@",model.order_total_money];;
    priceLbl.frame = CGRectMake(CGRectGetMaxX(footerLbl.frame), 0, 150, footerView.ml_height);
    priceLbl.font = [UIFont systemFontOfSize:12];
    [footerMainView addSubview:priceLbl];
    
    
    UIButton *sendServiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *sendServiceBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *sendServiceBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    sendServiceBtn.tag = section;
    sendServiceBtn1.tag = section;
    sendServiceBtn2.tag = section;
    
    if([model.refund_status integerValue] == 1){
        
        [sendServiceBtn setTitle:@"申请退款/换货" forState:UIControlStateNormal];
        [sendServiceBtn addTarget:self action:@selector(comment:) forControlEvents:UIControlEventTouchUpInside];
        sendServiceBtn.frame = CGRectMake(UISCREEN_WIDTH - 8-80 , (footerView.ml_height - 20) * 0.5, 80, 20);
        [sendServiceBtn setTitleColor:NavBar_Color forState:UIControlStateNormal];
        sendServiceBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        sendServiceBtn.layer.cornerRadius = 3.0;
        sendServiceBtn.layer.borderColor = NavBar_Color.CGColor;
        sendServiceBtn.layer.borderWidth = PX_ONE;
        
    }else if([model.refund_status integerValue] == 5){
        
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
    }else if([model.refund_status integerValue] == 3){
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
    MBRefundGoodsModel *model = nil;
    if (_lastButton.tag == 0) {
        model  = _allOrderData[indexPath.section].goodsDetail[indexPath.row];
    }
    if (_lastButton.tag == 1) {
        model = _toApplyOrderData[indexPath.section].goodsDetail[indexPath.row];
    }
    if (_searchRefundModel) {
        model = _searchRefundModel.goodsDetail[indexPath.row];
    }
    
    MBAfterServiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBAfterServiceTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MBAfterServiceTableViewCell" owner:self options:nil]firstObject];
    }
    cell.refundGoodsModel = model;
    [cell uiedgeInsetsZero];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MBRefundGoodsModel *model = nil;
    if (_lastButton.tag == 0) {
        model = _allOrderData[indexPath.section].goodsDetail[indexPath.row];
    }
    if (_lastButton.tag == 1) {
        model = _toApplyOrderData[indexPath.section].goodsDetail[indexPath.row];
    }
    if (_searchRefundModel) {
        model = _searchRefundModel.goodsDetail[indexPath.row];
    }
    MBOrderInfoTableViewController  *infoVC =  [[UIStoryboard storyboardWithName:@"PersonalCenter" bundle:nil] instantiateViewControllerWithIdentifier:@"MBOrderInfoTableViewController"];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:infoVC];

    
    
    //单号和时间
    infoVC.order_id = model.order_id;
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_searchTextField resignFirstResponder];
}

- ( void )scrollViewDidEndDecelerating:( UIScrollView *)scrollView{
    if (scrollView  == _scrollView) {
        _searchRefundModel = nil;
        CGFloat contentOffsetX = scrollView.contentOffset.x;
        NSInteger num = contentOffsetX / UISCREEN_WIDTH;
       
        
        [_lastButton setTitleColor:[UIColor colorWithHexString:@"313232"] forState:UIControlStateNormal];
        
//        if (_lastButton == _allOrderButton) {
//            [_toApplyButton setTitleColor:NavBar_Color forState:UIControlStateNormal];
//            _lastButton = _toApplyButton;
//        }else{
//            [_allOrderButton setTitleColor:NavBar_Color forState:UIControlStateNormal];
//            _lastButton = _toApplyButton;
//        }
        
        [UIView animateWithDuration:.25 animations:^{
            _leftConstraint.constant   = num*((UISCREEN_WIDTH - 1)/2+1);
            [_mentLineView setNeedsLayout];
        }];
        
        
        switch (num) {
            case 0:{
                _isToApple = false;
                [_allOrderButton setTitleColor:NavBar_Color forState:UIControlStateNormal];
                _lastButton = _allOrderButton;
                [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            }break;
                
            default:{
                _isToApple = true;
                [_toApplyButton setTitleColor:NavBar_Color forState:UIControlStateNormal];
                _lastButton = _toApplyButton;
                [_scrollView setContentOffset:CGPointMake(UISCREEN_WIDTH, 0) animated:YES];
                if (!_toApplyOrderData) {
                    [self requestData];
                }
                
            }break;
                
        }
    }
    
}
@end
