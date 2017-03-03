//
//  MBOrderInfoViewController.m
//  XiaoMaBao
//
//  Created by 张磊 on 15/6/19.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "MBOrderInfoViewController.h"
#import "MBFireOrderTableViewCell.h"
#import "MBSignaltonTool.h"
@interface MBOrderInfoViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak,nonatomic) UITableView *tableView;
@property (strong,nonatomic)NSDictionary *defaultAddressdict;

@end

@implementation MBOrderInfoViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    UITableView *tableView = [[UITableView alloc] init];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerNib:[UINib nibWithNibName:@"MBFireOrderTableViewCell" bundle:nil] forCellReuseIdentifier:@"MBFireOrderTableViewCell"];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.dataSource = self,tableView.delegate = self;
    tableView.frame = CGRectMake(0, TOP_Y, self.view.ml_width, self.view.ml_height - TOP_Y - 35);
    [self.view addSubview:_tableView = tableView];
    
    
    //获取订单详情
    [self getOrderInfo];
    
}

- (void)getOrderInfo{
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/order/order_detail"] parameters:@{@"session":dict,@"order_id":self.order_id} success:^(NSURLSessionDataTask *operation, id responseObject) {
        
        MMLog(@"%@",[responseObject valueForKeyPath:@"data"]);

        
        
        NSDictionary * status = [responseObject valueForKeyPath:@"status"];
        if([status[@"succeed"] isEqualToNumber:@1]){
            NSDictionary * data = [responseObject valueForKeyPath:@"data"];
            self.order_sn = [data valueForKeyPath:@"order_sn"];
            self.user_id = [data valueForKeyPath:@"user_id"];
            self.order_status = [data valueForKeyPath:@"order_status"];
            self.add_time_formatted = [data valueForKeyPath:@"add_time_formatted"];
            self.consignee = [data valueForKeyPath:@"consignee"];
            self.country = [data valueForKeyPath:@"country"];
            self.province = [data valueForKeyPath:@"province"];
            self.city = [data valueForKeyPath:@"city"];
            self.district = [data valueForKeyPath:@"district"];
            self.address = [data valueForKeyPath:@"address"];
            self.mobile = [data valueForKeyPath:@"mobile"];
            self.pay_name = [data valueForKeyPath:@"pay_name"];
            self.shipping_name = [data valueForKeyPath:@"shipping_name"];
            self.goods_amount_formatted = [data valueForKeyPath:@"goods_amount_formatted"];
            self.order_amount_formatted = [data valueForKeyPath:@"order_amount_formatted"];
            self.saving_money_formatted = [data valueForKeyPath:@"saving_money_formatted"];
            self.shipping_fee_formatted = [data valueForKeyPath:@"shipping_fee_formatted"];
            self.surplus_formatted = [data valueForKeyPath:@"surplus_formatted"];
            self.goodsListArray = [data valueForKeyPath:@"goods_list"];
        }
        
        _tableView.tableHeaderView = [self tableViewHeaderView];
        _tableView.tableFooterView = [self tableViewFooterView];
        [_tableView reloadData];
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        MMLog(@"失败");
    }];
}


