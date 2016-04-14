//
//  MBAddressListController.h
//  XiaoMaBao
//
//  Created by 朱理哲 on 15/8/29.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "BkBaseViewController.h"

@interface MBAddressListController : BkBaseViewController
@property(copy,nonatomic)void(^ cityBlock)(NSString * cityData,NSInteger provinceId,NSInteger cityId,NSInteger districtId);

@end
