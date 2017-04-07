//
//  MBSerViceOrderModel.h
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/4/6.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    
    Topayment = 0,
    Toused,
    Toevaluate,
    ToafterSales
    
} serviceType;
@interface MBSerViceOrderModel : NSObject
@property (nonatomic,strong) NSString *order_id;
@property (nonatomic,strong) NSString *product_sn;
@property (nonatomic,strong) NSString *product_id;
@property (nonatomic,strong) NSString *ticket_await_use_num;
@property (nonatomic,strong) NSString *product_name;
@property (nonatomic,strong) NSString *product_shop_price;
@property (nonatomic,strong) NSString *product_market_price;
@property (nonatomic,strong) NSString *product_number;
@property (nonatomic,strong) NSString *order_amount;
@property (nonatomic,strong) NSString *shop_name;
@property (nonatomic,strong) NSString *shop_id;
@property (nonatomic,strong) NSString *order_status;
@property (nonatomic,strong) NSURL *shop_logo;
@property (nonatomic,strong) NSURL *product_img;
@property (nonatomic,assign) serviceType type;
@end
