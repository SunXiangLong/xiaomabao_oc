//
//  MBShoppingCartModel.h
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/2/4.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface MBGood_ListModel : NSObject
@property (nonatomic, strong) NSString * rec_id;
@property (nonatomic, strong) NSString * user_id;
@property (nonatomic, strong) NSString * session_id;
@property (nonatomic, strong) NSString * goods_id;
@property (nonatomic, strong) NSURL    * goods_img;
@property (nonatomic, strong) NSURL    * goods_thumb;
@property (nonatomic, strong) NSString * goods_sn;
@property (nonatomic, strong) NSString * product_id;
@property (nonatomic, strong) NSString * product_sn;
@property (nonatomic, strong) NSString * goods_name;
@property (nonatomic, strong) NSString * market_price;

@property (nonatomic, strong) NSString * goods_price;
@property (nonatomic, strong) NSString * goods_number;
@property (nonatomic, strong) NSString * goods_attr;
@property (nonatomic, strong) NSString * is_real;
@property (nonatomic, strong) NSString * extension_code;
@property (nonatomic, strong) NSString * parent_id;
@property (nonatomic, strong) NSString * rec_type;
@property (nonatomic, strong) NSString * is_gift;
@property (nonatomic, strong) NSString * is_shipping;
@property (nonatomic, strong) NSString * can_handsel;

@property (nonatomic, strong) NSString * goods_attr_id;
@property (nonatomic, strong) NSString * flow_order;
@property (nonatomic, strong) NSString * supplier_id;
@property (nonatomic, strong) NSString * is_group;
@property (nonatomic, strong) NSString * coupon_disable;
@property (nonatomic, strong) NSString * is_cross_border;
@property (nonatomic, strong) NSString * goods_weight;
@property (nonatomic, strong) NSString * cost_price;
@property (nonatomic, strong) NSString * sub_total;
@property (nonatomic, strong) NSString * subtotal;
@property (nonatomic, strong) NSString * goods_price_formatted;
@property (nonatomic, strong) NSString * market_price_formatted;
@property (nonatomic, strong) NSString * is_third;
@end
@interface MBTotalModel : NSObject
@property (nonatomic, strong) NSNumber * real_goods_count;
@property (nonatomic, strong) NSString * goods_amount;
@property (nonatomic, strong) NSString * market_price;
@property (nonatomic, strong) NSString * saving;
@property (nonatomic, strong) NSString * save_rate;
@property (nonatomic, strong) NSString * goods_price;
@end
@interface MBShoppingCartModel : NSObject
@property (nonatomic, strong) MBTotalModel * total;
@property (nonatomic, copy) NSMutableArray<MBGood_ListModel *> * goods_list;
@property (nonatomic, assign) BOOL isSettlement;
@end
