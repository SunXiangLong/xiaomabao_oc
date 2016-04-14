//
//  MBSwing.h
//  XiaoMaBao
//
//  Created by 张磊 on 15/8/16.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBSwing : NSObject
@property (copy,nonatomic) NSString *type_id;
@property (copy,nonatomic) NSString *type_name;
@property (copy,nonatomic) NSString *type_money;
@property (copy,nonatomic) NSString *send_type;
@property (copy,nonatomic) NSString *min_amount;
@property (copy,nonatomic) NSString *send_start_date;
@property (copy,nonatomic) NSString *send_end_date;
@property (copy,nonatomic) NSString *use_end_date;
@property (copy,nonatomic) NSString *min_goods_amount;
@property (copy,nonatomic) NSString *prize_rate;

@end
