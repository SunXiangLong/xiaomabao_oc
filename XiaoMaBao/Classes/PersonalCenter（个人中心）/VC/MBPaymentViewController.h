//
//  MBPaymentViewController.h
//  XiaoMaBao
//
//  Created by 张磊 on 15/6/2.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "BkBaseViewController.h"
typedef NS_ENUM(NSInteger, MBorderType) {
//    商品订单
    MBOrdersForGoods = 1,
//    服务订单
    MBServiceOrder   = 2,
//    电子卡订单
    MBAnECardOrders  = 3,
};
@interface MBPaymentViewController : BkBaseViewController
/***  订单信息 */
@property(strong,nonatomic)NSDictionary *orderInfo;

/**
 要支付的订单类型
 */
@property(assign,nonatomic)MBorderType type;
/**是否是订单界面pus*/
@property(assign,nonatomic)BOOL isOrderVC;
@end
