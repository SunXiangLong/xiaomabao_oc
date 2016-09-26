//
//  MBOrderInfoViewController.h
//  XiaoMaBao
//
//  Created by 张磊 on 15/6/19.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "BkBaseViewController.h"

@interface MBOrderInfoViewController : BkBaseViewController
//订单id
@property(copy,nonatomic)NSString *order_id;
//订单号
@property(copy,nonatomic)NSString *order_sn;
//时间
@property(copy,nonatomic)NSString *order_time;
//该订单下有几个商品
@property(strong,nonatomic)NSMutableArray *goodsListArray;

//时间
@property(copy,nonatomic)NSString *user_id;
@property(copy,nonatomic)NSString *order_status;
@property(copy,nonatomic)NSString *add_time_formatted;
@property(copy,nonatomic)NSString *consignee;
@property(copy,nonatomic)NSString *country;
@property(copy,nonatomic)NSString *province;
@property(copy,nonatomic)NSString *city;
@property(copy,nonatomic)NSString *district;
@property(copy,nonatomic)NSString *address;
@property(copy,nonatomic)NSString *mobile;
@property(copy,nonatomic)NSString *pay_name;
@property(copy,nonatomic)NSString *shipping_name;
@property(copy,nonatomic)NSString *goods_amount_formatted;
@property(copy,nonatomic)NSString *order_amount_formatted;
@property(copy,nonatomic)NSString *saving_money_formatted;
@property(copy,nonatomic)NSString *shipping_fee_formatted;
@property(copy,nonatomic)NSString *surplus_formatted;

@end
