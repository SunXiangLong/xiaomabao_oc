//
//  MBOrderBuyViewController.h
//  XiaoMaBao
//
//  Created by 张磊 on 15/6/4.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "BkBaseViewController.h"

@interface MBJoinCartViewController : BkBaseViewController
@property (assign,nonatomic) BOOL isBuy;
@property (assign,nonatomic) BOOL isSelectGuige;

@property (nonatomic,copy)NSString *userID;
@property (nonatomic,copy)NSString *goods_id;
@property (nonatomic,assign)int *number;
@property (nonatomic,copy)NSString *spec;
@property (nonatomic,copy)NSString *goods_name;
@property (nonatomic,copy)NSString *goods_number;
@property (nonatomic,copy)NSString *shop_price;
@property(copy,nonatomic)NSString *showPlayImageUrl;

@property (nonatomic ,assign)  NSInteger shopNumber;

@end
