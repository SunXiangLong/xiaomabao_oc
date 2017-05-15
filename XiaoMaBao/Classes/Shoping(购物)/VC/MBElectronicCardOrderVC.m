//
//  MBElectronicCardOrderVC.m
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/3/22.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "MBElectronicCardOrderVC.h"
#import "MBElectronicCardOrderModel.h"
#import "MBCardHelpCenterTitleCell.h"
#import "MBWelfareCardCollectionViewCell.h"
#import "MBElectronicCardOrderInfoVC.h"
#import "MBPaymentViewController.h"
@interface MBElectronicCardOrderVC ()
{
    UIButton *_lastButton;
    NSInteger _selectionPage;
    NSArray *_orderStatusArr;
    NSMutableArray<UIButton *> *_orderStatusBtnArr;
}

@property (weak, nonatomic) IBOutlet UIButton *allButton;
@property (weak, nonatomic) IBOutlet UIButton *waitpayBtn;
@property (weak, nonatomic) IBOutlet UIButton *waitcompleteBtn;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineLeft;
@property (weak, nonatomic) IBOutlet MBBaseCollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray <NSMutableArray<MBElectronicCardOrderModels *> *> *dataArr;
@property (strong, nonatomic) NSMutableArray <NSString *> * pageArr;
@end

@implementation MBElectronicCardOrderVC
-(NSMutableArray<NSMutableArray<MBElectronicCardOrderModels *> *> *)dataArr{
    if (!_dataArr) {
        _dataArr = [@[[@[] mutableCopy], [@[] mutableCopy],[@[] mutableCopy]] mutableCopy];
    }
    return _dataArr;
}
-(NSMutableArray<NSString *> *)pageArr{
    if (!_pageArr) {
        _pageArr = [@[@"1",@"1",@"1"] mutableCopy];
    }
    return _pageArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _lastButton = _allButton;
    _selectionPage = 0;
    _orderStatusArr = @[@"",@"waitpay",@"waitcomplete"];
    _orderStatusBtnArr = [@[self.allButton,_waitcompleteBtn,_waitpayBtn] mutableCopy];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(UISCREEN_WIDTH,UISCREEN_HEIGHT - 40 -TOP_Y);
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.pagingEnabled = true;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self addBottomLineView:self.topView];    
    [self reloadData];
}
-(void)reloadData
{
    [self show];
    
   
    
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    [MBNetworking   POSTOrigin:string(BASE_URL_root, @"/order/gift_order_list/") parameters:@{@"session":sessiondict,@"page":self.pageArr[_selectionPage],@"order_status":_orderStatusArr[_selectionPage]} success:^(id responseObject) {
        [self dismiss];
       
        if (![self charmResponseObject:responseObject]) {
            return ;
        } ;
        MMLog(@"%@",responseObject);
       
            MBElectronicCardOrderCell *cell = (MBElectronicCardOrderCell * )[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_selectionPage inSection:0]];
        if ([_pageArr[_selectionPage] integerValue] == 1) {
            MBRefreshGifFooter *footer = [MBRefreshGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(reloadData)];
            footer.automaticallyHidden = YES;
            cell.tableView.mj_footer =  footer;
        }else{
            [cell.tableView.mj_footer endRefreshing];
        }
        if ([responseObject[@"data"] count] > 0) {
            [self.dataArr[_selectionPage] addObjectsFromArray:[NSArray modelDictionary:responseObject modelKey:@"data" modelClassName:@"MBElectronicCardOrderModels"]];
            NSInteger coun = [_pageArr[_selectionPage] integerValue];
            coun ++;
            _pageArr[_selectionPage] = s_Integer(coun);
            [cell.tableView reloadData];
            
        }else{
            if (self.dataArr[_selectionPage].count > 0) {
                
                [cell.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                
                [cell.tableView reloadData];
                [cell.tableView.mj_footer removeFromSuperview];
                cell.tableView.mj_footer = nil;
                if ([_pageArr[_selectionPage] integerValue] == 1) {
                    cell.isDataNull = true;
                }
            }
            
        }
        
      
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [self show:@"请求失败！" time:1];
    }];
    
}
-(NSString *)titleStr{
    return @"电子卡订单";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnSelection:(UIButton *)sender {
    _selectionPage = sender.tag;
    [_collectionView setContentOffset:CGPointMake(_selectionPage*UISCREEN_WIDTH, 0) animated:false];
    
    _lineLeft.constant = 75*_selectionPage;
    [_lastButton setTitleColor:UIcolor(@"555555") forState:UIControlStateNormal];
    _lastButton = _orderStatusBtnArr[_selectionPage];
    [_lastButton setTitleColor: UIcolor(@"e8465e") forState:UIControlStateNormal];
}
- (void)payForMoney:(UIButton *)btn{

    
    MBPaymentViewController *payVc = [[MBPaymentViewController alloc] init];
    
    payVc.orderInfo = @{@"order_sn":self.dataArr[_selectionPage][btn.tag].order_sn,
                        @"order_amount":[self.dataArr[_selectionPage][btn.tag].order_amount substringFromIndex:1],
                        @"pay_status":@"0",
                        @"subject":@"北京小麻包信息技术有限公司",
                        @"desc":@"购买电子卡业务"
                        };
    payVc.type = MBAnECardOrders;
    payVc.isOrderVC = true;
    [self pushViewController:payVc Animated:true];
}
- (void)details:(UIButton *)btn{
    
      NSString *order_sn = _dataArr[_selectionPage][btn.tag].order_sn;
     [self performSegueWithIdentifier:@"MBElectronicCardOrderInfoVC" sender:order_sn];

}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MBElectronicCardOrderInfoVC *VC = (MBElectronicCardOrderInfoVC *)segue.destinationViewController;
    VC.orderSn = sender;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    MBElectronicCardOrderModels *orderModel = _dataArr[_selectionPage][section];
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, UISCREEN_WIDTH, 35);
    view.backgroundColor = [UIColor whiteColor];
    UIImageView *topImage = [[UIImageView alloc] init];
    topImage.backgroundColor = UIcolor(@"f2f3f7");
    [view addSubview:topImage];
    //订时间
    UILabel *order_time = [[UILabel alloc] init];
    order_time.textColor = UIcolor(@"2c2c2c");
    order_time.text = orderModel.add_time;
    order_time.font = [UIFont systemFontOfSize:13];
    [view addSubview:order_time];
    //订单状态
    UILabel *sectionLbl = [[UILabel alloc] init];
    sectionLbl.textColor = UIcolor(@"d66263");
    sectionLbl.text =  orderModel.order_status_code;;
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
    
  

    return view;
}



- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    MBElectronicCardOrderModels *orderModel = _dataArr[_selectionPage][section];
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
    priceLbl.text = orderModel.order_amount;
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
//    去付款
    UIButton *sendServiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendServiceBtn setTitleColor:UIcolor(@"555555") forState:UIControlStateNormal];
    sendServiceBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    sendServiceBtn.layer.cornerRadius = 3.0;
    [sendServiceBtn setTitle:@"去付款" forState:UIControlStateNormal];
    sendServiceBtn.layer.borderColor = UIcolor(@"555555").CGColor;
    sendServiceBtn.layer.borderWidth = PX_ONE;
    sendServiceBtn.tag = section;
//    详情
    UIButton *detailsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [detailsBtn setTitleColor:UIcolor(@"555555") forState:UIControlStateNormal];
    detailsBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    detailsBtn.layer.cornerRadius = 3.0;
    detailsBtn.layer.borderColor = UIcolor(@"555555").CGColor;
    detailsBtn.layer.borderWidth = PX_ONE;
    detailsBtn.tag = section;
    [detailsBtn setTitle:@"详情" forState:UIControlStateNormal];
    [detailsBtn addTarget:self action:@selector(details:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    NSString *order_status = orderModel.order_status_code;
    if(order_status != nil && (NSNull *)order_status != [NSNull null]){
        if([order_status isEqualToString:@"待付款"]){
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
            
        }else{
            [footerMainView addSubview:detailsBtn];
            [detailsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-10);
                make.centerY.mas_equalTo(0);
                make.width.mas_equalTo(45);
            }];

        }
        
    }
    
     [self addBottomLineView:footerMainView];
    return footerMainView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  
    return self.dataArr[_selectionPage].count ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return self.dataArr[_selectionPage][section].orderCardsListArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 99;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 30;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MBElectronicCardModel *model = self.dataArr[_selectionPage][indexPath.section].orderCardsListArray[indexPath.row];
    
    MBElectronicSubOrderCardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBElectronicSubOrderCardCell" forIndexPath:indexPath];
    cell.model = model;
    return cell;
    
}
#pragma mark UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataArr.count;
    
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MBElectronicCardOrderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MBElectronicCardOrderCell" forIndexPath:indexPath];
   
    if ([_pageArr[_selectionPage] integerValue] == 1&&_selectionPage !=0 ) {
        
        [self reloadData];
    }
    
    return cell;
    
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    if ([scrollView isEqual:self.collectionView]  ) {
        // 取出对应的子控制器
        _selectionPage  = scrollView.contentOffset.x / scrollView.ml_width;
        _lineLeft.constant = 75*_selectionPage;
        [_lastButton setTitleColor:UIcolor(@"555555") forState:UIControlStateNormal];
        _lastButton = _orderStatusBtnArr[_selectionPage];
        [_lastButton setTitleColor: UIcolor(@"e8465e") forState:UIControlStateNormal];
        if ([_pageArr[_selectionPage] integerValue] == 1&&_selectionPage !=0 ) {
            
            [self reloadData];
        }
        
    }
    
}


@end
