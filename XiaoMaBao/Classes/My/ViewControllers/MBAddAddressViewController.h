//
//  MBAddAddressViewController.h
//  XiaoMaBao
//
//  Created by 张磊 on 15/6/12.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "BkBaseViewController.h"


@interface MBAddAddressViewController : BkBaseViewController
@property(copy,nonatomic)NSString *TheTitle;

@property(nonatomic) NSInteger provinceId;
@property(nonatomic) NSInteger cityId;
@property(nonatomic) NSInteger districtId;
//收货人
@property(nonatomic,copy)NSString *consignee;
@property(nonatomic,copy)NSString *address_id;
@property(nonatomic,assign)NSInteger cellIndex;

@property(nonatomic,strong)NSArray *infoArray;

@end
