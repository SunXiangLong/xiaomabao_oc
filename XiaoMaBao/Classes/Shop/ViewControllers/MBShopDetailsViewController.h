//
//  MBShopDetailsViewController.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/3/22.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "BkBaseViewController.h"

@interface MBShopDetailsViewController : BkBaseViewController
@property(copy,nonatomic)NSString *GoodsId;
@property(copy,nonatomic)NSString *actId;//专场ID
@property(copy,nonatomic)NSString *showPlayImageUrl;
@property(strong,nonatomic)NSDictionary *GoodsDict;
@property(copy,nonatomic)NSString *goods_name;
@property(copy,nonatomic)NSString *shop_price;
@property(copy,nonatomic)NSString *shop_price_formatted;
@property(copy,nonatomic)NSString *market_price;
@property(copy,nonatomic)NSString *market_price_formatted;
@property(copy,nonatomic)NSString *preferential_info;//优惠信息
@property(copy,nonatomic)NSString *goods_brief;
@property(copy,nonatomic)NSArray *goods_gallery;
@property(strong,nonatomic)NSArray *goods_desc;
@property(copy,nonatomic)NSString *goods_sn;
@property(copy,nonatomic)NSString *goods_brand;
@property(copy,nonatomic)NSString *goods_number;
@property(copy,nonatomic)NSString *carriage_fee;
@property(copy,nonatomic)NSString *salesnum;
@property(nonatomic) NSString * is_shipping;//是否包邮
@property(nonatomic) NSString * is_promote;//是否显示促销
@property(nonatomic) NSString * active_remainder_time;//活动剩余时间

@end
