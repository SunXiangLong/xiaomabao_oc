//
//  MBRefundModel.h
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/2/27.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface MBRefundGoodsModel : NSObject
@property (nonatomic, strong) NSString * order_id;
@property (nonatomic, strong) NSString * goods_id;
@property (nonatomic, strong) NSString * goods_name;
@property (nonatomic, strong) NSNumber * goods_price;
@property (nonatomic, strong) NSString * goods_number;
@property (nonatomic, strong) NSString * refund_number;
@property (nonatomic, strong) NSURL    * goods_thumb;
@end
@interface MBRefundModel : NSObject
@property (nonatomic, strong) NSString * order_id;
@property (nonatomic, strong) NSString * order_sn;
@property (nonatomic, strong) NSString * add_time;
@property (nonatomic, strong) NSNumber * refund_status;
@property (nonatomic, strong) NSString * order_total_money;
@property (nonatomic, strong) NSString * back_tax;
@property (nonatomic,strong)  NSArray<MBRefundGoodsModel *>  * goodsDetail;
@end
