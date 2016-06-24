//
//  MBVoucherViewController.h
//  XiaoMaBao
//
//  Created by 张磊 on 15/6/9.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "BkBaseViewController.h"

@interface MBVoucherViewController : BkBaseViewController
@property(copy,nonatomic)NSString *is_fire;//是否结算时选择优惠券
@property(copy,nonatomic)NSString *order_money;//结算金额

@property (nonatomic, strong) RACSubject *myCircleViewSubject;
@end
