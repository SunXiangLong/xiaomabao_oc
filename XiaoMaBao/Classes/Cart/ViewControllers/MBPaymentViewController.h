//
//  MBPaymentViewController.h
//  XiaoMaBao
//
//  Created by 张磊 on 15/6/2.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "BkBaseViewController.h"

@interface MBPaymentViewController : BkBaseViewController

@property(strong,nonatomic)NSString *order_id;
@property(strong,nonatomic)NSString *pay_id;
@property(strong,nonatomic)NSString *shipping_id;
@property(strong,nonatomic)NSString *address_id;
@property(strong,nonatomic)NSString *bonus_id;
@property(strong,nonatomic)NSString *coupon_id;
@property(strong,nonatomic)NSString *integral;
@property(strong,nonatomic)NSString *inv_type;
@property(strong,nonatomic)NSString *inv_content;
@property(strong,nonatomic)NSString *inv_payee;

@property(strong,nonatomic)NSString *isOrderDetail;

@property(strong,nonatomic) NSNumber *is_cross_border;

@property(strong,nonatomic)NSString *real_name;
@property(strong,nonatomic)NSString *identity_card;

@property(strong,nonatomic)NSDictionary *orderInfo;
@property(strong,nonatomic)NSString *type;

@property (nonatomic,strong) NSDictionary *service_data;


@end