- (UIView *)tableViewHeaderView{
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = BG_COLOR;
    headerView.frame = CGRectMake(0, 0, self.view.ml_width, 120);
    
    UIView *orderView = [[UIView alloc] init];
    orderView.backgroundColor = [UIColor whiteColor];
    orderView.frame = CGRectMake(0, MARGIN_8, self.view.ml_width, 50);
    
    UILabel *orderLbl = [[UILabel alloc] init];
    orderLbl.font = [UIFont systemFontOfSize:15];
    NSString * statusName = @"";
    if (![self.order_status isEqual:[NSNull null]]) {
        if (self.order_status) {
            
            if([self.order_status isEqualToString:@"await_pay"]){
                statusName = @"待付款";
            }else if([self.order_status isEqualToString:@"await_ship"]){
                statusName = @"待发货";
            }else if([self.order_status isEqualToString:@"shipped"]){
                statusName = @"待收货";
            }else if([self.order_status isEqualToString:@"order_status"]){
                statusName = @"已取消";
            }else{
                statusName = @"已完成";
            }
    }
    
    }
    
    orderLbl.text = statusName;
    orderLbl.textAlignment = NSTextAlignmentCenter;
    orderLbl.textColor = [UIColor colorWithHexString:@"2ba390"];
    orderLbl.frame = CGRectMake(0, 0, 60, orderView.ml_height);
    [orderView addSubview:orderLbl];
    
    UIView *orderLineView = [[UIView alloc] init];
    orderLineView.backgroundColor = [UIColor colorWithHexString:@"2ba390"];
    orderLineView.frame = CGRectMake(CGRectGetMaxX(orderLbl.frame) + PX_ONE, MARGIN_5, PX_ONE, orderView.ml_height - MARGIN_10);
    [orderView addSubview:orderLineView];
    
    UILabel *orderNmbLbl = [[UILabel alloc] init];
    orderNmbLbl.font = [UIFont systemFontOfSize:12];
    orderNmbLbl.text = [NSString stringWithFormat:@"订  单  号：%@",self.order_sn];
    orderNmbLbl.frame = CGRectMake(CGRectGetMaxX(orderLbl.frame) + MARGIN_8, 10, self.view.ml_width - CGRectGetMaxX(orderLbl.frame), 15);
    [orderView addSubview:orderNmbLbl];
    
    UILabel *orderTimeLbl = [[UILabel alloc] init];
    orderTimeLbl.font = [UIFont systemFontOfSize:12];
    
    orderTimeLbl.text = [NSString stringWithFormat:@"下单时间：%@",self.add_time_formatted];
    orderTimeLbl.frame = CGRectMake(orderNmbLbl.ml_x, CGRectGetMaxY(orderNmbLbl.frame) + MARGIN_5, self.view.ml_width - CGRectGetMaxX(orderLbl.frame), 15);
    [orderView addSubview:orderTimeLbl];
    
    UIView *headerBoxView = [[UIView alloc] init];
    headerBoxView.backgroundColor = [UIColor whiteColor];
    headerBoxView.frame = CGRectMake(0, CGRectGetMaxY(orderView.frame) + MARGIN_8, self.view.ml_width, 50);
    [headerView addSubview:headerBoxView];
    
    UILabel *consigneeLabel = [[UILabel alloc] init];
    consigneeLabel.text = [NSString stringWithFormat:@"收货人：%@" ,self.consignee];
    consigneeLabel.frame = CGRectMake(MARGIN_8, 10, self.view.ml_width * 0.5, 18);
    consigneeLabel.font = [UIFont systemFontOfSize:15];
    
    UILabel *phoneLabel = [[UILabel alloc] init];
    phoneLabel.font = [UIFont systemFontOfSize:15];
    phoneLabel.text = self.mobile;
    phoneLabel.frame = CGRectMake(consigneeLabel.ml_width, 10, self.view.ml_width * 0.5, 18);
    
    UILabel *addressLabel = [[UILabel alloc] init];
    
    addressLabel.text = [NSString stringWithFormat:@"地址 ：%@%@%@ %@",self.province,self.city,self.district,self.address];
    addressLabel.font = [UIFont systemFontOfSize:13];
    addressLabel.frame = CGRectMake(MARGIN_8, CGRectGetMaxY(consigneeLabel.frame) + MARGIN_5, self.view.ml_width - MARGIN_20, 15);
    
    [headerView addSubview:orderView];
    [headerBoxView addSubview:consigneeLabel];
    [headerBoxView addSubview:phoneLabel];
    [headerBoxView addSubview:addressLabel];
    
    return headerView;
}

- (UIView *)tableViewFooterView{
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor whiteColor];
    footerView.frame = CGRectMake(0, 0, self.view.ml_width, 80);
    
    UILabel *totalLbl = [[UILabel alloc] init];
    totalLbl.font = [UIFont systemFontOfSize:14];
    totalLbl.text =[NSString stringWithFormat:@"商品总额:%@",self.goods_amount_formatted];
    totalLbl.frame = CGRectMake(8, 10, self.view.ml_width, 15);
    
    UILabel *freightLbl = [[UILabel alloc] init];
    freightLbl.font = [UIFont systemFontOfSize:14];
    NSString * fee = [NSString stringWithFormat:@"运        费:%@",self.shipping_fee_formatted ];
    freightLbl.text = fee;
    freightLbl.frame = CGRectMake(8, CGRectGetMaxY(totalLbl.frame) + MARGIN_5, self.view.ml_width, 15);
    
    UILabel *surplusLbl = [[UILabel alloc] init];
    surplusLbl.font = [UIFont systemFontOfSize:14];
    surplusLbl.text = [NSString stringWithFormat:@"麻  包  卡:%@",self.surplus_formatted];;
    surplusLbl.frame = CGRectMake(8, CGRectGetMaxY(freightLbl.frame) + MARGIN_5, self.view.ml_width, 15);
    
    UILabel *remarkLbl = [[UILabel alloc] init];
    remarkLbl.font = [UIFont systemFontOfSize:14];
    remarkLbl.text = [NSString stringWithFormat:@"备        注:%@",@""];
    remarkLbl.frame = CGRectMake(8, CGRectGetMaxY(surplusLbl.frame) + MARGIN_5, self.view.ml_width, 15);
    
    [footerView addSubview:totalLbl];
    [footerView addSubview:freightLbl];
    [footerView addSubview:surplusLbl];
    [footerView addSubview:remarkLbl];
    
    return footerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_goodsListArray count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"MBFireOrderTableViewCell";
    
    MBFireOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    //第几组对应的goods_list
    
    if([_goodsListArray count] == 0){
        
        return cell;
    }
    //图片
    NSString *urlstr = [[self.goodsListArray objectAtIndex:indexPath.row]  valueForKeyPath:@"img"];
    NSURL *url = [NSURL URLWithString:urlstr];
    [cell.showimageview sd_setImageWithURL:url];
    //名字描述
    NSString *name1 = [[self.goodsListArray objectAtIndex:indexPath.row]  valueForKeyPath:@"name"];;
    cell.desribe.text = name1;
    //数量
    NSString *goods_number = [[self.goodsListArray objectAtIndex:indexPath.row]  valueForKeyPath:@"goods_number"];
    cell.countNumber.text = [NSString stringWithFormat:@"X %@",goods_number];
    NSString *price = [[self.goodsListArray objectAtIndex:indexPath.row]  valueForKeyPath:@"goods_price_formatted"];
    cell.countprice.text = price;
    return cell;

    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 146;
}

- (NSString *)titleStr{
    return @"订单详情";
}

@end
