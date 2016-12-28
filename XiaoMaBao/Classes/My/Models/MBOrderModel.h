//
//  MBOrderModel.h
//  XiaoMaBao
//
//  Created by xiaomabao on 2016/12/27.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface MBGoodListModel : NSObject
@property (nonatomic, strong) NSString * goods_id;
@property (nonatomic, strong) NSString * goods_name;
@property (nonatomic, strong) NSString * goods_price;
@property (nonatomic, strong) NSString * goods_price_formatted;
@property (nonatomic, strong) NSURL    * goods_img;
@property (nonatomic, strong) NSURL    * img;
@property (nonatomic, strong) NSString * goods_number;
@property (nonatomic, strong) NSString * is_comment;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * subtotal;
@property (nonatomic, strong) NSString * shop_price_formatted;
@end
@interface MBChildOrderModel : NSObject
@property (nonatomic,strong) NSArray *goodsList;
@property (nonatomic, strong) NSString * order_sn;
@property (nonatomic, strong) NSString * pay_status;
@property (nonatomic, strong) NSString * shipping_status;
@property (nonatomic, strong) NSString * is_cross_border;
@property (nonatomic, strong) NSString * order_id;
@property (nonatomic, strong) NSString * total_fee;
@property (nonatomic, strong) NSString * order_status;
@property (nonatomic, strong) NSString * add_time;
@property (nonatomic, strong) NSString * is_comment;
@property (nonatomic, strong) NSString * order_amount;
@property (nonatomic, strong) NSString * pay_id;

@end
@interface MBOrderModel : NSObject
@property (nonatomic, strong) NSString * order_time;
@property (nonatomic, strong) NSString * parent_order_sn;
@property (nonatomic, strong) NSString * order_status;
@property (nonatomic, strong) NSString * subject;
@property (nonatomic, strong) NSString * is_parent_order;
@property (nonatomic, strong) NSString * order_id;
@property (nonatomic, strong) NSString * order_amount;
@property (nonatomic, strong) NSString * invoice_no;
@property (nonatomic, strong) NSString * order_sn;
@property (nonatomic, strong) NSString * shipping_name;
@property (nonatomic, strong) NSString * is_cross_border;
@property (nonatomic, strong) NSString * pay_status;
@property (nonatomic, strong) NSString * totalFee;
@property (nonatomic, strong) NSString * pay_id;
@property (nonatomic, strong) NSString * total_fee;
@property (nonatomic, strong) NSString * desc;
@property (nonatomic, strong) NSString * back_tax;
@property (nonatomic, strong) NSString * refund_status;
@property (nonatomic, strong) NSString * is_comment;
@property (nonatomic,strong) NSArray *goodsList;
@property (nonatomic,strong) NSArray *childOrders;

@end
