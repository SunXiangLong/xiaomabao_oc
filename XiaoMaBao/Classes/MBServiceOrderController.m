//
//  MBServiceOrderController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/4/6.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBServiceOrderController.h"
#import "MBServiceOrderFootView.h"
#import "MBServiceOrderOneCell.h"
#import "MBServiceOrderTwoCell.h"
#import "MBServiceOrderThreeCell.h"
#import "MBServiceDetailsViewController.h"
@interface MBServiceOrderController (){

    NSDictionary  *_dataDic;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MBServiceOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setheadData];
}
#pragma mark -- 请求数据
- (void)setheadData{
    
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    NSString *url =[NSString stringWithFormat:@"%@%@",BASE_URL_SHERVICE,@"service/order_info"];
    if (! sid) {
        return;
    }
    [MBNetworking POSTAPPStore:url parameters:@{@"session":sessiondict,@"order_id":self.order_id} success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        if (responseObject) {
            _dataDic = responseObject;
            
            [self.tableView reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self show:@"请求失败 " time:1];
        NSLog(@"%@",error);
    }];
    
}
-(NSString *)titleStr{
    return @"订单详情";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_dataDic) {
        return 3;
    }
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==1) {
        NSArray *arr = _dataDic[@"ticket_info"];
        return arr.count;
    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0: return 95;
        case 1: return 40;
        default:  return 360;
          
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==1) {
        if ([_dataDic[@"return_status"] isEqualToNumber:@1]) {
            return 47;
        }
       
    }
    return 0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section;{
    
    if (section==1) {
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(0, 0, UISCREEN_WIDTH, 47);
        MBServiceOrderFootView *footView = [MBServiceOrderFootView instanceView];
        footView.vc = self;
        footView.order_id =self.order_id;
        footView.frame = view.frame;
        [view addSubview:footView];
        return view;
    }
 
    return nil;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0: {
            NSDictionary *dic = _dataDic[@"product_info"];
            MBServiceOrderOneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBServiceOrderOneCell"];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"MBServiceOrderOneCell"owner:nil options:nil]firstObject];
            }
            [cell.shopImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"product_img"]] placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
            cell.service_name.text = dic[@"product_name"];
            cell.service_price.text = [NSString stringWithFormat:@"¥ %@",dic[@"product_shop_price"]];
            
            return cell;}
        case 1: {
            NSDictionary *dic = _dataDic[@"ticket_info"][indexPath.row];

            MBServiceOrderTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBServiceOrderTwoCell"];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"MBServiceOrderTwoCell"owner:nil options:nil]firstObject];
            }
            cell.mabaoquan.text = dic[@"ticket_code"];
            cell.zhuangtai.text = dic[@"ticket_status"];
            
            return cell;}
        default: {
             NSDictionary *orderDic = _dataDic[@"order_info"];
            NSDictionary *shopDic =  _dataDic[@"shop_info"];
            MBServiceOrderThreeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBServiceOrderThreeCell"];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"MBServiceOrderThreeCell"owner:nil options:nil]firstObject];
            }
            cell.store_name.text = shopDic[@"shop_name"];
            cell.store_adress.text =  [NSString stringWithFormat:@"地址：%@",shopDic[@"shop_address"]];
            cell.store_phone.text = [NSString stringWithFormat:@"电话：%@",shopDic[@"shop_phone"]];
            
            cell.order_number.text = [NSString stringWithFormat:@"订单号：%@",orderDic[@"product_sn"]];
            cell.order_phone.text = [NSString stringWithFormat:@"购买手机号：%@",orderDic[@"mobile_phone"]];
            cell.oredr_time.text = [NSString stringWithFormat:@"购买手机号：%@",orderDic[@"pay_time"]];
            cell.order_num.text = [NSString stringWithFormat:@"数量：%@",orderDic[@"product_number"]];
            cell.order_price.text = [NSString stringWithFormat:@"总价：%@元",orderDic[@"order_amount"]];
            return cell;}
            
    }
   
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
         NSDictionary *dic = _dataDic[@"product_info"];
        MBServiceDetailsViewController *VC = [[MBServiceDetailsViewController alloc] init];
        VC.product_id = dic[@"product_id"];
        [self pushViewController:VC Animated:YES];
 
    }
   
}

@end
