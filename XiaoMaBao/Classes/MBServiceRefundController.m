//
//  MBServiceRefundController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/4/7.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBServiceRefundController.h"
#import "TPKeyboardAvoidingTableView.h"
#import "MBServiceRefundHeadView.h"
#import "MBMBServiceRefundTwoCell.h"
#import "MBServiceRefundFootView.h"
#import "MBDetailsRefundController.h"
#import "MBServiceRefundFootCell.h"
@interface MBServiceRefundController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSDictionary *_dataDic;
    NSMutableArray *_selectedArray;
    NSMutableArray *_ticketsArray;
    
    NSMutableArray *_refundFoot;
    NSArray *_refundArray;
    NSString *_content;
    NSString *_price;
    
    UITableView *_refundFootTableView;
}
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingTableView *tableView;

@end

@implementation MBServiceRefundController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MBServiceRefundController"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MBServiceRefundController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _selectedArray = [NSMutableArray     array];
    _ticketsArray =  [NSMutableArray     array];
    _refundFoot =    [NSMutableArray      array];
    _refundArray = @[@"预约不上",@"商家营业单不接待",@"商家营业／装修／转让",@"去过了，不太满意",@"朋友，网上评价不好",@"买多了／买错了",@"计划有变／没时间消费",@"后悔了，不想要了",@"商家说可以直接团购价到店消费",@"联系不上商家"];
    for (NSString *str in _refundArray) {
        [_refundFoot addObject:@"0"];
    }
    [self setheadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(is_selected:) name:@"is_selected" object:nil];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(serviceRefundFoot:) name:@"is_reSelected" object:nil];
    
}
- (void)is_selected:(NSNotification *)notificat{
    NSIndexPath *indexPath = notificat.userInfo[@"indexPath"];
    NSString *selected =  notificat.userInfo[@"selected"];
    _selectedArray[indexPath.row] = selected;
    [self.tableView reloadData];
     self.tableView.tableFooterView = [self setTableFootView];
}
- (void)serviceRefundFoot:(NSNotification *)notificat{
    NSIndexPath *indexPath = notificat.userInfo[@"indexPath"];
    NSString *selected =  notificat.userInfo[@"selected"];
    
    
    _refundFoot[indexPath.row] = selected;
    [_refundFootTableView reloadData];
}
#pragma mark -- 请求数据
- (void)setheadData{
    [self show];
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    NSString *url =[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/service/return_order_info"];
    if (! sid) {
        [self show:@"账号已过期，请重新登录" time:1];
        return;
    }
    [MBNetworking POSTOrigin:url parameters:@{@"session":sessiondict,@"order_id":self.order_id} success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        [self dismiss];
        if ([[responseObject valueForKeyPath:@"status"]isEqualToNumber:@1]) {
            _dataDic = responseObject;
            self.tableView.tableFooterView = [self setTableFootView];
            self.tableView.tableHeaderView = [self setTableHeadView];
            for (NSDictionary *dic  in _dataDic[@"data"][@"tickets"]) {
                [_selectedArray  addObject:@"0"];
                [_ticketsArray   addObject:dic];
            }
            [self.tableView reloadData];
        }else{
        [self show:@"数据错误" time:1];
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [self show:@"请求失败 " time:1];
        NSLog(@"%@",error);
    }];
    
}
#pragma mark -- 提交退款数据
- (void)setSubmitData{
    [self show];
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    NSString *url =[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/service/submit_return_order"];
    if (! sid) {
        [self show:@"账号已过期，请重新登录" time:1];
        return;
    }
    NSMutableString *ticket_ids = [NSMutableString string];
    for (NSInteger i= 0; i<_selectedArray.count; i++) {
        NSString *str = _selectedArray[i];
        NSDictionary *dic = _ticketsArray[i];
        NSString *str1 =  dic[@"ticket_id"];
        if ([str isEqualToString:@"1"]) {
            if (ticket_ids.length>0) {
                [ticket_ids appendFormat:@"|"];
                [ticket_ids appendFormat:str1];
            }else{
                ticket_ids = [NSMutableString stringWithFormat:@"%@",str1];

            }
        }
    }
    NSLog(@"%@",ticket_ids);
    
    
    [MBNetworking POSTOrigin:url parameters:@{@"session":sessiondict,@"order_id":self.order_id,@"ticket_ids":ticket_ids,@"reason":@"测试"} success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        
        
        [self dismiss];
        if ([[responseObject valueForKeyPath:@"status"]isEqualToNumber:@1]) {
          
            MBDetailsRefundController *VC = [[MBDetailsRefundController alloc] init];
            VC.order_id = self.order_id;
            VC.price  = [NSString stringWithFormat:@"%@元",_price];
            [self pushViewController:VC Animated:YES];
        }else{
            [self show:@"数据错误" time:1];
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [self show:@"请求失败 " time:1];
        NSLog(@"%@",error);
    }];
    
}
-(NSString *)titleStr{
return @"申请退款";
}
- (UIView *)setTableHeadView{
    
    UIView *view  = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, UISCREEN_WIDTH, 40);
    MBServiceRefundHeadView *headView = [MBServiceRefundHeadView instanceView];
    headView.frame = view.frame;
    [view addSubview:headView];
    if (_dataDic) {
        headView.code.text  = _dataDic[@"data"][@"product_sn"];
    }
    return view;
    

}
- (UIView *)setTableFootView{
    UIView *view  = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, UISCREEN_WIDTH, 750);
    MBServiceRefundFootView *footView = [MBServiceRefundFootView instanceView];
    footView.frame = view.frame;
    _refundFootTableView = footView.tableview;
   _refundFootTableView.delegate = self;
   _refundFootTableView.dataSource = self;
    [footView.button addTarget:self action:@selector(ServiceRefund) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:footView];
    NSInteger num = 0;
    for (NSString *str in _selectedArray) {
        if ([str isEqualToString:@"1"]) {
            num++;
        }
    }
    if (_dataDic) {
        _price = _dataDic[@"data"][@"product_shop_price"];
        
        footView.totalAmount.text = [NSString stringWithFormat:@"现金%.2f元",num*[_price doubleValue]];
    }

    
    return view;

}
- (void)ServiceRefund{
    
    NSInteger num = 0;
    for (NSString *str in _selectedArray) {
        if ([str isEqualToString:@"1"]) {
            num++;
        }
    }
    
    NSMutableString *center = [NSMutableString string];
    for (NSInteger i = 0; i<_refundFoot.count; i++) {
        NSString *str = _refundFoot[i];
        if ([str isEqualToString:@"1"]) {
            [center appendString:_refundArray[i]];
        }
    }
    _content = center;
    if (num==0) {
        [self show:@"请勾选要退款的服务" time:1];
        return;
    }
    if (_content.length<1) {
        [self show:@"请勾选退款理由" time:1];
        return;
    }
    
    [self setSubmitData];
 
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    if ([tableView isEqual:_refundFootTableView])  {
        return _refundArray.count;
    }
        return _selectedArray.count;
   

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:_refundFootTableView])  {
        MBServiceRefundFootCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBServiceRefundFootCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"MBServiceRefundFootCell"owner:nil options:nil]firstObject];
        }
        cell.indexPath = indexPath;
        cell.mabaoquan.text = _refundArray[indexPath.row];
        if ([_refundFoot[indexPath.row] isEqualToString:@"0"] ) {
            cell.selectButton.selected = NO;
        }else{
            cell.selectButton.selected = YES;
        }
        
        return cell;
    }

    
    NSDictionary *dic = _ticketsArray[indexPath.row];
    MBMBServiceRefundTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBMBServiceRefundTwoCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MBMBServiceRefundTwoCell"owner:nil options:nil]firstObject];
    }
    cell.indexPath = indexPath;
    cell.mabaoquan.text = dic[@"ticket_code"];
    if ([_selectedArray[indexPath.row] isEqualToString:@"0"] ) {
        cell.selectButton.selected = NO;
    }else{
        cell.selectButton.selected = YES;
    }
    
            return cell;

    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 
    
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
