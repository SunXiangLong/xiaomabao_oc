//
//  MBFireOrderViewController.h
//  XiaoMaBao
//
//  Created by 张磊 on 15/6/2.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "BkBaseViewController.h"

@interface MBFireOrderViewController : BkBaseViewController
@property(strong,nonatomic)NSArray *CartinfoDict;
@property(strong,nonatomic)NSDictionary *total;
@property(nonatomic,copy)NSString *totalPrice;
@property(nonatomic,strong)NSArray *goodnumber;
@property(nonatomic,strong)NSArray *goodselectArray;
//@property (strong,nonatomic)NSDictionary *defaultAddressdict;
//@property (strong,nonatomic)NSDictionary *addressdict;

@property(nonatomic,copy)NSString *order_amount_formatted;
@property(nonatomic,copy)NSString *order_amount;
@property(nonatomic,copy)NSString *discount_formatted;
@property(nonatomic,copy)NSString *shipping_fee_formatted;
@property(nonatomic,copy)NSString *goods_amount;
@property(nonatomic,copy)NSString *goods_amount_formatted;
@property(nonatomic,copy)NSString *cross_border_tax;
@property(nonatomic,copy)NSString *is_cross_border;
@property(nonatomic,copy)NSString *is_over_sea;
@property(nonatomic,copy)NSString *surplus;
@property(strong,nonatomic)NSMutableDictionary *CartDict;
@property(strong,nonatomic)NSDictionary *consignee;
@property(nonatomic,strong) NSArray *cartinfoArray;

@end
