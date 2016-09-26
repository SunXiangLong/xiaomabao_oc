//
//  MBPaymentViewController.h
//  XiaoMaBao
//
//  Created by 张磊 on 15/6/2.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "BkBaseViewController.h"

@interface MBPaymentViewController : BkBaseViewController


/**
 *  商品订单信息
 */
@property(strong,nonatomic)NSDictionary *orderInfo;
/**
 *   服务订单信息
 */
@property (nonatomic,strong) NSDictionary *service_data;
/**
 *  标示  2代表服务订单  1代表商品订单  返回的界面不一样
 */
@property(strong,nonatomic)NSString *type;

@end
