//
//  MBConfirmModel.h
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/2/4.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBShoppingCartModel.h"
@interface MBIdcardModel : NSObject
@property (nonatomic, strong) NSString * identity_id;
@property (nonatomic, strong) NSString * real_name;
@property (nonatomic, strong) NSString * identity_card;
@property (nonatomic, strong) NSString * user_id;
@property (nonatomic, strong) NSString * identity_card_front;
@property (nonatomic, strong) NSString * identity_card_front_thumb;
@property (nonatomic, strong) NSString * identity_card_backend;
@property (nonatomic, strong) NSString * identity_card_backend_thumb;
@property (nonatomic, strong) NSNumber * status;
@property (nonatomic, strong) NSNumber * is_black;
@end
@interface MBConsigneeModel : NSObject
@property (nonatomic, strong) NSString * address_id;
@property (nonatomic, strong) NSString * address_name;
@property (nonatomic, strong) NSString * user_id;
@property (nonatomic, strong) NSString * consignee;
@property (nonatomic, strong) NSString * email;
@property (nonatomic, strong) NSString * country;
@property (nonatomic, strong) NSString * province;
@property (nonatomic, strong) NSString * city;
@property (nonatomic, strong) NSString * district;
@property (nonatomic, strong) NSString * address;
@property (nonatomic, strong) NSString * zipcode;
@property (nonatomic, strong) NSString * tel;
@property (nonatomic, strong) NSString * mobile;
@property (nonatomic, strong) NSString * sign_building;
@property (nonatomic, strong) NSString * best_time;
@property (nonatomic, strong) NSString * is_default;
@property (nonatomic, strong) NSString * province_name;
@property (nonatomic, strong) NSString * city_name;
@property (nonatomic, strong) NSString * district_name;
@property (nonatomic, strong) NSString * id;
@property (nonatomic, strong) MBIdcardModel *idcard;
@end
@interface MBOrderShopModel : NSObject
@property (nonatomic, strong) NSNumber * number;
@property (nonatomic, strong) NSString * supplier;
@property (nonatomic, strong) NSString * shipping_fee;
@property (nonatomic, strong) NSString * total_money;
@property (nonatomic, strong) NSString * cross_border_money;
@property (nonatomic, strong) NSString * discount_name;

@property (nonatomic, strong) NSArray  <MBGood_ListModel *> *goods_list;
@end
@interface MBConfirmModel : NSObject
@property (nonatomic, strong) NSString * bean_fee;
@property (nonatomic, strong) NSString * goods_amount;
@property (nonatomic, strong) NSString * goods_amount_formatted;
@property (nonatomic, strong) NSString * order_amount;
@property (nonatomic, strong) NSString * order_amount_formatted;
@property (nonatomic, strong) NSString * discount_formatted;
@property (nonatomic, strong) NSString * shipping_fee_formatted;
@property (nonatomic, strong) NSString * cross_border_tax;
@property (nonatomic, strong) NSString * surplus;
@property (nonatomic, strong) NSNumber * discount;
@property (nonatomic, assign) BOOL  real_name;
@property (nonatomic, assign) BOOL  is_over_sea;
@property (nonatomic, strong) MBConsigneeModel * consignee;
@property (nonatomic, strong) NSArray <MBOrderShopModel *>*goods_list;
@end
